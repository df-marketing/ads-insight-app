# Intelligence Layer — ads-insight-app

## Messy Input
Raw CSV rows from ad platforms — inconsistent column names, mixed date formats, varying metrics (ROAS, CPA, CTR, open rate, ROMI, etc.).

## Auto-Structure Schema
Before calling AI, the server normalises the CSV into:
```json
{
  "filename": "q1_marketing_performance.csv",
  "columns": ["date", "campaign", "impressions", "clicks", "ctr", "spend", "conversions", "cpa", "roas"],
  "row_count": 90,
  "sample_rows": [
    {"date": "2024-01-01", "campaign": "Brand Search", "impressions": 12400, "clicks": 384, "ctr": 0.031, "spend": 540, "conversions": 38, "cpa": 14.2, "roas": 4.1}
  ],
  "aggregates": {
    "total_spend": 48200,
    "total_conversions": 3100,
    "avg_ctr": 0.029,
    "avg_roas": 4.2
  }
}
```

## Events to Track
- CSV uploaded
- AI analysis started / completed / errored
- Insight reviewed (accepted / flagged)

## Scoring Rules (v1 — rule-based)
| Rule | Score |
|---|---|
| category = `risk` | +20 |
| `\|change_percent\|` > 20% | +15 |
| category = `efficiency` | +10 |
| `change_direction = 'down'` on a positive metric | +10 |

Higher `priority_score` → rendered first. No ML required in v1.

## V1 vs Later
- **V1:** Rule-based priority score; single-file analysis; OpenAI prompt returns structured JSON
- **Later:** Learned scoring from user accept/flag patterns; cross-file trend detection; domain-specific prompt tuning
