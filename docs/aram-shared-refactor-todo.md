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
| H7 | active overlay debt phase-2 | done | hero/module retained boundaries 已固化，Wave-C 无新增强候选，剩余 active diff 已转入已知保留边界 |

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
- 2026-03-07: H7 Wave-B 完成 module overlay semantic split + retention decision：`aram-00-init-and-settings.opy` 与 `aram-20-player-lifecycle-and-reset.opy` 已拆成 module-local 语义叶子，`aram-10-safety-blacklist-ban.opy`、`aram-15-extra-hero-pool.opy`、`aram-20-changelog.opy` 维持保留整体。
- 2026-03-07: H7 Closure Review 完成 retained boundary 审核：Wave-C 未发现新的 mixed-responsibility module overlays，`hazard/kiriko` 与剩余 module-owned overlays 全部固化为当前阶段的保留边界，H7 正式收口。

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

## Latest Completed Iteration (H7 Closure Review)

- 波次范围：
  - 复核 H7 Wave-B 之后仍保留的 hero/module overlays
  - 判断是否存在必须启动 Wave-C 的新 mixed-responsibility 候选
  - 将 retained boundaries 固化为 H7 阶段结论
  - 本波不新增 report，仅更新主 TODO
- 变更动作：
  - 复核 `src/modules/bootstrap/aram-10-safety-blacklist-ban.opy`、`src/modules/bootstrap/aram-15-extra-hero-pool.opy`、`src/modules/debug/aram-20-changelog.opy`，确认它们仍是职责集中的 module-owned mode-only overlays，不触发 Wave-C。
  - 复核 `src/heroes/hazard/aram.opy` 与 `src/heroes/kiriko/aram.opy`，确认它们仍属于已知 hero-root retained boundaries，继续拆分会回到 exact-overlay / whitelist 风险。
  - 将 H7 的剩余 active overlay debt 从“待拆分候选”更新为“已知保留边界”。
- 指标结果：
  - `src/aram_overrides.opy exact/diff/unique` 维持 `0/0/0`
  - active overlay 基线维持 `18/109/53`
  - hero-root retained overlays 仍为 `2`（`hazard`、`kiriko`）
  - retained module overlays 仍为 `3`
  - `unwhitelisted exact/diff = 0/0`
- 验证报告：
  - 无新增代码验证；本波为 closure review，沿用 Wave-B 后的 gate 基线。
- 当前 inventory：
  - retained hero overlays: `src/heroes/hazard/aram.opy`、`src/heroes/kiriko/aram.opy`
  - non-target entry file: `src/heroes/aram-init.opy`
  - retained module overlays: `src/modules/bootstrap/aram-10-safety-blacklist-ban.opy`、`src/modules/bootstrap/aram-15-extra-hero-pool.opy`、`src/modules/debug/aram-20-changelog.opy`
  - newly split module assemblies: `src/modules/bootstrap/aram-00-init-and-settings.opy`、`src/modules/bootstrap/aram-20-player-lifecycle-and-reset.opy`

## Next Steps

1. 若继续推进，应新开后续阶段，单独评估是否要调整 whitelist 策略，再决定是否重启 `hazard/kiriko` 或其他 retained overlay 的结构化尝试。
2. 继续只保留仍被主 TODO 引用、或对关键决策回溯仍有价值的 wave 报告。
