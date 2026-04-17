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

## Sync One Hero Into This Repo (Constants + Settings + Rules)

Use this flow when the task is not only data collection, but also landing hero values
into `Overwatch-AI-PVE` source files.

1. Fetch one hero page from Fandom (prefer `scraplingserver` in Codex for quick extraction).
2. Extract gameplay numbers needed by the repo:
   - Health
   - Passive/burning damage + duration
   - Weapon damage/ammo/speed/range
   - Ability cooldown/damage/charges
   - Ultimate damage/cost
3. Update `src/constants/ow2_hero_defaults.opy`:
   - add `OW2_<HERO>_*` constants in hero alphabetical block.
4. Copy/sync values into `src/constants/player_constants.opy`:
   - add `<HERO>_*` baseline constants (no `OW2_` prefix).
   - add settings target constants if required by task convention.
   - add rule effect constants for any magic numbers used in `hero_rules`.
5. Reverse settings values from current `%` config when required:
   - if task requests `percent(...)` expressions, use:
     - `percent((TARGET_VALUE) / (BASE_COOLDOWN))`
   - if task forbids `SET_*_TARGET`, use hero-specific non-`SET_` target constant names.
6. Update `src/modules/prelude/settings.opy` hero entries:
   - replace hard-coded percentages with constant-driven `percent(...)` expressions.
7. Update `src/modules/hero_rules/heroes/<hero>.opy`:
   - replace hard-coded effect values with constants from `player_constants.opy`.

## Codex Extraction Pattern (Fandom)

For one hero page, this pattern is usually enough:

1. `mcp__scraplingserver__fetch` with markdown extraction:
   - URL: `https://overwatch.fandom.com/wiki/<HeroName>`
2. `mcp__scraplingserver__get` with targeted selectors for structure:
   - `span.mw-headline` for section anchors.
   - ability-oriented selectors (`[class*='ability']`) for numeric fields.
3. Normalize extracted values before writing constants.

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

## Validation Gate For Repo Landing

After updating constants/settings/rules for a hero, run:

```bash
skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff
skills/ow-contract-guard/scripts/check_contracts.sh --build
pnpm run build
```

Recommended semantic checks (example for `Anran`):

```bash
rg -n "SET_.*ANRAN" src/constants/player_constants.opy
rg -n "\"anran\": \\{" src/modules/prelude/settings.opy
rg -n "ANRAN_BURN_TARGET_DAMAGE_AMP_PERCENT|startDamageModification" src/modules/hero_rules/heroes/anran.opy
```

## Resources

- `scripts/fetch_heroes_from_page.py`: Parse hero names from the Heroes page.
- `scripts/fetch_hero_details.py`: Parse title, summary, and infobox data from one hero page.
- `scripts/fetch_all_hero_details.py`: Batch-fetch hero details from a heroes list.
- `references/output-schema.md`: Output schema and normalization notes.
