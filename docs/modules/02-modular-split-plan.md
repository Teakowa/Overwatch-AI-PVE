# 02. `src/main.opy` 模块化拆分方案（已落地）

本文档记录本仓库从单文件到多文件编排的拆分方案与实施结果。

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
  modules/
    prelude/
    bootstrap/
    ai/
    hero_rules/
    hero_init/
    debug/
```

## 3. 入口编排顺序（`src/main.opy`）

1. `modules/prelude/00-settings.opy`
2. `modules/prelude/01-global-vars.opy`
3. `modules/prelude/02-player-vars.opy`
4. `modules/prelude/03-subroutine-names.opy`
5. `#!optimizeStrict`
6. `modules/bootstrap/_index.opy`
7. `modules/ai/_index.opy`
8. `modules/hero_rules/_index.opy`
9. `modules/hero_init/_index.opy`
10. `modules/debug/_index.opy`

所有 `_index.opy` 使用显式 include；不使用目录通配 include。

## 4. 迁移策略（顺序）

1. 拆 `debug` 区（低风险验证 include）
2. 拆 `hero_init` 区（Detect/Initialize 对）
3. 拆 `hero_rules` 区（按连续区段分组）
4. 拆 `ai` 区（保留 AI delimiter）
5. 拆 `bootstrap + prelude`
6. 文档收口

## 5. 验收门禁

- 规则总数维持 `361`
- 变量/子程序索引协议不变
- `@Disabled` 规则不丢失
- 编译可通过：`pnpm run build`
- 发行构建可通过：`pnpm run build:release`

## 6. 注意事项

- `hero_rules` 当前按连续片段拆分，文件名用于可读性分组，不代表“该英雄全部规则都只在单文件”。
- 需要改规则执行顺序时必须评估回归风险，默认不重排。
