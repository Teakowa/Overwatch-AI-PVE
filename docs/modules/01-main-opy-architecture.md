# 01. `src/main.opy` 代码逻辑总览

本文档只负责回答两个问题：主入口如何组织当前代码，以及阅读源码时先看哪里。硬约束与提交门禁统一以 `docs/agents/*` 为准。

## 规范来源

- 入口顺序、分隔规则与 `#!mainFile` 相关约束：`docs/agents/main-contract.md`
- 协议、索引与命名约束：`docs/agents/protocol-constraints.md`
- Hero Init 约束：`docs/agents/hero-init-contract.md`
- 性能与 Anti Crash 约束：`docs/agents/performance-stability.md`

## 1. 当前入口角色

- 主入口：`src/main.opy`
- 角色：扁平 manifest，显式列出常量、prelude、bootstrap、utilities、AI 与 hero surface
- 顺序源：`src/modules/*/_index.opy` 仍保留给维护与校验使用，但不是主入口直接 include 的执行面

## 2. 入口阅读路径

阅读 `src/main.opy` 时，可按下面的心智顺序理解：

1. `utilities/macros.opy` 与 `constants/player_constants.opy`
2. `modules/prelude/*.opy`
3. `modules/bootstrap/*` 与 `main_mode_profile.opy`
4. `utilities/*`
5. `modules/ai/*`
6. `heroes/main.opy`

这条路径描述的是“先看哪里”，不是额外规则定义；真实硬约束请直接查看 canonical agent docs。

## 3. 运行链路

### 3.1 Bootstrap

- 负责模式与设置初始化、稳定性保护、准入控制，以及玩家生命周期入口
- `main_mode_profile.opy` 放在 bootstrap 后段，承接主模式专属 profile 配置

### 3.2 Utilities

- 放共享子程序与状态清理工具
- `resetHero()`、`resetStats()`、`resetStatuses()`、`resetFrenemies()` 与自定义生命值工具都在这里组成复位工具链

### 3.3 AI

- `modules/ai/` 按 `core`、`movement`、`control` 分层
- 负责目标选择、移动、视角与技能控制

### 3.4 Hero Surface

- `heroes/main.opy` 是当前英雄玩法与初始化的聚合入口
- 该层继续分发到 hero rules、hero init 与共享英雄片段；阅读英雄逻辑时优先从这里下钻

## 4. 阅读建议

- 想看入口编排：先读 `src/main.opy`，再看 `docs/agents/main-contract.md`
- 想看 reset / hero init 协作：先读 bootstrap 和 utilities，再看 `docs/agents/hero-init-contract.md`
- 想看玩法改动：从 `heroes/main.opy` 进入对应英雄目录
- 想看文件分布：配合 `appendix-src-file-index.md` 使用
