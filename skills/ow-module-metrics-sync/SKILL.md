---
name: ow-module-metrics-sync
description: Sync module metrics in docs/modules with the current source of truth. Use when src/modules or prelude declarations change and docs may have drifted counts for rules, vars, subroutines, defs, or disabled annotations.
---

# OW Module Metrics Sync

Use this skill to keep module documentation statistics aligned with source code.

## Quick Start

Sync metrics into `docs/modules/*.md`:

```bash
skills/ow-module-metrics-sync/scripts/metrics_sync.sh
```

Check whether docs are already synchronized (no file write):

```bash
skills/ow-module-metrics-sync/scripts/metrics_sync.sh --check
```

Generate a report while syncing:

```bash
skills/ow-module-metrics-sync/scripts/metrics_sync.sh --report
```

## What It Syncs

1. Global stats from source:
- `rule` total
- `globalvar` / `playervar` / `subroutine` declaration counts
- `def` implementation count
- `@Disabled` annotation count

2. Module-level stats:
- `bootstrap` rules / defs
- `ai` rules / defs
- `hero_rules` rules / defs
- `hero_init` rules
- `debug` rules / defs

3. Managed docs targets:
- `docs/modules/01-main-opy-architecture.md`
- `docs/modules/04-current-implementation-summary.md`
- `docs/modules/appendix-src-file-index.md`
- `docs/modules/02-modular-split-plan.md`

## Recommended Flow

1. Modify `src/modules/*` gameplay or structure.
2. Run `metrics_sync.sh` to refresh docs metrics.
3. Run `metrics_sync.sh --check` as final gate before commit.
4. If needed, attach `--report` output to review notes.
