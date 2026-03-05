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
| H1 | heroes 单入口切换 | in_progress | `main/aramMain` 均通过 `heroes/init.<mode>.opy` 装配英雄段 |
| H2 | 工具链路径迁移 | in_progress | `check_contracts`/`hero_pipeline`/`changelog_sync` 识别 `src/heroes/**` |
| H3 | 白名单/重复检查迁移 | in_progress | `aram-delta-whitelist.tsv` 与 duplicates 输出路径切到 `src/heroes/**` |
| H4 | ARAM overlay 按英雄迁移 | todo | `aram_overrides` 差异逐英雄落到 `src/heroes/<hero>/aram.opy` 或同级叶子 |
| H5 | `aram_overrides` 薄层化与分段机制退役 | todo | `aram_overrides_segments` 不再参与编译，剩余项均为跨英雄模式差异 |

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

## Next Steps

1. H4：按英雄把 `aram_overrides` 差异迁入 `src/heroes/<hero>/aram.opy`（迁移即白名单收口）。
2. H4：把 `src/heroes/init.opy` 从薄层扩展为稳定共享基线（不改变玩法语义）。
3. H5：当 `aram_overrides` 仅剩跨英雄模式逻辑后，退役 `aram_overrides_segments`。
