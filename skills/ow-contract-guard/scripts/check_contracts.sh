#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'USAGE'
Usage: scripts/check_contracts.sh [--strict-hero-init] [--build]

Options:
  --strict-hero-init  Treat missing hero init condition as a failure (default: warning)
  --build             Run `pnpm run build` after contract checks
  -h, --help          Show this help text
USAGE
}

strict_hero_init=false
run_build=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --strict-hero-init)
            strict_hero_init=true
            ;;
        --build)
            run_build=true
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

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT_DIR"

for cmd in rg awk sed sort wc tail; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Missing required command: $cmd" >&2
        exit 2
    fi
done

failures=0
warnings=0
passes=0

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
    local file="$1"
    local needle="$2"
    local matches count
    matches="$(rg -n --fixed-strings "$needle" "$file" || true)"
    count="$(printf '%s\n' "$matches" | sed '/^$/d' | wc -l | tr -d ' ')"
    printf '%s\n' "$count"
}

line_of_fixed_match() {
    local file="$1"
    local needle="$2"
    local matches
    matches="$(rg -n --fixed-strings "$needle" "$file" || true)"
    printf '%s\n' "$matches" | sed -n '1p' | cut -d: -f1
}

echo "Running ow-contract-guard checks from: $ROOT_DIR"

# 1) Top-level flattened main include order contract
main_file="src/main.opy"
main_optimize='#!optimizeStrict'

flatten_index_includes() {
    local file="$1"
    local base include target rel
    base="$(cd "$(dirname "$file")" && pwd)"

    while IFS= read -r include; do
        [[ -z "$include" ]] && continue

        target="$(cd "$base" && cd "$(dirname "$include")" && printf '%s/%s' "$PWD" "$(basename "$include")")"
        rel="${target#${ROOT_DIR}/src/}"

        if [[ "$(basename "$target")" == "_index.opy" ]]; then
            flatten_index_includes "$target"
        else
            printf '%s\n' "$rel"
        fi
    done < <(awk '/^[[:space:]]*#!include[[:space:]]+"[^"]+"/ {
        line = $0
        sub(/^[[:space:]]*#!include[[:space:]]+"/, "", line)
        sub(/".*$/, "", line)
        print line
    }' "$file")
}

compare_array_by_name() {
    local label="$1"
    local actual_name="$2"
    local expected_name="$3"
    local actual_len expected_len i actual_item expected_item

    eval "actual_len=\${#${actual_name}[@]}"
    eval "expected_len=\${#${expected_name}[@]}"

    if [[ "$actual_len" -ne "$expected_len" ]]; then
        fail "$label include count mismatch (actual=$actual_len expected=$expected_len)"
        return
    fi

    for ((i = 0; i < expected_len; i++)); do
        eval "actual_item=\${${actual_name}[$i]}"
        eval "expected_item=\${${expected_name}[$i]}"

        if [[ "$actual_item" != "$expected_item" ]]; then
            fail "$label include mismatch at position $((i + 1)): actual=$actual_item expected=$expected_item"
            return
        fi
    done

    pass "$label include order contract preserved"
}

main_includes=()
main_include_lines=()
while IFS=$'\t' read -r line path; do
    [[ -z "${line}" ]] && continue
    main_include_lines+=("$line")
    main_includes+=("$path")
done < <(awk '/^[[:space:]]*#!include[[:space:]]+"[^"]+"/ {
    line = $0
    sub(/^[[:space:]]*#!include[[:space:]]+"/, "", line)
    sub(/".*$/, "", line)
    printf "%d\t%s\n", NR, line
}' "$main_file")

index_ref_count=0
for path in "${main_includes[@]}"; do
    if [[ "$path" == */_index.opy ]]; then
        index_ref_count=$((index_ref_count + 1))
    fi
done

if [[ "$index_ref_count" == "0" ]]; then
    pass "main includes are flattened (no *_index.opy references)"
else
    fail "main still references *_index.opy includes (count=$index_ref_count)"
fi

optimize_count="$(count_fixed_matches "$main_file" "$main_optimize")"
if [[ "$optimize_count" == "1" ]]; then
    optimize_line="$(line_of_fixed_match "$main_file" "$main_optimize")"
    pass "main directive: #!optimizeStrict at line $optimize_line"
else
    fail "main directive missing/duplicated: #!optimizeStrict (count=$optimize_count)"
fi

if [[ "$optimize_count" == "1" ]]; then
    expected_before_optimize=("constants/player_constants.opy")
    while IFS= read -r include; do
        [[ -z "$include" ]] && continue
        expected_before_optimize+=("$include")
    done < <(flatten_index_includes "${ROOT_DIR}/src/modules/prelude/_index.opy")

    expected_after_optimize=()
    while IFS= read -r include; do
        [[ -z "$include" ]] && continue
        expected_after_optimize+=("$include")
    done < <(flatten_index_includes "${ROOT_DIR}/src/modules/_index.opy")

    actual_before_optimize=()
    actual_after_optimize=()
    while IFS=$'\t' read -r line path; do
        [[ -z "${line}" ]] && continue
        if [[ "$line" -lt "$optimize_line" ]]; then
            actual_before_optimize+=("$path")
        elif [[ "$line" -gt "$optimize_line" ]]; then
            actual_after_optimize+=("$path")
        fi
    done < <(awk '/^[[:space:]]*#!include[[:space:]]+"[^"]+"/ {
        line = $0
        sub(/^[[:space:]]*#!include[[:space:]]+"/, "", line)
        sub(/".*$/, "", line)
        printf "%d\t%s\n", NR, line
    }' "$main_file")

    compare_array_by_name "main before optimizeStrict" actual_before_optimize expected_before_optimize
    compare_array_by_name "main after optimizeStrict" actual_after_optimize expected_after_optimize
fi

# 2) Delimiter include boundaries
ai_index_file="src/modules/ai/_index.opy"
hero_init_index_file="src/modules/hero_init/_index.opy"

ai_first="$(sed -n '1p' "$ai_index_file")"
ai_last="$(tail -n 1 "$ai_index_file")"
if [[ "$ai_first" == '#!include "00-delimiter-begin.opy"' && "$ai_last" == '#!include "99-delimiter-end.opy"' ]]; then
    pass "AI delimiter includes are at the beginning/end of ai/_index.opy"
else
    fail "AI delimiter include boundaries are broken in ai/_index.opy"
fi

hero_init_first="$(sed -n '1p' "$hero_init_index_file")"
hero_init_last="$(tail -n 1 "$hero_init_index_file")"
if [[ "$hero_init_first" == '#!include "00-delimiter-begin.opy"' && "$hero_init_last" == '#!include "99-delimiter-end.opy"' ]]; then
    pass "Hero init delimiter includes are at the beginning/end of hero_init/_index.opy"
else
    fail "Hero init delimiter include boundaries are broken in hero_init/_index.opy"
fi

# 3) Required delimiter rule names must exist exactly once
required_delimiters=(
    'Initialize AI Scripts'
    'Initialize AI Scripts End'
    'Initialize Heroes'
    'Initialize Heors End'
)

for name in "${required_delimiters[@]}"; do
    matches="$(rg -n "^rule \"${name}\":$" src/modules || true)"
    count="$(printf '%s\n' "$matches" | sed '/^$/d' | wc -l | tr -d ' ')"
    if [[ "$count" == "1" ]]; then
        pass "delimiter rule exists exactly once: $name"
    else
        fail "delimiter rule missing/duplicated: $name (count=$count)"
    fi
done

# 4) Protocol index mapping and duplicate index checks
protocol_file="skills/ow-contract-guard/references/protocol-indexes.tsv"
if [[ ! -f "$protocol_file" ]]; then
    fail "protocol index reference file missing: $protocol_file"
else
    pass "protocol index reference file found"
fi

check_duplicate_indices() {
    local kind="$1"
    local file="$2"
    local dupes
    dupes="$(awk -v k="$kind" '$1 == k {print $3}' "$file" | sort -n | uniq -d)"
    if [[ -n "$dupes" ]]; then
        fail "$kind has duplicate index values in $file: $(printf '%s' "$dupes" | tr '\n' ' ')"
    else
        pass "$kind has no duplicate index values in $file"
    fi
}

check_duplicate_indices "globalvar" "src/modules/prelude/01-global-vars.opy"
check_duplicate_indices "playervar" "src/modules/prelude/02-player-vars.opy"
check_duplicate_indices "subroutine" "src/modules/prelude/03-subroutine-names.opy"

if [[ -f "$protocol_file" ]]; then
    while IFS=$'\t' read -r kind name index; do
        [[ -z "${kind}" ]] && continue
        case "$kind" in
            globalvar)
                file="src/modules/prelude/01-global-vars.opy"
                ;;
            playervar)
                file="src/modules/prelude/02-player-vars.opy"
                ;;
            subroutine)
                file="src/modules/prelude/03-subroutine-names.opy"
                ;;
            *)
                fail "unknown kind in protocol file: $kind"
                continue
                ;;
        esac

        pattern="^${kind} ${name} ${index}(\\s|$)"
        matches="$(rg -n "$pattern" "$file" || true)"
        count="$(printf '%s\n' "$matches" | sed '/^$/d' | wc -l | tr -d ' ')"

        if [[ "$count" == "1" ]]; then
            pass "index mapping preserved: ${kind} ${name} ${index}"
        else
            fail "index mapping changed/missing: ${kind} ${name} ${index}"
        fi
    done < "$protocol_file"
fi

# 5) reset_pvar stable slot map in resetFrenemies
reset_file="src/utilities/reset_frenemies.opy"
stable_slots=(1 3 4 5 6 7 9 11 12 13 14 15 16)

for slot in "${stable_slots[@]}"; do
    count="$(count_fixed_matches "$reset_file" "eventPlayer.reset_pvar[$slot] =")"
    if [[ "$count" == "1" ]]; then
        pass "reset slot mapping present once: reset_pvar[$slot]"
    else
        fail "reset slot mapping broken for reset_pvar[$slot] (count=$count)"
    fi
done

# 6) Hero init detect/initialize safety checks
for hero_file in src/modules/hero_init/heroes/*.opy; do
    hero_name="$(basename "$hero_file")"

    rule_count="$(rg -n '^rule "' "$hero_file" | wc -l | tr -d ' ')"
    true_count="$(count_fixed_matches "$hero_file" 'eventPlayer.reset_pvar[0] = true')"
    false_count="$(count_fixed_matches "$hero_file" 'eventPlayer.reset_pvar[0] = false')"
    reset_hero_count="$(count_fixed_matches "$hero_file" 'resetHero()')"

    cond_a="$(count_fixed_matches "$hero_file" '@Condition eventPlayer.reset_pvar[0] != false')"
    cond_b="$(count_fixed_matches "$hero_file" '@Condition eventPlayer.reset_pvar[0] == true')"
    cond_count=$((cond_a + cond_b))

    if [[ "$rule_count" -ge 2 ]]; then
        pass "$hero_name has at least two rules"
    else
        fail "$hero_name should include Detect + Initialize rules (rule count=$rule_count)"
    fi

    if [[ "$true_count" -ge 1 ]]; then
        pass "$hero_name sets reset_pvar[0] = true"
    else
        fail "$hero_name missing reset_pvar[0] = true trigger"
    fi

    if [[ "$false_count" -ge 1 ]]; then
        pass "$hero_name resets reset_pvar[0] = false"
    else
        fail "$hero_name missing reset_pvar[0] = false reset"
    fi

    if [[ "$reset_hero_count" -ge 1 ]]; then
        pass "$hero_name calls resetHero() in initialization"
    else
        fail "$hero_name missing resetHero() call"
    fi

    if [[ "$cond_count" -ge 1 ]]; then
        pass "$hero_name gates initialize rule with reset_pvar[0] condition"
    else
        if [[ "$strict_hero_init" == true ]]; then
            fail "$hero_name missing initialize gating condition on reset_pvar[0]"
        else
            warn "$hero_name missing initialize gating condition on reset_pvar[0]"
        fi
    fi

done

# 7) Optional build gate
if [[ "$run_build" == true ]]; then
    if ! command -v pnpm >/dev/null 2>&1; then
        fail "pnpm is required for --build"
    else
        echo "Running build gate: pnpm run build"
        if pnpm run build; then
            pass "build succeeded"
        else
            fail "build failed"
        fi
    fi
fi

echo
printf 'Summary: %s passed, %s warning(s), %s failure(s)\n' "$passes" "$warnings" "$failures"

if [[ "$failures" -gt 0 ]]; then
    exit 1
fi

exit 0
