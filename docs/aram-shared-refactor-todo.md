# ARAM/Main Shared Refactor TODO

本文档用于持续跟踪 `src/main.opy` 与 `src/aramMain.opy` 的共用模块拆分进度。

## Scope & Invariants

- 目标：等价重构，不主动调整玩法数值和平衡。
- 保持 `aramMain` 编排顺序：`settings -> protocol -> optimize/postHook -> shared -> overrides`。
- 不改动 `globalvar/playervar/subroutine` 现有索引协议。
- 不在 `src/modules/*` 新建 ARAM 专用模块文件。

## Baseline

- 入口文件：
  - `src/main.opy`
  - `src/aramMain.opy`
- ARAM 差异核心：
  - `src/aram_settings.opy`
  - `src/aram_protocol.opy`
  - `src/aram_overrides.opy`
- 历史验证基线：
  - `docs/reports/aram-vs-main-verification.md`

## Tracking Board

| ID | Task | Baseline | Target | Status | Exit Criteria |
|---|---|---|---|---|---|
| T0 | 基线冻结与报告对齐 | 已有 `aram-vs-main-verification` | 增加最新增量记录 | done | 行数、共享清单、验收结果可追溯 |
| T1 | 维护已共享白名单 | `aram_shared_index` 共 9 项 | 持续维护 | done | 共享 include 与报告一致 |
| T2 | 抽取 3 个完全一致 utilities | 0/3 | 3/3 | done | 使用主线 utility include，ARAM 不再重复定义 |
| T3 | reset 工具链参数化 | 0/5 | 5/5 | done | `reset*` 差异改为参数/开关，不再双份复制 |
| T4 | bootstrap 数据/逻辑分离 | 未开始 | 完成 | todo | 黑名单/模式配置与规则骨架分离 |
| T5 | AI 常量收敛（不改行为） | 未开始 | 首批完成 | todo | 统一等待/阈值常量，降低 body 差异 |
| T6 | hero_init 共用扩展 | 仅分隔符与少量文件共享 | 扩大共享项 | todo | 新增共享项并通过 strict hero init 契约 |
| T7 | hero_rules 共用扩展 | 当前共享 5 个英雄规则文件 | 逐英雄扩展 | todo | 每次扩展都通过等价验证 |
| T8 | ARAM 共用化门禁脚本 | 部分已有 | 完成 | todo | 一键输出“候选共享项 + 风险” |
| T9 | 文档收口 | 未开始 | 完成 | todo | 报告/TODO/模块文档一致 |

## Current Iteration (T2/T3)

- 新增 `src/aram_shared_utilities.opy`，集中引入：
  - `utilities/bot_aim2target.opy`
  - `utilities/enable_all_abilities.opy`
  - `utilities/reset_frenemies.opy`
- `src/aramMain.opy` 新增该入口 include（位于 `aram_shared_index` 与 `aram_overrides` 之间）。
- `src/aram_overrides.opy` 删除 3 个重复 `def`：
  - `botAim2Target`
  - `enableAllAbilities`
  - `resetFrenemies`
- T3 增量：reset 工具链改为“共享骨架 + 模式参数宏”：
  - ARAM 宏定义放在 `src/aram_protocol.opy`
  - Main 默认宏定义放在 `src/modules/bootstrap/20-player-lifecycle-and-reset.opy`
  - `aram_overrides` 删除 5 个重复 reset 相关 `def`，改用主线 utilities include

## Iteration Log

- 2026-03-05: 完成 T2（3/3 utilities 提取），并通过 `build/build:aram/contract-guard` 验证。
- 2026-03-05: 完成 T3（5/5 reset 工具链参数化），并通过 `build/build:aram/contract-guard` 验证。

## Verification Checklist

1. `pnpm run build`
2. `pnpm run build:aram`
3. `skills/ow-contract-guard/scripts/check_contracts.sh --build`
4. 必要时：`skills/ow-contract-guard/scripts/check_contracts.sh --strict-hero-init`
5. ARAM 改造前后 rule-block multiset 等价（后续扩展阶段执行）
