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

## Iteration Log

- 2026-03-06: 完成 H6 Wave-F（closure review for retained overlays, no extra reports）。复核 `hazard/kiriko` 的 hero-local 保留项与 `src/modules/**/aram-*.opy` 的 active overlay 边界；结论是剩余规则均属于明确的 mode-only 或 exact-overlay 保留项，H6 退出条件满足，正式标记完成。
- 2026-03-06: 完成 H6 Wave-E（mode-only residual assembly cleanup, no extra reports）。继续处理 `genji/junkrat/moira/sombra/vendetta/venture/widowmaker/wrecking_ball`，把仍停留在 `aram.opy` 的 mode-only 规则下沉到同级语义叶子；`kiriko` 的 payload bot 规则尝试拆分后会新增 hero overlay exact duplicate，因此和 `hazard` 一样保留在 `aram.opy` 原位。
- 2026-03-06: 完成 H6 Wave-D（residual hero overlay cleanup, no extra reports）。继续处理 `ashe/baptiste/bastion/illari/lifeweaver/mei/sojourn/torbjorn/winston` 的低密度 residual `aram.opy`，将其收成纯 assembly 并补齐语义叶子；`hazard` 的 `Violent Leap` 套件在尝试拆分后会新增 hero overlay exact duplicate，因此按评估结果保留原位、不强拆。
- 2026-03-06: 完成 H6 Wave-C（tank/fighter suite consolidation, no extra reports）。处理 `mauga/doomfist` 的剩余 `aram.opy` 内联套件，并复核 `ramattra` 当前 suite 边界；`ramattra` 因 `pain-endures/ult/block` 在 assembly 中并非连续段，暂维持现状并标记为已评估保留。
- 2026-03-06: 完成 H6 Wave-B（mid/high-density overlay normalization, no extra reports）。处理 `freja/ana/brigitte`，把仍堆在 `aram.opy` 里的 ARAM 规则按技能/效果语义拆到同级叶子；优先复用已有套件边界，不改规则体。
- 2026-03-06: 完成 H6 Wave-A（highest-density hero overlay split, no extra reports）。先处理 `reaper/wuyang/soldier76/roadhog`，把大块 `aram.opy` 规则按技能/套件语义拆回同级 `aram-*.opy` 叶子；本波只做结构拆分，不改规则体。
- 2026-03-06: 完成 H6 Wave-10（remaining hero leaf naming cleanup, no extra reports）。收掉剩余 `wrecking_ball/sombra/kiriko/widowmaker/wuyang` 数字前缀叶子；至此 `src/heroes/**` 中历史遗留、但不承担排序职责的数字前缀 hero 叶子已全部改为语义命名。
- 2026-03-06: 完成 H6 Wave-9（hazard/doomfist/mercy naming cleanup, no extra reports）。继续把 `hazard/doomfist/mercy` 的 ARAM 拆分文件改成纯语义命名，并将这 3 个英雄仍由 Main/ARAM 复用的技能文件一并去掉数字前缀；仅对齐 include 引用，不改规则体。
- 2026-03-06: 完成 H6 Wave-8（aram-only offense naming cleanup, no extra reports）。继续把 `ashe/junkrat/moira/roadhog/soldier76` 的 ARAM-only 拆分文件改成纯语义命名；本波仅改 `src/aram_overrides.opy` 的装配引用，不触碰 Main 侧规则。
- 2026-03-06: 完成 H6 Wave-7（control/support naming cleanup, no extra reports）。继续把 `orisa/sigma/zarya/zenyatta` 的 ARAM 拆分文件改成纯语义命名，并将这 4 个英雄仍由 Main/ARAM 共用的技能文件一并去掉数字前缀；仅对齐 include 引用，不改装配顺序。
- 2026-03-06: 完成 H6 Wave-2（hero-owned exact cleanup without hero `shared/` dirs, no extra reports）。将 `src/heroes/**/shared/*.opy` 全部回卷到英雄根目录的同级技能/特效拆分文件，并完成 `mercy/zenyatta/reinhardt/widowmaker` 10 条 hero-local exact overlay 的双侧复用与 whitelist 收缩。
- 2026-03-06: 完成 H6 Wave-3（naming cleanup start, no extra reports）。开始把 ARAM 拆分文件改成纯语义命名，避免用数字前缀表达加载顺序；本波先处理 `ana` 的 3 个 ARAM 拆分文件与 `freja` 的 `Revdraw Crossbow Stack` 文件，并同步修正文档用语。
- 2026-03-06: 完成 H6 Wave-4（support naming cleanup, no extra reports）。继续把 `brigitte/kiriko/juno` 的 ARAM 拆分文件改成纯语义命名，并将 `juno` 复用的轨道射线跟踪文件一并改名为语义文件名。
- 2026-03-06: 完成 H6 Wave-5（offense naming cleanup, no extra reports）。继续把 `cassidy/genji/tracer` 的 ARAM 拆分文件与复用技能文件改成纯语义命名，不改装配顺序。
- 2026-03-06: 完成 H6 Wave-6（tank naming cleanup, no extra reports）。继续把 `mauga/ramattra/reinhardt` 的 ARAM 拆分文件与复用技能文件改成纯语义命名，并同步对齐英雄目录内的 include。
- 2026-03-06: 完成 H6 Wave-1（pure assembly cutover, no extra reports）。将 `src/aram_overrides.opy` 中剩余 bootstrap/player helper、hero-local ARAM-only 规则、hero init delimiter 与本地 `def` 全部迁回 `src/modules/**/aram-*.opy`、`src/heroes/**/aram-*.opy`、`src/utilities/*.opy`，并把 `src/aram_overrides.opy` 清成纯 `#!include` 装配层；本波不新增 report。
- 2026-03-06: 完成 H5 Wave-N+8（system/bootstrap overlay extraction, no extra reports）。将 `init/settings`、`player ban/allowed heroes`、`player lifecycle/reset` 与 `changelog` 的 ARAM mode diff 从 `src/aram_overrides.opy` 抽到 `src/modules/**/aram-*.opy`，并扩展 duplicates 门禁扫描到活跃模块 overlays。H5 达成收口。
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
- 2026-03-06: 完成 H4 Wave-3（Hero Overlay First 清理 10 条 hero exact）。规则源统一迁入 `src/heroes/<hero>/*.opy`，ARAM 通过 `src/heroes/<hero>/aram.opy` 复用；duplicates 门禁 overlay 扫描扩展到 `src/heroes/*/aram*.opy` 全量。

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

## Latest Completed Iteration (H6 Wave-F: Closure Review For Retained Overlays)

- 波次范围：
  - 复核 `hazard/kiriko` 的 hero-local retained overlays
  - 复核 `src/modules/bootstrap/*.opy` 与 `src/modules/debug/aram-20-changelog.opy` 的 active overlay 边界
  - 确认 H6 exit criteria 是否已经满足
  - 本波不新增 report，仅更新主 TODO
- 变更动作：
  - 确认 `hazard` 的 `Violent Leap` 与 `kiriko` 的 payload bot 规则继续保留在 `aram.opy` 原位；原因都是与 `rules.opy` 存在 exact overlay 关系，继续强拆只会制造新的 whitelist debt。
  - 确认 `src/modules/bootstrap/aram-00/10/15/20` 与 `src/modules/debug/aram-20-changelog.opy` 承担的是模式入口、玩家池、生命周期与 changelog 这类 module-owned mode-only 行为，不属于继续 hero-local 细拆的目标。
  - 依据当前基线与 retained-overlay 评估结果，将 H6 从 `in_progress` 收口为 `done`。
- 指标结果：
  - `src/aram_overrides.opy exact/diff/unique` 维持 `0/0/0`
  - active overlay 基线维持 `18/109/53`
  - `exact = 0`
  - `unwhitelisted exact/diff = 0/0`
- 验证报告：
  - 无；本波结果直接记入本 TODO。

## Next Steps

1. 后续若继续推进，应新开下一阶段，专门处理 `src/**/aram*.opy` 中仍保留的 active overlay diff，而不是再把它们归入 H6。
2. `hazard/kiriko` 这两组 retained overlays 可以视作当前已确认的保留边界；若未来要继续拆分，应连同 whitelist 策略一起设计，不建议在 H6 范围内继续尝试。
3. `src/modules/**/aram-*.opy` 当前维持 module-owned mode-only 设计，后续只在明确需要跨模块再归档或再分层时再动。
4. overlay 结构已基本稳定，下一步更适合统一清理 `docs/reports/` 的历史归档密度与 TODO 文案，或开启新阶段的 overlay debt reduction 计划。
