# Overwatch-AI-PVE：Agent 工作入口

> 本文件是本仓库 AI agent 的最小入口。权威规则正文统一放在
> `docs/agents/*.md`，这里负责说明仓库边界、风险入口、规则路由和交付门槛；不要在根文件与权威文档重复维护规则。

## 仓库边界

- 本仓库是 Overwatch Workshop / OverPy 项目，当前维护两个入口：常规赛
  `src/main.opy` 与大乱斗 `src/aramMain.opy`。
- 根目录历史 `main.opy` 不再作为主编辑入口；实现应从对应的 `src/` 入口和模块开始追踪。
- 主要生成产物是 `workshop.ow`；发布构建产物是 `build/main.ow` 与 `build/aram.ow`。
  生成文件不是规则或业务逻辑的权威来源，不要手工编辑或把无关生成差异混入任务提交。
- 高风险边界包括 entry include 顺序、声明所有权与名称唯一性、变量/子程序协议索引、英雄 init/reset 链路，以及高频 AI/英雄规则的服务器负载。
- 开始工作前先确认实际仓库、分支、worktree 与工作区状态；保留用户已有改动，不覆盖、不回退、不跨仓库扩展任务范围。

## 规则组织

- 工程约束统一放在 `docs/agents/`；`docs/agents/rules-index.md` 是规则 ID、触发条件和权威路径的唯一注册表。
- `globalvar` / `playervar` 描述 Workshop 存储作用域，不等于模块所有权；所有权、include 图可达性和声明唯一性以 `docs/agents/variable-ownership.md` 为准，清单见 `docs/agents/variable-ownership-matrix.md`。
- 根 `AGENTS.md` 只保留所有任务通用的入口规则、路由和门槛；模块专属约束必须写入对应的 canonical 文档，并在规则注册表登记。
- 需要共享的专项说明放在 `docs/`，由根文件或 canonical 文档写明触发条件；不要默认读取全部 `docs/agents/*` 或 `docs/modules/*`。
- 新增 canonical 规则前必须先登记 `docs/agents/rules-index.md`；只有整理入口或修正文档路由时，才不需要新增规则 ID。

## 当前规则索引

按任务触发条件读取，先读“读取优先”，只有遇到直接依赖或交付门槛时再读“按需追加”：

| 变更范围 | 读取优先 | 按需追加 |
| --- | --- | --- |
| 任意任务 | `docs/agents/project-scope.md` | `docs/agents/rules-index.md` |
| `globalvar` / `playervar` 所有权或 prelude 迁移 | `docs/agents/variable-ownership.md` | `docs/agents/protocol-constraints.md` |
| `src/main.opy` 或 `src/modules/prelude/*` | `docs/agents/main-contract.md` | `docs/agents/protocol-constraints.md` |
| `src/modules/hero_init/*` | `docs/agents/hero-init-contract.md` | `docs/agents/protocol-constraints.md` |
| `src/modules/hero_rules/*` 或高频 `src/modules/ai/*` | `docs/agents/performance-stability.md` | `docs/agents/protocol-constraints.md` |
| `src/aramMain.opy`、`src/aram_overrides*.opy` 或 `src/heroes/*/shared/*.opy` | `docs/agents/performance-stability.md` | `docs/agents/protocol-constraints.md`、`docs/agents/gates-and-commits.md` |
| 提交前自检 | `docs/agents/self-checklist.md` | `docs/agents/gates-and-commits.md` |
| 门禁执行或提交准备 | `docs/agents/gates-and-commits.md` | `docs/agents/self-checklist.md` |

规则 ID 与 canonical anchor 以 `docs/agents/rules-index.md` 为准；不要根据根文件中的摘要自行推导新规则。

## 最小红线

1. 不要随意重排两个入口的 include 流程。
2. 不要重排或复用已有变量、数组、子程序的协议索引；新增协议项只能追加。
3. 每个声明必须有明确且唯一的模块所有权，并在使用它的 expanded include graph 中可达；跨英雄直接读取私有存储前必须先解决语义接口问题。
4. 不要破坏英雄 dispatcher、init/reset 清理链路，或引入无等待循环和未经评估的高频昂贵操作。
5. 不要绕过适用的 contract、性能、构建、ARAM 重复覆盖或 portability 检查。
6. 不要把 Team 1（AI）与 Team 2（玩家）的职责边界混在一起。
7. 不要为了“整理”而改动与任务无关的生成文件、用户改动或模块结构。

## 通用工作流程

1. 先确认用户目标、仓库边界、当前分支、worktree 和工作区状态。
2. 先读实际源码、测试/工具和相关文档，再根据上面的路由加载必要的 canonical 规则；不要只凭文档猜测现状。
3. 先确定 producer → consumer → 持久化/生成产物链路，再决定实现范围；保持改动窄、可回滚，不添加未被请求的抽象或兼容层。
4. 修改时保护已有脏文件和并发改动，不使用破坏性 Git 命令；生成 `workshop.ow` 仅作为验证产物，除非任务明确要求，否则不要把验证产生的无关差异提交进去。
5. 完成后运行与风险匹配的检查，检查整体 diff、`git diff --check` 和待提交文件清单。
6. 如实区分本地代码/构建证据、浏览器证据、CI 证据、生产证据和远程 Issue/Release 状态；未验证的部分要明确写出。

## 验证与交付

### 常用构建与性能门禁

- 依赖初始化：`pnpm install --frozen-lockfile`
- 日常构建：`pnpm run build`
- 发布构建：`pnpm run build:release`、`pnpm run build:aram`、`pnpm run build:release:all`
- 性能扫描：`pnpm run perf:scan`；高风险收敛时使用 `pnpm run perf:scan:strict`
- 合同检查：`tools/check-contracts.ts`、`tools/check-contracts.ts --build`；英雄 init 变更可追加 `--strict-hero-init`
- ARAM 覆盖检查：`tools/check-aram-overrides-duplicates.ts`、`tools/check-aram-overrides-duplicates.ts --check`
- 对应的 `pnpm run tool:check-contracts` 与 `pnpm run tool:check-aram-overrides-duplicates` wrapper 适合在 package 脚本环境中使用。

### 按任务追加的工具

- 变量所有权迁移：先检查 expanded Main/ARAM include graph、读写/reset/lifecycle 消费者，再运行 duplicate/include-graph、contract、Main/ARAM build 和行为静态检查。
- Ana portability：`pnpm run tool:check-ana-portability`。
- 英雄变更：`tools/hero-pipeline.ts --from-diff`；需要构建或 cooldown 严格检查时追加 `--build`、`--strict-cooldown-placement`，也可使用 `--report-template` 或 `--hero <name>`。对应 wrapper 为 `pnpm run tool:hero-pipeline`。
- changelog 同步：`tools/changelog-sync.ts --from-diff`；提交前覆盖检查可追加 `--strict-coverage --strict-language --strict-settings-sync`，报告模式为 `--report`，也可使用 `--hero <name>`。对应 wrapper 为 `pnpm run tool:changelog-sync`。
- ARAM 候选报告：`tools/check-aram-overrides-duplicates.ts --check --emit-candidates build/reports/aram-delta-whitelist-candidates.tsv`。
- 模块结构：`tools/module-metrics-sync.ts`、`tools/module-metrics-sync.ts --check`、`tools/module-metrics-sync.ts --report`；对应 wrapper 为 `pnpm run tool:module-metrics-sync`。
- 玩家常量可达性：`tools/player-constants-reachability.ts --prefix ANRAN_`；仅在明确要应用修复时才使用 `--apply`，全局清理需显式使用 `--global-cleanup --apply`；对应 wrapper 为 `pnpm run tool:player-constants-reachability`。
- Fandom 英雄数据：`tools/fandom/fetch-heroes.ts --output /tmp/ow_heroes.json --pretty`；详情脚本支持 `--hero "Ana"`、`--url URL`、`--html-file PATH`，批量脚本支持 `--heroes-file PATH`、`--html-dir PATH`。按任务需要读取并限制生成范围。
- Balance note：使用 `docs/workflows/ow-balance-notes-writer.md`，除非用户另有要求，输出保持中文。

### 建议门禁顺序

1. `pnpm run tool:check-ana-portability`（涉及 Ana portability 时）
2. `tools/hero-pipeline.ts --from-diff`（涉及英雄时）
3. `tools/check-contracts.ts --build`
4. `pnpm run perf:scan`
5. `pnpm run build`
6. 依据 ARAM、发布、变量所有权或 changelog 影响追加对应检查。

文档-only 改动至少检查路径和命令引用、`git diff --check` 与整体 diff；不要为了文档改动运行与风险无关的完整发布流程。

### Release 语义

- 版本源：`src/version.opy`；版本格式：`YY.MMDD.N`。
- Release 触发：push 到 `main`；流程自动运行 `pnpm run tool:bump-version`，构建 `build/main.ow` 与 `build/aram.ow`，打 tag 并发布 GitHub Release。
- Release 新鲜度：工作流会跳过不是当前 `origin/main` head 的过期运行。
- Release 跳过：在 `main` 提交消息中包含 `[skip release]`。
- 版本工具：`pnpm run tool:bump-version`。

## Git 与提交

- 遵循仓库已有分支/worktree 工作流；已有隔离环境时直接复用，不嵌套创建或擅自搬动工作区。
- 实现性改动默认提交已验证的任务文件；使用 Conventional Commits，小步提交，跨分区改动优先拆成可回滚提交。
- 只 stage 当前任务拥有的文件或 hunks。提交前检查 staged diff、`git diff --check`，排除凭证、私有标识、运行日志、截图和无关生成物。
- 若任务带 GitHub Issue，编辑前先读取对应仓库的 live Issue；准备 stage/commit 前再次核对仓库和 Issue 编号。只有实际完成 Issue 才使用 `Fixes #N`/`Closes #N`，关联或部分完成使用 `Refs #N`/`Related to #N`。
- 本地 commit 不等于远程 Issue 已关闭或 Release 已完成；除非用户明确要求，不 push、amend、rebase 或改写历史。
- 玩法改动的提交说明应标注影响英雄/系统、负载影响，以及是否调整 init/reset 链路；详细规则见 `docs/agents/gates-and-commits.md`。

## 绝对安全底线

- 用户凭证、令牌、授权文件和密钥不得写入仓库或任何可能被 Git 跟踪的路径。
- 未经用户明确授权，不删除数据、覆盖改动、推送、发布、合并或执行其他难以恢复的外部写操作。
- 不使用 `git reset --hard`、`git checkout --`、`git clean` 或永久删除命令来处理工作区；不确定目标或范围时先停下核对。
- 发现任务会触及协议索引、Release、用户数据、外部 Issue 状态或生成产物边界时，先核对对应 canonical 规则，并在报告中分开说明证据和剩余风险。
