# ARAM/Main Hero-First Cutover Report (2026-03-06)

## Scope

- 切换英雄代码事实来源到 `src/heroes/<hero>/`。
- `main/aramMain` 英雄段入口切换到 `src/heroes/init.<mode>.opy`。
- 工具链路径契约切到 `src/heroes/**`。
- 仅结构重构，不改玩法。

## Changed Entry Contracts

- `src/main.opy`:
  - 英雄段改为 `#!include "heroes/init.main.opy"`
- `src/aramMain.opy`:
  - 共享英雄段改为 `#!include "heroes/init.aram.opy"`
- `src/modules/_index.opy`:
  - 模块展开契约改为 `#!include "../heroes/init.main.opy"`

## Tooling Contract Migration

- `skills/ow-contract-guard/scripts/check_contracts.sh`
  - hero_init 巡检改为 `src/heroes/*/init.opy`
  - hero delimiter 顺序检查改为 `src/heroes/main.opy`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh`
  - hero 发现与 diff 识别改为 `src/heroes/**`
  - hero include 校验改为 `src/heroes/main.opy`
- `skills/ow-changelog-sync/scripts/changelog_sync.sh`
  - hero 发现与 diff 识别改为 `src/heroes/**`
- `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh`
  - 校验提示文案更新为 `src/heroes` 语义

## Whitelist/Manifest Path Migration

- `skills/ow-contract-guard/references/aram-delta-whitelist.tsv`
  - `source_module` 中 `src/modules/hero_*` 已迁移到 `src/heroes/**`
- `src/aram_overrides_segments/manifest.tsv`
  - `source_modules` 中 `modules/hero_*` 已迁移到 `heroes/**`

## Validation Results

1. `pnpm run build` -> PASS
2. `pnpm run build:aram` -> PASS
3. `skills/ow-contract-guard/scripts/check_contracts.sh --build` -> PASS
4. `skills/ow-contract-guard/scripts/check_contracts.sh --strict-hero-init` -> PASS
5. `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff --build` -> PASS（本次因未暂存重命名，自动识别为空）
6. `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero freja --build` -> PASS（补跑）
7. `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh --check --emit-candidates build/reports/aram-delta-whitelist-candidates.tsv` -> PASS

## Duplicate Metrics

- exact duplicate: `53`
- same-name-diff: `148`
- unique: `49`
- unwhitelisted exact: `0`
- unwhitelisted diff: `0`
- candidates: `0`

## Conclusion

- Hero-First 结构切换完成并通过门禁。
- duplicate 基线保持稳定（`53/148`）。
- 后续按 H4 执行逐英雄 ARAM overlay 收敛，最终推进 H5 退役 `aram_overrides_segments`。
