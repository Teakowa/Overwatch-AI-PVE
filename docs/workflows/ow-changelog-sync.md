# OW Changelog Sync

- Display Name: `OW Changelog Sync`
- Prompt Intent: Detect impacted heroes from gameplay diffs, validate changelog hero coverage, and generate player-facing changelog todo items without Team 1/Team 2 wording.

## Quick Start

```bash
tools/changelog-sync.ts --from-diff
tools/changelog-sync.ts --hero freja --strict-coverage --strict-language
tools/changelog-sync.ts --hero jetpack_cat --strict-coverage --strict-language --strict-settings-sync
tools/changelog-sync.ts --from-diff --report
```

## Checks

1. Hero coverage in `src/modules/debug/changelog.opy`.
2. Diff-driven pending changelog items for impacted heroes.
3. Team-number wording guard for player-facing text.
4. Settings cooldown changes synced with hero changelog branch updates.
