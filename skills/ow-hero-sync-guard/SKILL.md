---
name: ow-hero-sync-guard
description: Safely sync one hero from Overwatch Fandom into Overwatch-AI-PVE constants/settings/rules with strict edit boundaries, dependency-aware constant cleanup, and mandatory validation gates.
---

# OW Hero Sync Guard

Use this skill when a task combines hero data sync and source updates, for example:
- fetch one hero data page from Fandom
- sync values into `ow2_hero_defaults` and `player_constants`
- reverse settings percentages into constant-driven expressions
- replace hero rule magic numbers with named constants

## Hard Boundaries

Default editable file scope is limited to:

1. `src/constants/ow2_hero_defaults.opy`
2. `src/constants/player_constants.opy`
3. `src/modules/prelude/00-settings.opy`
4. `src/modules/hero_rules/heroes/<hero>.opy`

Rules:

1. Do not touch protocol declarations (`globalvar`, `playervar`, `subroutine`) unless explicitly requested.
2. Do not touch `hero_init` or module include indexes unless explicitly requested.
3. Keep cleanup of `player_constants` report-only by default.
4. Deletion is opt-in and boundary-limited:
   - hero-scoped cleanup: `--prefix <HERO_>` + `--apply`
   - global cleanup: `--global-cleanup` + `--apply` (explicit high-risk mode)
5. Commit only intended files; never include unrelated dirty files (for example `workshop.ow`).

## Recommended Workflow

1. Extract one hero page data (prefer `scraplingserver` in Codex).
2. Normalize values into repo constants vocabulary.
3. Sync `OW2_<HERO>_*` into `src/constants/ow2_hero_defaults.opy`.
4. Sync `<HERO>_*` into `src/constants/player_constants.opy`.
5. If requested, reverse settings `%` values to constant-driven expressions:
   - `percent((TARGET_VALUE) / (BASE_VALUE))`
   - avoid `SET_*_TARGET` if task requires non-`SET` naming.
6. Replace hero rule magic numbers with constants in `hero_rules/heroes/<hero>.opy`.
7. Run constant reachability report before deletion:

```bash
python3 skills/ow-hero-sync-guard/scripts/player_constants_reachability.py --prefix ANRAN_
```

8. Apply deletion only when explicitly requested:

```bash
python3 skills/ow-hero-sync-guard/scripts/player_constants_reachability.py --prefix ANRAN_ --apply
```

Global deletion (high risk, explicit only):

```bash
python3 skills/ow-hero-sync-guard/scripts/player_constants_reachability.py --global-cleanup --apply
```

## Validation Gates (mandatory)

```bash
skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff
skills/ow-contract-guard/scripts/check_contracts.sh --build
pnpm run build
```

## Scope Guard Snippet

Before commit, ensure staged files are in the allowed set:

```bash
git diff --cached --name-only | rg -v '^(src/constants/ow2_hero_defaults\.opy|src/constants/player_constants\.opy|src/modules/prelude/00-settings\.opy|src/modules/hero_rules/heroes/<hero>\.opy)$'
```

If output is non-empty, stop and split commits or restage.

## Resources

- `scripts/player_constants_reachability.py`: dependency-aware unused-constant report/apply tool for `player_constants.opy`.
- `skills/ow-fandom-hero-data/SKILL.md`: extraction-focused workflow from Fandom.
- `skills/ow-hero-change-pipeline/SKILL.md`: hero-focused regression checks.
- `skills/ow-contract-guard/SKILL.md`: contract invariants and build gate.
