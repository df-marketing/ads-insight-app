create table if not exists uploads (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  file_name text not null,
  raw_csv text,
  status text not null default 'pending',
  created_at timestamptz not null default now()
);
alter table uploads enable row level security;
drop policy if exists "uploads_v1_read" on uploads;
create policy "uploads_v1_read" on uploads for select using (true);
drop policy if exists "uploads_v1_write" on uploads;
create policy "uploads_v1_write" on uploads for all using (true) with check (true);

create table if not exists campaigns (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  upload_id uuid references uploads(id) on delete cascade,
  name text not null,
  platform text,
  date_start date,
  date_end date,
  created_at timestamptz not null default now()
);
alter table campaigns enable row level security;
drop policy if exists "campaigns_v1_read" on campaigns;
create policy "campaigns_v1_read" on campaigns for select using (true);
drop policy if exists "campaigns_v1_write" on campaigns;
create policy "campaigns_v1_write" on campaigns for all using (true) with check (true);

create table if not exists metrics (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  campaign_id uuid references campaigns(id) on delete cascade,
  metric_date date,
  spend numeric,
  impressions integer,
  clicks integer,
  conversions integer,
  ctr numeric,
  cpl numeric,
  cpa numeric,
  roas numeric,
  created_at timestamptz not null default now()
);
alter table metrics enable row level security;
drop policy if exists "metrics_v1_read" on metrics;
create policy "metrics_v1_read" on metrics for select using (true);
drop policy if exists "metrics_v1_write" on metrics;
create policy "metrics_v1_write" on metrics for all using (true) with check (true);

create table if not exists insights (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  campaign_id uuid references campaigns(id) on delete cascade,
  insight_type text,
  summary_text text,
  summary_text_source text,
  summary_text_confidence numeric,
  summary_text_review_status text default 'unreviewed',
  insight_bullets jsonb,
  insight_bullets_source text,
  insight_bullets_confidence numeric,
  insight_bullets_review_status text default 'unreviewed',
  why_explanation text,
  why_explanation_source text,
  why_explanation_confidence numeric,
  why_explanation_review_status text default 'unreviewed',
  created_at timestamptz not null default now()
);
alter table insights enable row level security;
drop policy if exists "insights_v1_read" on insights;
create policy "insights_v1_read" on insights for select using (true);
drop policy if exists "insights_v1_write" on insights;
create policy "insights_v1_write" on insights for all using (true) with check (true);

create table if not exists reports (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  campaign_id uuid references campaigns(id) on delete cascade,
  title text not null,
  narrative_md text,
  narrative_md_source text,
  narrative_md_confidence numeric,
  narrative_md_review_status text default 'unreviewed',
  status text not null default 'draft',
  created_at timestamptz not null default now()
);
alter table reports enable row level security;
drop policy if exists "reports_v1_read" on reports;
create policy "reports_v1_read" on reports for select using (true);
drop policy if exists "reports_v1_write" on reports;
create policy "reports_v1_write" on reports for all using (true) with check (true);

create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  action text not null,
  object_type text,
  object_id uuid,
  detail jsonb,
  created_at timestamptz not null default now()
);
alter table audit_logs enable row level security;
drop policy if exists "audit_logs_v1_read" on audit_logs;
create policy "audit_logs_v1_read" on audit_logs for select using (true);
drop policy if exists "audit_logs_v1_write" on audit_logs;
create policy "audit_logs_v1_write" on audit_logs for all using (true) with check (true);

insert into uploads (id, file_name, status) values
  ('a1000000-0000-0000-0000-000000000001', 'demo_meta_q1.csv', 'analysed'),
  ('a1000000-0000-0000-0000-000000000002', 'demo_google_search_april.csv', 'analysed'),
  ('a1000000-0000-0000-0000-000000000003', 'demo_retargeting_may.csv', 'analysed');

insert into campaigns (id, upload_id, name, platform, date_start, date_end) values
  ('b1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', 'Meta – Spring Promo', 'Meta', '2024-01-08', '2024-03-31'),
  ('b1000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000002', 'Google Search – Brand', 'Google', '2024-04-01', '2024-04-30'),
  ('b1000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000003', 'Meta – Retargeting May', 'Meta', '2024-05-01', '2024-05-31');

insert into metrics (campaign_id, metric_date, spend, impressions, clicks, conversions, ctr, cpl, cpa, roas) values
  ('b1000000-0000-0000-0000-000000000001', '2024-03-24', 1200.00, 85000, 2040, 38, 2.40, 31.58, 31.58, 4.20),
  ('b1000000-0000-0000-0000-000000000001', '2024-03-31', 1350.00, 91000, 2548, 51, 2.80, 26.47, 26.47, 5.10),
  ('b1000000-0000-0000-0000-000000000002', '2024-04-15', 980.00, 42000, 1890, 29, 4.50, 33.79, 33.79, 3.80),
  ('b1000000-0000-0000-0000-000000000002', '2024-04-30', 1100.00, 47000, 2209, 44, 4.70, 25.00, 25.00, 4.50),
  ('b1000000-0000-0000-0000-000000000003', '2024-05-15', 600.00, 31000, 1240, 22, 4.00, 27.27, 27.27, 5.80),
  ('b1000000-0000-0000-0000-000000000003', '2024-05-31', 650.00, 33000, 1386, 27, 4.20, 24.07, 24.07, 6.30);

insert into insights (campaign_id, insight_type, summary_text, summary_text_source, summary_text_confidence, summary_text_review_status, insight_bullets, insight_bullets_source, insight_bullets_confidence, insight_bullets_review_status, why_explanation, why_explanation_source, why_explanation_confidence, why_explanation_review_status) values
  ('b1000000-0000-0000-0000-000000000001', 'weekly_summary', 'Meta Spring Promo improved significantly week-on-week: CPL dropped 16% and ROAS climbed to 5.1x, driven by stronger creative engagement.', 'openai/gpt-4o', 0.91, 'unreviewed', '["CTR up 0.4pp to 2.80%", "CPL reduced from £31.58 to £26.47", "Conversions grew 34% WoW", "ROAS improved from 4.2x to 5.1x"]', 'openai/gpt-4o', 0.89, 'unreviewed', 'The creative refresh in week 2 (new video thumb) correlated with the CTR uplift. Higher click quality sent more warm visitors to the landing page, pushing conversion rate up.', 'openai/gpt-4o', 0.85, 'unreviewed'),
  ('b1000000-0000-0000-0000-000000000002', 'weekly_summary', 'Google Brand Search held strong efficiency gains across April: CPA fell 26% and ROAS reached 4.5x by month end.', 'openai/gpt-4o', 0.88, 'unreviewed', '["CTR up 0.2pp to 4.70%", "CPA down from £33.79 to £25.00", "Conversions up 52% MoM", "Spend increased only 12%"]', 'openai/gpt-4o', 0.87, 'unreviewed', 'Bid strategy switch to Target CPA in week 2 of April allowed Google to re-allocate budget toward high-intent queries, reducing wasted spend.', 'openai/gpt-4o', 0.83, 'unreviewed'),
  ('b1000000-0000-0000-0000-000000000003', 'weekly_summary', 'Retargeting campaign is the highest-ROAS segment at 6.3x — small spend but highly efficient audience.', 'openai/gpt-4o', 0.93, 'unreviewed', '["ROAS grew from 5.8x to 6.3x", "CPL down to £24.07", "CTR stable at 4.2%", "Low spend ceiling limits scale"]', 'openai/gpt-4o', 0.90, 'unreviewed', 'Retargeting warm audiences naturally convert at higher rates. The audience pool is capped at recent site visitors, so efficiency is high but volume is inherently limited.', 'openai/gpt-4o', 0.88, 'unreviewed');

insert into reports (campaign_id, title, narrative_md, narrative_md_source, narrative_md_confidence, narrative_md_review_status, status) values
  ('b1000000-0000-0000-0000-000000000001', 'Meta Spring Promo – Weekly Report', '## Meta Spring Promo\n**Period:** 24 Mar – 31 Mar 2024\n\nThis week''s campaign delivered strong efficiency gains. CTR rose to **2.80%** (+0.4pp) and CPL fell to **£26.47**, a 16% improvement. ROAS climbed to **5.1x**.\n\n**What improved:** Creative engagement, conversion rate, overall ROAS.\n**Why it happened:** The new video thumbnail introduced mid-week drove stronger click-through quality.\n\n**Recommended next step:** Increase budget by 15% and test a second creative variant.', 'openai/gpt-4o', 0.90, 'unreviewed', 'ready'),
  ('b1000000-0000-0000-0000-000000000002', 'Google Brand Search – April Wrap', '## Google Brand Search\n**Period:** Apr 2024\n\nSolid month. CPA dropped 26% to **£25.00** and ROAS hit **4.5x**. Conversions grew 52% with only a 12% spend increase.\n\n**What improved:** CPA, ROAS, conversion volume.\n**Why it happened:** Switching to Target CPA bid strategy in week 2 redirected spend toward high-intent queries.\n\n**Recommended next step:** Expand to non-brand search terms with a controlled test budget.', 'openai/gpt-4o', 0.88, 'unreviewed', 'ready');