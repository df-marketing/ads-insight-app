# Architecture — ads-insight-app

## Stack
- **Frontend:** Next.js 14 (App Router) + Tailwind CSS
- **Backend/DB:** Supabase (Postgres + Storage for CSV files)
- **AI:** OpenAI GPT-4o via server-side API route
- **Deploy:** Vercel

## What to Build Now vs Later
| Now | Later |
|-----|-------|
| CSV upload → parse → store | Google Sheets live sync |
| AI analysis per campaign | Meta / Google Ads API |
| Insight cards + report view | PDF export |
| Demo seed data, no login | Auth + per-user isolation |
| Copy-to-clipboard report | Email / Slack delivery |

## Key User Action — Step by Step
1. User drops a CSV onto the upload zone
2. Frontend sends the file to `/api/upload`; server parses CSV rows
3. Parsed campaigns + metrics written to Supabase (`campaigns`, `metrics`)
4. User reviews the data preview and clicks **Analyse**
5. Server sends structured metric payload to OpenAI; response stored in `insights` table (with `source`, `confidence`, `review_status`)
6. Report record created in `reports` table from the insight text
7. UI renders Insight Cards and the Report view; user copies the narrative

## Layer Plan
1. **Data layer first** — tables, seed rows, CRUD all work without AI
2. **App logic** — CSV parsing, metric delta calculations (rule-based, no AI)
3. **Intelligence on top** — OpenAI call enriches stored rows; if the API is down, the parsed data and rule-based deltas still display

## Why the Core Runs Without AI
All metric data is stored in Postgres. Delta badges (↑/↓ %) are computed with pure arithmetic. The AI only enriches the `summary_text`, `insight_bullets`, and `why_explanation` fields — those show a fallback "Analysis pending" state if the call fails.
