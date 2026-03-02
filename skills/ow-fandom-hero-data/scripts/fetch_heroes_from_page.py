#!/usr/bin/env python3
"""Fetch candidate Overwatch hero names from the Overwatch Fandom Heroes page."""

from __future__ import annotations

import argparse
import json
import re
import sys
import urllib.parse
import urllib.request
from html.parser import HTMLParser
from pathlib import Path

DEFAULT_URL = "https://overwatch.fandom.com/wiki/Heroes"
DEFAULT_USER_AGENT = "Mozilla/5.0 (compatible; ow-fandom-hero-data/1.0)"

KNOWN_NAMESPACES = {
    "Category",
    "File",
    "Template",
    "Special",
    "Help",
    "User",
    "Talk",
    "Forum",
    "Blog",
    "Module",
    "MediaWiki",
}

EXCLUDED_EXACT = {
    "Heroes",
    "Hero",
    "Overwatch",
    "Overwatch 2",
    "Damage",
    "Tank",
    "Support",
    "Overwatch Wiki",
    "Patch",
    "Maps",
    "Modes",
    "Story",
    "Lore",
}

NAME_PATTERN = re.compile(r"^[\w .':+\-]+$", re.UNICODE)


class HeroLinkParser(HTMLParser):
    """Collect href values from anchor tags."""

    def __init__(self) -> None:
        super().__init__()
        self.hrefs: list[str] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag != "a":
            return
        attr_map = dict(attrs)
        href = attr_map.get("href")
        if href:
            self.hrefs.append(href)


def fetch_text(url: str, timeout: float, user_agent: str) -> str:
    req = urllib.request.Request(url, headers={"User-Agent": user_agent})
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        charset = resp.headers.get_content_charset() or "utf-8"
        return resp.read().decode(charset, errors="replace")


def clean_name(raw: str) -> str | None:
    name = urllib.parse.unquote(raw)
    name = name.replace("_", " ").strip()
    if not name:
        return None

    if "#" in name:
        name = name.split("#", 1)[0].strip()
    if "?" in name:
        name = name.split("?", 1)[0].strip()
    if not name:
        return None

    if name.endswith("(disambiguation)"):
        return None

    namespace = name.split(":", 1)[0]
    if namespace in KNOWN_NAMESPACES:
        return None

    if "/" in name:
        return None

    if name in EXCLUDED_EXACT:
        return None

    if name.startswith("List of") or name.startswith("List Of"):
        return None

    if not NAME_PATTERN.match(name):
        return None

    return name


def extract_hero_names(page_html: str) -> list[str]:
    parser = HeroLinkParser()
    parser.feed(page_html)

    names: set[str] = set()
    for href in parser.hrefs:
        parsed = urllib.parse.urlparse(href)
        path = parsed.path or ""
        if "/wiki/" not in path:
            continue
        slug = path.split("/wiki/", 1)[1]
        if not slug:
            continue
        name = clean_name(slug)
        if name:
            names.add(name)

    return sorted(names, key=str.casefold)


def load_allowlist(path: Path) -> set[str]:
    allowed: set[str] = set()
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        normalized = line.replace("_", " ").strip()
        if normalized:
            allowed.add(normalized)
    return allowed


def write_output(payload: dict, output: Path | None, pretty: bool) -> None:
    content = json.dumps(payload, ensure_ascii=False, indent=2 if pretty else None)
    if output:
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(content + "\n", encoding="utf-8")
    else:
        sys.stdout.write(content + "\n")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Fetch candidate Overwatch hero names from "
            "https://overwatch.fandom.com/wiki/Heroes"
        )
    )
    parser.add_argument("--url", default=DEFAULT_URL, help="Heroes page URL")
    parser.add_argument(
        "--html-file",
        type=Path,
        help="Parse hero names from a local HTML file instead of fetching the URL",
    )
    parser.add_argument(
        "--allowlist",
        type=Path,
        help="Optional newline-delimited file to keep only listed hero names",
    )
    parser.add_argument("--timeout", type=float, default=20.0, help="Network timeout in seconds")
    parser.add_argument("--user-agent", default=DEFAULT_USER_AGENT, help="HTTP User-Agent header")
    parser.add_argument("--output", type=Path, help="Output JSON path (default: stdout)")
    parser.add_argument("--pretty", action="store_true", help="Pretty-print JSON output")
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    if args.html_file:
        html = args.html_file.read_text(encoding="utf-8")
        source = str(args.html_file)
    else:
        html = fetch_text(args.url, timeout=args.timeout, user_agent=args.user_agent)
        source = args.url

    heroes = extract_hero_names(html)

    if args.allowlist:
        allowlist = load_allowlist(args.allowlist)
        heroes = [hero for hero in heroes if hero in allowlist]

    payload = {
        "source": source,
        "count": len(heroes),
        "heroes": heroes,
    }
    write_output(payload, output=args.output, pretty=args.pretty)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
