create table if not exists reports (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  filename text not null,
  original_csv_url text,
  row_count integer,
  detected_columns jsonb,
  status text not null default 'processing',
  created_at timestamptz not null default now()
);

alter table reports enable row level security;
drop policy if exists "reports_v1_read" on reports;
create policy "reports_v1_read" on reports for select using (true);
drop policy if exists "reports_v1_write" on reports;
create policy "reports_v1_write" on reports for all using (true) with check (true);

create table if not exists insights (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  report_id uuid not null references reports(id) on delete cascade,
  metric_name text not null,
  metric_value text,
  change_direction text,
  change_percent numeric,
  explanation text,
  explanation_source text,
  explanation_confidence numeric,
  explanation_review_status text default 'unreviewed',
  category text,
  priority_score numeric,
  created_at timestamptz not null default now()
);

alter table insights enable row level security;
drop policy if exists "insights_v1_read" on insights;
create policy "insights_v1_read" on insights for select using (true);
drop policy if exists "insights_v1_write" on insights;
create policy "insights_v1_write" on insights for all using (true) with check (true);

create table if not exists upload_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  report_id uuid references reports(id) on delete set null,
  event_type text not null,
  detail jsonb,
  created_at timestamptz not null default now()
);

alter table upload_events enable row level security;
drop policy if exists "upload_events_v1_read" on upload_events;
create policy "upload_events_v1_read" on upload_events for select using (true);
drop policy if exists "upload_events_v1_write" on upload_events;
create policy "upload_events_v1_write" on upload_events for all using (true) with check (true);

insert into reports (id, filename, row_count, detected_columns, status) values
  ('a1000000-0000-0000-0000-000000000001', 'q1_marketing_performance.csv', 90, '["date","campaign","impressions","clicks","ctr","spend","conversions","cpa","roas"]', 'complete'),
  ('a1000000-0000-0000-0000-000000000002', 'social_ads_june.csv', 45, '["date","platform","spend","reach","engagement_rate","link_clicks","purchases"]', 'complete'),
  ('a1000000-0000-0000-0000-000000000003', 'email_campaigns_q2.csv', 30, '["send_date","campaign_name","sent","opens","open_rate","clicks","click_rate","unsubscribes"]', 'complete');

insert into insights (report_id, metric_name, metric_value, change_direction, change_percent, explanation, explanation_source, explanation_confidence, explanation_review_status, category, priority_score) values
  ('a1000000-0000-0000-0000-000000000001', 'ROAS', '4.2', 'up', 18.0, 'Return on ad spend improved 18% vs last quarter, driven by stronger performance on Google Search campaigns in March. Your spend efficiency is above the 3.5x industry benchmark.', 'openai', 0.91, 'unreviewed', 'efficiency', 95),
  ('a1000000-0000-0000-0000-000000000001', 'CPA', '$14.30', 'down', -12.0, 'Cost per acquisition dropped 12%, meaning you are paying less to win each customer. This is a positive trend likely linked to improved ad targeting in week 10–12.', 'openai', 0.87, 'unreviewed', 'cost', 88),
  ('a1000000-0000-0000-0000-000000000001', 'CTR', '3.1%', 'down', -5.0, 'Click-through rate dipped slightly in February. Ad creative fatigue may be a factor — consider refreshing visuals for campaigns running longer than 30 days.', 'openai', 0.82, 'unreviewed', 'engagement', 72),
  ('a1000000-0000-0000-0000-000000000002', 'Engagement Rate', '4.8%', 'up', 22.0, 'Engagement rate on social ads jumped 22% in June. Video creatives on Instagram outperformed static images by a wide margin — lean into short-form video for July.', 'openai', 0.89, 'unreviewed', 'engagement', 90),
  ('a1000000-0000-0000-0000-000000000002', 'Spend', '$8,450', 'up', 10.0, 'Total spend increased 10% month-over-month. Without a proportional increase in purchases, monitor ROAS closely in the next reporting period.', 'openai', 0.85, 'unreviewed', 'cost', 80),
  ('a1000000-0000-0000-0000-000000000003', 'Open Rate', '28.4%', 'up', 9.0, 'Email open rates are above the 20–25% industry average and improved 9% this quarter. Subject line A/B tests in May appear to have had a measurable positive effect.', 'openai', 0.93, 'accepted', 'engagement', 85),
  ('a1000000-0000-0000-0000-000000000003', 'Unsubscribes', '312', 'up', 34.0, 'Unsubscribe volume rose 34% in June — the highest single-month spike this quarter. Review the June 18 campaign for overly frequent sends or mismatched audience targeting.', 'openai', 0.88, 'unreviewed', 'risk', 92);

insert into upload_events (report_id, event_type, detail) values
  ('a1000000-0000-0000-0000-000000000001', 'upload_complete', '{"file_size_kb": 48}'),
  ('a1000000-0000-0000-0000-000000000001', 'ai_analysis_complete', '{"insight_count": 3}'),
  ('a1000000-0000-0000-0000-000000000002', 'upload_complete', '{"file_size_kb": 22}'),
  ('a1000000-0000-0000-0000-000000000002', 'ai_analysis_complete', '{"insight_count": 2}'),
  ('a1000000-0000-0000-0000-000000000003', 'upload_complete', '{"file_size_kb": 15}'),
  ('a1000000-0000-0000-0000-000000000003', 'ai_analysis_complete', '{"insight_count": 2}');