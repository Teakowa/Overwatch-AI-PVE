---
name: ow-balance-notes-writer
description: Generate Overwatch-AI-PVE hero balance notes in the project's official markdown style, including summary tables and `[update {...}]` blocks. Use when the user asks to write or format patch notes/changelog text from hero balance changes, AI-only adjustments, bug fixes, or known issues in Chinese.
---

# OW Balance Notes Writer

Generate consistent player-facing balance notes using the project style.

## Quick Start

1. Read the provided change list or diff summary.
2. Classify each item as one of:
   - `综合更新` (global/system-wide gameplay changes)
   - `英雄更新` (hero balance changes)
   - `AI 改进` (AI logic behavior improvements)
   - `错误修复` (bug fixes)
   - `已知问题` (known issues)
3. For hero balance entries, emit:
   - Hero summary table rows (增强/削弱/调整)
   - Detailed `[update {...}]` blocks grouped by role section when needed (`重装` / `输出` / `支援`)
   - Split Player and AI adjustments into separate blocks when their numbers differ:
     - Player block title: `英雄名`
     - AI block title: `英雄名（AI）`
   - Put cooldown changes under concrete ability keys (e.g. `"怒炎冲"`, `"技能1"`), never in `"General"`
   - Cooldown wording must use time directly (e.g. `冷却时间由 8 秒降低至 6 秒`), not coefficient wording like `冷却系数`
4. Follow the exact formatting contract in [references/format-spec.md](references/format-spec.md).

## Output Rules

1. Keep output in Chinese unless the user explicitly requests another language.
2. Preserve project markers and style:
   - Section titles like `## **英雄更新**`
   - Summary rows with colorized labels (`▲ 增强`, `▼ 削弱`, `▷ 调整`)
   - `[update {...}]` object blocks
3. Default scope wording:
   - Keep this sentence when hero updates exist:
     `> 如果没有单独注明（如 Player、AI），则英雄改动对AI与玩家都生效`
4. Distinguish AI-only entries explicitly:
   - Use hero title suffix `（AI）` when the block affects AI only.
5. Split AI and Player adjustments when both exist:
   - Do not merge AI and Player numbers into one `[update {...}]` block.
   - Generate one Player block and one AI block for the same hero when values differ.
   - Once split by title, do not repeat scope words like `Player` / `AI` inside `abilities` lines.
6. Cooldown placement rule:
   - Cooldown changes must be written under specific ability keys.
   - `"General"` can include only non-ability-specific changes (e.g. damage/healing/received damage/health/ult economy/global mechanics).
   - Do not place cooldown text in `"General"`.
   - Describe cooldown by time change only (`冷却时间由 xx 秒 ...`), do not use coefficient expressions (`冷却系数 xx%`).
7. Keep values explicit:
   - Prefer `旧值->新值` numeric expressions for percentages, cooldowns, health, or charge points.
8. Keep changelog language player-facing:
   - Avoid internal implementation detail unless requested.
   - Avoid Team-number wording unless the user explicitly asks for it.

## Classification Heuristics

Classify each hero into exactly one summary bucket unless the user asks to list a hero in multiple buckets.

- `▲ 增强`:
  - Survivability, damage, healing, utility, uptime increased
  - Cost/cooldown reduced
- `▼ 削弱`:
  - Survivability, damage, healing, utility, uptime reduced
  - Cost/cooldown increased
- `▷ 调整`:
  - Mixed trade-offs, reworks, removals/replacements, behavior shifts without clear net buff/nerf

When uncertain, default to `▷ 调整` and state assumptions briefly.

## Minimal Validation

Before finalizing output, verify:

1. Every hero in the summary table has at least one corresponding `[update {...}]` block.
2. Every `[update {...}]` block has:
   - `hero`
   - `abilities` with at least one entry
   - `icons` only when ability icon override is needed
3. If a hero has both AI and Player tuning, output contains separate Player/AI blocks and the AI block title ends with `（AI）`.
4. No cooldown line appears in `"General"`; cooldown lines are placed under concrete ability keys.
5. Cooldown lines use time wording only (`冷却时间由 xx 秒 ...`), with no coefficient wording.
6. When title split is used (`英雄名` / `英雄名（AI）`), `abilities` lines do not repeat `Player` / `AI`.
7. Markdown structure remains valid and readable.
8. Optional sections (`AI 改进`, `错误修复`, `已知问题`) are omitted when no items exist.

## Reference

Use [references/format-spec.md](references/format-spec.md) as the canonical template and style contract for final output shape.
