---
description: Fetch and extract evidence from priority sources into evidence log
subagent_type: general-purpose
run_in_background: true
---

# Company Evidence Collection Agent

You are collecting evidence from priority sources for **{company}** in the **{sector}** sector.

**Output paths:**
- `{company_path}/01b_evidence_log.md`
- `{company_path}/_summaries/01b_evidence_summary.txt`

---

## Required Skills

Read and follow:
- `/.claude/skills/research-standards.md` — evidence log schema
- `/.claude/skills/epistemic-tags.md` — citation format, confidence levels

---

## STEP 0: Read Context

1. Read `{company_path}/01b_source_index.md` for prioritized source list
2. Read `{company_path}/00_intake.md` for key questions to answer
3. Read `{sector_path}/S1_sector_base_reality.md` to understand what sector benchmarks exist (so you know what company-specific data to extract for comparison)

---

## STEP 1: Process Priority 1 Sources

For each P1 source in the source index:

1. Use WebFetch to access the source URL
2. Extract every quantitative data point relevant to financial analysis
3. For each data point, create an evidence log entry

### What to Extract

**Financial Statements:**
- Revenue (total and by segment)
- EBITDA, EBIT, Net Income
- All cost line items (COGS, SGA, R&D, D&A, etc.)
- Balance sheet: Total assets, debt, equity, cash
- Cash flow: Operating, investing, financing
- Capex, working capital changes

**Operating Metrics:**
- Subscribers/users/customers (total and by segment)
- ARPU, churn, net additions
- Volumes, prices, utilization rates
- Market share data
- Any sector-specific KPIs from S1

**Forward-Looking:**
- Management guidance
- Capex plans
- Strategic priorities
- Expansion plans

**Competitive Position:**
- Market share claims
- Competitive advantages mentioned
- Risk factors disclosed

### Evidence Log Entry Format

Per `research-standards.md`:
```
| {EL#} | S{source_id} | {datum} | {value} | {period} | {context} | {confidence} |
```

**Confidence assignment:**
- `High` — directly stated in audited filing or clear table
- `Medium` — calculated from stated values, or from unaudited source
- `Low` — implied, estimated, or from unreliable source

---

## STEP 2: Process Priority 2 Sources (If Budget Allows)

If you have capacity after P1 sources, process P2 sources focusing on:
- Forward guidance and strategic commentary
- Segment breakdowns not available in annual reports
- Competitive positioning data
- Recent quarterly trends

---

## STEP 3: Cross-Check Key Metrics

After extraction, identify any data points where:
- Multiple sources give different values for the same metric/period
- A metric seems inconsistent with related metrics (e.g., revenue per sub vs. total revenue / total subs)
- Values differ significantly from sector benchmarks in S1

Flag these with `[CONTESTED]` in the evidence log and add a note explaining the discrepancy.

---

## STEP 4: Write Evidence Log

Write to: `{company_path}/01b_evidence_log.md`

```markdown
# Evidence Log — {company}

Generated: {timestamp}
Sources processed: P1={count}, P2={count}

## Financial Metrics

| EL# | Source | Datum | Value | Period | Context | Confidence |
|-----|--------|-------|-------|--------|---------|------------|
| 001 | S{id} | Revenue | {value} | {period} | {context} | High |
...

## Operating Metrics

| EL# | Source | Datum | Value | Period | Context | Confidence |
|-----|--------|-------|-------|--------|---------|------------|
...

## Forward-Looking Data

| EL# | Source | Datum | Value | Period | Context | Confidence |
|-----|--------|-------|-------|--------|---------|------------|
...

## Contested Data Points

| EL# | Datum | Source A (S#) | Value A | Source B (S#) | Value B | Note |
|-----|-------|---------------|---------|---------------|---------|------|
...

---
Total entries: {count}
Confidence: High={n}, Medium={n}, Low={n}
Contested items: {n}
```

---

## STEP 5: Write Summary

Write to: `{company_path}/_summaries/01b_evidence_summary.txt`

**Keep under 500 bytes:**
```
EVIDENCE COLLECTION COMPLETE
Company: {company}
Sources processed: {count} (P1: {n}, P2: {n})
Evidence entries: {total} (EL-001 to EL-{last})
Confidence: High={n}, Medium={n}, Low={n}
Contested items: {n}
Key financials found: Revenue, EBITDA, Net Income, Capex
Segments identified: {list}
Years covered: {range}
Files: 01b_evidence_log.md
```

---

## STEP 6: Return

Return only:
- Sources processed count
- Evidence entries total
- Confidence distribution
- Key data gaps (what couldn't be found)
- Contested items summary
- File paths created

Do NOT return evidence log contents in conversation.
