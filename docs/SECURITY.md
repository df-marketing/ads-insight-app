# Security — ads-insight-app

## Secret Handling
- `OPENAI_API_KEY` and `SUPABASE_SERVICE_ROLE_KEY` stored in Vercel environment variables only
- Never referenced in any client-side file; OpenAI is called exclusively from `/api/*` server routes
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` is the only key exposed to the browser — it is scoped by RLS

## Permission Model (v1 → lock-down)
- **V1:** Open RLS policies allow any visitor to read and write (demo mode)
- **Lock-down sprint:** All policies replaced with `auth.uid() = user_id`; unauthenticated users can read only the seeded demo report
- Supabase Storage bucket: private; files accessed via signed URLs generated server-side only

## Approved Tools Rule
Server routes may only call: `parse_csv`, `generate_insights`, `save_insights`, `update_review_status`. No dynamic code execution, no `eval`, no arbitrary HTTP calls.

## Prompt Injection
- CSV cell contents are passed as data, never as instruction text
- System prompt clearly separates instruction from data payload
- Review at lock-down sprint: scan for cells containing prompt-override strings

## Audit Principle
Every meaningful state change (upload, AI call, review action, delete) writes an `upload_events` row. Rows are append-only — no update or delete permitted on `upload_events`.

## Known Gaps to Verify at Lock-Down
- Rate-limiting on `/api/upload` (not implemented in v1)
- CSRF protection (Next.js default headers only in v1)
- Full npm audit pass not yet run
