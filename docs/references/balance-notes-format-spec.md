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

## 3) Update Block Schema

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
- `icons` is optional.
- `"General"` only holds non-ability-specific changes.
- Cooldown changes must live under explicit ability keys.
- Cooldown text must use time wording.

## 4) Scope Split (Player / AI)

When Player and AI values differ, split into two blocks and make the AI title end with `（AI）`.

## 5) Optional Sections

Include only when relevant:

```markdown
## **综合更新**
## **AI 改进**
## **错误修复**
## **已知问题**
```
