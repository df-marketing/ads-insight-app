# Intelligence Layer — ads-insight-app

## Messy Inputs
- Raw CSV with inconsistent column names ("Cost" vs "Spend" vs "Amount Spent")
- Missing values, date format variation, extra header rows
- No context about what changed (creative, budget, audience)

## Auto-Structure Schema
Before calling the AI, the server normalises CSV rows into this payload:
```json
{
  "campaign": "Meta – Spring Promo",
  "platform": "Meta",
  "period": { "start": "2024-03-24", "end": "2024-03-31" },
  "metrics": {
    "spend": 1350,
    "impressions": 91000,
    "clicks": 2548,
    "conversions": 51,
    "ctr": 2.80,
    "cpl": 26.47,
    "cpa": 26.47,
    "roas": 5.10
  },
  "prior_period_metrics": {
    "ctr": 2.40, "cpl": 31.58, "roas": 4.20
  }
}
```

## Events to Track
- CSV uploaded
- Parsing succeeded / failed
- AI analysis requested
- Insight generated (confidence scored)
- Report copied / exported

## Scoring Rules (v1 — rule-based first)
| Signal | Rule |
|--------|------|
| ROAS delta | >10% improvement → highlight green |
| CPL delta | >10% drop → positive insight |
| CTR | <1% → flag as low engagement |
| Conversions WoW | >20% drop → flag as alert |

AI confidence score stored on every generated field; anything <0.75 shown with a "Review recommended" badge.

## What Gets Ranked
- Insight bullets ordered by magnitude of delta (largest change first)
- Campaigns on the report list ordered by ROAS desc

## v1 vs Later
| v1 | Later |
|----|-------|
| Single-period analysis | Multi-period trend lines |
| Rule-based delta badges | AI anomaly detection |
| Plain insight bullets | A/B test statistical significance |
| Manual note field | AI context extraction from notes |
