# Skills TODO Roadmap

本清单用于指引仓库后续 skill 的实现顺序与验收标准。

## 状态约定

- `todo`: 未开始
- `in_progress`: 正在实现
- `done`: 已完成

## 当前路线

| Skill | Status | 目标 | 最小验收标准 |
|---|---|---|---|
| `ow-contract-guard` | done | 守护编排与协议不变量 | 可检查 include 顺序、分隔规则、索引协议、hero init 基础安全项 |
| `ow-hero-change-pipeline` | in_progress | 标准化英雄改动流水线，降低漏改风险 | 可按 hero 审核 init 模式、索引 include、hero_rules 触达、changelog 覆盖 |
| `ow-changelog-sync` | todo | 降低英雄平衡改动与 changelog 漂移 | 可从规则差异生成待更新条目，并校验 hero 覆盖 |
| `ow-module-metrics-sync` | todo | 保持文档统计与源码一致 | 可自动统计 rule/vars/subroutine 并更新 docs/modules/*.md |

## `ow-hero-change-pipeline` 实施拆解

1. `MVP 审核脚本`
- [x] 支持按 `--hero <slug>` 进行英雄改动审核
- [x] 支持 `--from-diff [range]` 从 git diff 推断受影响英雄
- [x] 校验 `hero_init` detect/initialize 关键模式
- [x] 校验 hero 文件是否在 `_index.opy` 中被 include
- [x] 校验 changelog 是否存在对应 hero 分支

2. `流程封装`
- [x] 增加 `SKILL.md` 指导“改前-改中-改后”流程
- [x] 明确软告警与阻断失败边界
- [x] 与 `ow-contract-guard` 串联（作为最终门禁）

3. `后续增强`
- [ ] 支持对 `reset_pvar` 槽位写入做更细粒度语义审查
- [ ] 支持检测 hero_rules 中高频规则节流风险（wait/waitUntil）
- [ ] 支持生成“本次英雄改动复核报告”模板

## 使用建议

- 每次实现新 skill 前，先更新本文件状态。
- 每次 skill 增强后，补充对应验收标准，避免“完成定义”漂移。
