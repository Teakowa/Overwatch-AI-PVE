# ARAM/Main Shared Refactor TODO (Hero-First)

本文档已切换到 Hero-First 架构，目标对齐 `ow1-emulator/src/heroes/init.opy` 风格：
- 英雄事实来源集中到 `src/heroes/<hero>/`。
- 外部入口通过 `src/heroes/init.<mode>.opy` 装配。
- 采用 `Shared Base + Mode Overlay`，逐波把 ARAM 差异从 `aram_overrides` 收敛到英雄目录。

## Scope & Invariants

- 不主动调整玩法和平衡数值。
- 不改动 `globalvar/playervar/subroutine` 索引协议。
- 保持主入口顺序契约：`settings/prelude -> optimize -> bootstrap/util/ai -> heroes -> debug`。
- `aram_overrides` 仅承载 ARAM 专属差异，禁止回流 exact duplicate。

## Hero-First Contract

- 共享入口：`src/heroes/init.opy`（共享基线层，当前保持薄层）。
- Main 入口：`src/heroes/init.main.opy`。
- ARAM 入口：`src/heroes/init.aram.opy`。
- 入口切换：
  - `src/main.opy` 仅引入 `#!include "heroes/init.main.opy"`（英雄段）。
  - `src/aramMain.opy` 仅引入 `#!include "heroes/init.aram.opy"`（共享英雄段）。
- 英雄目录规范：`src/heroes/<hero>/`
  - 必备：`init.opy`、`rules.opy`、`main.opy`、`aram.opy`
  - 可选叶子：同级技能/特效文件（示例：`shared/*.opy`、`falloff.opy`）

## Tracking Board

| ID | Task | Status | Exit Criteria |
|---|---|---|---|
| H1 | heroes 单入口切换 | done | `main/aramMain` 均通过 `heroes/init.<mode>.opy` 装配英雄段 |
| H2 | 工具链路径迁移 | done | `check_contracts`/`hero_pipeline`/`changelog_sync` 识别 `src/heroes/**` |
| H3 | 白名单/重复检查迁移 | done | `aram-delta-whitelist.tsv` 与 duplicates 输出路径切到 `src/heroes/**` |
| H4 | ARAM overlay 按英雄迁移 | done | 单英雄 ARAM 差异已归位到 `src/heroes/<hero>/aram.opy` 或同级叶子，`exact=0` |
| H5 | `aram_overrides` 薄层化与分段机制退役 | in_progress | `aram_overrides_segments` 不再参与编译，剩余项以 hero-local mode diff 为主，`aram_overrides.opy` 继续薄层化 |

## Current Gate Baseline

- 当前 duplicate 基线：
  - `src/aram_overrides.opy exact/diff/unique = 0/11/30`
  - `src/heroes/*/aram*.opy exact/diff/unique = 28/98/16`
  - `unwhitelisted aram/overlay exact-diff = 0/0, 0/0`
- H5 当前关注点：
  - `src/aram_overrides.opy` 继续薄层化
  - 剩余债务以 hero-local `same_name_diff` 为主
  - `soldier76` 当前不在剩余 `same_name_diff` 高密度批次中，已从下一波候选移除
- 常用门禁：
  1. `pnpm run build`
  2. `pnpm run build:aram`
  3. `skills/ow-contract-guard/scripts/check_contracts.sh --build`
  4. `skills/ow-contract-guard/scripts/check_contracts.sh --strict-hero-init`
  5. `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff --build`
  6. `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh --check --emit-candidates build/reports/aram-delta-whitelist-candidates.tsv`

## Iteration Log

- 2026-03-06: 完成 H5 Wave-N+7（thin-layer cleanup without extra reports）。修复 `Genji`/`Venture` 的原位装配残留，并将 `mei/bastion/juno/torbjorn/roadhog/winston/ashe/vendetta/widowmaker/soldier76` 的一批 ARAM-only hero-local 规则回收到 `src/heroes/<hero>/aram*.opy`；本波仅更新主 TODO，不新增 report。
- 2026-03-06: 完成 H5 Wave-N+6（selective hero-local leftovers + report cleanup）。`cassidy/genji/venture/zenyatta` 共 6 条 ARAM diff 从 `src/aram_overrides.opy` 回收到英雄 overlay，同时清理 2 份已被后续波次覆盖的早期 pilot 报告。
- 2026-03-06: 完成 H5 Wave-N+5（remaining mid-density hero-local diff localization）。`ashe/baptiste/illari/junkrat/moira/roadhog/sojourn` 共 12 条 ARAM diff 从 `src/aram_overrides.opy` 回收到 `src/heroes/<hero>/aram.opy`。
- 2026-03-06: 完成 H5 Wave-N+4（hazard/juno/orisa/sigma diff localization）。4 组高密度 hero-local ARAM diff 从 `src/aram_overrides.opy` 回收到 `src/heroes/<hero>/aram*.opy`，`src/aram_overrides.opy diff: 40 -> 30`。
- 2026-03-06: 完成 H5 Wave-N+3（next-5 same_name_diff localization）。`ana/brigitte/freja/kiriko/reinhardt` 共 24 条 ARAM diff 从 `src/aram_overrides.opy` 内联规则体回收到 `src/heroes/<hero>/aram*.opy`。
- 2026-03-06: 完成 H5 Wave-N+2（next-4 same_name_diff localization）。`doomfist/mauga/reaper/wuyang` 共 26 条 ARAM diff 从 `src/aram_overrides.opy` 内联规则体回收到 `src/heroes/<hero>/aram*.opy`。
- 2026-03-06: 完成 H5 Wave-N+1（top-5 same_name_diff localization）。`ramattra/sombra/tracer/zarya/wrecking_ball` 共 16 条 ARAM diff 从 `src/aram_overrides.opy` 内联规则体回收到 `src/heroes/<hero>/aram*.opy`。
- 2026-03-06: 完成 H5 Wave-N（cross-hero exact cleanup + legacy directory retirement）。`aram_cross_hero_overrides.opy` 下线，4 组 cross-hero exact 回收到 hero-owned shared leaves；`src/aram_overrides_segments/` 整体删除。
- 2026-03-06: 完成 H5 Prep（segment compile dependency retirement）。`aram_overrides` 不再直接 include `aram_overrides_segments/*`；单英雄 segment 归位到 `src/heroes/<hero>/aram.opy`，跨英雄残留收束到 `src/aram_cross_hero_overrides.opy`。
- 2026-03-06: 完成 H4 Wave-1（6 英雄 Detect 先行）。门禁全绿，行为保持“仅抽取、不改逻辑”。后续进入 H4 下一波，继续收敛 Initialize same-name-diff 与 overlay 归位。
- 2026-03-06: 完成 H4 Wave-2（全量 Initialize 向 Main 收敛 + custom_hp helper 下线）。ARAM hero_init 改为统一 include `src/heroes/*/init.opy`，`aram_overrides` 不再承载 Detect/Initialize 规则体与 custom_hp 依赖。
- 2026-03-06: 完成 H4 Wave-3（Hero Overlay First 清理 10 条 hero exact）。规则源统一迁入 `src/heroes/<hero>/shared/*.opy`，ARAM 通过 `src/heroes/<hero>/aram.opy` 复用；duplicates 门禁 overlay 扫描扩展到 `src/heroes/*/aram*.opy` 全量。

## Archived Reports

- Hero-First cutover and H4 migration details are archived in:
  - `docs/reports/aram-shared-wave-hero-first-cutover-2026-03-06.md`
  - `docs/reports/aram-shared-wave-h4-init-detect-pilot-2026-03-06.md`
  - `docs/reports/aram-shared-wave-h4-init-full-convergence-2026-03-06.md`
  - `docs/reports/aram-shared-wave-h4-hero-exact-overlay-2026-03-06.md`
- H5 completed wave reports are archived in:
  - `docs/reports/aram-shared-wave-h5-segment-retirement-prep-2026-03-06.md`
  - `docs/reports/aram-shared-wave-h5-cross-hero-retirement-2026-03-06.md`
  - `docs/reports/aram-shared-wave-h5-top5-diff-localization-2026-03-06.md`
  - `docs/reports/aram-shared-wave-h5-next4-diff-localization-2026-03-06.md`
  - `docs/reports/aram-shared-wave-h5-next5-diff-localization-2026-03-06.md`
  - `docs/reports/aram-shared-wave-h5-next4-hjos-diff-localization-2026-03-06.md`
  - `docs/reports/aram-shared-wave-h5-next7-mid-density-diff-localization-2026-03-06.md`

## Latest Completed Iteration (H5 Wave-N+7: Thin-Layer Cleanup Without Extra Reports)

- 波次范围：
  - 修复 `Genji` 与 `Venture` 在 `src/aram_overrides.opy` 中的残留装配问题，恢复 hero-owned overlay 的原位展开
  - 将 `mei/bastion/juno/torbjorn/roadhog/winston/ashe/vendetta/widowmaker/soldier76` 的 ARAM-only 规则继续回收到对应 `src/heroes/<hero>/aram*.opy`
  - 本波不新增 report，仅更新主 TODO
- 变更动作：
  - `src/aram_overrides.opy` 删除 `Genji` 半拆分残留，并把 `Venture` include 挪回原位，避免 hero overlay 被晚于原顺序展开。
  - 新增 `src/heroes/ashe/aram-10-dynamite.opy` 与 `src/heroes/juno/aram-10-pulsar-torpedoes.opy`，用于保持原插入点，不把规则整体提前到通用 `aram.opy`。
  - `src/heroes/mei/aram.opy`、`src/heroes/bastion/aram.opy`、`src/heroes/torbjorn/aram.opy`、`src/heroes/roadhog/aram.opy`、`src/heroes/winston/aram.opy`、`src/heroes/vendetta/aram.opy`、`src/heroes/widowmaker/aram.opy`、`src/heroes/soldier76/aram.opy` 收回对应 ARAM-only 规则。
- 指标结果：
  - `src/aram_overrides.opy exact/diff/unique: 0/12/45 -> 0/11/30`
  - `src/heroes/*/aram*.opy exact/diff/unique: 28/98/2 -> 28/98/16`
  - `exact = 0`
  - `unwhitelisted exact/diff = 0/0`
- 验证报告：
  - 无；本波结果直接记入本 TODO。

## Next Steps

1. H5：继续处理剩余 11 条 `same_name_diff`，优先只动 `src/aram_overrides.opy` 与英雄 overlay，不碰你正在调整的 system/bootstrap 主线文件。
2. H5：`src/aram_overrides.opy` 的 hero-local ARAM-only 规则已明显下降，下一步只在顺序确实需要时再新增 `aram-*.opy` 叶子，不再默认写波次 report。
3. H6：在 `src/aram_overrides.opy` 稳定收缩到最后一批 system-level diff 后，再推进结构收敛与文档归档。
