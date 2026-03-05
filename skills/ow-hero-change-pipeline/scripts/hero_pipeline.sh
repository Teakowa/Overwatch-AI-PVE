#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'USAGE'
Usage:
  scripts/hero_pipeline.sh [--hero <slug>]... [--from-diff [range]] [--build]
                           [--strict-changelog] [--strict-rules] [--strict-init-gate] [--strict-throttle]
                           [--strict-cooldown-placement]
                           [--report-template [path]]
                           [--list-heroes] [--help]

Examples:
  scripts/hero_pipeline.sh --hero freja
  scripts/hero_pipeline.sh --from-diff
  scripts/hero_pipeline.sh --from-diff HEAD~1 --build
  scripts/hero_pipeline.sh --hero freja --report-template
USAGE
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT_DIR"

for cmd in rg awk sed sort uniq git basename dirname mktemp date mkdir; do
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
strict_throttle=false
strict_cooldown_placement=false
list_heroes=false
report_template=false
report_path=""
report_file=""
current_hero="global"

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
        --strict-throttle)
            strict_throttle=true
            ;;
        --strict-cooldown-placement)
            strict_cooldown_placement=true
            ;;
        --report-template)
            report_template=true
            if [[ $# -gt 1 && "$2" != --* ]]; then
                report_path="$2"
                shift
            fi
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

if [[ "$report_template" == true ]]; then
    report_file="$(mktemp)"
    trap 'rm -f "$report_file"' EXIT
fi

record_report_line() {
    local level="$1"
    local message="$2"
    if [[ -n "$report_file" ]]; then
        printf '%s\t%s\t%s\n' "$current_hero" "$level" "$message" >> "$report_file"
    fi
}

pass() {
    passes=$((passes + 1))
    printf '[PASS] %s\n' "$1"
    record_report_line "PASS" "$1"
}

warn() {
    warnings=$((warnings + 1))
    printf '[WARN] %s\n' "$1"
    record_report_line "WARN" "$1"
}

fail() {
    failures=$((failures + 1))
    printf '[FAIL] %s\n' "$1"
    record_report_line "FAIL" "$1"
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

expected_owner_for_slot() {
    local slot="$1"
    case "$slot" in
        1) printf 'brigitte\n' ;;
        3) printf 'kiriko\n' ;;
        4) printf 'sombra\n' ;;
        5) printf 'ramattra\n' ;;
        7) printf 'ana\n' ;;
        11) printf 'freja\n' ;;
        *)
            printf '\n'
            ;;
    esac
}

expected_team_for_slot() {
    local slot="$1"
    case "$slot" in
        1|3|4|2)
            printf 'ally\n'
            ;;
        5|7|11)
            printf 'enemy\n'
            ;;
        *)
            printf '\n'
            ;;
    esac
}

hero_settings_key_present_for_both_teams() {
    local hero_key="$1"
    local key="$2"
    local settings_file="src/modules/prelude/00-settings.opy"
    local count=0
    local line

    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        local line_no
        line_no="${line%%:*}"
        if sed -n "${line_no},$((line_no + 24))p" "$settings_file" | rg -q "\"${key}\""; then
            count=$((count + 1))
        fi
    done < <(rg -n "\"${hero_key}\"[[:space:]]*:[[:space:]]*\\{" "$settings_file" || true)

    [[ "$count" -ge 2 ]]
}

audit_cooldown_placement() {
    local slug="$1"
    local hero_key="$2"
    shift 2 || true
    local files=("$@")
    local checked=0
    local flagged=0

    if [[ "${#files[@]}" -eq 0 ]]; then
        warn "[cooldown] no hero_rules files found for ${slug}, skip cooldown placement audit"
        return
    fi

    for file in "${files[@]}"; do
        [[ -f "$file" ]] || continue

        while IFS= read -r raw; do
            [[ -z "$raw" ]] && continue

            local line_part line_no line_text button expected_key
            line_part="${raw#*:}"
            line_no="${line_part%%:*}"
            line_text="${line_part#*:}"
            checked=$((checked + 1))

            # Relative cooldown deltas are typically trigger-based effects.
            if [[ "$line_text" == *"getAbilityCooldown("* ]]; then
                continue
            fi

            flagged=$((flagged + 1))
            button="$(printf '%s\n' "$line_text" | sed -E 's/.*setAbilityCooldown\(Button\.([A-Z_0-9]+),.*/\1/')"
            expected_key=""
            case "$button" in
                ABILITY_1) expected_key="ability1Cooldown%" ;;
                ABILITY_2) expected_key="ability2Cooldown%" ;;
                SECONDARY_FIRE) expected_key="secondaryFireCooldown%" ;;
            esac

            if [[ -n "$expected_key" ]]; then
                if hero_settings_key_present_for_both_teams "$hero_key" "$expected_key"; then
                    if [[ "$strict_cooldown_placement" == true ]]; then
                        fail "[cooldown] ${file}:${line_no} uses absolute setAbilityCooldown(${button}); keep generic cooldown in settings and keep only trigger-dependent cooldown logic in rules"
                    else
                        warn "[cooldown] ${file}:${line_no} uses absolute setAbilityCooldown(${button}); prefer settings key ${expected_key} for generic cooldown tuning"
                    fi
                else
                    if [[ "$strict_cooldown_placement" == true ]]; then
                        fail "[cooldown] ${file}:${line_no} uses absolute setAbilityCooldown(${button}) but missing ${expected_key} under team1/team2 settings for hero ${hero_key}"
                    else
                        warn "[cooldown] ${file}:${line_no} uses absolute setAbilityCooldown(${button}) and settings key ${expected_key} is missing for hero ${hero_key}"
                    fi
                fi
            else
                if [[ "$strict_cooldown_placement" == true ]]; then
                    fail "[cooldown] ${file}:${line_no} uses absolute setAbilityCooldown(${button}); verify this is trigger-dependent and not generic cooldown tuning"
                else
                    warn "[cooldown] ${file}:${line_no} uses absolute setAbilityCooldown(${button}); verify this is trigger-dependent"
                fi
            fi
        done < <(rg -n -H 'setAbilityCooldown\(Button\.(ABILITY_1|ABILITY_2|SECONDARY_FIRE|ULTIMATE),' "$file" || true)
    done

    if [[ "$checked" -eq 0 ]]; then
        pass "[cooldown] no setAbilityCooldown usage detected in hero_rules for ${slug}"
    elif [[ "$flagged" -eq 0 ]]; then
        pass "[cooldown] cooldown placement check passed for ${slug} (${checked} setAbilityCooldown calls reviewed)"
    fi
}

audit_throttle_risks() {
    local slug="$1"
    shift || true
    local files=("$@")
    local checked=0
    local risky=0

    if [[ "${#files[@]}" -eq 0 ]]; then
        warn "[throttle] no hero_rules files found for ${slug}, skip throttle audit"
        return
    fi

    for file in "${files[@]}"; do
        [[ -f "$file" ]] || continue

        local block_rule=""
        local block_line=0
        local block_each_player=false
        local block_has_wait=false
        local block_has_loop=false
        local block_has_expensive=false

        evaluate_block() {
            if [[ -z "$block_rule" || "$block_each_player" != true ]]; then
                return
            fi

            checked=$((checked + 1))
            if [[ "$block_has_loop" == true && "$block_has_wait" != true ]]; then
                risky=$((risky + 1))
                if [[ "$strict_throttle" == true ]]; then
                    fail "[throttle] ${file}:${block_line} '${block_rule}' has loop/while without wait/waitUntil"
                else
                    warn "[throttle] ${file}:${block_line} '${block_rule}' has loop/while without wait/waitUntil"
                fi
            elif [[ "$block_has_expensive" == true && "$block_has_wait" != true ]]; then
                risky=$((risky + 1))
                if [[ "$strict_throttle" == true ]]; then
                    fail "[throttle] ${file}:${block_line} '${block_rule}' has expensive actions without wait/waitUntil"
                else
                    warn "[throttle] ${file}:${block_line} '${block_rule}' has expensive actions without wait/waitUntil"
                fi
            fi
        }

        while IFS= read -r raw; do
            local line_no line_text rule_name rest
            rest="${raw#*:}"
            line_no="${rest%%:*}"
            line_text="${rest#*:}"

            if [[ "$line_text" =~ ^rule[[:space:]]+\" ]]; then
                evaluate_block
                rule_name="$(printf '%s\n' "$line_text" | sed -E 's/^rule "([^"]+)".*/\1/')"
                block_rule="$rule_name"
                block_line="$line_no"
                block_each_player=false
                block_has_wait=false
                block_has_loop=false
                block_has_expensive=false
                continue
            fi

            if [[ "$line_text" == *"@Event eachPlayer"* ]]; then
                block_each_player=true
            fi
            if [[ "$line_text" == *"wait("* || "$line_text" == *"waitUntil("* ]]; then
                block_has_wait=true
            fi
            if [[ "$line_text" == *"loop()"* || "$line_text" =~ ^[[:space:]]*while[[:space:]] ]]; then
                block_has_loop=true
            fi
            if [[ "$line_text" == *"getPlayersInRadius("* || "$line_text" == *"distance("* || "$line_text" == *"isInLoS("* || "$line_text" == *"getClosestPlayer("* || "$line_text" == *"getPlayerClosestToReticle("* || "$line_text" == *"len(["* || "$line_text" == *"hudText("* || "$line_text" == *"playEffect("* || "$line_text" == *"startDamageModification("* || "$line_text" == *"sort("* || "$line_text" == *"nearestWalkablePosition("* ]]; then
                block_has_expensive=true
            fi
        done < <(rg -n -H '^rule "|@Event eachPlayer|wait\(|waitUntil\(|loop\(\)|^[[:space:]]*while[[:space:]]|getPlayersInRadius\(|distance\(|isInLoS\(|getClosestPlayer\(|getPlayerClosestToReticle\(|len\(\[|hudText\(|playEffect\(|startDamageModification\(|sort\(|nearestWalkablePosition\(' "$file" || true)

        evaluate_block
    done

    if [[ "$checked" -eq 0 ]]; then
        warn "[throttle] no eachPlayer hero_rules blocks scanned for ${slug}"
    elif [[ "$risky" -eq 0 ]]; then
        pass "[throttle] no high-frequency throttle risks detected for ${slug} (${checked} eachPlayer blocks checked)"
    fi
}

generate_review_report_template() {
    local path="$1"
    local generated_at
    generated_at="$(date '+%Y-%m-%d %H:%M:%S %z')"

    mkdir -p "$(dirname "$path")"
    {
        echo "# Hero Change Review Report Template"
        echo
        echo "- Generated At: ${generated_at}"
        echo "- Branch: $(git branch --show-current)"
        echo "- Target Heroes: ${heroes[*]}"
        echo "- Automated Summary: ${passes} passed / ${warnings} warnings / ${failures} failures"
        echo
        echo "## Blocking Findings (FAIL)"
        if ! awk -F $'\t' '$2 == "FAIL" {printf "- [%s] %s\n", $1, $3; found=1} END{exit found?0:1}' "$report_file"; then
            echo "- None"
        fi
        echo
        echo "## Warnings (WARN)"
        if ! awk -F $'\t' '$2 == "WARN" {printf "- [%s] %s\n", $1, $3; found=1} END{exit found?0:1}' "$report_file"; then
            echo "- None"
        fi
        echo
        echo "## Manual Review Checklist"
        for hero in "${heroes[@]}"; do
            echo "### ${hero}"
            echo "- [ ] hero_init Detect/Initialize 逻辑和 reset 链路符合预期"
            echo "- [ ] hero_rules 行为改动符合设计并已评估负载风险"
            echo "- [ ] changelog 文案已覆盖本次改动"
            echo "- [ ] Team 1/Team 2 职责边界未被破坏"
            echo
        done
        echo "## Release Notes Draft"
        echo "- 影响英雄/系统："
        echo "- 服务器负载影响："
        echo "- 初始化或 reset 链路调整："
    } > "$path"

    pass "review report template generated: $path"
}

list_all_heroes() {
    rg --files src/heroes \
        | sed -n -E 's#^src/heroes/([^/]+)/init\.opy$#\1#p' \
        | sort
}

if [[ "$list_heroes" == true ]]; then
    echo "Available heroes (from src/heroes/*/init.opy):"
    list_all_heroes
    exit 0
fi

collect_heroes_from_diff() {
    local range="$1"
    git diff --name-only "$range" -- src/heroes 2>/dev/null \
        | sed -n -E 's#^src/heroes/([^/]+)/.+\.opy$#\1#p' \
        | while IFS= read -r slug; do
            [[ -z "$slug" ]] && continue
            if [[ -f "src/heroes/${slug}/init.opy" ]]; then
                printf '%s\n' "$slug"
            fi
          done \
        | sed '/^$/d' | sort -u
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
    local init_file="src/heroes/${slug}/init.opy"
    local heroes_main="src/heroes/main.opy"
    local hero_dir="src/heroes/${slug}"
    local changelog="src/modules/debug/20-changelog.opy"
    current_hero="$slug"

    echo
    echo "=== Hero: ${slug} ==="

    if [[ -f "$init_file" ]]; then
        pass "hero_init file exists: $init_file"
    else
        fail "hero_init file missing: $init_file"
        return
    fi

    rules_include_line="#!include \"${slug}/rules.opy\""
    rules_include_count="$(count_fixed_matches "$rules_include_line" "$heroes_main")"
    if [[ "$rules_include_count" == "1" ]]; then
        pass "hero rules include exists in src/heroes/main.opy"
    else
        fail "hero rules include missing/duplicated in src/heroes/main.opy (count=$rules_include_count)"
    fi

    init_include_line="#!include \"${slug}/init.opy\""
    init_include_count="$(count_fixed_matches "$init_include_line" "$heroes_main")"
    if [[ "$init_include_count" == "1" ]]; then
        pass "hero init include exists in src/heroes/main.opy"
    else
        fail "hero init include missing/duplicated in src/heroes/main.opy (count=$init_include_count)"
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

    reset_line="$(first_line_fixed_match 'resetHero()' "$init_file")"
    false_line="$(first_line_fixed_match 'eventPlayer.reset_pvar[0] = false' "$init_file")"
    if [[ -n "$reset_line" && -n "$false_line" ]]; then
        if [[ "$false_line" -gt "$reset_line" ]]; then
            pass "init clear happens after resetHero()"
        else
            fail "reset_pvar[0] = false appears before resetHero()"
        fi
    fi

    # Semantics checks for reset_pvar writes inside init file
    mapfile -t slot_write_lines < <(rg -n -H 'reset_pvar\[[0-9]+\]\s*=' "$init_file" || true)
    known_slots="0 1 2 3 4 5 6 7 8 9 11 12 13 14 15 16"

    for raw in "${slot_write_lines[@]}"; do
        line_part="${raw#*:}"
        line_no="${line_part%%:*}"
        line_text="${line_part#*:}"

        if [[ "$line_text" =~ reset_pvar\[[0-9]+\]\.reset_pvar\[[0-9]+\][[:space:]]*= ]]; then
            first_slot="$(printf '%s\n' "$line_text" | sed -E 's/.*reset_pvar\[([0-9]+)\]\.reset_pvar\[[0-9]+\].*/\1/')"
            second_slot="$(printf '%s\n' "$line_text" | sed -E 's/.*reset_pvar\[[0-9]+\]\.reset_pvar\[([0-9]+)\].*/\1/')"

            if [[ "$first_slot" == "6" && "$second_slot" == "9" ]]; then
                pass "reset_pvar nested semantics OK at ${slug}.opy:${line_no} (6 -> 9 chain)"
            else
                warn "reset_pvar nested semantics unusual at ${slug}.opy:${line_no} (found ${first_slot} -> ${second_slot}, expected 6 -> 9)"
            fi
            continue
        fi

        slot="$(printf '%s\n' "$line_text" | sed -E 's/.*reset_pvar\[([0-9]+)\].*/\1/')"
        expr="$(printf '%s\n' "$line_text" | sed -E 's/.*=[[:space:]]*//; s/^[[:space:]]+//; s/[[:space:]]+$//')"

        if [[ " $known_slots " == *" ${slot} "* ]]; then
            pass "reset_pvar write uses known slot at ${slug}.opy:${line_no} -> [$slot]"
        else
            warn "reset_pvar write uses unknown slot at ${slug}.opy:${line_no} -> [$slot]"
        fi

        if [[ "$slot" == "0" ]]; then
            if [[ "$expr" == "true" || "$expr" == "false" ]]; then
                pass "slot[0] boolean semantics OK at ${slug}.opy:${line_no}"
            else
                fail "slot[0] expects boolean value at ${slug}.opy:${line_no}, found: $expr"
            fi
            continue
        fi

        expected_owner="$(expected_owner_for_slot "$slot")"
        expected_team="$(expected_team_for_slot "$slot")"

        if [[ -n "$expected_owner" && "$hero_tag" != "$expected_owner" ]]; then
            warn "slot[$slot] semantic owner mismatch at ${slug}.opy:${line_no}: hero @Hero $hero_tag writes slot expected for $expected_owner"
        fi

        if [[ "$expected_team" == "ally" ]]; then
            if [[ "$line_text" == *"getPlayers(getOppositeTeam(eventPlayer.getTeam())).reset_pvar[$slot]"* ]]; then
                warn "slot[$slot] expects ally mapping at ${slug}.opy:${line_no}, but writes to opposite team"
            fi
            if [[ "$line_text" == *"getPlayers(eventPlayer.getTeam()).reset_pvar[$slot]"* ]]; then
                pass "slot[$slot] ally direction semantics OK at ${slug}.opy:${line_no}"
            fi
        elif [[ "$expected_team" == "enemy" ]]; then
            if [[ "$line_text" == *"getPlayers(eventPlayer.getTeam()).reset_pvar[$slot]"* ]]; then
                warn "slot[$slot] expects enemy mapping at ${slug}.opy:${line_no}, but writes to ally team"
            fi
            if [[ "$line_text" == *"getPlayers(getOppositeTeam(eventPlayer.getTeam())).reset_pvar[$slot]"* ]]; then
                pass "slot[$slot] enemy direction semantics OK at ${slug}.opy:${line_no}"
            fi
        fi
    done

    rules_tag_hits="$(rg -n "@Hero[[:space:]]+${hero_tag}(\s|$)" "$hero_dir" -g '*.opy' -g '!init.opy' -g '!main.opy' -g '!aram.opy' || true)"
    rules_const_hits="$(rg -n "Hero\.${hero_const}(\b|[^A-Z_0-9])" "$hero_dir" -g '*.opy' -g '!init.opy' -g '!main.opy' -g '!aram.opy' || true)"
    rules_hit_count="$((
        $(printf '%s\n' "$rules_tag_hits" | sed '/^$/d' | wc -l | tr -d ' ') +
        $(printf '%s\n' "$rules_const_hits" | sed '/^$/d' | wc -l | tr -d ' ')
    ))"

    if [[ "$rules_hit_count" -gt 0 ]]; then
        pass "hero_rules touchpoint detected for ${slug}"
        local -a touched_rule_files
        mapfile -t touched_rule_files < <({
            printf '%s\n' "$rules_tag_hits"
            printf '%s\n' "$rules_const_hits"
        } | sed '/^$/d' | cut -d: -f1 | sort -u)
        audit_cooldown_placement "$slug" "$hero_tag" "${touched_rule_files[@]}"
        audit_throttle_risks "$slug" "${touched_rule_files[@]}"
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

if [[ "$report_template" == true ]]; then
    if [[ -z "$report_path" ]]; then
        report_path="docs/reports/hero-pipeline-review-$(date '+%Y%m%d-%H%M%S').md"
    fi
    current_hero="global"
    generate_review_report_template "$report_path"
fi

echo
printf 'Summary: %s passed, %s warning(s), %s failure(s)\n' "$passes" "$warnings" "$failures"

if [[ "$failures" -gt 0 ]]; then
    exit 1
fi

exit 0
