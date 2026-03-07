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
| H8 | main/aram shared-leaf convergence | in_progress | 仅使用完整 `.opy` 叶子做 shared merge 或 paired leaves，main/aram 重复规则继续按成对判定收敛 |

## Current Gate Baseline

- 当前 duplicate 基线：
  - `src/aram_overrides.opy exact/diff/unique = 0/0/0`
  - `src/**/aram*.opy active overlays exact/diff/unique = 18/102/53`
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
- 2026-03-07: H8 Wave-A/B 改按 full-file shared leaves only 推进：回收所有 rule 内 snippet-style `#!include`，`debug/changelog` 改成合法完整共享叶子，`bootstrap` 的近重复规则改成 main/aram paired full leaves，`cassidy` 的 falloff 改成完整共享叶子，active overlay diff 从 `109` 降到 `102`。
- 2026-03-07: H8 Wave-C 完成 pair inventory：`src/**/aram-*.opy` 与同目录 main 对文件逐对审计后，未发现新的可直接落地 exact shared 候选；`bootstrap 00/10/20` 与 `heroes/init` 保持 `retain split`，`cassidy falloff` 与 `debug/changelog` 维持已落地的合法 full-file shared 模式。
- 2026-03-07: H8 Wave-D 完成 reports cleanup（baseline-only）：移除已完成且已被 TODO 覆盖的 H4/H5 波次归档，保留 `aram-vs-main-verification.md` 与 `module-metrics-sync-20260302-201115.md` 作为长期关键基线；`exact shared / paired full leaves / retain split` 判定边界不变。
- 2026-03-07: H8 Wave-E 完成 bootstrap join/respawn 收敛（后续被 Wave-I 稳定化策略覆盖）：曾以共享叶子承载 join/respawn；最终按稳定优先改回 main 单文件规则体 + aram paired full leaves，`Team1/Team2` respawn 仍保持 main=`5/10`、aram=`2/5`，行为不变。
- 2026-03-07: H8 Wave-F 完成 ARAM 自定义英雄接入：`anran/domina/emre/mizuki/jetpack_cat` 在 ARAM 侧复用 main `rules.opy` 装配；并在 `aram_protocol.opy` 对齐补齐 `playervar anran_burn_target 111`、`anran_burn_dmg_mod 112` 以消除 `anran` 编译阻塞。基线保持 `0/0/0` 与 `18/102/53`。
- 2026-03-07: H8 Wave-G 完成 `aram-* + *-aram` 全覆盖盘点：当前无新增 straight exact pair；`player-death-reset-main/-aram` 与 `player-reinitialize-main/-aram` 确认为可收敛 near-duplicate；`bootstrap 00/10/20` 与 `heroes/init` 继续保持 `retain split`。
- 2026-03-07: H8 Wave-H 完成 near-duplicate 收敛：`player-death-reset`、`player-reinitialize` 与 `player-hero-switch-reset` 迁移到 shared full leaf + mode wrapper 形态，保留 mode 差量（wait/extra_hero/healing-reset/log）且不改行为顺序。基线保持 `0/0/0` 与 `18/102/53`。
- 2026-03-07: H8 Wave-I 完成 bootstrap lifecycle 稳定化：`20-player-lifecycle-and-reset.opy` 改为 main 侧单文件完整规则体，移除 `20 -> *-main -> shared` 链式 include；ARAM 维持 paired full leaves，删除 main 包装壳与中间 shared 生命周期叶子。`main.opy` 恢复标准 include 路径，`build/build:aram` 通过，基线保持 `0/0/0` 与 `18/102/53`。
- 2026-03-07: H8 Wave-J 完成 de-wrapper 收敛：`aram_overrides` 中 `cassidy` 直接改引 `falloff.opy`，退役 `aram-falloff.opy`；`modules/debug/aram-20-changelog.opy` 退役，避免保留无入口依赖的一跳包装文件。行为不变，基线保持 `0/0/0` 与 `18/102/53`。

## Archived Reports

- 波次报告已清理，关键信息已折叠进 `Condensed Iteration Summary`。
- Baseline-only 保留文档：
  - `docs/reports/aram-vs-main-verification.md`
  - `docs/reports/module-metrics-sync-20260302-201115.md`

## Latest Completed Iteration (H8 Wave-J: De-wrapper Convergence)

- 波次范围：
  - 继续压缩 ARAM 一跳包装链路，退役无语义转发文件
  - `aram_overrides` 直接 include `cassidy/falloff.opy`
  - 退役 `modules/debug/aram-20-changelog.opy`，保留 `20-changelog.opy` 作为单一共享叶子
- 判定结论：
  - `exact shared`（边界不变）：
    - `src/modules/debug/20-changelog.opy`（ARAM 不再经 wrapper 转发）
    - `src/heroes/cassidy/falloff.opy`（ARAM 不再经 wrapper 转发）
  - `near-duplicate converged`（边界不变）：
    - main：`src/modules/bootstrap/20-player-lifecycle-and-reset.opy` 承载 join/respawn、death reset、reinitialize、hero switch 全量规则
    - aram：`player-join-and-respawn-aram.opy`、`player-death-reset-aram.opy`、`player-reinitialize-aram.opy`、`player-hero-switch-reset-aram.opy` 维持 paired full leaves
  - `retain split`（边界不变）：
    - `src/modules/bootstrap/00-init-and-settings.opy` vs `aram-00-init-and-settings.opy`
    - `src/modules/bootstrap/10-safety-blacklist-ban.opy` vs `aram-10-safety-blacklist-ban.opy`
    - `src/modules/bootstrap/20-player-lifecycle-and-reset.opy` vs `aram-20-player-lifecycle-and-reset.opy`
    - `src/heroes/init.opy` vs `aram-init.opy`
- 约束确认：
  - `#!include` 仅用于完整 `.opy` 文件，不在 `rule` 内拼接片段
  - 未触碰 `hazard/kiriko` retained boundary，未调整 whitelist 策略
- 指标结果：
  - `src/aram_overrides.opy exact/diff/unique` 维持 `0/0/0`
  - `src/**/aram*.opy active overlays exact/diff/unique = 18/102/53`
  - active overlay `diff` 相比 H7 基线下降 `7`
  - hero-root retained overlays 仍为 `2`（`hazard`、`kiriko`）
  - `unwhitelisted exact/diff = 0/0`
- 验证报告：
  - `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff --build`
  - `pnpm run build`
  - `pnpm run build:aram`
  - `skills/ow-contract-guard/scripts/check_contracts.sh --strict-hero-init`
  - `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh --check`
  - 当前 inventory：
  - retained hero overlays: `src/heroes/hazard/aram.opy`、`src/heroes/kiriko/aram.opy`
  - near-duplicate stabilized lifecycle: `src/modules/bootstrap/20-player-lifecycle-and-reset.opy` + `src/modules/bootstrap/aram-20-player-lifecycle-and-reset.opy`
  - exact shared candidates landed: `src/heroes/cassidy/falloff.opy`、`src/modules/debug/20-changelog.opy`
  - aram custom heroes reused from main rules: `anran`、`domina`、`emre`、`mizuki`、`jetpack_cat`
  - retained module overlays remain: `src/modules/bootstrap/aram-10-safety-blacklist-ban.opy`、`src/modules/bootstrap/aram-15-extra-hero-pool.opy`
  - retained baseline reports: `docs/reports/aram-vs-main-verification.md`、`docs/reports/module-metrics-sync-20260302-201115.md`

## Next Steps

1. H8 Wave-K：继续扫描 `main/aram` 成对叶子，优先挖掘新的 `exact shared`；near-duplicate 仅在低风险可参数化时继续推进。
2. `hazard/kiriko` 继续保持为 H7 retained boundary，不纳入 H8 shared merge 范围，除非未来另开 whitelist 策略阶段。
3. `check_contracts --strict-hero-init` 当前仍有既有的 `src/main.opy` include mismatch，继续视为 pre-existing gate issue，而不是 H8 新回归。
4. 继续只保留仍被主 TODO 引用、或对关键决策回溯仍有价值的 wave 报告。
