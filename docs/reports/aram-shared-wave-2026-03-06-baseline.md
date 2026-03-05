# ARAM Shared Refactor Wave Baseline (2026-03-06)

## Scope

- 目标：为“薄 overrides + 差异白名单”迁移建立本轮可重复门禁基线。
- 约束：不改玩法，不改变量索引协议，不在 `src/modules/*` 新建 ARAM 专用模块。

## Structural Changes In This Wave

1. Main-only 模式宏承载迁移：
   - 新增 `src/main_mode_profile.opy`
   - 从 `src/modules/bootstrap/20-player-lifecycle-and-reset.opy` 移除 Main 默认 `RESET_*` 宏
2. Main 入口契约对齐：
   - `src/main.opy` 采用 `constants -> prelude -> #!optimizeStrict -> modules`
   - `src/modules/_index.opy` 新增 `#!include "../main_mode_profile.opy"`
3. ARAM 差异门禁升级：
   - `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh` 新增
     - `--whitelist`
     - `--emit-candidates`
   - 新增 `skills/ow-contract-guard/references/aram-delta-whitelist.tsv`
4. ARAM segment manifest 噪声修复：
   - `src/aram_overrides_segments/manifest.tsv` 与当前 include 集合一致（16 条）

## Verification Commands

1. `pnpm run build`
   - Result: PASS
   - Notes: existing warnings only (`w_wait_until`, `w_player_closest_to_reticle`, `w_9999`, `w_wait_9999`)
2. `pnpm run build:aram`
   - Result: PASS
   - Notes: existing warnings only
3. `skills/ow-contract-guard/scripts/check_contracts.sh --build`
   - Result: PASS
   - Summary: `397 passed, 0 warning(s), 0 failure(s)`
4. `skills/ow-contract-guard/scripts/check_contracts.sh --strict-hero-init`
   - Result: PASS
   - Summary: `396 passed, 0 warning(s), 0 failure(s)`
5. `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff --build`
   - Result: PASS (N/A)
   - Output: `No hero-related file changes detected from diff range: HEAD`
6. `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh --check --emit-candidates build/reports/aram-delta-whitelist-candidates.tsv`
   - Result: PASS
   - Metrics:
     - total rules: `254`
     - exact duplicates: `57`
     - same-name-diff: `148`
     - unique names: `49`
     - manifest segments: `16`
     - unwhitelisted exact: `0`
     - unwhitelisted diff: `0`
     - residual exact runs `>=2`: `0`
   - Candidate file rows: `0`

## Current Delta Governance Status

- 白名单门禁已接入：新增未登记的 exact/diff 将在 `--check` 下失败。
- 现状仍为“迁移中”：
  - `exact duplicate` 与 `same-name-diff` 仍存在（已被基线白名单托管）
  - 后续 Wave 需要持续从白名单中“消项”直至薄 overrides 目标
