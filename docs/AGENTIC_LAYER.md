# Agentic Layer — ads-insight-app

## Risk Levels & Actions

### Low risk — auto-execute (no approval needed)
- **generate_insight** — call OpenAI, write result to `insights` table
- **generate_report** — compose narrative from insight, write to `reports` table
- **tag_campaign_platform** — detect platform from CSV headers, write to `campaigns.platform`
- **score_metrics** — compute delta percentages, write rule-based flags

### Medium risk — show draft, user confirms
- **rename_report** — edits `reports.title`; shown as editable field before save
- **mark_insight_approved** — sets `review_status = 'approved'`; one-click confirm

### High risk — always requires explicit approval
- **delete_report** — shows confirmation modal; logs to `audit_logs` on confirm
- **delete_upload** — cascades to campaigns + metrics; explicit confirm required

### Critical — human-only (not in v1)
- Sending reports externally (email, Slack) — added in a later sprint with full approval flow

## Named Tools (v1)
| Tool | Action |
|------|--------|
| `csv_parser` | Parse and normalise uploaded file |
| `openai_analyse` | POST to OpenAI with structured payload |
| `insight_writer` | Write insight rows to Supabase |
| `report_builder` | Compose and store Markdown report |
| `audit_logger` | Append row to `audit_logs` |

No `run_any` or `eval` permitted. Every tool call is named and logged.

## Audit Log Fields
`action` · `object_type` · `object_id` · `user_id` · `detail` (JSON snapshot) · `created_at`

## v1 vs Later
- v1: auto-generate insight + report on user trigger
- Later: scheduled re-analysis, diff against prior report, Slack delivery with approval step
