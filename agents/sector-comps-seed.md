---
description: Seed the sector comps matrix with initial company data
subagent_type: general-purpose
run_in_background: true
---

# Sector Comps Seed Agent

You are creating the initial comparables matrix (S2) for the **{sector}** sector using the provided company names.

**Companies to seed:** {companies}

**Output paths:**
- `{sector_path}/S2_sector_comps_matrix.md`
- `{sector_path}/S3_sector_debates.md`
- `{sector_path}/S4_sector_consensus_tracker.md`

---

## Required Skills

Read and follow:
- `/.claude/skills/sector-data-model.md` — comps matrix schema, S3/S4 schemas
- `/.claude/skills/epistemic-tags.md` — tagging requirements

---

## STEP 1: Research Each Company

For each company in the list, use WebSearch to find:

1. `"{company}" market cap revenue 2025`
2. `"{company}" financial results EBITDA margin`
3. `"{company}" investor relations annual report`
4. `"{company}" EV/EBITDA P/E valuation`

Use WebFetch on financial data pages to extract key metrics.

### Required Metrics Per Company

| Metric | Units | Source Priority |
|--------|-------|----------------|
| Market Cap | $B | Exchange/financial site |
| Revenue (LTM) | $B | Latest annual report or quarterly |
| Revenue Growth (YoY) | % | Calculated from 2 years |
| EBITDA Margin | % | Latest annual or LTM |
| Net Margin | % | Latest annual or LTM |
| ROIC | % | Calculate or find reported |
| ROE | % | Latest annual |
| Net Debt / EBITDA | x | Latest balance sheet + EBITDA |
| EV/Revenue | x | Market data |
| EV/EBITDA | x | Market data |
| P/E (Forward) | x | Consensus estimates |
| FCF Yield | % | Calculate from FCF and market cap |
| Dividend Yield | % | Market data |
| Capex / Revenue | % | Latest annual |

Also collect sector-specific KPIs based on the sector type:
- **Telecom:** Subscribers (M), ARPU ($/mo), Churn (%)
- **Technology:** Users (M), Revenue per User, R&D/Revenue (%)
- **Banking:** NIM (%), NPL Ratio (%), CET1 (%), Loan Growth (%)
- **Energy:** Production (units), Reserve life (years), Lifting cost ($/unit)

If a metric is unavailable for a company, mark as `n/a` in the table.

---

## STEP 2: Write S2 — Comps Matrix

Write to: `{sector_path}/S2_sector_comps_matrix.md`

Follow the comps matrix schema from `sector-data-model.md`:

1. Create the full table with all companies as columns
2. Calculate Median and Mean for each row (excluding n/a values)
3. Add sector-specific KPI rows at the bottom
4. Note the data period and currency for each company in the column header

---

## STEP 3: Write S3 — Sector Debates (Initial)

Write to: `{sector_path}/S3_sector_debates.md`

Based on your research, identify 3-5 key sector debates. Follow the S3 schema:

```markdown
# S3: Sector Debates — {sector}

## Debate Map

### D1: {Title}
- **Bull thesis:** ...
- **Bear thesis:** ...
- **Crux variable:** {specific measurable metric}
- **Current evidence:** [brief, with S# citations]
- **Companies affected:** [list]
- **Status:** Open
```

Focus on debates that:
- Affect valuation multiples across the sector
- Involve structural changes (technology, regulation, competition)
- Have clear crux variables that can be tracked

---

## STEP 4: Write S4 — Consensus Tracker (Initial)

Write to: `{sector_path}/S4_sector_consensus_tracker.md`

```markdown
# S4: Sector Consensus Tracker — {sector}

## Consensus Estimates

| Company | Metric | Consensus | Bull Case | Bear Case | Source | Updated |
|---------|--------|-----------|-----------|-----------|--------|---------|
```

Populate with any consensus estimates found during research. If broker consensus is not freely available, leave the table structure ready for manual additions and note:

```
Note: Broker consensus data requires Bloomberg/FactSet access. Populate manually or via /sector-update.
```

---

## STEP 5: Write Summary

Write to: `{sector_path}/_summaries/S2_summary.txt`

**Keep under 500 bytes:**
```
S2 COMPS MATRIX SEEDED
Sector: {sector}
Companies: {count}
Metrics per company: {count}
Data completeness: {%} (non-n/a cells / total cells)
Median EV/EBITDA: {value}
Median Revenue Growth: {value}
Debates identified: {count}
Files: S2_sector_comps_matrix.md, S3_sector_debates.md, S4_sector_consensus_tracker.md
```

---

## STEP 6: Return

Return only:
- Number of companies seeded
- Data completeness percentage
- Notable data gaps
- Key debates identified (titles only)
- File paths created

Do NOT return full tables in conversation.
