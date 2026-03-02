# Output Schema

## Hero List (`fetch_heroes_from_page.py`)

```json
{
  "source": "https://overwatch.fandom.com/wiki/Heroes",
  "count": 42,
  "heroes": ["Ana", "Ashe", "Baptiste"]
}
```

## Single Hero (`fetch_hero_details.py`)

```json
{
  "hero": "Ana",
  "title": "Ana",
  "summary": "First paragraph extracted from the hero page.",
  "infobox": {
    "real_name": {
      "label": "Real Name",
      "value": "Ana Amari"
    }
  },
  "infobox_fields": [
    {
      "key": "real_name",
      "label": "Real Name",
      "value": "Ana Amari"
    }
  ],
  "url": "https://overwatch.fandom.com/wiki/Ana"
}
```

## Batch (`fetch_all_hero_details.py`)

```json
{
  "source": "/tmp/ow_heroes.json",
  "count": 2,
  "failed_count": 1,
  "heroes": [
    {"hero": "Ana", "title": "Ana", "infobox": {}, "infobox_fields": [], "summary": null, "url": "..."}
  ],
  "failures": [
    {"hero": "Hero Name", "error": "Error text"}
  ]
}
```

## Normalization Rules

- Script replaces underscore with space in hero names.
- Script deduplicates hero names while preserving first-seen order.
- Script keeps infobox values as plain text with collapsed whitespace.
- Script keeps both map (`infobox`) and ordered list (`infobox_fields`) forms for compatibility.
