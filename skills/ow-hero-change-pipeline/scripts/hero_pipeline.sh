#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'USAGE'
Usage:
  scripts/hero_pipeline.sh [--hero <slug>]... [--from-diff [range]] [--build]
                           [--strict-changelog] [--strict-rules] [--strict-init-gate]
                           [--list-heroes] [--help]

Examples:
  scripts/hero_pipeline.sh --hero freja
  scripts/hero_pipeline.sh --from-diff
  scripts/hero_pipeline.sh --from-diff HEAD~1 --build
USAGE
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT_DIR"

for cmd in rg awk sed sort uniq git basename dirname; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Missing required command: $cmd" >&2
        exit 2
    fi
done

declare -a request_heroes=()
use_from_diff=false
diff_range="HEAD"
run_build=false
strict_changelog=false
strict_rules=false
strict_init_gate=false
list_heroes=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --hero)
            if [[ $# -lt 2 ]]; then
                echo "--hero requires a value" >&2
                exit 2
            fi
            request_heroes+=("$2")
            shift
            ;;
        --from-diff)
            use_from_diff=true
            if [[ $# -gt 1 && "$2" != --* ]]; then
                diff_range="$2"
                shift
            fi
            ;;
        --build)
            run_build=true
            ;;
        --strict-changelog)
            strict_changelog=true
            ;;
        --strict-rules)
            strict_rules=true
            ;;
        --strict-init-gate)
            strict_init_gate=true
            ;;
        --list-heroes)
            list_heroes=true
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            usage >&2
            exit 2
            ;;
    esac
    shift
done

passes=0
warnings=0
failures=0

pass() {
    passes=$((passes + 1))
    printf '[PASS] %s\n' "$1"
}

warn() {
    warnings=$((warnings + 1))
    printf '[WARN] %s\n' "$1"
}

fail() {
    failures=$((failures + 1))
    printf '[FAIL] %s\n' "$1"
}

count_fixed_matches() {
    local needle="$1"
    local file="$2"
    local matches
    matches="$(rg -n --fixed-strings "$needle" "$file" || true)"
    printf '%s\n' "$matches" | sed '/^$/d' | wc -l | tr -d ' '
}

count_regex_matches() {
    local pattern="$1"
    local file="$2"
    local matches
    matches="$(rg -n "$pattern" "$file" || true)"
    printf '%s\n' "$matches" | sed '/^$/d' | wc -l | tr -d ' '
}

first_line_fixed_match() {
    local needle="$1"
    local file="$2"
    local matches
    matches="$(rg -n --fixed-strings "$needle" "$file" || true)"
    printf '%s\n' "$matches" | sed -n '1p' | cut -d: -f1
}

normalize_const_from_tag() {
    local tag="$1"
    local upper
    upper="$(printf '%s' "$tag" | sed -E 's/([a-z0-9])([A-Z])/\1_\2/g' | tr '[:lower:]' '[:upper:]')"
    case "$upper" in
        SOLDIER76)
            printf 'SOLDIER\n'
            ;;
        *)
            printf '%s\n' "$upper"
            ;;
    esac
}

list_all_heroes() {
    rg --files src/modules/hero_init/heroes \
        | sed -E 's#^.*/##' \
        | sed -E 's#\.opy$##' \
        | sort
}

if [[ "$list_heroes" == true ]]; then
    echo "Available heroes (from hero_init/heroes):"
    list_all_heroes
    exit 0
fi

collect_heroes_from_diff() {
    local range="$1"
    {
        git diff --name-only "$range" -- src/modules/hero_init/heroes/*.opy 2>/dev/null \
            | sed -E 's#^.*/##' \
            | sed -E 's#\.opy$##'

        git diff --name-only "$range" -- src/modules/hero_rules/heroes/*.opy 2>/dev/null \
            | sed -E 's#^.*/##' \
            | sed -E 's#\.opy$##' \
            | while IFS= read -r slug; do
                [[ -z "$slug" ]] && continue
                if [[ -f "src/modules/hero_init/heroes/${slug}.opy" ]]; then
                    printf '%s\n' "$slug"
                fi
              done
    } | sed '/^$/d' | sort -u
}

if [[ "$use_from_diff" == true ]]; then
    while IFS= read -r hero; do
        request_heroes+=("$hero")
    done < <(collect_heroes_from_diff "$diff_range")
fi

if [[ "${#request_heroes[@]}" -eq 0 ]]; then
    if [[ "$use_from_diff" == true ]]; then
        echo "No hero-related file changes detected from diff range: $diff_range"
        exit 0
    fi
    echo "No target heroes provided. Use --hero <slug> or --from-diff [range]." >&2
    exit 2
fi

mapfile -t heroes < <(printf '%s\n' "${request_heroes[@]}" | sed '/^$/d' | sort -u)

audit_hero() {
    local slug="$1"
    local init_file="src/modules/hero_init/heroes/${slug}.opy"
    local init_index="src/modules/hero_init/_index.opy"
    local rules_dir="src/modules/hero_rules/heroes"
    local changelog="src/modules/debug/20-changelog.opy"

    echo
    echo "=== Hero: ${slug} ==="

    if [[ -f "$init_file" ]]; then
        pass "hero_init file exists: $init_file"
    else
        fail "hero_init file missing: $init_file"
        return
    fi

    include_line="#!include \"heroes/${slug}.opy\""
    include_count="$(count_fixed_matches "$include_line" "$init_index")"
    if [[ "$include_count" == "1" ]]; then
        pass "hero_init include exists in _index.opy"
    else
        fail "hero_init include missing/duplicated in _index.opy (count=$include_count)"
    fi

    rule_count="$(count_regex_matches '^rule "' "$init_file")"
    if [[ "$rule_count" -ge 2 ]]; then
        pass "detect/initialize pair likely present (rule count=$rule_count)"
    else
        fail "expected at least 2 rules in hero_init file (got $rule_count)"
    fi

    true_count="$(count_fixed_matches 'eventPlayer.reset_pvar[0] = true' "$init_file")"
    false_count="$(count_fixed_matches 'eventPlayer.reset_pvar[0] = false' "$init_file")"
    reset_hero_count="$(count_fixed_matches 'resetHero()' "$init_file")"
    cond_count="$((
        $(count_fixed_matches '@Condition eventPlayer.reset_pvar[0] != false' "$init_file") +
        $(count_fixed_matches '@Condition eventPlayer.reset_pvar[0] == true' "$init_file")
    ))"

    if [[ "$true_count" -ge 1 ]]; then
        pass "init detect trigger exists: reset_pvar[0] = true"
    else
        fail "missing detect trigger: reset_pvar[0] = true"
    fi

    if [[ "$reset_hero_count" -ge 1 ]]; then
        pass "init reset chain exists: resetHero()"
    else
        fail "missing resetHero() in hero init"
    fi

    if [[ "$false_count" -ge 1 ]]; then
        pass "init clear trigger exists: reset_pvar[0] = false"
    else
        fail "missing reset clear: reset_pvar[0] = false"
    fi

    if [[ "$cond_count" -ge 1 ]]; then
        pass "initialize gating condition exists for reset_pvar[0]"
    else
        if [[ "$strict_init_gate" == true ]]; then
            fail "missing initialize gating condition for reset_pvar[0]"
        else
            warn "missing initialize gating condition for reset_pvar[0]"
        fi
    fi

    reset_line="$(first_line_fixed_match 'resetHero()' "$init_file")"
    false_line="$(first_line_fixed_match 'eventPlayer.reset_pvar[0] = false' "$init_file")"
    if [[ -n "$reset_line" && -n "$false_line" ]]; then
        if [[ "$false_line" -gt "$reset_line" ]]; then
            pass "init clear happens after resetHero()"
        else
            fail "reset_pvar[0] = false appears before resetHero()"
        fi
    fi

    # Sanity-check reset_pvar slot writes inside init file
    mapfile -t written_slots < <((rg -n 'reset_pvar\[[0-9]+\]\s*=' "$init_file" || true) \
        | sed -E 's/.*reset_pvar\[([0-9]+)\].*/\1/' \
        | sort -n -u)

    allowed_slots="0 1 3 4 5 6 7 8 9 11 12 13 14 15 16"
    for slot in "${written_slots[@]}"; do
        if [[ " $allowed_slots " == *" ${slot} "* ]]; then
            pass "reset_pvar write uses approved slot: [$slot]"
        else
            warn "reset_pvar write uses non-whitelisted slot: [$slot]"
        fi
    done

    local hero_tag_line
    hero_tag_line="$(rg -m 1 '^[[:space:]]*@Hero[[:space:]]+' "$init_file" || true)"
    hero_tag="$(printf '%s\n' "$hero_tag_line" | sed -E 's/.*@Hero[[:space:]]+([^[:space:]]+).*/\1/')"
    if [[ -n "$hero_tag" ]]; then
        pass "hero tag resolved from init: @Hero $hero_tag"
    else
        warn "failed to resolve @Hero tag from init"
        hero_tag="$slug"
    fi

    hero_const="$(normalize_const_from_tag "$hero_tag")"

    rules_tag_hits="$(rg -n "@Hero[[:space:]]+${hero_tag}(\s|$)" "$rules_dir" || true)"
    rules_const_hits="$(rg -n "Hero\.${hero_const}(\b|[^A-Z_0-9])" "$rules_dir" || true)"
    rules_hit_count="$((
        $(printf '%s\n' "$rules_tag_hits" | sed '/^$/d' | wc -l | tr -d ' ') +
        $(printf '%s\n' "$rules_const_hits" | sed '/^$/d' | wc -l | tr -d ' ')
    ))"

    if [[ "$rules_hit_count" -gt 0 ]]; then
        pass "hero_rules touchpoint detected for ${slug}"
    else
        if [[ "$strict_rules" == true ]]; then
            fail "no hero_rules touchpoint detected for ${slug}"
        else
            warn "no hero_rules touchpoint detected for ${slug}"
        fi
    fi

    changelog_hits="$(rg -n --fixed-strings "eventPlayer.getHero() == Hero.${hero_const}" "$changelog" || true)"
    changelog_count="$(printf '%s\n' "$changelog_hits" | sed '/^$/d' | wc -l | tr -d ' ')"

    if [[ "$changelog_count" -ge 1 ]]; then
        pass "changelog branch exists for Hero.${hero_const}"
    else
        if [[ "$strict_changelog" == true ]]; then
            fail "missing changelog branch for Hero.${hero_const}"
        else
            warn "missing changelog branch for Hero.${hero_const}"
        fi
    fi
}

echo "Running ow-hero-change-pipeline from: $ROOT_DIR"
echo "Target heroes: ${heroes[*]}"

for hero in "${heroes[@]}"; do
    audit_hero "$hero"
done

if [[ "$run_build" == true ]]; then
    echo
    echo "Running contract guard + build gate..."
    if skills/ow-contract-guard/scripts/check_contracts.sh --build; then
        pass "contract guard and build succeeded"
    else
        fail "contract guard or build failed"
    fi
fi

echo
printf 'Summary: %s passed, %s warning(s), %s failure(s)\n' "$passes" "$warnings" "$failures"

if [[ "$failures" -gt 0 ]]; then
    exit 1
fi

exit 0
