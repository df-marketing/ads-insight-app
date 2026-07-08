# Tasks — ads-insight-app

## Gantt Overview
```
Sprint 1: DB + seed + upload storage
Sprint 2: AI insight engine (core)
Sprint 3: UI — all screens + states        ← v1 functional milestone
Sprint 4: Polish + full test pass
Sprint 5: Auth + lock-down (before real users)
```

---

## Sprint 1 — DB, Seed Data, CSV Upload Storage
**Goal:** Schema live, demo data visible, file upload persists to DB and Storage.

- [ ] Run migration SQL in Supabase (reports, insights, upload_events + RLS v1 policies)
- [ ] Confirm 3 seed reports + 7 seed insights render via Supabase client
- [ ] Create `/api/upload` route: accept multipart CSV, upload to Storage, insert `reports` row
- [ ] Insert `upload_event` row on upload complete
- [ ] Return `report_id` to client

**Definition of Done:** POST to `/api/upload` with a real CSV → new row in `reports` + file in Storage bucket + event in `upload_events`. Verified in Supabase table editor.

---

## Sprint 2 — AI Insight Generation Engine
**Goal:** Upload triggers AI analysis; structured insights saved to DB.

- [ ] `/api/analyse` route: read CSV from Storage, parse to normalised JSON
- [ ] Build prompt with normalised JSON; call OpenAI GPT-4o; expect JSON insight array
- [ ] Validate response schema; persist each insight row with `source`, `confidence`, `review_status`
- [ ] Set `reports.status = 'complete'`; log `ai_analysis_complete` event
- [ ] On OpenAI error: set `reports.status = 'error'`; log `ai_error` event; return structured error
- [ ] Apply rule-based `priority_score` calculation before insert

**Definition of Done:** Upload `q1_marketing_performance.csv` → within 10 s, ≥3 `insights` rows exist in DB with non-null `explanation` and `explanation_confidence > 0`. Verified in table editor.

---

## Sprint 3 — Insight Display UI ✦ v1 functional
**Goal:** Full UI working end-to-end; anonymous visitors see demo data immediately.

- [ ] Homepage (`/`): renders reports list using seed data — no login wall
- [ ] Reports list: loading skeleton → empty state ("Upload your first report") → cards list
- [ ] Upload form: file picker, 10 MB limit enforced, progress indicator, error message on bad file
- [ ] Report detail page (`/reports/[id]`): loading → error → insight cards sorted by `priority_score`
- [ ] Insight card: metric name, value, change badge (▲/▼/→), category label, explanation text
- [ ] Accept / Flag buttons on each card → PATCH `insights.review_status` → UI updates instantly
- [ ] Delete report button → confirm dialog → DELETE persists to DB → redirects to list
- [ ] All buttons wire to real DB mutations — zero dead buttons

**Definition of Done:** Walk the success scenario end-to-end (see PRD) without a login. Flag an insight; refresh page; flag status persists.

---

## Sprint 4 — Polish, Error Handling, Test Pass
**Goal:** Every edge case handled; test plan passes fully.

- [ ] Malformed CSV (no recognisable columns) → friendly error: "We couldn't read this file. Make sure it's a standard marketing export CSV."
- [ ] File > 10 MB → blocked at client with message before upload
- [ ] OpenAI timeout (> 30 s) → report shows "Analysis is taking longer than expected — retry" with button
- [ ] Empty insights state on report detail (analysis error path)
- [ ] Run all manual test steps in TEST_PLAN.md; mark each pass/fail
- [ ] Confirm no secrets in any client bundle (`NEXT_PUBLIC_` audit)
- [ ] Lighthouse performance check; fix any p0 issues

**Definition of Done:** Every test step in TEST_PLAN.md returns ✅. No `OPENAI_API_KEY` found in browser network tab or JS bundle.

---

## Sprint 5 — Lock It Down (Auth + Per-User Isolation)
**Goal:** User accounts added; data scoped to owner; open policies replaced.

- [ ] Enable Supabase Auth (email/password)
- [ ] Add sign-up / login pages; session stored via Supabase SSR helpers
- [ ] Populate `user_id` on all new `reports` + `insights` + `upload_events` rows
- [ ] Replace v1 open RLS policies with `auth.uid() = user_id` for all tables
- [ ] Seed demo report remains readable without login (pinned `user_id = null` + explicit policy)
- [ ] Test: user A cannot read user B's reports
- [ ] Rate-limit `/api/upload` (5 requests / minute per IP)
- [ ] Run `npm audit`; resolve any high/critical vulnerabilities
- [ ] Document any security gaps that could not be verified

**Definition of Done:** User A logs in, uploads a report, logs out. User B logs in — cannot see User A's report. Unauthenticated visitor sees only the seed demo report.
