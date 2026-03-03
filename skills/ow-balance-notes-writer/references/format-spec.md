# Balance Notes Format Spec

## 1) Hero Updates Header

Use this header when there is at least one hero balance change:

```markdown
## **英雄更新**

> 如果没有单独注明（如 Player、AI），则英雄改动对AI与玩家都生效

|  |  |
| -------- | -------- |
| <span style="color:#28b463;">▲ 增强</span>   | [hero HeroA] [hero HeroB]
| <span style="color:#e74c3c;">▼ 削弱</span>   | [hero HeroC]
| <span style="color:#ecc445;">▷ 调整</span>   | [hero HeroD]
```

Notes:
- Omit empty rows.
- Keep one space-separated `[hero Name]` token per hero.
- Keep hero names consistent with update blocks.

## 2) Role Grouping

When multiple heroes are present, group detailed blocks by role:

```markdown
### **重装**
...update blocks...

### **输出**
...update blocks...

### **支援**
...update blocks...
```

If only one or two heroes are changed, role grouping can be skipped when the user prefers compact output.

## 3) Update Block Schema

Use this exact bracketed object style:

```text
[update {
  hero: "HeroName",
  title: "中文名（可选）",
  abilities: {
    "General": [
      "数值与效果描述"
    ],
    "技能名": [
      "技能改动描述"
    ]
  },
  icons: {
    "技能名": "Official Ability Name"
  }
}]
```

Rules:
- `hero` and `abilities` are required.
- `title` is optional but recommended for Chinese readability.
- `icons` is optional; include it when skill names are custom, translated, or remapped.
- Use double quotes for keys and strings.
- `"General"` is only for non-ability-specific changes (damage/healing/health/ult economy/global effects).
- Cooldown changes must be placed under explicit ability keys, not under `"General"`.
- Cooldown text must use time wording (`冷却时间由 xx 秒 ...`), not coefficient wording (`冷却系数 xx%`).

### 3.1 Scope Split (Player / AI)

When a hero has different Player and AI values, split into two blocks:

```text
[update {
  hero: "HeroName",
  title: "英雄名",
  abilities: {
    "General": [
      "造成伤害由 100% **增强↗** 至 135%"
    ],
    "技能名": [
      "冷却时间由 8 秒 **降低↘** 至 6 秒"
    ]
  }
}]

[update {
  hero: "HeroName",
  title: "英雄名（AI）",
  abilities: {
    "General": [
      "造成伤害由 100% **增强↗** 至 125%"
    ],
    "技能名": [
      "冷却时间由 8 秒 **降低↘** 至 6 秒"
    ]
  }
}]
```

Rules:
- Do not merge Player and AI values into one block when values differ.
- AI block title must end with `（AI）`.
- Once title is split (`英雄名` / `英雄名（AI）`), do not repeat scope words (`Player` / `AI`) in `abilities` lines.

## 4) Wording Conventions

Prefer this notation:
- `提高↗` / `增强↗` for buffs
- `降低↘` / `削弱↘` for nerfs
- Numeric transitions like `100%->125%`
- Explicit charge-point notation for ult economy changes

Recommended phrasing patterns:
- `"基础生命值由 200 点 **增强↗** 至 225 点"`
- `"终极技能消耗 **提高↗** 20%（充能所需点数由 2000 点 **提高↗** 至 2400 点）"`
- `"**已移除：** ..."`

## 5) Optional Sections

Include only when relevant:

```markdown
## **综合更新**
- ...

## **AI 改进**
- ...

## **错误修复**
- ...

## **已知问题**
- ...
```

## 6) Quality Checklist

Before returning output:

1. Ensure every hero in the summary table has a matching `[update {...}]` block.
2. Ensure AI-only blocks are clearly marked (`title: "X（AI）"` or equivalent clear labeling).
3. Ensure Player/AI split is applied when values differ (two blocks for the same hero).
4. Ensure no cooldown text appears in `"General"` (cooldowns must live under ability keys).
5. Ensure cooldown wording is time-based (`冷却时间由 xx 秒 ...`) and does not use coefficient expressions.
6. Ensure abilities lines do not repeat `Player` / `AI` when title already carries scope.
7. Ensure no contradiction between summary bucket and detailed numbers.
8. Ensure markdown renders cleanly with blank lines between major sections.
