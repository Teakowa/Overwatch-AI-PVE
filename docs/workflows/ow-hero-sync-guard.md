# OW Hero Sync Guard

## Scope

Default editable files:

1. `src/constants/ow2_hero_defaults.opy`
2. `src/constants/player_constants.opy`
3. `src/modules/prelude/settings.opy`
4. `src/modules/hero_rules/heroes/<hero>.opy`

## Commands

```bash
tools/player-constants-reachability.ts --prefix ANRAN_
tools/player-constants-reachability.ts --prefix ANRAN_ --apply
tools/player-constants-reachability.ts --global-cleanup --apply
tools/hero-pipeline.ts --from-diff
tools/check-contracts.ts --build
pnpm run build
```

## Notes

- Protocol declarations stay out of scope unless explicitly requested.
- Cleanup defaults to report-only.
- Commit only intended files.
