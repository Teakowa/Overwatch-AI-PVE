#!/usr/bin/env python3
"""Dependency-aware reachability scan for player_constants defines.

Default mode is report-only. Deletion requires explicit flags:
- scoped delete: --prefix <HERO_> --apply
- global delete: --global-cleanup --apply
"""

from __future__ import annotations

import argparse
import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Set

DEFINE_RE = re.compile(r"^#!define\s+([A-Z][A-Z0-9_]*)\s+(.*)$")
TOKEN_RE = re.compile(r"\b[A-Z][A-Z0-9_]*\b")
COMMENT_RE = re.compile(r"^\s*#")


@dataclass
class ScanResult:
    defined: int
    roots: int
    reachable: int
    unused_total: int
    candidate_unused: List[str]


def parse_defines(constants_file: Path) -> tuple[List[str], Dict[str, str], List[str]]:
    lines = constants_file.read_text(encoding="utf-8").splitlines()
    order: List[str] = []
    expr: Dict[str, str] = {}

    for line in lines:
        match = DEFINE_RE.match(line)
        if not match:
            continue
        name, value = match.group(1), match.group(2)
        order.append(name)
        expr[name] = value

    return order, expr, lines


def build_dependencies(expr: Dict[str, str], defs: Set[str]) -> Dict[str, Set[str]]:
    deps: Dict[str, Set[str]] = {}
    for name, value in expr.items():
        tokens = set(TOKEN_RE.findall(value))
        deps[name] = {tok for tok in tokens if tok in defs and tok != name}
    return deps


def collect_external_tokens(src_root: Path, constants_file: Path) -> Set[str]:
    tokens: Set[str] = set()
    for path in src_root.rglob("*.opy"):
        if path.resolve() == constants_file.resolve():
            continue
        for line in path.read_text(encoding="utf-8").splitlines():
            if COMMENT_RE.match(line):
                continue
            tokens.update(TOKEN_RE.findall(line))
    return tokens


def reachable_constants(
    defs: Set[str], deps: Dict[str, Set[str]], external_tokens: Set[str]
) -> Set[str]:
    roots = defs & external_tokens
    keep: Set[str] = set()
    stack = list(roots)

    while stack:
        cur = stack.pop()
        if cur in keep:
            continue
        keep.add(cur)
        stack.extend(deps.get(cur, set()) - keep)

    return keep


def filter_candidates(unused: List[str], prefixes: List[str], global_cleanup: bool) -> List[str]:
    if global_cleanup:
        return unused
    if not prefixes:
        return []
    return [name for name in unused if any(name.startswith(p) for p in prefixes)]


def apply_delete(lines: List[str], delete_names: Set[str], constants_file: Path) -> None:
    out: List[str] = []
    for line in lines:
        match = DEFINE_RE.match(line)
        if match and match.group(1) in delete_names:
            continue
        out.append(line)

    constants_file.write_text("\n".join(out) + "\n", encoding="utf-8")


def run(args: argparse.Namespace) -> int:
    constants_file = Path(args.constants_file)
    src_root = Path(args.src_root)

    if not constants_file.exists():
        raise FileNotFoundError(f"constants file not found: {constants_file}")
    if not src_root.exists():
        raise FileNotFoundError(f"src root not found: {src_root}")

    if args.apply and not args.global_cleanup and not args.prefix:
        raise ValueError("refuse to apply without scope: use --prefix <HERO_> or --global-cleanup")

    order, expr, lines = parse_defines(constants_file)
    defs = set(order)
    deps = build_dependencies(expr, defs)
    external_tokens = collect_external_tokens(src_root, constants_file)
    keep = reachable_constants(defs, deps, external_tokens)

    unused = [name for name in order if name not in keep]
    candidates = filter_candidates(unused, args.prefix, args.global_cleanup)

    result = ScanResult(
        defined=len(order),
        roots=len(defs & external_tokens),
        reachable=len(keep),
        unused_total=len(unused),
        candidate_unused=candidates,
    )

    payload = {
        "defined": result.defined,
        "external_roots": result.roots,
        "reachable": result.reachable,
        "unused_total": result.unused_total,
        "candidate_unused_count": len(result.candidate_unused),
        "candidate_unused": result.candidate_unused,
        "constants_file": str(constants_file),
        "scope": {
            "prefix": args.prefix,
            "global_cleanup": args.global_cleanup,
            "apply": args.apply,
        },
    }

    if args.json:
        print(json.dumps(payload, ensure_ascii=False, indent=2))
    else:
        print(f"defined={result.defined}")
        print(f"external_roots={result.roots}")
        print(f"reachable={result.reachable}")
        print(f"unused_total={result.unused_total}")
        print(f"candidate_unused_count={len(result.candidate_unused)}")
        for name in result.candidate_unused:
            print(name)

    if args.report_file:
        Path(args.report_file).write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    if args.apply and result.candidate_unused:
        apply_delete(lines, set(result.candidate_unused), constants_file)
        print(f"applied_delete_count={len(result.candidate_unused)}")
    elif args.apply:
        print("applied_delete_count=0")

    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Reachability scan for player_constants defines")
    parser.add_argument(
        "--constants-file",
        default="src/constants/player_constants.opy",
        help="path to constants file",
    )
    parser.add_argument(
        "--src-root",
        default="src",
        help="source root for external reference scan",
    )
    parser.add_argument(
        "--prefix",
        action="append",
        default=[],
        help="limit candidate deletion to constants starting with prefix (repeatable)",
    )
    parser.add_argument(
        "--global-cleanup",
        action="store_true",
        help="allow candidate set to include all unused constants",
    )
    parser.add_argument(
        "--apply",
        action="store_true",
        help="apply deletion to constants file",
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="print report in JSON format",
    )
    parser.add_argument(
        "--report-file",
        default="",
        help="optional JSON report output path",
    )
    return parser


if __name__ == "__main__":
    parser = build_parser()
    ns = parser.parse_args()
    raise SystemExit(run(ns))
