# Protocol Constraints (Canonical)

### R-PROTO-INDEX-IMMUTABLE

- 变量/子程序索引是协议：禁止改号（`globalvar/playervar/subroutine <index>`）。

### R-PROTO-APPEND-NO-REORDER

- 改动策略：优先追加，避免重排变量与规则。

### R-PROTO-KEEP-DELIMITER-NAMES

- 保留关键分隔规则名：`Initialize AI Scripts`、`Initialize AI Scripts End`、`Initialize Heroes`、`Initialize Heors End`（拼写保持现状）。

### R-PROTO-KEEP-DISABLED

- 不随意移除 `@Disabled` 规则。

### R-PROTO-RULE-NAME-STYLE

- 规则命名保持现有风格（`[module]: action`）。

### R-PROTO-SETTINGS-FIRST

- 英雄通用数值优先放 `settings`；仅在依赖前置条件时使用 `rule`。

### R-PROTO-NO-FILENAME-ORDER-HACK

- 不要试图在文件名中使用数字影响加载顺序。
- Agent 规范文档文件名禁止使用数字前缀排序（例如 `01-*.md`、`10-*.md`）。
