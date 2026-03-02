#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'USAGE'
Usage:
  scripts/metrics_sync.sh [--check] [--report [path]] [--help]

Examples:
  scripts/metrics_sync.sh
  scripts/metrics_sync.sh --check
  scripts/metrics_sync.sh --report
  scripts/metrics_sync.sh --report docs/reports/module-metrics-sync-latest.md
USAGE
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT_DIR"

for cmd in rg awk sed sort uniq mktemp date mkdir dirname basename cmp diff cp; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Missing required command: $cmd" >&2
        exit 2
    fi
done

check_only=false
emit_report=false
report_path=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --check)
            check_only=true
            ;;
        --report)
            emit_report=true
            if [[ $# -gt 1 && "$2" != --* ]]; then
                report_path="$2"
                shift
            fi
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

count_pattern() {
    local path="$1"
    local pattern="$2"
    (rg -n "$pattern" "$path" --glob '*.opy' || true) | wc -l | tr -d ' '
}

replace_line_or_fail() {
    local file="$1"
    local regex="$2"
    local replacement="$3"
    local tmp
    local status

    tmp="$(mktemp)"

    status=0
    awk -v regex="$regex" -v replacement="$replacement" '
        BEGIN { replaced = 0 }
        {
            if ($0 ~ regex) {
                print replacement
                replaced += 1
                next
            }
            print
        }
        END {
            if (replaced == 0) {
                exit 42
            }
            if (replaced > 1) {
                exit 43
            }
        }
    ' "$file" > "$tmp" || status=$?

    if [[ "$status" -eq 0 ]]; then
        mv "$tmp" "$file"
        return
    fi

    rm -f "$tmp"

    if [[ "$status" -eq 42 ]]; then
        fail "pattern not found in $file: $regex"
    elif [[ "$status" -eq 43 ]]; then
        fail "pattern matched multiple lines in $file: $regex"
    else
        fail "failed to rewrite $file"
    fi
}

apply_updates() {
    local file_01="$1/docs/modules/01-main-opy-architecture.md"
    local file_02="$1/docs/modules/02-modular-split-plan.md"
    local file_04="$1/docs/modules/04-current-implementation-summary.md"
    local file_appendix="$1/docs/modules/appendix-src-file-index.md"

    replace_line_or_fail "$file_01" '^- 规则数：`[0-9]+`$' "- 规则数：\`${total_rules}\`"
    replace_line_or_fail "$file_01" '^- `globalvar`：`[0-9]+`$' "- \`globalvar\`：\`${globalvar_total}\`"
    replace_line_or_fail "$file_01" '^- `playervar`：`[0-9]+`$' "- \`playervar\`：\`${playervar_total}\`"
    replace_line_or_fail "$file_01" '^- `subroutine` 声明：`[0-9]+`$' "- \`subroutine\` 声明：\`${subroutine_total}\`"
    replace_line_or_fail "$file_01" '^- `def` 子程序实现：`[0-9]+`$' "- \`def\` 子程序实现：\`${def_total}\`"
    replace_line_or_fail "$file_01" '^- `@Disabled` 规则：`[0-9]+`$' "- \`@Disabled\` 规则：\`${disabled_total}\`"

    replace_line_or_fail "$file_04" '^- `rule` 总数：`[0-9]+`$' "- \`rule\` 总数：\`${total_rules}\`"
    replace_line_or_fail "$file_04" '^- `globalvar`：`[0-9]+`$' "- \`globalvar\`：\`${globalvar_total}\`"
    replace_line_or_fail "$file_04" '^- `playervar`：`[0-9]+`$' "- \`playervar\`：\`${playervar_total}\`"
    replace_line_or_fail "$file_04" '^- `subroutine` 声明：`[0-9]+`$' "- \`subroutine\` 声明：\`${subroutine_total}\`"
    replace_line_or_fail "$file_04" '^- `def` 子程序实现：`[0-9]+`$' "- \`def\` 子程序实现：\`${def_total}\`"
    replace_line_or_fail "$file_04" '^- `@Disabled`：`[0-9]+`$' "- \`@Disabled\`：\`${disabled_total}\`"

    replace_line_or_fail "$file_04" '^- `bootstrap`：`[0-9]+` 条规则 [+] `[0-9]+` 个 `def`$' "- \`bootstrap\`：\`${bootstrap_rules}\` 条规则 + \`${bootstrap_defs}\` 个 \`def\`"
    replace_line_or_fail "$file_04" '^- `ai`：`[0-9]+` 条规则 [+] `[0-9]+` 个 `def`.*$' "- \`ai\`：\`${ai_rules}\` 条规则 + \`${ai_defs}\` 个 \`def\`（\`botAim2Target()\`）"
    replace_line_or_fail "$file_04" '^- `hero_rules`：`[0-9]+` 条规则 [+] `[0-9]+` 个 `def`.*$' "- \`hero_rules\`：\`${hero_rules_rules}\` 条规则 + \`${hero_rules_defs}\` 个 \`def\`（\`Knockback()\`）"
    replace_line_or_fail "$file_04" '^- `hero_init`：`[0-9]+` 条规则（.*$' "- \`hero_init\`：\`${hero_init_rules}\` 条规则（\`heroes/* + extras/* + delimiters\`）"
    replace_line_or_fail "$file_04" '^- `debug`：`[0-9]+` 条规则 [+] `[0-9]+` 个 `def`.*$' "- \`debug\`：\`${debug_rules}\` 条规则 + \`${debug_defs}\` 个 \`def\`（\`changelogText()\`）"

    replace_line_or_fail "$file_appendix" '^- `rule` 总数应保持 `[0-9]+`$' "- \`rule\` 总数应保持 \`${total_rules}\`"
    replace_line_or_fail "$file_02" '^- 规则总数维持 `[0-9]+`$' "- 规则总数维持 \`${total_rules}\`"
}

render_report() {
    local out_path="$1"
    local mode_label="$2"
    shift 2 || true
    local changed=("$@")

    mkdir -p "$(dirname "$out_path")"

    {
        echo "# Module Metrics Sync Report"
        echo
        echo "- Generated At: $(date '+%Y-%m-%d %H:%M:%S %z')"
        echo "- Branch: $(git branch --show-current)"
        echo "- Mode: ${mode_label}"
        echo
        echo "## Global Metrics"
        echo "- rule: ${total_rules}"
        echo "- globalvar: ${globalvar_total}"
        echo "- playervar: ${playervar_total}"
        echo "- subroutine: ${subroutine_total}"
        echo "- def: ${def_total}"
        echo "- @Disabled: ${disabled_total}"
        echo
        echo "## Module Metrics"
        echo "- bootstrap: ${bootstrap_rules} rules / ${bootstrap_defs} defs"
        echo "- ai: ${ai_rules} rules / ${ai_defs} defs"
        echo "- hero_rules: ${hero_rules_rules} rules / ${hero_rules_defs} defs"
        echo "- hero_init: ${hero_init_rules} rules / ${hero_init_defs} defs"
        echo "- debug: ${debug_rules} rules / ${debug_defs} defs"
        echo
        echo "## Managed Docs"
        if [[ "${#changed[@]}" -eq 0 ]]; then
            echo "- No diffs"
        else
            for f in "${changed[@]}"; do
                echo "- ${f}"
            done
        fi
        echo
        echo "## Summary"
        echo "- ${passes} passed / ${warnings} warnings / ${failures} failures"
    } > "$out_path"

    pass "report generated: $out_path"
}

docs_targets=(
    "docs/modules/01-main-opy-architecture.md"
    "docs/modules/02-modular-split-plan.md"
    "docs/modules/04-current-implementation-summary.md"
    "docs/modules/appendix-src-file-index.md"
)

echo "Running ow-module-metrics-sync from: $ROOT_DIR"

for target in "${docs_targets[@]}"; do
    if [[ -f "$target" ]]; then
        pass "managed doc found: $target"
    else
        fail "managed doc missing: $target"
    fi
done

total_rules="$(count_pattern "src/modules" '^rule "')"
globalvar_total="$(count_pattern "src/modules/prelude/01-global-vars.opy" '^globalvar[[:space:]]')"
playervar_total="$(count_pattern "src/modules/prelude/02-player-vars.opy" '^playervar[[:space:]]')"
subroutine_total="$(count_pattern "src/modules/prelude/03-subroutine-names.opy" '^subroutine[[:space:]]')"
def_total="$(count_pattern "src/modules" '^def[[:space:]]+[A-Za-z0-9_]+\(')"
disabled_total="$(count_pattern "src/modules" '@Disabled\b')"

bootstrap_rules="$(count_pattern "src/modules/bootstrap" '^rule "')"
bootstrap_defs="$(count_pattern "src/modules/bootstrap" '^def[[:space:]]+[A-Za-z0-9_]+\(')"
ai_rules="$(count_pattern "src/modules/ai" '^rule "')"
ai_defs="$(count_pattern "src/modules/ai" '^def[[:space:]]+[A-Za-z0-9_]+\(')"
hero_rules_rules="$(count_pattern "src/modules/hero_rules" '^rule "')"
hero_rules_defs="$(count_pattern "src/modules/hero_rules" '^def[[:space:]]+[A-Za-z0-9_]+\(')"
hero_init_rules="$(count_pattern "src/modules/hero_init" '^rule "')"
hero_init_defs="$(count_pattern "src/modules/hero_init" '^def[[:space:]]+[A-Za-z0-9_]+\(')"
debug_rules="$(count_pattern "src/modules/debug" '^rule "')"
debug_defs="$(count_pattern "src/modules/debug" '^def[[:space:]]+[A-Za-z0-9_]+\(')"

legacy_rules_total="$(count_pattern "src" '^rule "')"
legacy_defs_total="$(count_pattern "src" '^def[[:space:]]+[A-Za-z0-9_]+\(')"
legacy_disabled_total="$(count_pattern "src" '@Disabled\b')"

rules_outside_modules=$((legacy_rules_total - total_rules))
defs_outside_modules=$((legacy_defs_total - def_total))
disabled_outside_modules=$((legacy_disabled_total - disabled_total))

module_rule_sum=$((bootstrap_rules + ai_rules + hero_rules_rules + hero_init_rules + debug_rules))
module_def_sum=$((bootstrap_defs + ai_defs + hero_rules_defs + hero_init_defs + debug_defs))

if [[ "$module_rule_sum" -eq "$total_rules" ]]; then
    pass "module rule sum matches total rule count (${module_rule_sum})"
else
    warn "module rule sum (${module_rule_sum}) differs from total rules (${total_rules})"
fi

if [[ "$module_def_sum" -eq "$def_total" ]]; then
    pass "module def sum matches total def count (${module_def_sum})"
else
    warn "module def sum (${module_def_sum}) differs from total defs (${def_total})"
fi

if [[ "$rules_outside_modules" -gt 0 || "$defs_outside_modules" -gt 0 || "$disabled_outside_modules" -gt 0 ]]; then
    warn "ignored non-module declarations under src (rules=${rules_outside_modules}, defs=${defs_outside_modules}, disabled=${disabled_outside_modules})"
else
    pass "no extra declarations outside src/modules"
fi

echo "Computed metrics: rule=${total_rules}, globalvar=${globalvar_total}, playervar=${playervar_total}, subroutine=${subroutine_total}, def=${def_total}, disabled=${disabled_total}"

scratch_dir="$(mktemp -d)"
trap 'rm -rf "$scratch_dir"' EXIT

for target in "${docs_targets[@]}"; do
    mkdir -p "$scratch_dir/$(dirname "$target")"
    cp "$target" "$scratch_dir/$target"
done

apply_updates "$scratch_dir"

changed_files=()
for target in "${docs_targets[@]}"; do
    if ! cmp -s "$target" "$scratch_dir/$target"; then
        changed_files+=("$target")
        if [[ "$check_only" == true ]]; then
            fail "metrics drift detected: $target"
            diff -u "$target" "$scratch_dir/$target" | sed -n '1,80p' || true
        else
            cp "$scratch_dir/$target" "$target"
            pass "metrics updated: $target"
        fi
    else
        pass "metrics already in sync: $target"
    fi
done

if [[ "$emit_report" == true ]]; then
    if [[ -z "$report_path" ]]; then
        report_path="docs/reports/module-metrics-sync-$(date '+%Y%m%d-%H%M%S').md"
    fi

    if [[ "$check_only" == true ]]; then
        render_report "$report_path" "check"
    else
        render_report "$report_path" "write" "${changed_files[@]}"
    fi
fi

echo
printf 'Summary: %s passed, %s warning(s), %s failure(s)\n' "$passes" "$warnings" "$failures"

if [[ "$failures" -gt 0 ]]; then
    exit 1
fi

exit 0
