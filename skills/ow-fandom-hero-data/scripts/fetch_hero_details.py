#!/usr/bin/env python3
"""Fetch structured hero data from an Overwatch Fandom hero page."""

from __future__ import annotations

import argparse
import json
import re
import sys
import urllib.parse
import urllib.request
from html.parser import HTMLParser
from pathlib import Path

DEFAULT_URL_TEMPLATE = "https://overwatch.fandom.com/wiki/{heroName}"
DEFAULT_USER_AGENT = "Mozilla/5.0 (compatible; ow-fandom-hero-data/1.0)"
WHITESPACE_RE = re.compile(r"\s+")


def normalize_spaces(value: str) -> str:
    return WHITESPACE_RE.sub(" ", value).strip()


class HeroPageParser(HTMLParser):
    """Extract title, summary, and portable infobox fields from a hero page."""

    def __init__(self) -> None:
        super().__init__()
        self.title_depth = 0
        self.title_parts: list[str] = []

        self.mw_output_depth = 0
        self.summary_depth = 0
        self.summary_parts: list[str] = []
        self.summary: str | None = None

        self.field_stack: list[tuple[str, int]] = []
        self.field_order: list[str] = []
        self.field_parts: dict[str, dict[str, list[str]]] = {}

        self.label_depth = 0
        self.value_depth = 0
        self.active_label_field: str | None = None
        self.active_value_field: str | None = None

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        attr_map = dict(attrs)
        classes = set((attr_map.get("class") or "").split())

        # Extend active depth counters when entering nested tags.
        if self.title_depth > 0:
            self.title_depth += 1
        if self.mw_output_depth > 0:
            self.mw_output_depth += 1
        if self.summary_depth > 0:
            self.summary_depth += 1
        if self.label_depth > 0:
            self.label_depth += 1
        if self.value_depth > 0:
            self.value_depth += 1
        if self.field_stack:
            field_key, field_depth = self.field_stack[-1]
            self.field_stack[-1] = (field_key, field_depth + 1)

        if tag == "h1" and "page-header__title" in classes and self.title_depth == 0:
            self.title_depth = 1

        if "mw-parser-output" in classes and tag in {"div", "section"} and self.mw_output_depth == 0:
            self.mw_output_depth = 1

        if self.mw_output_depth > 0 and self.summary is None and tag == "p" and self.summary_depth == 0:
            self.summary_depth = 1
            self.summary_parts = []

        data_source = attr_map.get("data-source")
        if data_source:
            key = normalize_spaces(data_source).replace(" ", "_")
            if key:
                if key not in self.field_parts:
                    self.field_parts[key] = {
                        "label_parts": [],
                        "value_parts": [],
                    }
                    self.field_order.append(key)
                self.field_stack.append((key, 1))

        current_field = self.field_stack[-1][0] if self.field_stack else None
        if current_field and "pi-data-label" in classes and self.label_depth == 0:
            self.label_depth = 1
            self.active_label_field = current_field

        if current_field and "pi-data-value" in classes and self.value_depth == 0:
            self.value_depth = 1
            self.active_value_field = current_field

    def handle_endtag(self, tag: str) -> None:
        _ = tag

        if self.title_depth > 0:
            self.title_depth -= 1

        if self.summary_depth > 0:
            self.summary_depth -= 1
            if self.summary_depth == 0 and self.summary is None:
                text = normalize_spaces(" ".join(self.summary_parts))
                if text:
                    self.summary = text
                self.summary_parts = []

        if self.label_depth > 0:
            self.label_depth -= 1
            if self.label_depth == 0:
                self.active_label_field = None

        if self.value_depth > 0:
            self.value_depth -= 1
            if self.value_depth == 0:
                self.active_value_field = None

        if self.field_stack:
            field_key, field_depth = self.field_stack[-1]
            field_depth -= 1
            if field_depth <= 0:
                self.field_stack.pop()
            else:
                self.field_stack[-1] = (field_key, field_depth)

        if self.mw_output_depth > 0:
            self.mw_output_depth -= 1

    def handle_data(self, data: str) -> None:
        text = normalize_spaces(data)
        if not text:
            return

        if self.title_depth > 0:
            self.title_parts.append(text)

        if self.summary_depth > 0:
            self.summary_parts.append(text)

        if self.label_depth > 0 and self.active_label_field:
            self.field_parts[self.active_label_field]["label_parts"].append(text)

        if self.value_depth > 0 and self.active_value_field:
            self.field_parts[self.active_value_field]["value_parts"].append(text)

    def to_result(self) -> dict:
        infobox_fields: list[dict[str, str]] = []

        for key in self.field_order:
            field = self.field_parts[key]
            label = normalize_spaces(" ".join(field["label_parts"]))
            value = normalize_spaces(" ".join(field["value_parts"]))

            if not label:
                label = key.replace("_", " ").title()

            if label or value:
                infobox_fields.append(
                    {
                        "key": key,
                        "label": label,
                        "value": value,
                    }
                )

        infobox = {
            item["key"]: {
                "label": item["label"],
                "value": item["value"],
            }
            for item in infobox_fields
        }

        return {
            "title": normalize_spaces(" ".join(self.title_parts)),
            "summary": self.summary,
            "infobox": infobox,
            "infobox_fields": infobox_fields,
        }


def fetch_text(url: str, timeout: float, user_agent: str) -> str:
    req = urllib.request.Request(url, headers={"User-Agent": user_agent})
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        charset = resp.headers.get_content_charset() or "utf-8"
        return resp.read().decode(charset, errors="replace")


def build_hero_url(hero_name: str, template: str) -> str:
    slug = hero_name.strip().replace(" ", "_")
    quoted = urllib.parse.quote(slug, safe=":()'!-._~")
    return template.format(heroName=quoted, hero_name=quoted, hero=quoted)


def parse_hero_page(html: str, hero_hint: str | None = None) -> dict:
    parser = HeroPageParser()
    parser.feed(html)
    parser.close()

    result = parser.to_result()
    hero_name = hero_hint or result["title"] or None

    return {
        "hero": hero_name,
        "title": result["title"],
        "summary": result["summary"],
        "infobox": result["infobox"],
        "infobox_fields": result["infobox_fields"],
    }


def write_output(payload: dict, output: Path | None, pretty: bool) -> None:
    content = json.dumps(payload, ensure_ascii=False, indent=2 if pretty else None)
    if output:
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(content + "\n", encoding="utf-8")
    else:
        sys.stdout.write(content + "\n")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Fetch structured hero data from https://overwatch.fandom.com/wiki/{heroName}"
    )
    parser.add_argument("--hero", help="Hero name, e.g. 'Ana' or 'Soldier: 76'")
    parser.add_argument("--url", help="Explicit hero page URL (overrides --hero + --url-template)")
    parser.add_argument(
        "--url-template",
        default=DEFAULT_URL_TEMPLATE,
        help="URL template with {heroName}, {hero_name}, or {hero}",
    )
    parser.add_argument(
        "--html-file",
        type=Path,
        help="Parse hero details from a local HTML file instead of fetching a URL",
    )
    parser.add_argument("--timeout", type=float, default=20.0, help="Network timeout in seconds")
    parser.add_argument("--user-agent", default=DEFAULT_USER_AGENT, help="HTTP User-Agent header")
    parser.add_argument("--output", type=Path, help="Output JSON path (default: stdout)")
    parser.add_argument("--pretty", action="store_true", help="Pretty-print JSON output")
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    if not args.html_file and not args.url and not args.hero:
        raise SystemExit("Provide one of: --hero, --url, or --html-file")

    if args.html_file:
        html = args.html_file.read_text(encoding="utf-8")
        resolved_url = args.url or str(args.html_file)
    else:
        resolved_url = args.url or build_hero_url(args.hero, args.url_template)
        html = fetch_text(resolved_url, timeout=args.timeout, user_agent=args.user_agent)

    parsed = parse_hero_page(html, hero_hint=args.hero)
    parsed["url"] = resolved_url

    write_output(parsed, output=args.output, pretty=args.pretty)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
