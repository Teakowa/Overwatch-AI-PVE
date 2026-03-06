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
| H5 | `aram_overrides` 薄层化与分段机制退役 | in_progress | `aram_overrides_segments` 不再参与编译，剩余项均为跨英雄模式差异 |

## Current Iteration (H1/H2/H3 Cutover)

- 目录迁移：
  - `src/modules/hero_rules/heroes/*.opy` -> `src/heroes/<hero>/rules.opy`
  - `src/modules/hero_init/heroes/*.opy` -> `src/heroes/<hero>/init.opy`
  - 相关 extras/shared 叶子同步迁移到对应英雄目录
- 入口改造：
  - `src/main.opy` -> `#!include "heroes/init.main.opy"`
  - `src/aramMain.opy` -> `#!include "heroes/init.aram.opy"`
- 工具链迁移：
  - `skills/ow-contract-guard/scripts/check_contracts.sh`
  - `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh`
  - `skills/ow-changelog-sync/scripts/changelog_sync.sh`
  - 已改为以 `src/heroes/*/init.opy` 与 `src/heroes/<hero>/*.opy` 为识别源
- 白名单与元数据迁移：
  - `skills/ow-contract-guard/references/aram-delta-whitelist.tsv` 的 `source_module` 已迁到 `src/heroes/**`
  - `src/aram_overrides_segments/manifest.tsv` 的 `source_modules` 已迁到 `heroes/**`
- 验证报告：
  - `docs/reports/aram-shared-wave-hero-first-cutover-2026-03-06.md`

## Baseline Gate Target (Structure Wave)

- 结构切换波要求保持：
  - duplicate baseline 稳定（当前目标：`exact=53`, `diff=148`）
  - `unwhitelisted exact/diff = 0/0`
- 本波门禁：
  1. `pnpm run build`
  2. `pnpm run build:aram`
  3. `skills/ow-contract-guard/scripts/check_contracts.sh --build`
  4. `skills/ow-contract-guard/scripts/check_contracts.sh --strict-hero-init`
  5. `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff --build`
  6. `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh --check --emit-candidates build/reports/aram-delta-whitelist-candidates.tsv`

## Current Iteration (H4 Wave-1: hero_init Detect Pilot)

- 波次范围：6 英雄 Detect exact 清理（`reaper/tracer/mercy/hanzo/freja/torbjorn`）。
- 变更动作：
  - 每个试点英雄新增 `src/heroes/<hero>/init-detect.opy`，仅承载 Detect 规则。
  - `src/heroes/<hero>/init.opy` 改为 include `init-detect.opy`，Initialize 本体不变。
  - `src/aram_overrides.opy` 原位替换 6 条 Detect exact 为 `#!include "heroes/<hero>/init-detect.opy"`，保持顺序不变。
  - 白名单删除 6 条 Detect `rule_exact_duplicate`。
- 工具链兼容：
  - `check_contracts.sh` 与 `hero_pipeline.sh` 支持 `init.opy + init-detect.opy` 组合判定 detect/initialize 契约。
  - `check_aram_overrides_duplicates.sh` 增加 6 英雄 `src/heroes/<hero>/aram*.opy` pilot overlay 门禁通道。
- 指标结果：
  - `exact: 53 -> 47`
  - `diff: 148 -> 148`
  - `unwhitelisted exact/diff: 0/0`
  - `candidates: 0`
- 验证报告：
  - `docs/reports/aram-shared-wave-h4-init-detect-pilot-2026-03-06.md`

## Iteration Log

- 2026-03-06: 完成 H5 Wave-N（cross-hero exact cleanup + legacy directory retirement）。`aram_cross_hero_overrides.opy` 下线，4 组 cross-hero exact 回收到 hero-owned shared leaves；`src/aram_overrides_segments/` 整体删除。
- 2026-03-06: 完成 H5 Prep（segment compile dependency retirement）。`aram_overrides` 不再直接 include `aram_overrides_segments/*`；单英雄 segment 归位到 `src/heroes/<hero>/aram.opy`，跨英雄残留收束到 `src/aram_cross_hero_overrides.opy`。
- 2026-03-06: 完成 H4 Wave-1（6 英雄 Detect 先行）。门禁全绿，行为保持“仅抽取、不改逻辑”。后续进入 H4 下一波，继续收敛 Initialize same-name-diff 与 overlay 归位。
- 2026-03-06: 完成 H4 Wave-2（全量 Initialize 向 Main 收敛 + custom_hp helper 下线）。ARAM hero_init 改为统一 include `src/heroes/*/init.opy`，`aram_overrides` 不再承载 Detect/Initialize 规则体与 custom_hp 依赖。
- 2026-03-06: 完成 H4 Wave-3（Hero Overlay First 清理 10 条 hero exact）。规则源统一迁入 `src/heroes/<hero>/shared/*.opy`，ARAM 通过 `src/heroes/<hero>/aram.opy` 复用；duplicates 门禁 overlay 扫描扩展到 `src/heroes/*/aram*.opy` 全量。

## Current Iteration (H5 Prep: Segment Compile Dependency Retirement)

- 波次范围：
  - 清理最后 1 条 bootstrap `rule_exact_duplicate`
  - 回收 12 个 single-hero segment 到 `src/heroes/<hero>/aram.opy`
  - 将 4 组 multi-hero 残留差异收束到 `src/aram_cross_hero_overrides.opy`
- 变更动作：
  - 新增 `src/modules/bootstrap/shared/10-setup-var-when-player-joins-lobby.opy`，Main/ARAM 共享 lobby reset 初始化规则。
  - `src/aram_overrides.opy` 不再 include `aram_overrides_segments/*`；single-hero 段切到 `heroes/<hero>/aram.opy`，cross-hero 段切到 `aram_cross_hero_overrides.opy`。
  - `src/heroes/{mercy,ana,brigitte,kiriko,zenyatta,reinhardt,hazard,reaper,wuyang,widowmaker}/aram.opy` 从空壳或薄层扩展为该英雄 ARAM 差异归属层。
  - `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh` 改为检查 `src/heroes/*/aram*.opy` 与 `src/aram_cross_hero_overrides.opy`，`manifest.tsv` 仅保留历史记录语义。
  - 白名单删除最后 1 条 bootstrap `rule_exact_duplicate`。
- 指标目标：
  - `exact: 1 -> 0`
  - `unwhitelisted exact/diff: 0/0`
  - `rg '#!include "aram_overrides_segments/' src` 返回空
- 验证报告：
  - `docs/reports/aram-shared-wave-h5-segment-retirement-prep-2026-03-06.md`

## Current Iteration (H5 Wave-N: Cross-Hero Exact Cleanup + Legacy Directory Retirement)

- 波次范围：
  - 清理 `src/aram_cross_hero_overrides.opy` 中 4 组 cross-hero exact（10 条规则）
  - 退役 `src/aram_overrides_segments/` 历史目录
- 变更动作：
  - 为 `genji/tracer/ramattra/wrecking_ball/sombra/zarya` 新增 `shared/*.opy` 叶子，作为 cross-hero exact 的事实来源。
  - Main 侧 `rules*.opy` 改为 include 对应 shared 叶子，保持主线规则顺序不变。
  - `src/aram_overrides.opy` 在原 cross-hero include 位置改为逐条 include hero-owned shared 叶子，保持 ARAM 规则顺序不变。
  - 删除 `src/aram_cross_hero_overrides.opy`。
  - 删除 `src/aram_overrides_segments/` 目录及 `manifest.tsv`。
  - `check_aram_overrides_duplicates.sh` 不再读取 cross-hero transitional file 或 manifest，改为仅检查活跃装配面与退休引用残留。
  - 白名单删除 10 条原 cross-hero exact `rule_exact_duplicate`。
- 指标目标：
  - `src/aram_overrides.opy exact = 0`
  - `unwhitelisted exact/diff = 0/0`
  - `rg 'aram_cross_hero_overrides|aram_overrides_segments' src` 返回空
- 验证报告：
  - `docs/reports/aram-shared-wave-h5-cross-hero-retirement-2026-03-06.md`

## Current Iteration (H4 Wave-2: Full Initialize Convergence)

- 变更动作：
  - `src/aram_overrides.opy` 的 hero_init 段改为 Main 顺序 `#!include "heroes/<hero>/init.opy"`（每英雄一次）。
  - 删除 ARAM 内联 Detect/Initialize 规则体；删除 `def clearCustomHp()/def applyCustomHp()` 覆盖实现。
  - Ramattra 4 条原 `custom_hp_pvar[0] + 50` 条件改为 `getMaxHealthOfType(Health.NORMAL) + 50` 推导。
  - `src/aramMain.opy` 增加 `utilities/apply_custom_hp.opy` 与 `utilities/clear_custom_hp.opy` include，复用主线 utilities。
  - `src/aram_protocol.opy` 追加 `BotHeroArray` 声明以兼容 Main `ana/init.opy` 依赖。
  - 白名单删除全部 `source_module=src/heroes/*/init.opy` 旧项。
- 指标结果：
  - `total: 164`
  - `exact: 11`
  - `diff: 106`
  - `unique: 47`
  - `unwhitelisted exact/diff: 0/0`
  - `candidates: 0`
- 验证报告：
  - `docs/reports/aram-shared-wave-h4-init-full-convergence-2026-03-06.md`

## Current Iteration (H4 Wave-3: Hero Overlay First Exact Cleanup)

- 波次范围：清理 10 条 hero `rule_exact_duplicate`（`doomfist/hazard/juno/mauga/orisa/sigma/kiriko/wuyang`）。
- 变更动作：
  - 新增 10 个共享叶子：`src/heroes/<hero>/shared/*.opy`，承载本波 exact 规则本体。
  - `src/heroes/<hero>/rules.opy` 原位改为 include shared 叶子，保持 Main 顺序不变。
  - `src/heroes/<hero>/aram.opy` 从空壳切换为 include 对应 shared 叶子。
  - `src/aram_overrides.opy` 用 `#!include "heroes/<hero>/aram.opy"` 替换 7 条单英雄 exact；Wuyang 采用单点 include 并删除 3 条内联 exact。
  - 白名单删除 10 条已迁移 `rule_exact_duplicate`，仅保留 bootstrap exact（`[utilities/reset]: setup var when player joins lobby`）。
  - `check_aram_overrides_duplicates.sh` 将 overlay 门禁范围从 6 英雄 pilot 扩展到 `src/heroes/*/aram*.opy` 全量。
- 指标结果：
  - `total: 154`
  - `exact: 1`
  - `diff: 106`
  - `unique: 47`
  - `unwhitelisted exact/diff: 0/0`
  - `candidates: 0`
- 验证报告：
  - `docs/reports/aram-shared-wave-h4-hero-exact-overlay-2026-03-06.md`

## Next Steps

1. H5：继续收敛 `src/aram_overrides.opy` 中剩余的 `same_name_diff`，优先 `ramattra/wrecking_ball/sombra/tracer/zarya` 相关模式差异。
2. H5：评估 hero-owned shared leaves 中哪些 cross-mode exact 已足够稳定，可进一步合并到更贴近主线的共享布局。
3. H6：在 `same_name_diff` 继续下降后，进一步薄层化 `src/aram_overrides.opy`。
