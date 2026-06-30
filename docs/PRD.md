# Product Requirements — ads-insight-app

## Problem
Media buyers and marketers spend hours manually reading campaign data, writing performance summaries, and turning spreadsheets into stakeholder-ready reports. This app automates that: upload a CSV, get a plain-English analysis and a copy-ready report in seconds.

## Target Users
- Performance marketers / media buyers
- Marketing analysts
- Founders reviewing their own ad spend
- Non-technical clients who need simple explanations

## Core Objects
- **Upload** — the raw CSV file event
- **Campaign** — a named ad campaign (Meta, Google, etc.)
- **Metrics** — per-date performance rows (spend, impressions, clicks, conversions, CTR, CPL, CPA, ROAS)
- **Insight** — AI-generated summary, bullets, and why-explanation for a campaign
- **Report** — the final formatted narrative, ready to copy/export

## MVP Checklist (v1 must-haves)
- [ ] CSV upload with parsing and column mapping
- [ ] Parsed data preview table before analysis
- [ ] AI analysis: performance summary + insight bullets + why-explanation
- [ ] Insight cards showing key metric deltas
- [ ] Ready-to-send report view with one-click copy
- [ ] Demo dataset pre-loaded (app works without a login)
- [ ] Graceful empty/error/loading states

## Non-Goals (v1)
- Meta / Google Ads API direct connection
- User login and per-user history
- PDF/Markdown export
- Email or Slack delivery
- Multi-user teams
- Predictive ML or budget forecasting

## Success Scenario
A visitor lands on the app, clicks "Try demo data", sees three real campaigns with metric cards and AI-generated insight bullets, opens the ready-to-send report for one campaign, and copies the narrative to their clipboard — all within 30 seconds, no login required.
