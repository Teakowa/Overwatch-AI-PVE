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
3. Ensure no contradiction between summary bucket and detailed numbers.
4. Ensure markdown renders cleanly with blank lines between major sections.
