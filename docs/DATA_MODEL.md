# Data Model — ads-insight-app

## uploads
| Field | Type | Notes |
|-------|------|-------|
| id | uuid PK | gen_random_uuid() |
| user_id | uuid nullable | owner scope (auth later) |
| file_name | text | original filename |
| raw_csv | text | stored CSV string |
| status | text | pending / parsed / analysed / error |
| created_at | timestamptz | |

## campaigns
| Field | Type | Notes |
|-------|------|-------|
| id | uuid PK | |
| user_id | uuid nullable | |
| upload_id | uuid FK → uploads | |
| name | text | e.g. "Meta – Spring Promo" |
| platform | text | Meta / Google / TikTok / other |
| date_start | date | |
| date_end | date | |

## metrics
| Field | Type | Notes |
|-------|------|-------|
| id | uuid PK | |
| user_id | uuid nullable | |
| campaign_id | uuid FK → campaigns | |
| metric_date | date | |
| spend | numeric | |
| impressions | integer | |
| clicks | integer | |
| conversions | integer | |
| ctr | numeric | % |
| cpl | numeric | cost per lead |
| cpa | numeric | cost per acquisition |
| roas | numeric | return on ad spend |

## insights *(AI-generated fields)*
| Field | Type | Notes |
|-------|------|-------|
| id | uuid PK | |
| user_id | uuid nullable | |
| campaign_id | uuid FK → campaigns | |
| insight_type | text | weekly_summary / comparison / ab_test |
| summary_text | text | **AI** |
| summary_text_source | text | e.g. openai/gpt-4o |
| summary_text_confidence | numeric | 0–1 |
| summary_text_review_status | text | unreviewed / approved / flagged |
| insight_bullets | jsonb | **AI** array of strings |
| insight_bullets_source | text | |
| insight_bullets_confidence | numeric | |
| insight_bullets_review_status | text | |
| why_explanation | text | **AI** |
| why_explanation_source | text | |
| why_explanation_confidence | numeric | |
| why_explanation_review_status | text | |

## reports
| Field | Type | Notes |
|-------|------|-------|
| id | uuid PK | |
| user_id | uuid nullable | |
| campaign_id | uuid FK → campaigns | |
| title | text | |
| narrative_md | text | **AI** Markdown narrative |
| narrative_md_source | text | |
| narrative_md_confidence | numeric | |
| narrative_md_review_status | text | |
| status | text | draft / ready |

## audit_logs
| Field | Type | Notes |
|-------|------|-------|
| id | uuid PK | |
| user_id | uuid nullable | |
| action | text | e.g. report.generated |
| object_type | text | campaign / report / upload |
| object_id | uuid | |
| detail | jsonb | snapshot of key values |

## RLS
All tables have RLS enabled. v1 policies are fully permissive (`using (true)`) so the demo works without login. The Lock-Down sprint replaces them with `auth.uid() = user_id`.
