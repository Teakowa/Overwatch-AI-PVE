#!/usr/bin/env python3
"""Fetch all hero details using a hero list JSON/TXT file."""

from __future__ import annotations

import argparse
import json
import time
import urllib.parse
from pathlib import Path

from fetch_hero_details import build_hero_url, fetch_text, parse_hero_page

DEFAULT_URL_TEMPLATE = "https://overwatch.fandom.com/wiki/{heroName}"
DEFAULT_USER_AGENT = "Mozilla/5.0 (compatible; ow-fandom-hero-data/1.0)"


def normalize_hero_name(value: str) -> str:
    return value.replace("_", " ").strip()


def load_heroes(path: Path) -> list[str]:
    if not path.exists():
        raise FileNotFoundError(f"Heroes file not found: {path}")

    heroes: list[str] = []
    suffix = path.suffix.lower()

    if suffix == ".json":
        data = json.loads(path.read_text(encoding="utf-8"))
        if isinstance(data, dict) and isinstance(data.get("heroes"), list):
            source_heroes = data["heroes"]
        elif isinstance(data, list):
            source_heroes = data
        else:
            raise ValueError("JSON heroes file must be a list or an object with a 'heroes' list")

        for item in source_heroes:
            if isinstance(item, str):
                name = normalize_hero_name(item)
                if name:
                    heroes.append(name)
            elif isinstance(item, dict) and isinstance(item.get("hero"), str):
                name = normalize_hero_name(item["hero"])
                if name:
                    heroes.append(name)
    else:
        for raw_line in path.read_text(encoding="utf-8").splitlines():
            line = raw_line.strip()
            if not line or line.startswith("#"):
                continue
            heroes.append(normalize_hero_name(line))

    seen: set[str] = set()
    deduped: list[str] = []
    for hero in heroes:
        if hero and hero not in seen:
            deduped.append(hero)
            seen.add(hero)

    return deduped


def resolve_html_file(html_dir: Path, hero: str) -> Path:
    slug = hero.replace(" ", "_")
    candidates = [
        html_dir / f"{slug}.html",
        html_dir / f"{urllib.parse.quote(slug, safe='')}.html",
    ]
    for candidate in candidates:
        if candidate.exists():
            return candidate
    raise FileNotFoundError(
        f"No local HTML file found for hero '{hero}' in {html_dir} "
        f"(tried: {', '.join(str(c.name) for c in candidates)})"
    )


def write_output(payload: dict, output: Path | None, pretty: bool) -> None:
    content = json.dumps(payload, ensure_ascii=False, indent=2 if pretty else None)
    if output:
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(content + "\n", encoding="utf-8")
    else:
        print(content)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Fetch details for all heroes listed in a JSON/TXT file. "
            "Use fetch_heroes_from_page.py output as input."
        )
    )
    parser.add_argument(
        "--heroes-file",
        type=Path,
        required=True,
        help="Path to heroes JSON/TXT (e.g. output from fetch_heroes_from_page.py)",
    )
    parser.add_argument(
        "--html-dir",
        type=Path,
        help="Optional local HTML directory for offline parsing. File name format: <Hero_Name>.html",
    )
    parser.add_argument(
        "--url-template",
        default=DEFAULT_URL_TEMPLATE,
        help="URL template with {heroName}, {hero_name}, or {hero}",
    )
    parser.add_argument("--timeout", type=float, default=20.0, help="Network timeout in seconds")
    parser.add_argument("--user-agent", default=DEFAULT_USER_AGENT, help="HTTP User-Agent header")
    parser.add_argument("--delay", type=float, default=0.3, help="Delay seconds between hero requests")
    parser.add_argument("--max", type=int, help="Optional max number of heroes to process")
    parser.add_argument("--output", type=Path, help="Output JSON path (default: stdout)")
    parser.add_argument("--pretty", action="store_true", help="Pretty-print JSON output")
    parser.add_argument("--fail-on-error", action="store_true", help="Exit with code 1 if any hero fails")
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    heroes = load_heroes(args.heroes_file)
    if args.max is not None and args.max >= 0:
        heroes = heroes[: args.max]

    results: list[dict] = []
    failures: list[dict[str, str]] = []

    for index, hero in enumerate(heroes):
        try:
            if args.html_dir:
                html_path = resolve_html_file(args.html_dir, hero)
                html = html_path.read_text(encoding="utf-8")
                source_url = str(html_path)
            else:
                source_url = build_hero_url(hero, args.url_template)
                html = fetch_text(source_url, timeout=args.timeout, user_agent=args.user_agent)

            parsed = parse_hero_page(html, hero_hint=hero)
            parsed["url"] = source_url
            results.append(parsed)
        except Exception as exc:  # pylint: disable=broad-except
            failures.append({"hero": hero, "error": str(exc)})

        is_last = index == len(heroes) - 1
        if not is_last and args.delay > 0:
            time.sleep(args.delay)

    payload = {
        "source": str(args.heroes_file),
        "count": len(results),
        "failed_count": len(failures),
        "heroes": results,
        "failures": failures,
    }
    write_output(payload, output=args.output, pretty=args.pretty)

    if args.fail_on_error and failures:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
