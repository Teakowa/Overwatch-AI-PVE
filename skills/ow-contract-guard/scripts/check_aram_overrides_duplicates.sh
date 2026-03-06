#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'USAGE'
Usage: skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh [--segment-min N] [--report PATH] [--whitelist PATH] [--emit-candidates PATH] [--check]

Options:
  --segment-min N       Minimum contiguous exact run length to enforce in aram_overrides (default: 2)
  --report PATH         Markdown report path (default: build/reports/aram_overrides_duplicates.md)
  --whitelist PATH      Delta whitelist TSV path (default: skills/ow-contract-guard/references/aram-delta-whitelist.tsv)
  --emit-candidates PATH  Emit unwhitelisted candidate TSV to this path
  --check               Exit 1 when violations are found
  -h, --help            Show this help text
USAGE
}

segment_min=2
report_path="build/reports/aram_overrides_duplicates.md"
whitelist_path="skills/ow-contract-guard/references/aram-delta-whitelist.tsv"
emit_candidates_path=""
check_mode="false"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --segment-min)
            shift
            [[ $# -gt 0 ]] || { echo "Missing value for --segment-min" >&2; exit 2; }
            segment_min="$1"
            ;;
        --report)
            shift
            [[ $# -gt 0 ]] || { echo "Missing value for --report" >&2; exit 2; }
            report_path="$1"
            ;;
        --whitelist)
            shift
            [[ $# -gt 0 ]] || { echo "Missing value for --whitelist" >&2; exit 2; }
            whitelist_path="$1"
            ;;
        --emit-candidates)
            shift
            [[ $# -gt 0 ]] || { echo "Missing value for --emit-candidates" >&2; exit 2; }
            emit_candidates_path="$1"
            ;;
        --check)
            check_mode="true"
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

if ! [[ "$segment_min" =~ ^[0-9]+$ ]]; then
    echo "--segment-min must be a non-negative integer" >&2
    exit 2
fi

for cmd in python3 rg awk sed; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Missing required command: $cmd" >&2
        exit 2
    fi
done

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT_DIR"

python3 - "$segment_min" "$report_path" "$check_mode" "$whitelist_path" "$emit_candidates_path" <<'PY'
from __future__ import annotations

import csv
import re
import sys
from collections import defaultdict
from pathlib import Path

segment_min = int(sys.argv[1])
report_path = Path(sys.argv[2])
check_mode = sys.argv[3].lower() == "true"
whitelist_path = Path(sys.argv[4]) if sys.argv[4] else None
emit_candidates_path = Path(sys.argv[5]) if sys.argv[5] else None

root = Path.cwd()
src = root / "src"
aram_file = src / "aram_overrides.opy"
heroes_root = src / "heroes"
overlay_heroes = sorted(p.name for p in heroes_root.iterdir() if p.is_dir()) if heroes_root.exists() else []

rule_re = re.compile(r'^rule\s+"([^"]+)":\s*$')
legacy_ref_pattern = 'aram_cross_hero_overrides|aram_overrides_segments'

whitelist_fieldnames = [
    "kind",
    "rule_or_macro",
    "source_module",
    "reason",
    "decision",
    "owner",
]
valid_decisions = {"keep_aram_only", "parameterize_shared"}


def parse_rules(path: Path):
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()
    rules = []
    i = 0
    while i < len(lines):
        match = rule_re.match(lines[i])
        if not match:
            i += 1
            continue
        start = i
        name = match.group(1)
        i += 1
        while i < len(lines) and not rule_re.match(lines[i]):
            i += 1
        end = i
        block = "\n".join(lines[start:end]) + "\n"
        norm = "\n".join(line.rstrip() for line in block.splitlines()).strip() + "\n"
        rules.append(
            {
                "name": name,
                "line": start + 1,
                "end": end,
                "norm": norm,
                "path": path,
            }
        )
    return rules


def is_mode_overlay(path: Path) -> bool:
    try:
        rel = path.relative_to(src)
    except ValueError:
        return False
    if path == aram_file:
        return False
    if path.name in {"aramMain.opy", "aram_settings.opy", "aram_protocol.opy"}:
        return False
    return path.name.startswith("aram") and path.name.endswith(".opy")


def rel_path(path: Path) -> str:
    return str(path.relative_to(root))


def normalize_value(value: str) -> str:
    return (value or "").strip()


def whitelist_keys(rows: list[dict]):
    return {
        (
            normalize_value(row.get("kind", "")),
            normalize_value(row.get("rule_or_macro", "")),
            normalize_value(row.get("source_module", "")),
        )
        for row in rows
    }


def is_whitelisted(keys: set[tuple[str, str, str]], kind: str, rule_name: str, source_module: str) -> bool:
    source_module = normalize_value(source_module)
    return any(
        probe in keys
        for probe in [
            (kind, rule_name, source_module),
            (kind, rule_name, "*"),
            (kind, rule_name, ""),
        ]
    )


def classify_rules(rules: list[dict], other_by_name):
    exact, diff, unique = [], [], []
    for rule in rules:
        cands = other_by_name.get(rule["name"], [])
        if not cands:
            unique.append(rule)
            continue
        if any(candidate_norm == rule["norm"] for candidate_norm, _, _ in cands):
            exact.append(rule)
        else:
            diff.append(rule)
    return exact, diff, unique


def pick_source_module(rule: dict, other_by_name, exact_only: bool) -> str:
    cands = other_by_name.get(rule["name"], [])
    paths = []
    for candidate_norm, path, _ in cands:
        if exact_only and candidate_norm != rule["norm"]:
            continue
        paths.append(rel_path(path))
    if not paths and exact_only:
        return ""
    if not paths:
        paths = [rel_path(path) for _, path, _ in cands]
    return sorted(set(paths))[0] if paths else ""


def annotate_sources(rules: list[dict], other_by_name, exact_only: bool):
    for rule in rules:
        rule["source_module"] = pick_source_module(rule, other_by_name, exact_only=exact_only)


def collect_unwhitelisted(rules: list[dict], kind: str, whitelist_keyset):
    return [
        rule
        for rule in rules
        if not is_whitelisted(whitelist_keyset, kind, rule["name"], rule["source_module"])
    ]


def candidate_rows_for(rules: list[dict], kind: str):
    decision = "keep_aram_only" if kind == "rule_exact_duplicate" else "parameterize_shared"
    return [
        {
            "kind": kind,
            "rule_or_macro": rule["name"],
            "source_module": rule["source_module"] or "*",
            "reason": "TODO",
            "decision": decision,
            "owner": "TODO",
        }
        for rule in rules
    ]


failures = []
if not aram_file.exists():
    failures.append(f"Missing file: {aram_file}")
if whitelist_path and not whitelist_path.exists():
    failures.append(f"Missing whitelist: {whitelist_path}")
if not overlay_heroes:
    failures.append("overlay scan: no hero directories found under src/heroes")

aram_rules = parse_rules(aram_file) if aram_file.exists() else []
whitelist_rows = []
if whitelist_path and whitelist_path.exists():
    with whitelist_path.open("r", encoding="utf-8", newline="") as f:
        whitelist_rows = list(csv.DictReader(f, delimiter="\t"))

whitelist_bad_rows = []
for idx, row in enumerate(whitelist_rows, 2):
    decision = normalize_value(row.get("decision", ""))
    if decision not in valid_decisions:
        whitelist_bad_rows.append((idx, decision))
    for field in whitelist_fieldnames:
        if field not in row:
            failures.append(f"whitelist: missing required column '{field}'")
            break

for line_no, decision in whitelist_bad_rows:
    failures.append(
        f"whitelist line {line_no}: invalid decision '{decision}' (allowed: keep_aram_only, parameterize_shared)"
    )

whitelist_keyset = whitelist_keys(whitelist_rows)

overlay_rules = []
overlay_rules_by_file: dict[str, list[dict]] = {}
for hero in overlay_heroes:
    hero_dir = src / "heroes" / hero
    files = sorted(hero_dir.glob("aram*.opy")) if hero_dir.exists() else []
    if not files:
        failures.append(f"overlay missing: src/heroes/{hero}/aram*.opy")

overlay_paths = sorted(path for path in src.rglob("*.opy") if is_mode_overlay(path))
for path in overlay_paths:
    parsed = parse_rules(path)
    overlay_rules.extend(parsed)
    overlay_rules_by_file[rel_path(path)] = parsed

other_by_name = defaultdict(list)
for path in src.rglob("*.opy"):
    if path == aram_file:
        continue
    if is_mode_overlay(path):
        continue
    for rule in parse_rules(path):
        other_by_name[rule["name"]].append((rule["norm"], path, rule["line"]))

aram_exact, aram_diff, aram_unique = classify_rules(aram_rules, other_by_name)
overlay_exact, overlay_diff, overlay_unique = classify_rules(overlay_rules, other_by_name)

annotate_sources(aram_exact, other_by_name, exact_only=True)
annotate_sources(aram_diff, other_by_name, exact_only=False)
annotate_sources(overlay_exact, other_by_name, exact_only=True)
annotate_sources(overlay_diff, other_by_name, exact_only=False)

unwhitelisted_exact = collect_unwhitelisted(aram_exact, "rule_exact_duplicate", whitelist_keyset)
unwhitelisted_diff = collect_unwhitelisted(aram_diff, "rule_same_name_diff", whitelist_keyset)
unwhitelisted_overlay_exact = collect_unwhitelisted(overlay_exact, "rule_exact_duplicate", whitelist_keyset)
unwhitelisted_overlay_diff = collect_unwhitelisted(overlay_diff, "rule_same_name_diff", whitelist_keyset)

if unwhitelisted_exact:
    failures.append(f"Found {len(unwhitelisted_exact)} unwhitelisted exact duplicate rule(s) in src/aram_overrides.opy")
if unwhitelisted_diff:
    failures.append(f"Found {len(unwhitelisted_diff)} unwhitelisted same-name-diff rule(s) in src/aram_overrides.opy")
if unwhitelisted_overlay_exact:
    failures.append(
        "Found {0} unwhitelisted exact duplicate rule(s) in hero overlays ({1})".format(
            len(unwhitelisted_overlay_exact),
            ", ".join(sorted({rel_path(rule['path']) for rule in unwhitelisted_overlay_exact})),
        )
    )
if unwhitelisted_overlay_diff:
    failures.append(
        "Found {0} unwhitelisted same-name-diff rule(s) in hero overlays ({1})".format(
            len(unwhitelisted_overlay_diff),
            ", ".join(sorted({rel_path(rule['path']) for rule in unwhitelisted_overlay_diff})),
        )
    )

legacy_refs = []
for path in list(src.rglob("*.opy")) + list((root / "skills").rglob("*.sh")):
    text = path.read_text(encoding="utf-8")
    if re.search(legacy_ref_pattern, text):
        legacy_refs.append(rel_path(path))

legacy_src_refs = [ref for ref in legacy_refs if ref.startswith("src/")]
if legacy_src_refs:
    failures.append("Found retired ARAM assembly references in src/: " + ", ".join(sorted(legacy_src_refs)))

aram_exact_by_line = {rule["line"] for rule in aram_exact}
residual_runs = []
i = 0
while i < len(aram_rules):
    if aram_rules[i]["line"] not in aram_exact_by_line:
        i += 1
        continue
    j = i
    while j + 1 < len(aram_rules) and aram_rules[j + 1]["line"] in aram_exact_by_line:
        j += 1
    residual_runs.append(aram_rules[i : j + 1])
    i = j + 1

violating_runs = [run for run in residual_runs if len(run) >= segment_min]
if violating_runs:
    failures.append(
        f"Found {len(violating_runs)} residual contiguous exact run(s) with length >= {segment_min} in src/aram_overrides.opy"
    )

candidate_rows = []
candidate_rows.extend(candidate_rows_for(unwhitelisted_exact, "rule_exact_duplicate"))
candidate_rows.extend(candidate_rows_for(unwhitelisted_diff, "rule_same_name_diff"))
candidate_rows.extend(candidate_rows_for(unwhitelisted_overlay_exact, "rule_exact_duplicate"))
candidate_rows.extend(candidate_rows_for(unwhitelisted_overlay_diff, "rule_same_name_diff"))

if emit_candidates_path:
    emit_candidates_path.parent.mkdir(parents=True, exist_ok=True)
    with emit_candidates_path.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=whitelist_fieldnames, delimiter="\t")
        writer.writeheader()
        writer.writerows(candidate_rows)

report_path.parent.mkdir(parents=True, exist_ok=True)
with report_path.open("w", encoding="utf-8") as f:
    f.write("# ARAM Overrides Duplicate Report\n\n")
    f.write("## Summary\n\n")
    f.write(f"- `src/aram_overrides.opy` total rules: **{len(aram_rules)}**\n")
    f.write(f"- `src/aram_overrides.opy` exact/diff/unique: **{len(aram_exact)}/{len(aram_diff)}/{len(aram_unique)}**\n")
    f.write(f"- Active overlays (`src/**/aram*.opy`, excluding entry/settings/protocol files) total rules: **{len(overlay_rules)}**\n")
    f.write(f"- Active overlay exact/diff/unique: **{len(overlay_exact)}/{len(overlay_diff)}/{len(overlay_unique)}**\n")
    f.write(f"- Residual contiguous exact runs in aram_overrides: **{len(residual_runs)}**\n")
    f.write(f"- Residual runs with length >= {segment_min}: **{len(violating_runs)}**\n")
    f.write(f"- Retired assembly references in `src/`: **{len(legacy_src_refs)}**\n")
    f.write(f"- Whitelist file: `{whitelist_path}`\n" if whitelist_path else "- Whitelist file: *(disabled)*\n")
    f.write(f"- Whitelist rows: **{len(whitelist_rows)}**\n")
    f.write(f"- Unwhitelisted aram exact/diff: **{len(unwhitelisted_exact)}/{len(unwhitelisted_diff)}**\n")
    f.write(f"- Unwhitelisted hero overlay exact/diff: **{len(unwhitelisted_overlay_exact)}/{len(unwhitelisted_overlay_diff)}**\n")
    if emit_candidates_path:
        f.write(f"- Candidate output: `{emit_candidates_path}` ({len(candidate_rows)} rows)\n")
    f.write(f"- Check mode: **{'ON' if check_mode else 'OFF'}**\n\n")

    f.write("## Active Overlay Coverage\n\n")
    for rel in sorted(overlay_rules_by_file):
        f.write(f"- `{rel}`: {len(overlay_rules_by_file[rel])} rules\n")
    f.write("\n")

    f.write("## Retired Assembly Reference Scan\n\n")
    if legacy_refs:
        for ref in sorted(legacy_refs):
            f.write(f"- `{ref}`\n")
    else:
        f.write("- None\n")
    f.write("\n")

    f.write("## Residual Exact Runs\n\n")
    if residual_runs:
        for run in residual_runs:
            f.write(
                f"- lines {run[0]['line']}-{run[-1]['end']}: {len(run)} rules, `{run[0]['name']}` -> `{run[-1]['name']}`\n"
            )
    else:
        f.write("- None\n")
    f.write("\n")

    sections = [
        ("Unwhitelisted Exact Duplicates (aram_overrides)", unwhitelisted_exact),
        ("Unwhitelisted Same-Name-Diff (aram_overrides)", unwhitelisted_diff),
        ("Unwhitelisted Exact Duplicates (hero overlays)", unwhitelisted_overlay_exact),
        ("Unwhitelisted Same-Name-Diff (hero overlays)", unwhitelisted_overlay_diff),
    ]
    for title, rules in sections:
        f.write(f"## {title}\n\n")
        if rules:
            for rule in rules:
                f.write(
                    f"- `{rel_path(rule['path'])}:{rule['line']}` `{rule['name']}` (source: `{rule['source_module'] or '*'}`)\n"
                )
        else:
            f.write("- None\n")
        f.write("\n")

    f.write("## Validation\n\n")
    if failures:
        for item in failures:
            f.write(f"- FAIL: {item}\n")
    else:
        f.write("- PASS: all validations passed\n")

print(f"Report written: {report_path}")
print(
    "Counts => aram total/exact/diff/unique: {0}/{1}/{2}/{3}, active overlays exact/diff/unique: {4}/{5}/{6}, residual exact runs >= {7}: {8}, retired src refs: {9}, unwhitelisted aram/overlay exact-diff: {10}/{11}, {12}/{13}".format(
        len(aram_rules),
        len(aram_exact),
        len(aram_diff),
        len(aram_unique),
        len(overlay_exact),
        len(overlay_diff),
        len(overlay_unique),
        segment_min,
        len(violating_runs),
        len(legacy_src_refs),
        len(unwhitelisted_exact),
        len(unwhitelisted_diff),
        len(unwhitelisted_overlay_exact),
        len(unwhitelisted_overlay_diff),
    )
)
if emit_candidates_path:
    print(f"Candidates written: {emit_candidates_path} ({len(candidate_rows)} rows)")
if failures:
    print("Validation failures:")
    for item in failures:
        print(f"- {item}")
if check_mode and failures:
    sys.exit(1)
PY
