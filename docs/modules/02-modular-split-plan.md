# 02. `src/main.opy` 模块化拆分方案（已落地）

本文档记录本仓库从单文件到多文件编排的拆分方案与实施结果，并作为当前编排方式的补充说明。

> 注（2026-03）：主入口已进一步演进为“扁平 include manifest”。本页保留模块化拆分历史，并补充当前入口状态说明。

## 1. 目标

- 保持玩法逻辑不变（零玩法改动）
- 将 `src/main.opy` 改为清单入口（manifest）
- 使用 OverPy `#!include` 进行显式顺序编排
- 保持以下硬约束：
  - 顶层顺序：`settings -> globalvar -> playervar -> subroutine -> #!optimizeStrict -> rules`
  - 分隔规则保留：
    - `Initialize AI Scripts`
    - `Initialize AI Scripts End`
    - `Initialize Heroes`
    - `Initialize Heors End`

## 2. 当前目录结构

```text
src/
  main.opy
  constants/
    player_constants.opy
  modules/
    _index.opy
    prelude/
      _index.opy
    bootstrap/
    ai/
      core/
      movement/
      control/
    hero_rules/
    hero_init/
    debug/
```

## 3. 入口编排顺序（`src/main.opy`）

当前执行入口采用扁平清单：

1. `constants/player_constants.opy`
2. `modules/prelude/00-settings.opy -> 01-global-vars.opy -> 02-player-vars.opy -> 03-subroutine-names.opy`
3. `#!optimizeStrict`
4. `modules/bootstrap/* -> utilities/* -> modules/ai/* -> modules/hero_rules/* -> modules/hero_init/* -> modules/debug/*`（显式列举）

`src/main.opy` 不直接 include `*_index.opy`；`_index.opy` 保留为顺序源与维护入口，不使用目录通配 include。

## 3.1 Bastion 风格对齐（分层聚合）

对齐 `Teakowa/Bastion` 的“入口清单 + 业务分域”风格后，本仓库采用分层 `_index`：

- `src/main.opy` 只保留最顶层编排
- `src/modules/_index.opy` 聚合玩法域模块
- `src/modules/ai/` 下进一步细分 `core` / `movement` / `control`
- `src/modules/hero_rules/heroes/_index.opy` 聚合英雄行为改动规则

## 4. 迁移策略（顺序）

1. 拆 `debug` 区（低风险验证 include）
2. 拆 `hero_init` 区（Detect/Initialize 对）
3. 拆 `hero_rules` 区（按连续区段分组）
4. 拆 `ai` 区（保留 AI delimiter）
5. 拆 `bootstrap + prelude`
6. 文档收口

## 5. 验收门禁

- 规则总数维持 `383`
- 变量/子程序索引协议不变
- `@Disabled` 规则不丢失
- `src/main.opy` 维持 `constants -> prelude 四文件 -> optimizeStrict -> 模块区扁平 include` 顺序
- 编译可通过：`pnpm run build`
- 发行构建可通过：`pnpm run build:release`

## 6. 注意事项

- `hero_rules` 当前按连续片段拆分，文件名用于可读性分组，不代表“该英雄全部规则都只在单文件”。
- 需要改规则执行顺序时必须评估回归风险，默认不重排。
