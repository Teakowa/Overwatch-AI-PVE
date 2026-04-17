#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'USAGE'
Usage:
  scripts/changelog_sync.sh [--hero <slug>]... [--from-diff [range]]
                            [--strict-coverage] [--strict-language]
                            [--strict-settings-sync]
                            [--report [path]] [--list-heroes] [--help]

Examples:
  scripts/changelog_sync.sh --from-diff
  scripts/changelog_sync.sh --hero freja --strict-coverage --strict-language
  scripts/changelog_sync.sh --from-diff --report
USAGE
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT_DIR"

for cmd in rg awk sed sort uniq git mktemp date mkdir basename dirname; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Missing required command: $cmd" >&2
        exit 2
    fi
done

changelog_file="src/modules/debug/changelog.opy"

strict_coverage=false
strict_language=true
strict_settings_sync=false
use_from_diff=false
diff_range="HEAD"
emit_report=false
report_path=""
list_heroes=false

declare -a requested_heroes=()
declare -a target_heroes=()

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

while [[ $# -gt 0 ]]; do
    case "$1" in
        --hero)
            if [[ $# -lt 2 ]]; then
                echo "--hero requires a value" >&2
                exit 2
            fi
            requested_heroes+=("$2")
            shift
            ;;
        --from-diff)
            use_from_diff=true
            if [[ $# -gt 1 && "$2" != --* ]]; then
                diff_range="$2"
                shift
            fi
            ;;
        --strict-coverage)
            strict_coverage=true
            ;;
        --strict-language)
            strict_language=true
            ;;
        --strict-settings-sync)
            strict_settings_sync=true
            ;;
        --report)
            emit_report=true
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

list_all_heroes() {
    rg --files src/heroes \
        | sed -n -E 's#^src/heroes/([^/]+)/init\.opy$#\1#p' \
        | sort
}

is_known_hero() {
    local slug="$1"
    [[ -f "src/heroes/${slug}/init.opy" ]]
}

normalize_tag_to_slug() {
    local tag="$1"
    local normalized

    normalized="$(printf '%s' "$tag" | sed -E 's/([a-z0-9])([A-Z])/\1_\2/g' | tr '[:upper:]' '[:lower:]')"

    case "$normalized" in
        soldier)
            printf 'soldier76\n'
            ;;
        wreckingball)
            printf 'wrecking_ball\n'
            ;;
        junkerqueen)
            printf 'junker_queen\n'
            ;;
        *)
            printf '%s\n' "$normalized"
            ;;
    esac
}

slug_from_const() {
    local const="$1"
    case "$const" in
        SOLDIER)
            printf 'soldier76\n'
            ;;
        WRECKING_BALL)
            printf 'wrecking_ball\n'
            ;;
        JUNKER_QUEEN)
            printf 'junker_queen\n'
            ;;
        *)
            printf '%s\n' "$(printf '%s' "$const" | tr '[:upper:]' '[:lower:]')"
            ;;
    esac
}

slug_to_settings_key() {
    local slug="$1"
    case "$slug" in
        wrecking_ball)
            printf 'wreckingBall\n'
            ;;
        junker_queen)
            printf 'junkerQueen\n'
            ;;
        *)
            if [[ "$slug" == *"_"* ]]; then
                printf '%s\n' "$slug" | awk -F'_' '{printf $1; for (i=2; i<=NF; i++) printf toupper(substr($i,1,1)) substr($i,2); printf "\n"}'
            else
                printf '%s\n' "$slug"
            fi
            ;;
    esac
}

const_from_slug() {
    local slug="$1"
    case "$slug" in
        soldier76)
            printf 'SOLDIER\n'
            ;;
        wrecking_ball)
            printf 'WRECKING_BALL\n'
            ;;
        junker_queen)
            printf 'JUNKER_QUEEN\n'
            ;;
        *)
            printf '%s\n' "$(printf '%s' "$slug" | tr '[:lower:]' '[:upper:]')"
            ;;
    esac
}

add_target_hero() {
    local raw="$1"
    local slug

    slug="$(normalize_tag_to_slug "$raw")"
    if is_known_hero "$slug"; then
        target_heroes+=("$slug")
    fi
}

if [[ "$list_heroes" == true ]]; then
    echo "Available heroes (from src/heroes/*/init.opy):"
    list_all_heroes
    exit 0
fi

collect_changed_files() {
    local range="$1"
    git diff --name-only "$range" -- src/heroes src/modules/prelude/settings.opy "$changelog_file" 2>/dev/null || true
}

collect_heroes_from_diff() {
    local range="$1"
    local file

    while IFS= read -r file; do
        [[ -z "$file" ]] && continue

        if [[ "$file" =~ ^src/heroes/([^/]+)/.+\.opy$ ]]; then
            add_target_hero "${BASH_REMATCH[1]}"
        fi
        if [[ "$file" == "src/modules/prelude/settings.opy" ]]; then
            while IFS= read -r hero_key; do
                [[ -z "$hero_key" ]] && continue
                add_target_hero "$hero_key"
            done < <((git diff --unified=3 "$range" -- "$file" || true) \
                | sed -n 's/^[-+][[:space:]]*"\([A-Za-z0-9_]\+\)"[[:space:]]*:[[:space:]]*{.*/\1/p')
        fi

        if [[ ! -f "$file" ]]; then
            continue
        fi

        while IFS= read -r tag; do
            [[ -z "$tag" ]] && continue
            add_target_hero "$tag"
        done < <((git diff --unified=0 "$range" -- "$file" || true) \
            | sed -n 's/^[-+]\s*@Hero\s\+\([A-Za-z0-9_]\+\).*/\1/p')

        while IFS= read -r const; do
            [[ -z "$const" ]] && continue
            add_target_hero "$(slug_from_const "$const")"
        done < <((git diff --unified=0 "$range" -- "$file" || true) \
            | rg -o 'Hero\.[A-Z0-9_]+' \
            | sed 's/^Hero\.//' || true)

    done < <(collect_changed_files "$range")
}

if [[ "${#requested_heroes[@]}" -gt 0 ]]; then
    for hero in "${requested_heroes[@]}"; do
        add_target_hero "$hero"
    done
fi

if [[ "$use_from_diff" == true ]]; then
    collect_heroes_from_diff "$diff_range"
fi

if [[ "${#target_heroes[@]}" -eq 0 ]]; then
    if [[ "$use_from_diff" == true ]]; then
        echo "No impacted heroes found from diff range: $diff_range"
        exit 0
    fi
    echo "No target heroes provided. Use --hero <slug> or --from-diff [range]." >&2
    exit 2
fi

mapfile -t target_heroes < <(printf '%s\n' "${target_heroes[@]}" | sort -u)

contains_banned_team_wording() {
    local text="$1"
    local label="$2"
    local found=false

    local patterns=(
        "Team 1"
        "Team1"
        "Team 2"
        "Team2"
        "队伍1"
        "队伍 1"
        "队伍2"
        "队伍 2"
        "机器人队伍"
        "玩家队伍"
        "阵营"
    )

    for p in "${patterns[@]}"; do
        if printf '%s\n' "$text" | rg -q --fixed-strings "$p"; then
            found=true
            if [[ "$strict_language" == true ]]; then
                fail "${label} contains team-number wording: '$p'"
            else
                warn "${label} contains team-number wording: '$p'"
            fi
        fi
    done

    [[ "$found" == true ]]
}

check_changelog_language() {
    local quoted_lines
    quoted_lines="$(rg -n 'hudText\(|hudSubtext\(' "$changelog_file" || true)"

    if [[ -z "$quoted_lines" ]]; then
        warn "No hudText/hudSubtext lines found in changelog file"
        return
    fi

    if contains_banned_team_wording "$quoted_lines" "changelog content"; then
        :
    else
        pass "changelog content does not use Team 1/Team 2 wording"
    fi
}

coverage_count_for_hero() {
    local slug="$1"
    local const
    const="$(const_from_slug "$slug")"
    (rg -n --fixed-strings "eventPlayer.getHero() == Hero.${const}" "$changelog_file" || true) | wc -l | tr -d ' '
}

sanitize_diff_line() {
    local line="$1"
    local sanitized="$line"

    sanitized="$(printf '%s' "$sanitized" | sed -E 's/Team\.1/特定队伍/g; s/Team\.2/特定队伍/g')"
    sanitized="$(printf '%s' "$sanitized" | sed -E 's/getOppositeTeam\(eventPlayer\.getTeam\(\)\)/敌方目标/g')"
    sanitized="$(printf '%s' "$sanitized" | sed -E 's/eventPlayer\.getTeam\(\)/当前队伍/g')"
    sanitized="$(printf '%s' "$sanitized" | sed -E 's/[[:space:]]+/ /g; s/^ //; s/ $//')"

    if [[ ${#sanitized} -gt 120 ]]; then
        sanitized="${sanitized:0:117}..."
    fi

    printf '%s\n' "$sanitized"
}

collect_settings_cooldown_clues_for_hero() {
    local slug="$1"
    local range="$2"
    local hero_key
    local settings_file="src/modules/prelude/settings.opy"

    hero_key="$(slug_to_settings_key "$slug")"

    (git diff --unified=3 "$range" -- "$settings_file" || true) | awk -v hero="$hero_key" '
        function trim(s) {
            sub(/^[[:space:]]+/, "", s)
            sub(/[[:space:]]+$/, "", s)
            return s
        }
        {
            line = $0
            if (line ~ /^[ +-][[:space:]]*"[^"]+"[[:space:]]*:[[:space:]]*{[[:space:]]*$/) {
                section = line
                sub(/^[ +-][[:space:]]*"/, "", section)
                sub(/".*/, "", section)
                current = section
            }

            if (current != hero) {
                next
            }

            if (line ~ /^[+-][[:space:]]*"(ability1Cooldown%|ability2Cooldown%|secondaryFireCooldown%)"[[:space:]]*:/) {
                sign = substr(line, 1, 1)
                value = line
                sub(/^[+-][[:space:]]*/, "", value)
                value = trim(value)
                sub(/,$/, "", value)
                if (sign == "+") {
                    print "新增线索: settings " value
                } else if (sign == "-") {
                    print "移除线索: settings " value
                }
            }
        }
    ' | awk '!seen[$0]++'
}

collect_diff_clues_for_hero() {
    local slug="$1"
    local range="$2"
    local const
    local tmp
    local file

    const="$(const_from_slug "$slug")"
    tmp="$(mktemp)"

    while IFS= read -r file; do
        [[ -z "$file" ]] && continue

        if [[ "$file" == "src/modules/prelude/settings.opy" ]]; then
            continue
        fi

        local file_match=false
        if [[ "$file" =~ ^src/heroes/${slug}/.+\.opy$ ]]; then
            file_match=true
        fi

        while IFS= read -r line; do
            [[ "$line" == +++* || "$line" == ---* ]] && continue
            [[ "$line" == +* || "$line" == -* ]] || continue

            sign="${line:0:1}"
            content="${line:1}"

            match=false
            if [[ "$file_match" == true ]]; then
                match=true
            fi
            if [[ "$content" == *"Hero.${const}"* ]]; then
                match=true
            fi
            if [[ "$content" =~ @Hero[[:space:]]+ ]]; then
                tag_candidate="$(printf '%s\n' "$content" | sed -n 's/.*@Hero[[:space:]]\+\([A-Za-z0-9_]*\).*/\1/p')"
                if [[ -n "$tag_candidate" ]]; then
                    if [[ "$(normalize_tag_to_slug "$tag_candidate")" == "$slug" ]]; then
                        match=true
                    fi
                fi
            fi

            if [[ "$match" != true ]]; then
                continue
            fi

            trimmed="$(printf '%s\n' "$content" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"

            [[ -z "$trimmed" ]] && continue
            [[ "$trimmed" == \#* ]] && continue
            [[ "$trimmed" == rule\ * ]] && continue
            [[ "$trimmed" == @* ]] && continue
            [[ "$trimmed" == *":" && "$trimmed" == lbl_* ]] && continue

            cleaned="$(sanitize_diff_line "$trimmed")"
            [[ -z "$cleaned" ]] && continue

            if [[ "$sign" == "+" ]]; then
                printf '新增线索: %s\n' "$cleaned" >> "$tmp"
            else
                printf '移除线索: %s\n' "$cleaned" >> "$tmp"
            fi

        done < <(git diff --unified=0 "$range" -- "$file" || true)

    done < <(collect_changed_files "$range")

    while IFS= read -r setting_clue; do
        [[ -z "$setting_clue" ]] && continue
        printf '%s\n' "$setting_clue" >> "$tmp"
    done < <(collect_settings_cooldown_clues_for_hero "$slug" "$range")

    awk '!seen[$0]++' "$tmp" | head -n 10
    rm -f "$tmp"
}

check_settings_cooldown_alignment_for_hero() {
    local slug="$1"
    local const
    local cooldown_clues
    local branch_touched

    cooldown_clues="$(collect_settings_cooldown_clues_for_hero "$slug" "$diff_range")"
    if [[ -z "$cooldown_clues" ]]; then
        return
    fi

    const="$(const_from_slug "$slug")"
    if ! rg -n --fixed-strings "eventPlayer.getHero() == Hero.${const}" "$changelog_file" >/dev/null; then
        if [[ "$strict_settings_sync" == true ]]; then
            fail "settings cooldown changed for ${slug}, but changelog branch Hero.${const} not found"
        else
            warn "settings cooldown changed for ${slug}, but changelog branch Hero.${const} not found"
        fi
        return
    fi

    branch_touched="$( (git diff --unified=3 "$diff_range" -- "$changelog_file" || true) | awk -v hero_const="$const" '
        BEGIN { in_branch = 0; touched = 0 }
        /^[ +-][[:space:]]*elif eventPlayer\.getHero\(\) == Hero\./ {
            if ($0 ~ ("Hero\\." hero_const)) {
                in_branch = 1
            } else {
                in_branch = 0
            }
            next
        }
        in_branch == 1 && /^[+-]/ && $0 !~ /^\+\+\+/ && $0 !~ /^---/ {
            touched = 1
        }
        END {
            if (touched == 1) {
                print "true"
            } else {
                print "false"
            }
        }
    ')"
    if [[ "$branch_touched" == "true" ]]; then
        pass "settings cooldown sync OK for ${slug} (changelog branch updated in diff)"
    else
        if [[ "$strict_settings_sync" == true ]]; then
            fail "settings cooldown changed for ${slug}, but changelog branch was not updated in diff"
        else
            warn "settings cooldown changed for ${slug}, but changelog branch was not updated in diff"
        fi
    fi
}

render_report() {
    local out_path="$1"
    local now

    now="$(date '+%Y-%m-%d %H:%M:%S %z')"
    mkdir -p "$(dirname "$out_path")"

    {
        echo "# Changelog Sync Report"
        echo
        echo "- Generated At: ${now}"
        echo "- Branch: $(git branch --show-current)"
        echo "- Diff Range: ${diff_range}"
        echo "- Heroes: ${target_heroes[*]}"
        echo "- Summary: ${passes} passed / ${warnings} warnings / ${failures} failures"
        echo
        echo "## Coverage"
        for hero in "${target_heroes[@]}"; do
            const="$(const_from_slug "$hero")"
            count="$(coverage_count_for_hero "$hero")"
            if [[ "$count" -eq 1 ]]; then
                echo "- [OK] ${hero}: Hero.${const} branch exists"
            elif [[ "$count" -gt 1 ]]; then
                echo "- [WARN] ${hero}: Hero.${const} branch duplicated (${count})"
            else
                echo "- [WARN] ${hero}: Hero.${const} branch missing"
            fi
        done
        echo
        echo "## Pending Player-Facing Changelog Items"
        for hero in "${target_heroes[@]}"; do
            echo "### ${hero}"
            clues="$(collect_diff_clues_for_hero "$hero" "$diff_range")"
            if [[ -z "$clues" ]]; then
                echo "- [ ] 未从 diff 中提取到直接线索，手动补充该英雄本次改动要点"
            else
                while IFS= read -r clue; do
                    [[ -z "$clue" ]] && continue
                    echo "- [ ] ${clue}"
                done <<< "$clues"
            fi
            echo "- [ ] 将以上线索转译为玩家可读文案（避免队伍编号表达）"
            echo
        done
        echo "## Language Rule"
        echo "- changelog 面向玩家，不使用队伍编号表达。"
    } > "$out_path"

    if contains_banned_team_wording "$(cat "$out_path")" "generated report"; then
        :
    else
        pass "report generated: $out_path"
    fi
}

echo "Running ow-changelog-sync from: $ROOT_DIR"
echo "Target heroes: ${target_heroes[*]}"

check_changelog_language

for hero in "${target_heroes[@]}"; do
    const="$(const_from_slug "$hero")"
    coverage_count="$(coverage_count_for_hero "$hero")"

    if [[ "$coverage_count" -eq 1 ]]; then
        pass "coverage OK for ${hero} (Hero.${const})"
    elif [[ "$coverage_count" -gt 1 ]]; then
        if [[ "$strict_coverage" == true ]]; then
            fail "coverage duplicated for ${hero} (Hero.${const}, count=${coverage_count})"
        else
            warn "coverage duplicated for ${hero} (Hero.${const}, count=${coverage_count})"
        fi
    else
        if [[ "$strict_coverage" == true ]]; then
            fail "coverage missing for ${hero} (Hero.${const})"
        else
            warn "coverage missing for ${hero} (Hero.${const})"
        fi
    fi

    clues="$(collect_diff_clues_for_hero "$hero" "$diff_range")"
    if [[ -n "$clues" ]]; then
        pass "diff clues extracted for ${hero}"
        while IFS= read -r clue; do
            [[ -z "$clue" ]] && continue
            echo "  - ${hero}: ${clue}"
        done <<< "$clues"
    else
        warn "no diff clues extracted for ${hero} from range ${diff_range}"
    fi

    check_settings_cooldown_alignment_for_hero "$hero"
done

if [[ "$emit_report" == true ]]; then
    if [[ -z "$report_path" ]]; then
        report_path="docs/reports/changelog-sync-$(date '+%Y%m%d-%H%M%S').md"
    fi
    render_report "$report_path"
fi

echo
printf 'Summary: %s passed, %s warning(s), %s failure(s)\n' "$passes" "$warnings" "$failures"

if [[ "$failures" -gt 0 ]]; then
    exit 1
fi

exit 0
