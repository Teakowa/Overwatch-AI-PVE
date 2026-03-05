#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'USAGE'
Usage: skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh [--segment-min N] [--report PATH] [--whitelist PATH] [--emit-candidates PATH] [--check]

Options:
  --segment-min N       Minimum contiguous exact segment length to enforce in aram_overrides (default: 2)
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
segments_dir = src / "aram_overrides_segments"
manifest_file = segments_dir / "manifest.tsv"

rule_re = re.compile(r'^rule\s+"([^"]+)":\s*$')
include_seg_re = re.compile(
    r'^#!include\s+"(aram_overrides_segments/[a-z0-9._-]+\.opy)"\s*$'
)

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
        m = rule_re.match(lines[i])
        if not m:
            i += 1
            continue
        name = m.group(1)
        start = i
        i += 1
        while i < len(lines) and not rule_re.match(lines[i]):
            i += 1
        end = i
        block = "\n".join(lines[start:end]) + "\n"
        norm = "\n".join(l.rstrip() for l in block.splitlines()).strip() + "\n"
        rules.append(
            {
                "name": name,
                "line": start + 1,
                "start": start,
                "end": end,
                "block": block,
                "norm": norm,
                "path": path,
            }
        )
    return rules


def parse_manifest(path: Path):
    rows = []
    if not path.exists():
        return rows
    with path.open("r", encoding="utf-8", newline="") as f:
        reader = csv.DictReader(f, delimiter="\t")
        for row in reader:
            rows.append(row)
    return rows


def classify_rules(rules, other_by_name):
    exact = []
    diff = []
    unique = []
    for r in rules:
        cands = other_by_name.get(r["name"], [])
        if not cands:
            unique.append(r)
            continue
        if any(cn == r["norm"] for cn, _, _ in cands):
            exact.append(r)
        else:
            diff.append(r)
    return exact, diff, unique


def parse_whitelist(path: Path):
    rows = []
    if not path.exists():
        return rows
    with path.open("r", encoding="utf-8", newline="") as f:
        reader = csv.DictReader(f, delimiter="\t")
        for row in reader:
            rows.append(row)
    return rows


def rel_path(path: Path) -> str:
    return str(path.relative_to(root))


def pick_source_module(rule: dict, other_by_name: dict, exact_only: bool) -> str:
    cands = other_by_name.get(rule["name"], [])
    if not cands:
        return ""
    paths = []
    for cn, p, _ in cands:
        if exact_only and cn != rule["norm"]:
            continue
        paths.append(rel_path(p))
    if not paths and exact_only:
        return ""
    if not paths:
        paths = [rel_path(p) for _, p, _ in cands]
    return sorted(set(paths))[0]


def normalize_value(value: str) -> str:
    return (value or "").strip()


def whitelist_keys(rows: list[dict]):
    keys = set()
    for row in rows:
        kind = normalize_value(row.get("kind", ""))
        rule = normalize_value(row.get("rule_or_macro", ""))
        src = normalize_value(row.get("source_module", ""))
        keys.add((kind, rule, src))
    return keys


def is_whitelisted(keys: set[tuple[str, str, str]], kind: str, rule_name: str, source_module: str) -> bool:
    source_module = normalize_value(source_module)
    probes = [
        (kind, rule_name, source_module),
        (kind, rule_name, "*"),
        (kind, rule_name, ""),
    ]
    return any(probe in keys for probe in probes)


failures = []

if not aram_file.exists():
    failures.append(f"Missing file: {aram_file}")

if not manifest_file.exists():
    failures.append(f"Missing manifest: {manifest_file}")

if whitelist_path and not whitelist_path.exists():
    failures.append(f"Missing whitelist: {whitelist_path}")

aram_rules = parse_rules(aram_file) if aram_file.exists() else []
manifest_rows = parse_manifest(manifest_file)
whitelist_rows = parse_whitelist(whitelist_path) if whitelist_path and whitelist_path.exists() else []

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

other_by_name = defaultdict(list)
for p in src.rglob("*.opy"):
    if p == aram_file:
        continue
    if p.is_relative_to(segments_dir):
        continue
    for r in parse_rules(p):
        other_by_name[r["name"]].append((r["norm"], p, r["line"]))

aram_exact, aram_diff, aram_unique = classify_rules(aram_rules, other_by_name)

for r in aram_exact:
    r["source_module"] = pick_source_module(r, other_by_name, exact_only=True)
for r in aram_diff:
    r["source_module"] = pick_source_module(r, other_by_name, exact_only=False)

unwhitelisted_exact = [
    r
    for r in aram_exact
    if not is_whitelisted(whitelist_keyset, "rule_exact_duplicate", r["name"], r["source_module"])
]
unwhitelisted_diff = [
    r
    for r in aram_diff
    if not is_whitelisted(whitelist_keyset, "rule_same_name_diff", r["name"], r["source_module"])
]

if unwhitelisted_exact:
    failures.append(
        f"Found {len(unwhitelisted_exact)} unwhitelisted exact duplicate rule(s) in src/aram_overrides.opy"
    )
if unwhitelisted_diff:
    failures.append(
        f"Found {len(unwhitelisted_diff)} unwhitelisted same-name-diff rule(s) in src/aram_overrides.opy"
    )

aram_exact_by_line = {r["line"] for r in aram_exact}

# contiguous exact segments that remain in aram_overrides
residual_runs = []
i = 0
while i < len(aram_rules):
    if aram_rules[i]["line"] not in aram_exact_by_line:
        i += 1
        continue
    j = i
    while j + 1 < len(aram_rules) and aram_rules[j + 1]["line"] in aram_exact_by_line:
        j += 1
    run = aram_rules[i : j + 1]
    residual_runs.append(run)
    i = j + 1

violating_runs = [run for run in residual_runs if len(run) >= segment_min]
if violating_runs:
    failures.append(
        f"Found {len(violating_runs)} residual contiguous exact run(s) with length >= {segment_min} in src/aram_overrides.opy"
    )

# manifest <-> include one-to-one
aram_include_paths = []
if aram_file.exists():
    for line in aram_file.read_text(encoding="utf-8").splitlines():
        m = include_seg_re.match(line)
        if m:
            aram_include_paths.append(m.group(1))

manifest_include_paths = [row.get("include_path", "") for row in manifest_rows]
if aram_include_paths != manifest_include_paths:
    failures.append(
        "Manifest include paths and aram_overrides include paths do not match exactly (order-sensitive)."
    )

# validate manifest rows and segment exactness
segment_rule_total = 0
for idx, row in enumerate(manifest_rows, 1):
    seg_rel = row.get("include_path", "")
    seg_path = src / seg_rel if seg_rel else None

    if not seg_rel:
        failures.append(f"manifest row {idx}: include_path is empty")
        continue

    if not seg_path.exists():
        failures.append(f"manifest row {idx}: missing segment file {seg_rel}")
        continue

    seg_rules = parse_rules(seg_path)
    segment_rule_total += len(seg_rules)

    expected_count = int(row.get("rule_count", "0") or 0)
    if len(seg_rules) != expected_count:
        failures.append(
            f"{seg_rel}: rule_count mismatch (manifest={expected_count}, actual={len(seg_rules)})"
        )

    if seg_rules:
        first_rule = row.get("first_rule", "")
        last_rule = row.get("last_rule", "")
        if seg_rules[0]["name"] != first_rule:
            failures.append(
                f"{seg_rel}: first_rule mismatch (manifest={first_rule}, actual={seg_rules[0]['name']})"
            )
        if seg_rules[-1]["name"] != last_rule:
            failures.append(
                f"{seg_rel}: last_rule mismatch (manifest={last_rule}, actual={seg_rules[-1]['name']})"
            )

    for rule in seg_rules:
        cands = other_by_name.get(rule["name"], [])
        if not cands:
            failures.append(
                f"{seg_rel}:{rule['line']}: rule '{rule['name']}' has no same-name candidate in src/heroes or other non-aram files"
            )
            continue
        exact_hits = [(p, ln) for cn, p, ln in cands if cn == rule["norm"]]
        if not exact_hits:
            failures.append(
                f"{seg_rel}:{rule['line']}: rule '{rule['name']}' is not exact with any non-aram module rule"
            )

# emit unwhitelisted candidates
candidate_rows = []
for rule in unwhitelisted_exact:
    candidate_rows.append(
        {
            "kind": "rule_exact_duplicate",
            "rule_or_macro": rule["name"],
            "source_module": rule["source_module"] or "*",
            "reason": "TODO",
            "decision": "keep_aram_only",
            "owner": "TODO",
        }
    )
for rule in unwhitelisted_diff:
    candidate_rows.append(
        {
            "kind": "rule_same_name_diff",
            "rule_or_macro": rule["name"],
            "source_module": rule["source_module"] or "*",
            "reason": "TODO",
            "decision": "parameterize_shared",
            "owner": "TODO",
        }
    )

if emit_candidates_path:
    emit_candidates_path.parent.mkdir(parents=True, exist_ok=True)
    with emit_candidates_path.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=whitelist_fieldnames, delimiter="\t")
        writer.writeheader()
        writer.writerows(candidate_rows)

# report
report_path.parent.mkdir(parents=True, exist_ok=True)

whitelisted_exact = len(aram_exact) - len(unwhitelisted_exact)
whitelisted_diff = len(aram_diff) - len(unwhitelisted_diff)

with report_path.open("w", encoding="utf-8") as f:
    f.write("# ARAM Overrides Duplicate Report\n\n")
    f.write("## Summary\n\n")
    f.write(f"- `src/aram_overrides.opy` total rules: **{len(aram_rules)}**\n")
    f.write(f"- Exact (same name + same body) against non-aram files: **{len(aram_exact)}**\n")
    f.write(f"- Same-name but different body: **{len(aram_diff)}**\n")
    f.write(f"- Name-unique: **{len(aram_unique)}**\n")
    f.write(f"- Segment files from manifest: **{len(manifest_rows)}**\n")
    f.write(f"- Total rules in segment files: **{segment_rule_total}**\n")
    f.write(f"- Residual contiguous exact runs in aram_overrides: **{len(residual_runs)}**\n")
    f.write(f"- Residual runs with length >= {segment_min}: **{len(violating_runs)}**\n")
    f.write(f"- Whitelist file: `{whitelist_path}`\n" if whitelist_path else "- Whitelist file: *(disabled)*\n")
    f.write(f"- Whitelist rows: **{len(whitelist_rows)}**\n")
    f.write(f"- Whitelisted exact duplicates: **{whitelisted_exact}/{len(aram_exact)}**\n")
    f.write(f"- Whitelisted same-name-diff: **{whitelisted_diff}/{len(aram_diff)}**\n")
    if emit_candidates_path:
        f.write(f"- Candidate output: `{emit_candidates_path}` ({len(candidate_rows)} rows)\n")
    f.write(f"- Check mode: **{'ON' if check_mode else 'OFF'}**\n\n")

    f.write("## Manifest Segments\n\n")
    if manifest_rows:
        f.write("| segment_id | include_path | start_line | end_line | rule_count | first_rule | last_rule |\n")
        f.write("|---|---|---:|---:|---:|---|---|\n")
        for row in manifest_rows:
            f.write(
                "| {segment_id} | `{include_path}` | {start_line} | {end_line} | {rule_count} | {first_rule} | {last_rule} |\n".format(
                    segment_id=row.get("segment_id", ""),
                    include_path=row.get("include_path", ""),
                    start_line=row.get("start_line", ""),
                    end_line=row.get("end_line", ""),
                    rule_count=row.get("rule_count", ""),
                    first_rule=row.get("first_rule", "").replace("|", "\\|"),
                    last_rule=row.get("last_rule", "").replace("|", "\\|"),
                )
            )
    else:
        f.write("- No manifest rows found.\n")
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

    f.write("## Unwhitelisted Exact Duplicates\n\n")
    if unwhitelisted_exact:
        for r in unwhitelisted_exact:
            f.write(
                f"- line {r['line']}: `{r['name']}` (source: `{r['source_module'] or '*'}`)\n"
            )
    else:
        f.write("- None\n")
    f.write("\n")

    f.write("## Unwhitelisted Same-Name-Diff Rules\n\n")
    if unwhitelisted_diff:
        for r in unwhitelisted_diff:
            f.write(
                f"- line {r['line']}: `{r['name']}` (source: `{r['source_module'] or '*'}`)\n"
            )
    else:
        f.write("- None\n")
    f.write("\n")

    f.write("## Unique Rule Names (aram_overrides)\n\n")
    if aram_unique:
        for r in aram_unique:
            f.write(f"- line {r['line']}: `{r['name']}`\n")
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
    "Counts => total: {0}, exact: {1}, diff: {2}, unique: {3}, manifest segments: {4}, residual exact runs >= {5}: {6}, unwhitelisted exact: {7}, unwhitelisted diff: {8}".format(
        len(aram_rules),
        len(aram_exact),
        len(aram_diff),
        len(aram_unique),
        len(manifest_rows),
        segment_min,
        len(violating_runs),
        len(unwhitelisted_exact),
        len(unwhitelisted_diff),
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
