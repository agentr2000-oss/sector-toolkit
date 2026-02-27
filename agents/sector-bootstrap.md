---
description: Synthesize discovery evidence into sector base reality (S1)
subagent_type: general-purpose
run_in_background: true
---

# Sector Bootstrap Agent

You are synthesizing research evidence into the foundational base reality document (S1) for the **{sector}** sector.

**Input files:**
- `{sector_path}/_working/discovery_notes.md` — raw evidence from discovery agent

**Output paths:**
- `{sector_path}/S1_sector_base_reality.md`
- `{sector_path}/S5_sector_source_register.md`
- `{sector_path}/_working/S1_gaps.md` — gap list for deepen agent

---

## Required Skills

Read and follow these skills (located in `Code/.claude/skills/` relative to workspace root `/Users/agentr/Claude/`):
- `sector-data-model.md` — S1 schema
- `research-standards.md` — source register format (T1-T4 tiers)
- `epistemic-tags.md` — tagging and citation format

---

## STEP 1: Read Discovery Evidence

Read `{sector_path}/_working/discovery_notes.md` to get the raw evidence collected by the discovery agent.

Review the evidence inventory:
- How many data points per S1 section?
- What's the source quality distribution (T1/T2/T3/T4)?
- Where are the quantitative vs qualitative gaps?

---

## STEP 2: Targeted Supplemental Research

Based on the discovery notes gap analysis, identify the most critical holes that would make S1 incomplete. Run up to 10 targeted searches to fill gaps that the discovery agent couldn't cover.

### Research Protocol: Search → Read → Extract

For EVERY WebSearch call:
1. Review the search results
2. Identify the 2-3 most relevant/authoritative results
3. Use WebFetch on each to read the FULL page content
4. Extract specific data points — numbers, percentages, time series

**Search snippets are for discovery. WebFetch is for evidence.**
Never cite a data point you only saw in a search snippet. Always read the full page.

### PDF Sources

When WebFetch encounters a PDF URL or a page linking to a key PDF report:
1. Use `Bash(python3 Code/templates/pdf_downloader.py "{url}" "{sector_path}/_working/")`
2. Use `Bash(python3 Code/templates/pdf_auto_extractor.py "{downloaded_path}")`
3. Read the extracted text and incorporate data points

---

## STEP 3: Build Source Register Entries

For every source used (from discovery notes + your supplemental research), create an entry for the sector source register.

Write to: `{sector_path}/S5_sector_source_register.md`

Use the format from `research-standards.md`. Start source IDs at the number provided in `{source_start_id}` (default: 1 if bootstrapping a new sector).

Set `Added By` to `sector-init` for all entries.

CRITICAL: The Reliability column MUST use ONLY these tier labels:
- T1 = Audited/regulatory primary (annual reports, regulator data, exchange filings)
- T2 = Unaudited primary (earnings calls, investor presentations, management commentary)
- T3 = Reputable secondary (industry reports, quality financial journalism)
- T4 = Unverified/opinion (blogs, social media, broker notes without data)
Do NOT use "High", "Medium", "Low", or any other labels.

---

## STEP 4: Write S1 — Sector Base Reality

Write to: `{sector_path}/S1_sector_base_reality.md`

Follow the S1 schema from `sector-data-model.md`. The document must include:

### Required Sections

1. **Industry Overview** — What the industry does, how value is created, who the key players are. Include market size estimates with sources.

2. **Value Chain Map** — Visual representation (text-based) of upstream → midstream → downstream. Name specific companies at each stage.

3. **Industry Economics** — Cost structure norms (as % of revenue), capital intensity ranges (Capex/Revenue), typical ROIC by segment, working capital patterns, scale effects.

4. **Growth Drivers** — Numbered list of structural drivers with quantified data where available. Tag each with growth/decline direction and magnitude.

5. **Regulatory Environment** — Licensing, spectrum allocation (if telecom), rate regulation, foreign ownership limits, recent policy changes.

6. **Sector KPIs** — Industry-specific metrics (e.g., ARPU, churn, subscriber growth for telecom; load factor, RPK for airlines).

7. **Benchmarks Table** — Bottom quartile / Median / Top quartile for key financial metrics. Use `[ESTIMATED]` tags where calculated from limited data; `[CONSENSUS]` where from industry reports. Every row must have >= 2 independent data points.

### Tagging Requirements

- Every non-trivial claim must carry an epistemic tag
- Every data point must cite a source register entry: `[S#]`
- Claims with only single-source support must be tagged `[REPORTED]` not `[VERIFIED]`
- Include QC footer per `epistemic-tags.md`

---

## STEP 5: Quality Pre-Check

Before finalizing, self-verify against these minimum thresholds:

```
QUALITY GATES (pre-deepen baseline):

1. Source count: >= 20 unique sources in S5 register
2. Tier distribution: >= 3 T1 sources, >= 5 T2 sources
3. Section coverage: Every S1 section has >= 2 cited data points
4. Benchmarks: Every row in benchmarks table has >= 1 data point
5. Time series: At least 2 years of data for key metrics
6. Recency: >= 3 sources from 2025 or later
```

If any gate fails, note it in the gaps file. The deepen agent will address remaining gaps.

---

## STEP 6: Write Gap List for Deepen Agent

Write to: `{sector_path}/_working/S1_gaps.md`

```markdown
# S1 Gaps — {sector}

Generated: {timestamp}

## Section-Level Gaps

| S1 Section | Evidence Quality | Data Points | What's Missing |
|------------|-----------------|-------------|----------------|
| Industry Overview | Strong/Thin/Missing | {count} | {specific gaps} |
| Value Chain | Strong/Thin/Missing | {count} | {specific gaps} |
| Industry Economics | Strong/Thin/Missing | {count} | {specific gaps} |
| Growth Drivers | Strong/Thin/Missing | {count} | {specific gaps} |
| Regulatory Environment | Strong/Thin/Missing | {count} | {specific gaps} |
| Sector KPIs | Strong/Thin/Missing | {count} | {specific gaps} |
| Benchmarks | Strong/Thin/Missing | {count} | {specific gaps} |

## Single-Source Claims (need cross-verification)

| Claim | Section | Current Source | Suggested Search Query |
|-------|---------|---------------|----------------------|
| {claim text} | {section} | S{id} | "{suggested query}" |

## Missing Quantitative Data

| Metric | Section | Currently | What's Needed |
|--------|---------|-----------|---------------|
| {metric} | {section} | Qualitative only / No data | {specific number type needed} |

## Quality Gate Failures

| Gate | Threshold | Actual | Gap |
|------|-----------|--------|-----|
| {gate} | {threshold} | {actual} | {what's needed to pass} |
```

---

## STEP 7: Write Summary

Write to: `{sector_path}/_summaries/S1_summary.txt`

**Keep under 500 bytes:**
```
S1 SECTOR BASE REALITY COMPLETE
Sector: {sector}
Market size: {value}
Key players: {count}
Growth drivers: {count}
Sources used: {count} (S{first}-S{last})
Benchmark metrics: {count}
Quality gates: {passed}/{total} passed
Gaps flagged for deepen: {count}
File: S1_sector_base_reality.md
```

---

## STEP 8: Return

Return only:
- Confirmation that S1, source register, and gap list were written
- Summary stats (market size, player count, source count)
- Quality gate pass/fail summary
- Gap count flagged for deepen agent
- File paths created
- Any research areas where data was particularly limited

Do NOT return the full document content in conversation.
