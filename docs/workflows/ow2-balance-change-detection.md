# OW2 Balance Change Detection

这个流程只负责把上游变更整理成可审阅的 candidate delta，不接受 reference，也不直接改变 PvE 玩法。

## 数据边界

- canonical snapshot：`data/ow2/reference-snapshot.json`。
- candidate intake：`data/ow2/change-feed.json`。它是维护者或导入工具写入的候选变更队列，不是假定完整、实时或权威的 OW2 API。
- generated constants：由 `pnpm run tool:generate-ow2-reference` 生成；detector 不写入该文件。
- impact classification：读取 `data/ow2/hero-balance-audit.json`，区分 `absolute_pve_target`、`relative_pve_modifier` 和其他消费者。

Source policy 保持分层：优先使用官方 Blizzard patch notes；repository import、第三方 structured source 和人工审查只用于发现、补洞或 cross-check。每条 candidate 都必须保留 source URL、identifier、ruleset、confidence 和 verification status；未验证的来源不能静默覆盖 snapshot。

## 本地命令

默认检查 `data/ow2/change-feed.json` 中 `publishedDate` 严格晚于 `lastChecked` 的候选。初始 marker 与当前 snapshot 的 `lastVerified` 对齐；维护者只有在实际覆盖了一个来源时间窗口后才应推进它：

```bash
pnpm run tool:detect-ow2-reference-changes
```

审阅候选时写出确定性 JSON 报告：

```bash
pnpm run tool:detect-ow2-reference-changes -- \
  --report build/reports/ow2-reference-change-review.json
```

也可以对外部导入文件或指定 marker 执行只读比较：

```bash
pnpm run tool:detect-ow2-reference-changes -- \
  --input /path/to/change-feed.json \
  --since 2026-03-04 \
  --report build/reports/ow2-reference-change-review.json
```

没有 candidate delta、untracked field、ruleset mismatch、unit mismatch 或 unresolved reference 时，命令只输出摘要，不创建报告文件；因此默认 no-change run 不会制造仓库 churn。显式传入 `--report` 时，即使没有变更也会写出报告。

## Candidate 格式

`data/ow2/change-feed.json` 默认保持空的 `changes` 数组。导入或人工审查后，每条记录至少包含：

```json
{
  "id": "2026-08-12-ana-sleep-dart-6v6",
  "hero": "ana",
  "field": "sleep_dart_cooldown_time",
  "proposedValue": 10,
  "unit": "seconds",
  "ruleset": "6v6",
  "publishedDate": "2026-08-11",
  "effectiveDate": "2026-08-12",
  "source": {
    "type": "official_patch_notes",
    "identifier": "patch-identifier",
    "url": "https://example.invalid/source"
  },
  "confidence": "high",
  "verificationStatus": "provisional",
  "note": "待维护者核对。"
}
```

`hero` 与 `field` 必须使用 reference dataset 的字段命名。检测器不会因为发现新字段而扩展 dataset；它会把该记录放入 `untrackedChanges`。已知字段但 ruleset 不在当前 snapshot 选择范围内的记录会放入 `rulesetMismatches`，保留候选值和可用 ruleset 列表。

## 报告与接受边界

tracked candidate delta 包含：

- canonical reference constant、旧值、候选值和数值差异；
- candidate 的 source/provenance、published/effective date、ruleset、confidence 和 verification status；
- 由审计 inventory 找到的 Main/ARAM 消费者及其语义类别。

影响解释遵循以下规则：

- `absolute_pve_target`：接受新 reference 后，重新计算 Workshop 百分比可以保持固定的 PvE 有效 target；这是需要显式重生成和验证的维护动作。
- `relative_pve_modifier`：保持配置的相对比例会使有效玩法随新 reference 变化；不能把它当作安全的等价更新。
- 其他或 runtime 消费者：报告会列出位置，但不会猜测其调优意图。

detector 始终把 `canonicalSnapshotUpdated` 设为 `false`，也不会修改 `reference-snapshot.json`、generated `.opy`、`player_constants.opy` 或任何玩法设置。维护者确认后，必须单独更新 dataset，运行 generator/audit/build gates，并在独立提交中记录接受决定。

## CI 策略

当前不添加 scheduled GitHub Actions。仓库没有可持续、完整且权威的 unattended OW2 balance feed；定时运行空 intake 只能产生噪声，接入未经验证的第三方抓取又会把 discovery 误当成 acceptance。等可靠的 acquisition/import 层确定后，再把该本地 detector 接到 artifact 或 review PR 流程；无论如何都不能由 scheduled job 自动提交 reference 或 PvE 数值。
