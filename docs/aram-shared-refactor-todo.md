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
  - 必备：`init.opy`、`rules.opy`、`main.opy`
  - `aram.opy`：可选（仅当该英雄需要保留 ARAM wrapper 语义边界或承载 ARAM 专属规则时保留）
  - 可选拆分文件：同级技能/特效文件（示例：`falloff.opy`、`aram-headhunter.opy`）；不再使用 `shared/` 目录承载可复用规则
  - 文件名只表达语义，不表达加载顺序；实际顺序只由 include 位置决定

## Tracking Board

| ID | Task | Status | Exit Criteria |
|---|---|---|---|
| H1 | heroes 单入口切换 | done | `main/aramMain` 均通过 `heroes/init.<mode>.opy` 装配英雄段 |
| H2 | 工具链路径迁移 | done | `check_contracts`/`hero_pipeline`/`changelog_sync` 识别 `src/heroes/**` |
| H3 | 白名单/重复检查迁移 | done | `aram-delta-whitelist.tsv` 与 duplicates 输出路径切到 `src/heroes/**` |
| H4 | ARAM overlay 按英雄迁移 | done | 单英雄 ARAM 差异已归位到 `src/heroes/<hero>/aram.opy` 或同级拆分文件，`exact=0` |
| H5 | `aram_overrides` 薄层化与分段机制退役 | done | `aram_overrides_segments` 不再参与编译，`src/aram_overrides.opy` 不再承载 exact/same-name-diff，活跃差异已下沉到 hero/module overlays |
| H6 | `aram_overrides.opy` 纯装配化 | done | `src/aram_overrides.opy` 不再出现 `rule/def`，active duplicate debt 仅存在于 `src/**/aram*.opy` |
| H7 | active overlay debt phase-2 | done | hero/module retained boundaries 已固化，Wave-C 无新增强候选，剩余 active diff 已转入已知保留边界 |
| H8 | main/aram shared-leaf convergence | in_progress | 仅使用完整 `.opy` 叶子做 shared merge 或 paired leaves，main/aram 重复规则继续按成对判定收敛 |

## Current Gate Baseline

- 当前 duplicate 基线：
  - `src/aram_overrides.opy exact/diff/unique = 0/0/0`
  - `src/**/aram*.opy active overlays exact/diff/unique = 18/102/54`
  - `unwhitelisted aram/overlay exact-diff = 0/0, 0/0`
- H5 收口结果：
  - `src/aram_overrides.opy` 已清空 duplicate debt，当前只保留装配入口
  - 活跃 duplicate debt 已全部下沉到 `src/heroes/**/aram*.opy` 与 `src/modules/**/aram*.opy`
  - 后续工作转入 H6，重点是把 `src/aram_overrides.opy` 收成纯装配层，并继续评估 overlay 层共享化与归档
- 常用门禁：
  1. `pnpm run build`
  2. `pnpm run build:aram`
  3. `skills/ow-contract-guard/scripts/check_contracts.sh --build`
  4. `skills/ow-contract-guard/scripts/check_contracts.sh --strict-hero-init`
  5. `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff --build`
  6. `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh --check --emit-candidates build/reports/aram-delta-whitelist-candidates.tsv`

## Condensed Iteration Summary

- H4-H6（2026-03-06）：完成 hero-first cutover、命名收敛与 `aram_overrides` pure assembly 化，duplicate debt 主体迁移到 `src/**/aram*.opy`。
- H7（2026-03-07）：完成 hero/module retained boundary 审核与 module overlay semantic split，关闭 phase-2 overlay debt 盘点。
- H8 Wave-A~H（2026-03-07）：修正为 full-file shared leaves only，完成 `debug/changelog` + `cassidy/falloff` exact shared，并完成 bootstrap lifecycle near-duplicate 收敛。
- H8 Wave-I~L（2026-03-07~2026-03-08）：以稳定优先去链式 include，退役多批 0-rule wrapper，当前仅保留确有规则或边界语义价值的 wrapper。
- H8 Wave-M（2026-03-08）：批量删除 15 个无引用 0-rule hero wrapper（`anran/domina/dva/echo/hanzo/jetpack_cat/junker_queen/lucio/mizuki/pharah/ramattra/symmetra/tracer/zarya/cassidy`），缩短后续收敛扫描路径。

## Archived Reports

- 波次报告已清理，关键信息已折叠进 `Condensed Iteration Summary`。
- Baseline-only 保留文档：
  - `docs/reports/aram-vs-main-verification.md`
  - `docs/reports/module-metrics-sync-20260302-201115.md`

## Latest Completed Iteration (H8 Wave-M: Wrapper Prune + TODO Compression)

- 波次范围：
  - 代码侧：删除 15 个无引用且 0-rule 的 `hero/*/aram.opy` 空壳文件
  - 文档侧：压缩 TODO 重复段落，合并阶段信息并保留执行入口
- 判定边界：
  - `exact shared`：`src/modules/debug/20-changelog.opy`、`src/heroes/cassidy/falloff.opy`
  - `retain split`：`bootstrap 00/10/20`、`heroes/init`
  - `retained boundary`：`hazard/kiriko` 继续作为已确认保留边界；`emre/aram.opy` 继续承载 ARAM 专属规则
- 指标结果：
  - `src/aram_overrides.opy exact/diff/unique = 0/0/0`
  - `src/**/aram*.opy active overlays exact/diff/unique = 18/102/54`
  - `unwhitelisted aram/overlay exact-diff = 0/0, 0/0`
- 验证：
  - `pnpm run build`
  - `pnpm run build:aram`
  - `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh --check`
  - `skills/ow-contract-guard/scripts/check_contracts.sh --strict-hero-init`（仅保留既有 include mismatch）

## Next Steps

1. H8 Wave-N：继续扫描 `main/aram` 成对叶子，仅落地新增 `exact shared` 或低风险 near-duplicate 收敛。
2. 既有 `strict-hero-init` 的 `src/main.opy` include mismatch 继续按 pre-existing gate issue 跟踪，不归因于 H8 回归。
3. 维持 baseline-only 报告策略，仅保留仍被 TODO 引用的关键基线文档。
