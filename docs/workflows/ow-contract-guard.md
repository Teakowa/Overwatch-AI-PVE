# OW Contract Guard

- Display Name: `OW Contract Guard`
- Prompt Intent: Run contract checks, report failures and warnings, and propose the minimum safe fix set.

## Quick Start

```bash
tools/check-contracts.ts
tools/check-contracts.ts --build
tools/check-contracts.ts --strict-hero-init
```

## Enforced Contracts

1. `src/main.opy` flattened include order and `#!optimizeStrict` placement.
2. Delimiter include boundaries in `src/modules/ai/_index.opy` and `src/heroes/main.opy`.
3. Required delimiter rule names exist exactly once.
4. `globalvar` / `playervar` / `subroutine` declaration order matches `tools/data/contract-guard/protocol-indexes.tsv`.
5. Stable `reset_pvar` slot assignments in `src/utilities/reset_frenemies.opy`.
6. Hero init safety pattern checks under `src/heroes/*/init*.opy`.

## Related Gate

```bash
tools/hero-pipeline.ts --from-diff --strict-cooldown-placement
```
