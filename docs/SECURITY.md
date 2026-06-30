# Security — ads-insight-app

## Secret Handling
- `OPENAI_API_KEY` and `SUPABASE_SERVICE_ROLE_KEY` stored in Vercel environment variables only
- Never imported into client-side code or exposed in API responses
- All AI calls go through `/api/analyse` (server route) — the key never touches the browser

## Permission Model (v1 → locked down)
- **v1:** RLS policies are permissive (`using (true)`) — demo works without login
- **Lock-Down sprint:** policies replaced with `auth.uid() = user_id`; new rows require a logged-in user
- Agent actions inherit the session user's Supabase permissions — no elevated service-role calls from the client

## Approved-Tools Rule
- Only named tools listed in `AGENTIC_LAYER.md` may be called
- No `eval`, `exec`, `run_any`, or dynamic tool construction
- Every tool invocation writes a row to `audit_logs` before returning

## Audit Principle
- Every report generation, deletion, and approval action is logged with `user_id`, `action`, `object_id`, and a JSON snapshot of the state at the time
- Audit logs are append-only (no update/delete policy on `audit_logs` table in the Lock-Down sprint)
