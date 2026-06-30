# Test Plan — ads-insight-app

## v1 Success Scenario (manual walkthrough)
1. Open the app — **expect:** 3 demo campaign cards visible, no login prompt
2. Click "Try demo data" banner — **expect:** demo campaign pre-selected
3. Click **Analyse** on the demo campaign — **expect:** loading skeleton appears, then insight cards render
4. Check Insight Cards — **expect:** CTR, CPL, CPA, ROAS shown with ↑/↓ delta badges
5. Read Performance Summary block — **expect:** 2–4 sentence AI narrative present
6. Open Ready-to-Send Report — **expect:** clean formatted report with headline, bullets, narrative
7. Click **Copy report** — **expect:** clipboard receives formatted text (paste into Notes to verify)
8. Upload `demo_meta_q1.csv` via drag-and-drop — **expect:** parsed preview table shows columns
9. Confirm upload — **expect:** new campaign row appears on home page
10. Click **Analyse** on new upload — **expect:** full insight + report generated and stored

## Empty States
- Visit `/reports` with no uploads → show "No reports yet — upload a CSV to get started"
- Upload a CSV with zero data rows → show "No metric rows found. Check your file and try again."
- Campaigns with no metrics → insight cards show "—" not blank or 0

## Error Cases
- Upload a `.pdf` file → "Unsupported file type. Please upload a CSV."
- Upload a CSV missing required columns (spend, clicks) → list missing columns by name
- OpenAI API timeout → show rule-based metric cards; narrative block shows "AI analysis unavailable — showing raw data."
- Delete report → confirm modal shown; after confirm, row gone from list; audit log entry present in Supabase

## Edge Cases
- Very large CSV (1000+ rows) → upload completes; only first/last period rows used for comparison
- All metric values are zero → delta badges show "—" not NaN or Infinity
- ROAS column absent in CSV → card hidden, not broken
