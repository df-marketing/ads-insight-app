# Tasks & Sprints — ads-insight-app

## Sprint 1 — Database, seed data, and CSV upload engine
**Goal:** App loads with demo data; CSV upload writes to the database.

- [ ] Apply migration SQL to Supabase (all tables + seed rows)
- [ ] Scaffold Next.js project + Tailwind + Supabase client
- [ ] Home page renders campaign cards from seeded `campaigns` + latest `metrics` (no login)
- [ ] Build CSV upload component (drag-and-drop + file picker)
- [ ] `/api/upload` route: parse CSV, map columns, insert into `campaigns` + `metrics`
- [ ] Parsed data preview table with column mapping confirmation
- [ ] Error states: wrong format, missing required columns, empty file

**Definition of Done:** Visiting the app shows 3 demo campaigns. Uploading a valid CSV adds a new campaign row visible on the page. Uploading a bad file shows a clear error.

---

## Sprint 2 — AI analysis engine ✅ *v1 functional milestone*
**Goal:** The full upload → insight → report flow works end-to-end.

- [ ] `/api/analyse` server route: build structured payload from `metrics`, call OpenAI
- [ ] Store AI response into `insights` (summary_text, insight_bullets, why_explanation + source + confidence + review_status)
- [ ] Create `reports` record from insight narrative
- [ ] Log action to `audit_logs`
- [ ] Insight Cards component: metric deltas (↑/↓ %), top wins, top drops
- [ ] Performance Summary block (summary_text)
- [ ] Ready-to-Send Report view: clean Markdown render
- [ ] "Copy report" button (clipboard API)
- [ ] Loading skeleton during AI call
- [ ] Error state if OpenAI call fails (show rule-based data only)
- [ ] "Try demo data" banner on home page with one-click load

**Definition of Done:** User uploads a CSV (or clicks demo), clicks Analyse, sees insight cards and a narrative report, and can copy the text. All data is in Supabase. Works without login.

---

## Sprint 3 — Report persistence and history
**Goal:** Users can browse, rename, and delete saved reports.

- [ ] Reports list page (`/reports`) — date, campaign name, platform, status
- [ ] Inline rename for `reports.title`
- [ ] Delete report with confirmation modal + audit log entry
- [ ] Week-over-week delta calculation (rule-based arithmetic)
- [ ] Delta badges (↑/↓ %) on metric cards
- [ ] Empty state for reports list (first-time user prompt)

**Definition of Done:** All CRUD actions on reports persist and reflect in the UI. No dead buttons.

---

## Sprint 4 — Export and polish
**Goal:** Report is exportable; UI is polished and mobile-friendly.

- [ ] PDF export via print stylesheet (`window.print()`)
- [ ] Markdown download (`.md` file blob)
- [ ] Mobile-responsive layout across all pages
- [ ] Consistent empty/error/loading states
- [ ] Confidence badge: fields with confidence <0.75 show "Review recommended"
- [ ] Accessibility pass (alt text, focus states, contrast)

**Definition of Done:** Report exports correctly. App is usable on a phone. No broken states.

---

## Sprint 5 — Lock it down
**Goal:** Per-user data isolation; app is safe for real data.

- [ ] Supabase Auth: email/password + Google OAuth
- [ ] Sign-up / login pages
- [ ] Set `user_id` on all new rows post-login
- [ ] Replace permissive RLS policies with `auth.uid() = user_id` owner policies
- [ ] Demo data remains public (seed rows have `user_id = null`; policy allows null rows in read)
- [ ] Protect `/api/analyse` and `/api/upload` — require session for writes
- [ ] Audit log append-only policy

**Definition of Done:** Logged-in user sees only their own reports. Demo seed data still visible to anonymous visitors. No secrets in client code.

---

## Gantt (sprint → feature)
```
Sprint 1  |████ DB + seed + CSV upload
Sprint 2  |████ AI analysis + insight cards + report view  ← v1 functional
Sprint 3  |████ Report history + CRUD + WoW deltas
Sprint 4  |████ Export + mobile polish
Sprint 5  |████ Auth + RLS lock-down
```
