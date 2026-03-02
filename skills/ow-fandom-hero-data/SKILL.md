---
name: ow-fandom-hero-data
description: Fetch Overwatch hero names from https://overwatch.fandom.com/wiki/Heroes and extract structured hero data from https://overwatch.fandom.com/wiki/{heroName}. Use when Codex needs to build or refresh hero datasets, parse Fandom infobox fields, or automate per-hero data collection from Overwatch wiki pages.
---

# OW Fandom Hero Data

Use this skill to collect Overwatch hero data from Overwatch Fandom in a repeatable way.

## Execute The Workflow

1. Get hero names from the Heroes page.
2. Fetch one hero page to validate parser behavior.
3. Fetch all hero pages in batch.
4. Save JSON outputs for downstream processing.

## Run Core Commands

Fetch hero list from `https://overwatch.fandom.com/wiki/Heroes`:

```bash
skills/ow-fandom-hero-data/scripts/fetch_heroes_from_page.py \
  --output /tmp/ow_heroes.json \
  --pretty
```

Fetch one hero detail page from `https://overwatch.fandom.com/wiki/{heroName}`:

```bash
skills/ow-fandom-hero-data/scripts/fetch_hero_details.py \
  --hero "Ana" \
  --output /tmp/ana.json \
  --pretty
```

Fetch all hero detail pages using the list output:

```bash
skills/ow-fandom-hero-data/scripts/fetch_all_hero_details.py \
  --heroes-file /tmp/ow_heroes.json \
  --output /tmp/ow_hero_details.json \
  --pretty
```

## Use Offline Parsing Mode

Use offline mode when network access is unavailable or when you want deterministic parser tests.

Parse heroes from a local HTML snapshot:

```bash
skills/ow-fandom-hero-data/scripts/fetch_heroes_from_page.py \
  --html-file /path/to/Heroes.html \
  --output /tmp/ow_heroes.json
```

Parse a single hero from local HTML:

```bash
skills/ow-fandom-hero-data/scripts/fetch_hero_details.py \
  --html-file /path/to/Ana.html \
  --hero "Ana" \
  --output /tmp/ana.json
```

Batch parse local HTML files (file naming pattern: `<Hero_Name>.html`):

```bash
skills/ow-fandom-hero-data/scripts/fetch_all_hero_details.py \
  --heroes-file /tmp/ow_heroes.json \
  --html-dir /path/to/html-pages \
  --output /tmp/ow_hero_details.json
```

## Apply Parsing Rules

- Treat hero list output as candidate heroes.
- Use `--allowlist` in `fetch_heroes_from_page.py` to constrain to a curated hero list when needed.
- Keep `--delay` in batch mode to reduce request pressure on the wiki.
- Keep `--fail-on-error` enabled in strict pipelines.

## Consume Output

Read output field definitions in [references/output-schema.md](references/output-schema.md).

Primary output keys:

- Hero list script: `source`, `count`, `heroes`
- Single hero script: `hero`, `title`, `summary`, `infobox`, `infobox_fields`, `url`
- Batch script: `source`, `count`, `failed_count`, `heroes`, `failures`

## Resources

- `scripts/fetch_heroes_from_page.py`: Parse hero names from the Heroes page.
- `scripts/fetch_hero_details.py`: Parse title, summary, and infobox data from one hero page.
- `scripts/fetch_all_hero_details.py`: Batch-fetch hero details from a heroes list.
- `references/output-schema.md`: Output schema and normalization notes.
