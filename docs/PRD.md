# Product Requirements — ads-insight-app

## Problem
Marketers and small business owners receive CSV reports from ad platforms but lack the time or skill to extract meaning. They end up either ignoring the data or spending hours manually reading spreadsheets.

## Target User
A solo marketer or business owner who runs paid ads, receives weekly/monthly CSV exports, and wants instant clarity on what worked, what didn't, and what to do next — with no data analysis background.

## Core Objects
| Object | What it represents |
|---|---|
| `report` | An uploaded CSV file and its metadata |
| `insight` | A single AI-generated finding from a report |
| `upload_event` | A log entry for each step of the upload/analysis process |

## MVP Must-Haves (v1)
- [ ] Upload a CSV file (marketing report format)
- [ ] Auto-detect column names and row count
- [ ] Generate AI insight cards: metric name, value, change direction, plain-language explanation
- [ ] Display insights ranked by priority score
- [ ] Reports list showing all past uploads
- [ ] User can mark an insight as accepted or flagged
- [ ] Handles empty, error, and loading states on every screen
- [ ] Demo reports visible to anonymous visitors — no login required

## Non-Goals (v1)
- User accounts or authentication
- Non-CSV data sources or live integrations
- PDF export, email delivery, or sharing
- Multi-file trend comparisons
- Team or multi-user workspaces

## Definition of Done
**Success scenario (pass/fail):** A user uploads `q1_marketing_performance.csv` → within 10 seconds, at least 3 insight cards appear showing metric name, change direction, and a plain-language explanation → the user flags one insight → the flagged status persists after page refresh.
