# Data Model — ads-insight-app

## reports
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | owner (populated at lock-down sprint) |
| filename | text | original file name |
| original_csv_url | text | Supabase Storage path |
| row_count | integer | parsed on upload |
| detected_columns | jsonb | array of column name strings |
| status | text | `processing` \| `complete` \| `error` |
| created_at | timestamptz | |

## insights
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| report_id | uuid FK → reports | cascade delete |
| metric_name | text | e.g. `ROAS`, `CTR` |
| metric_value | text | formatted display value |
| change_direction | text | `up` \| `down` \| `flat` |
| change_percent | numeric | |
| **explanation** | **text** | **AI-generated** |
| **explanation_source** | **text** | `openai` |
| **explanation_confidence** | **numeric** | 0–1 |
| **explanation_review_status** | **text** | `unreviewed` \| `accepted` \| `flagged` |
| category | text | `efficiency` \| `cost` \| `engagement` \| `risk` |
| priority_score | numeric | 0–100; higher = shown first |
| created_at | timestamptz | |

## upload_events
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| report_id | uuid FK → reports | set null on delete |
| event_type | text | `upload_complete`, `ai_analysis_complete`, `ai_error`, `insight_reviewed` |
| detail | jsonb | free metadata (file size, insight count, etc.) |
| created_at | timestamptz | |

## RLS
- All tables: v1 open read + write policies (any visitor can read/write)
- Lock-down sprint replaces with `auth.uid() = user_id` owner policies
