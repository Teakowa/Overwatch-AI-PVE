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
4. Shared-prelude `globalvar` / `playervar` / `subroutine` membership and order match
   `tools/data/contract-guard/protocol-indexes.tsv`. This file is the shared ABI
   baseline, not a registry of module-local declarations.
5. Stable `reset_pvar` slot assignments in `src/utilities/reset_frenemies.opy`.
6. Hero init safety pattern checks under `src/heroes/*/init*.opy`.

Module-local declarations are validated through their `#!mainFile` directive, expanded
Main/ARAM include-graph ownership boundary, duplicate-name detection, and explicit-index
collision checks. Moving a private variable out of prelude therefore requires removing
its baseline row while preserving the remaining baseline order; the owner module may
retain the old explicit slot when ABI stability requires it.

## Related Gate

```bash
tools/hero-pipeline.ts --from-diff --strict-cooldown-placement
```
