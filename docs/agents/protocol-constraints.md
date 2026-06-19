# Protocol Constraints (Canonical)

### R-PROTO-INDEX-IMMUTABLE

- 统一变量与公共子程序的声明顺序是协议：禁止在 `global-vars.opy`、`player-vars.opy`、`subroutine.opy` 中插队重排。
- 这条协议只约束共享 prelude 面；英雄私有变量不必继续挤在 prelude 中。

### R-PROTO-APPEND-NO-REORDER

- 改动策略：优先追加，避免重排统一变量协议与公共子程序协议。

### R-PROTO-KEEP-DELIMITER-NAMES

- 保留关键分隔规则名：`Initialize AI Scripts`、`Initialize AI Scripts End`、`Initialize Heroes`、`Initialize Heors End`（拼写保持现状）。

### R-PROTO-KEEP-DISABLED

- 不随意移除 `@Disabled` 规则。

### R-PROTO-RULE-NAME-STYLE

- 规则命名保持现有风格（`[module]: action`）。

### R-PROTO-REPO-WIDE-MAINFILE

- 被 `src/main.opy` 或 `src/aramMain.opy` include 到的非入口 `.opy` 模块，必须声明且只声明一次 `#!mainFile`，并放在文件第一行。
- 仅被 ARAM 入口引用的模块指向 `aramMain.opy`；其余模块统一指向 `main.opy`，包括同时被两个入口复用的共享模块。

### 公共/模式侧边界

- 只有跨模式共享的子程序进入 `src/modules/prelude/subroutine.opy`。
- 模式独占子程序与 `setThirdPerson` 这类 ARAM 自留实现，不要求进入统一协议。
- 只有跨英雄或跨基础设施共享的 `globalvar` / `playervar` 才留在 `src/modules/prelude/*.opy`。
- 英雄私有变量允许下沉到模式局部文件，但声明文件仍受仓库级 `#!mainFile` 约束，且不能在同一入口的 include 闭包里重复声明同名变量。

### R-PROTO-SETTINGS-FIRST

- 英雄通用数值优先放 `settings`；仅在依赖前置条件时使用 `rule`。

### R-PROTO-NO-FILENAME-ORDER-HACK

- 不要试图在文件名中使用数字影响加载顺序。
- Agent 规范文档文件名禁止使用数字前缀排序（例如 `01-*.md`、`10-*.md`）。

### R-PROTO-ROLE-FIRST-NAMING

- 模块名与规范文件名必须优先表达职责，不要新增 `shared`、`common` 这类不说明执行角色的泛化命名。
- 只有已经形成稳定公共协议的既有命名才允许保留；新文件默认使用 `dispatcher`、`reset`、`queue`、`subroutines` 这类职责名。
