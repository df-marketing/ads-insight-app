# Test Plan — ads-insight-app

## Success Scenario (manual walkthrough)

1. Open the app at `/` — seed demo reports visible without logging in ✅
2. Click a demo report → insight cards load with metric name, change badge, explanation ✅
3. Click "Upload Report" → file picker opens ✅
4. Select `q1_marketing_performance.csv` (valid, < 10 MB) → progress indicator shows ✅
5. After upload: redirected to new report detail page with `status = processing` skeleton ✅
6. Within 10 s: ≥3 insight cards appear, sorted highest priority first ✅
7. Click "Flag" on one insight → badge updates to `flagged` immediately ✅
8. Refresh page → flagged status still shows (DB persisted) ✅
9. Click "Delete Report" → confirm dialog appears → confirm → redirected to list → report gone ✅
10. Report no longer appears in reports list ✅

## Empty State Tests
- Fresh load with no uploads beyond seed data → reports list shows "Upload your first report" CTA ✅
- Report with `status = error` → detail page shows error message + retry button ✅

## Error / Edge Case Tests
- Upload a `.jpg` file → rejected at client with "Please upload a CSV file" ✅
- Upload a CSV > 10 MB → blocked before upload with size error message ✅
- Upload a CSV with unrecognised columns (e.g., a contacts export) → API returns structured error → UI shows "We couldn't read this file" message ✅
- Simulate OpenAI timeout: mock 35 s delay → UI shows "Analysis is taking longer than expected" with retry ✅
- Click "Accept" and "Flag" on the same insight in sequence → only the last status persists ✅

## Security Checks
- Open browser DevTools → Network tab → confirm `OPENAI_API_KEY` never appears in any request or response ✅
- Inspect JS bundle → confirm no `service_role` key present ✅
- Check Supabase Storage bucket policy: direct public URL for CSV file returns 403 (private bucket) ✅
