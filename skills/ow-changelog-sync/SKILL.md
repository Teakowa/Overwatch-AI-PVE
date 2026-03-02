---
name: ow-changelog-sync
description: Sync player-facing changelog updates with hero gameplay changes in Overwatch-AI-PVE. Use when hero_rules or hero_init changes are made and you need to generate pending changelog entries from diff, validate hero coverage in debug/20-changelog.opy, and enforce player-facing wording rules (no Team 1/Team 2 wording).
---

# OW Changelog Sync

Use this skill when hero behavior changes might drift from player-facing changelog text.

## Quick Start

Generate pending changelog entries for heroes inferred from current diff:

```bash
skills/ow-changelog-sync/scripts/changelog_sync.sh --from-diff
```

Audit one hero and enforce strict coverage/language rules:

```bash
skills/ow-changelog-sync/scripts/changelog_sync.sh --hero freja --strict-coverage --strict-language
```

Generate a markdown report:

```bash
skills/ow-changelog-sync/scripts/changelog_sync.sh --from-diff --report
```

## What It Checks

1. Hero coverage in `src/modules/debug/20-changelog.opy`:
   - validates `eventPlayer.getHero() == Hero.<CONST>` branch presence for each target hero
2. Diff-driven pending changelog items:
   - extracts hero-related change clues from `hero_rules` / `hero_init` diffs
   - outputs a player-facing todo list for changelog updates
3. Player-facing language guard:
   - checks changelog content and generated entries for team-number wording
   - blocks or warns on terms like `Team 1`, `Team 2`, `队伍 1`, `队伍 2`

## Player-Facing Writing Rule

Changelog content is for players. Do not use team-number phrasing.

Preferred style:
- Describe behavior directly (what changed, when, and impact)
- Use neutral role-based terms when needed (for example “友方/敌方”)

Avoid:
- `Team 1` / `Team 2`
- `队伍 1` / `队伍 2`

## Recommended Flow

1. Run `--from-diff` after gameplay edits.
2. Fill/update changelog branches for impacted heroes.
3. Rerun with `--strict-coverage --strict-language`.
4. If needed, export final review notes with `--report`.
