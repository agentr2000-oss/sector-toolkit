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

Read and follow these skills (located in `Code/.claude/skills/` relative to workspace root `/Users/agentr/Claude/`):
- `sector-data-model.md` — comps matrix schema, S3/S4 schemas
- `research-standards.md` — source register format (T1-T4 tiers)
- `epistemic-tags.md` — tagging and citation format

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
| Revenue - Core Business | $B | Annual report segment data |
| Revenue - Enterprise/B2B | $B | Annual report segment data |
| Free Cash Flow (LTM) | $B | EBITDA - Capex - Tax - Interest |
| Total Debt (Gross) | $B | Latest balance sheet |

Also collect sector-specific KPIs based on the sector type:
- **Telecom:** Subscribers (M), ARPU ($/mo), Churn (%)
- **Technology:** Users (M), Revenue per User, R&D/Revenue (%)
- **Banking:** NIM (%), NPL Ratio (%), CET1 (%), Loan Growth (%)
- **Energy:** Production (units), Reserve life (years), Lifting cost ($/unit)

If a metric is unavailable for a company, mark as `n/a` in the table.

---

### STEP 1.5: Classify Companies

After researching each company, assign a classification:

| Classification | Definition | KPI Applicability |
|---------------|------------|-------------------|
| Operator | Primary revenue from network services | All metrics apply |
| Infrastructure | Towers/fiber/data centers | Skip ARPU, subscribers, churn |
| Enterprise | B2B connectivity/cloud | Skip consumer ARPU, churn |
| Government/PSU | State-owned, non-market dynamics | Flag limited data; skip valuation multiples |

Rules:
- Classify based on revenue composition (>50% from category = that classification)
- Write classification as a row in S2
- Update the company object in _sector_config.json (change "pending" → actual classification)
- If unsure, default to "Operator" and add a note: "[CLASSIFICATION UNCERTAIN]"
- The user can override during the review phase

Classification determines which KPI rows are populated vs marked "n/a" for that company.

---

## STEP 2: Write S2 — Comps Matrix

Write to: `{sector_path}/S2_sector_comps_matrix.md`

Follow the comps matrix schema from `sector-data-model.md`:

1. Create the full table with all companies as columns
2. Calculate Median and Mean for each row (excluding n/a values)
3. Add sector-specific KPI rows at the bottom
4. Note the data period and currency for each company in the column header

---

## STEP 3: Write S3 — Sector Debates

Write to: `{sector_path}/S3_sector_debates.md`

Identify 4-6 key sector debates. For each, use this structure:

```markdown
# S3: Sector Debates — {sector}

## Debate Map

### D{n}: {Title}

**Core question:** {single sentence}
**Bull thesis:** {2-3 sentences with citations}
**Bear thesis:** {2-3 sentences with citations}

**Crux variable:** {specific measurable metric}
**Current value:** {value} [TAG] [S#]
**Bull threshold:** {value that confirms bull}
**Bear threshold:** {value that confirms bear}

**Scenario Impact:**
| Variable | Bull | Base | Bear |
|----------|------|------|------|
| {crux var} | {value} | {value} | {value} |
| Sector EBITDA impact | +X% | — | -X% |

**Catalyst Calendar:**
| Date/Event | What to Check | Source |
|------------|---------------|--------|

**Companies affected:** {list with direction of impact}
**Status:** Open | Leaning Bull | Leaning Bear
```

IMPORTANT: Every debate MUST include the Scenario Impact table and Catalyst
Calendar. If you cannot quantify impact precisely, state your best estimate
with [ESTIMATED] tag and show your methodology (e.g., "15% tariff hike ×
60% prepaid mix × 75% operator revenue share = ~7% sector EBITDA uplift").
Order-of-magnitude estimates are acceptable; omitting the table is not.

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

## STEP 5: Write Summaries

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

Also write to: `{sector_path}/_summaries/S3_summary.txt`

**Keep under 500 bytes:**
```
S3 SECTOR DEBATES SEEDED
Sector: {sector}
Debates: {count}
Debates with Scenario Impact tables: {count}
Debates with Catalyst Calendars: {count}
Key debates: {D1 title}, {D2 title}, ...
File: S3_sector_debates.md
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
