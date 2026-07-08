# Agentic Layer — ads-insight-app

## Risk Classification

| Action | Risk | Approval |
|---|---|---|
| Generate insight summary from CSV | Low | Auto |
| Tag insight category | Low | Auto |
| Score and rank insights | Low | Auto |
| Mark insight as accepted / flagged | Low | User click (immediate) |
| Retry failed AI analysis | Low | User click |
| Delete a report and its insights | High | Confirm dialog → persists to DB |
| Send insight summary by email (later) | Medium | User approval |
| Charge for premium analysis (later) | Critical | Human only |

## Named Tools (v1)
- `parse_csv` — reads Storage file, returns normalised JSON
- `generate_insights` — sends normalised JSON to OpenAI, returns insight array
- `save_insights` — writes insight rows to Supabase
- `update_review_status` — sets `review_status` on a single insight row

No `run_any` or `eval` equivalents permitted.

## Audit Log Fields (upload_events)
- `event_type` — what happened
- `report_id` — which report
- `user_id` — who (null until auth sprint)
- `detail` — relevant metadata (file size, insight count, error message)
- `created_at` — immutable timestamp

## V1 vs Later
- **V1:** Auto-generate insights on upload; user manually reviews
- **Later:** Agent drafts recommended actions ("pause this campaign"), requires user approval before any external action
