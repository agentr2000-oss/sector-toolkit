---
description: Research and generate sector base reality (S1) for a new sector
subagent_type: general-purpose
run_in_background: true
---

# Sector Bootstrap Agent

You are researching the **{sector}** sector to create the foundational base reality document (S1).

**Output path:** `{sector_path}/S1_sector_base_reality.md`

---

## Required Skills

Read and follow these skills:
- `/.claude/skills/epistemic-tags.md` — tagging and citation format
- `/.claude/skills/research-standards.md` — source register format
- `/.claude/skills/sector-data-model.md` — S1 schema

---

## STEP 1: Research the Sector

Use WebSearch to gather comprehensive sector data. Run these queries:

1. `"{sector}" industry overview market size 2025`
2. `"{sector}" value chain analysis`
3. `"{sector}" cost structure economics margins`
4. `"{sector}" industry ROIC return on capital`
5. `"{sector}" growth drivers trends 2025 2026`
6. `"{sector}" regulatory environment policy`
7. `"{sector}" key performance indicators KPIs`
8. `"{sector}" competitive landscape market share`

For each promising result, use WebFetch to extract detailed data points.

---

## STEP 2: Build Source Register Entries

For every source used, create an entry for the sector source register.

Write to: `{sector_path}/S5_sector_source_register.md`

Use the format from `research-standards.md`. Start source IDs at the number provided in `{source_start_id}` (default: 1 if bootstrapping a new sector).

Set `Added By` to `sector-init` for all entries.

---

## STEP 3: Write S1 — Sector Base Reality

Write to: `{sector_path}/S1_sector_base_reality.md`

Follow the S1 schema from `sector-data-model.md`. The document must include:

### Required Sections

1. **Industry Overview** — What the industry does, how value is created, who the key players are. Include market size estimates with sources.

2. **Value Chain Map** — Visual representation (text-based) of upstream → midstream → downstream. Name specific companies at each stage.

3. **Industry Economics** — Cost structure norms (as % of revenue), capital intensity ranges (Capex/Revenue), typical ROIC by segment, working capital patterns, scale effects.

4. **Growth Drivers** — Numbered list of structural drivers with quantified data where available. Tag each with growth/decline direction and magnitude.

5. **Regulatory Environment** — Licensing, spectrum allocation (if telecom), rate regulation, foreign ownership limits, recent policy changes.

6. **Sector KPIs** — Industry-specific metrics (e.g., ARPU, churn, subscriber growth for telecom; load factor, RPK for airlines).

7. **Benchmarks Table** — Bottom quartile / Median / Top quartile for key financial metrics. Use `[ESTIMATED]` tags where calculated from limited data; `[CONSENSUS]` where from industry reports.

### Tagging Requirements

- Every non-trivial claim must carry an epistemic tag
- Every data point must cite a source register entry: `[S#]`
- Include QC footer per `epistemic-tags.md`

---

## STEP 4: Write Summary

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
File: S1_sector_base_reality.md
```

---

## STEP 5: Return

Return only:
- Confirmation that S1 and source register entries were written
- Summary stats (market size, player count, source count)
- File paths created
- Any research gaps or areas where data was limited

Do NOT return the full document content in conversation.
