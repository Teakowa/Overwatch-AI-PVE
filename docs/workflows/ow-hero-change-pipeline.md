# OW Hero Change Pipeline

- Display Name: `OW Hero Pipeline`
- Prompt Intent: Run the hero change pipeline for impacted heroes, report blocking failures first, then warnings and suggested fixes.

## Quick Start

```bash
tools/hero-pipeline.ts --hero freja
tools/hero-pipeline.ts --from-diff
tools/hero-pipeline.ts --from-diff --build
tools/hero-pipeline.ts --from-diff --strict-cooldown-placement
tools/hero-pipeline.ts --from-diff --report-template
```

## What It Checks

1. Hero init include and detect/initialize safety pattern.
2. `reset_pvar` semantic usage inside hero init.
3. Hero rules touchpoint and changelog branch presence.
4. Throttle risks in high-frequency hero rules.
5. Cooldown placement drift between rules and settings.
6. Optional review report template generation.

## Recommended Final Gate

```bash
tools/check-contracts.ts --build
```
