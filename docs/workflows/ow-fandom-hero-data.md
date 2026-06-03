# OW Fandom Hero Data

- Display Name: `OW Fandom Hero Data`
- Prompt Intent: Get Overwatch hero names from the Heroes page and extract structured details from each hero wiki page.

## Core Commands

```bash
tools/fandom/fetch-heroes.ts --output /tmp/ow_heroes.json --pretty
tools/fandom/fetch-hero-details.ts --hero "Ana" --output /tmp/ana.json --pretty
tools/fandom/fetch-all-hero-details.ts --heroes-file /tmp/ow_heroes.json --output /tmp/ow_hero_details.json --pretty
```

## Offline Mode

```bash
tools/fandom/fetch-heroes.ts --html-file /path/to/Heroes.html --output /tmp/ow_heroes.json
tools/fandom/fetch-hero-details.ts --html-file /path/to/Ana.html --hero "Ana" --output /tmp/ana.json
tools/fandom/fetch-all-hero-details.ts --heroes-file /tmp/ow_heroes.json --html-dir /path/to/html-pages --output /tmp/ow_hero_details.json
```

## Output Reference

Read [fandom-output-schema.md](/Users/teakowa/Repos/teakowa/Overwatch-AI-PVE/docs/references/fandom-output-schema.md).
