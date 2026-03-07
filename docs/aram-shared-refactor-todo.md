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
| H7 | active overlay debt phase-2 | in_progress | 明确保留 `mode-only` / `exact-overlay` 边界，并为剩余 `src/**/aram*.opy` active diff 建立新的收敛批次 |

## Current Gate Baseline

- 当前 duplicate 基线：
  - `src/aram_overrides.opy exact/diff/unique = 0/0/0`
  - `src/**/aram*.opy active overlays exact/diff/unique = 18/109/53`
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

- 2026-03-06: H4 完成 hero-first cutover 与 init/rules 收敛，英雄段入口切到 `src/heroes/init.<mode>.opy`，duplicates 扫描范围同步扩展到 `src/heroes/*/aram*.opy`。
- 2026-03-06: H5 完成 `src/aram_overrides.opy` 薄层化与 segment retirement，大部分 hero-local 和 system-local diff 下沉到 `src/heroes/**/aram*.opy` 与 `src/modules/**/aram-*.opy`，并把 active overlay debt 从 overrides 本体迁出。
- 2026-03-06: H6 完成两类结构收口：
  - hero leaf 命名统一为纯语义命名，移除历史数字前缀与 `shared/` 目录残留
  - `src/aram_overrides.opy` 收成纯 assembly，hero/module overlays 的 active diff 结构稳定
- 2026-03-06: H6 后段确认 `hazard` 的 `Violent Leap` 与 `kiriko` 的 payload bot 规则属于已确认保留边界；继续拆分会重新引入与 `rules.opy` 的 exact-overlay 风险。
- 2026-03-07: H7 Wave-A 完成 hero retained overlay inventory，hero 侧当前仅剩 `hazard/kiriko` 两组 retained overlays，后续重心转向 module-owned overlays inventory。

## Archived Reports

- 已删除两份已被后续波次完全覆盖的早期归档，当前不再保留引用。
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

## Latest Completed Iteration (H7 Wave-A: Hero Retained Overlay Inventory)

- 波次范围：
  - 盘点 `src/heroes/**/aram*.opy` 中仍位于 hero 根 `aram.opy` 的活跃边界
  - 明确哪些属于 retained overlays，哪些属于入口/非目标文件
  - 为 H7 后续波次建立可执行名单
  - 本波不新增 report，仅更新主 TODO
- 变更动作：
  - 确认 `hazard` 与 `kiriko` 是当前仅存的 hero-root retained overlays；两者都不适合继续拆成同级叶子，因为会回到与 `rules.opy` 的 exact-overlay 风险。
  - 确认 `src/heroes/aram-init.opy` 是入口/分隔文件，不属于 H7 debt inventory 的目标。
  - 将 hero 侧 inventory 明确写入 TODO，作为 H7 Wave-B/C 的直接输入。
- 指标结果：
  - `src/aram_overrides.opy exact/diff/unique` 维持 `0/0/0`
  - active overlay 基线维持 `18/109/53`
  - hero-root retained overlays = `2`（`hazard`、`kiriko`）
  - `unwhitelisted exact/diff = 0/0`
- 验证报告：
  - 无；本波结果直接记入本 TODO。
- 当前 inventory：
  - retained overlays: `src/heroes/hazard/aram.opy`、`src/heroes/kiriko/aram.opy`
  - non-target entry file: `src/heroes/aram-init.opy`
  - H7 Wave-B 候选：`src/modules/bootstrap/aram-00-init-and-settings.opy`、`src/modules/bootstrap/aram-10-safety-blacklist-ban.opy`、`src/modules/bootstrap/aram-15-extra-hero-pool.opy`、`src/modules/bootstrap/aram-20-player-lifecycle-and-reset.opy`、`src/modules/debug/aram-20-changelog.opy`

## Next Steps

1. H7 Wave-B：按模块拆看 `src/modules/**/aram-*.opy`，确认是否存在可以继续下沉到 hero-owned leaves 的跨模块残留；若没有，就把 module-owned mode-only 设计固化成文档结论。
2. H7 Wave-C：仅在 Wave-B 明确存在可继续下沉的非 module-owned 残留时启动，并继续坚持不放宽 whitelist 的前提。
3. `hazard/kiriko` 视为当前已确认保留边界；若未来要继续拆分，应连同 whitelist 策略一起调整，而不是单独做文件重排。
4. 后续只保留仍被主 TODO 引用、或对关键决策回溯仍有价值的 wave 报告。
