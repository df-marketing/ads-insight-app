# Architecture — ads-insight-app

## Stack
- **Frontend:** Next.js (App Router) on Vercel
- **Database + Storage:** Supabase (Postgres + Storage bucket for CSV files)
- **AI:** OpenAI API (GPT-4o) — server-side only via Next.js API route
- **Styling:** Tailwind CSS

## What to Build Now vs Later
| Now (v1) | Later |
|---|---|
| CSV upload + AI insight generation | User accounts + per-user isolation |
| Insight cards with accept/flag | PDF export, Slack delivery |
| Reports list | Multi-file trend comparison |
| Demo data, no login wall | Team workspaces |

## Key User Action — Step by Step
1. User selects a CSV file in the upload form
2. File uploads to Supabase Storage; `reports` row created with `status='processing'`
3. `upload_event` row logged (`upload_complete`)
4. Next.js API route reads the file, parses rows, sends structured prompt to OpenAI
5. OpenAI returns JSON array of insight objects
6. Each insight saved to `insights` table with `source`, `confidence`, `review_status`
7. `upload_event` row logged (`ai_analysis_complete`); report `status` set to `complete`
8. Frontend polls/subscribes → insight cards render ranked by `priority_score`

## Layer Plan
1. **Data first** — schema, seed rows, RLS policies
2. **App logic** — upload → parse → persist (works without AI)
3. **Intelligence on top** — AI call generates insight rows; if AI is down, report stays in `processing` with a clear retry UI

## Core Without AI
If the OpenAI call fails, the report row exists, CSV is stored, and the UI shows a "Generate insights" retry button. No data is lost.
