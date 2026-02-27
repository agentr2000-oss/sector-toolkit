# Sector Data Model

This skill defines all file schemas, the comps matrix specification, cross-reference rules, and config JSON schemas for the recursive sector analyst system.

## Sector Config Schema

File: `{Sector}/config.json`

```json
{
  "version": "1.0",
  "sector_name": "India_Telecom",
  "display_name": "India Telecom",
  "created_at": "2026-02-26T10:00:00Z",
  "last_updated": "2026-02-26T14:30:00Z",
  "source_register_next_id": 101,
  "companies": [
    {
      "name": "Jio Platforms",
      "slug": "Jio_Platforms",
      "classification": "Operator",
      "added_at": "2026-02-26T11:00:00Z",
      "status": "complete",
      "source_id_block": [1, 100]
    }
  ],
  "sector_files": {
    "S1": "S1_sector_base_reality.md",
    "S2": "S2_sector_comps_matrix.md",
    "S3": "S3_sector_debates.md",
    "S4": "S4_sector_consensus_tracker.md",
    "S5_map": "S5_sector_source_map.md",
    "S5_register": "S5_sector_source_register.md"
  }
}
```

### Config Update Rules
- `source_register_next_id`: Increment by 100 per company added
- `companies`: Append only — never remove entries
- `last_updated`: Update on any config change
- `classification`: Valid values: `"Operator"`, `"Infrastructure"`, `"Enterprise"`, `"Government/PSU"`, `"pending"`. Set to `"pending"` at sector-init time. The comps-seed agent updates it to the correct value during STEP 1.5. If the comps-seed agent cannot determine classification, it remains `"pending"` and the user is prompted during review.

## Sector Checkpoint Schema

File: `{Sector}/_sector_checkpoint.json`

```json
{
  "version": "1.0",
  "sector_name": "India_Telecom",
  "created_at": "2026-02-26T10:00:00Z",
  "last_updated": "2026-02-26T10:30:00Z",
  "phases": {
    "bootstrap": {"status": "pending|in_progress|completed", "timestamp": null},
    "source_map": {"status": "pending|in_progress|completed", "timestamp": null},
    "comps_seed": {"status": "pending|in_progress|completed", "timestamp": null},
    "user_review": {"status": "pending|completed", "timestamp": null}
  }
}
```

## Company Checkpoint Schema

File: `{Sector}/companies/{Company}/_company_checkpoint.json`

```json
{
  "version": "1.0",
  "company": "Jio Platforms",
  "sector": "India_Telecom",
  "sector_path": "/Users/agentr/Claude/2026 Master Investment Workflow/Sectors/India_Telecom",
  "created_at": "2026-02-26T11:00:00Z",
  "last_updated": "2026-02-26T14:30:00Z",
  "source_id_block": [1, 100],
  "phases": {
    "intake": {"status": "pending", "timestamp": null},
    "source_map": {"status": "pending", "timestamp": null},
    "source_index": {"status": "pending", "timestamp": null},
    "evidence": {"status": "pending", "timestamp": null},
    "base_reality": {"status": "pending", "timestamp": null},
    "debates": {"status": "pending", "timestamp": null},
    "valuation": {"status": "pending", "timestamp": null},
    "archetype_growth": {"status": "pending", "timestamp": null},
    "archetype_value": {"status": "pending", "timestamp": null},
    "archetype_quality": {"status": "pending", "timestamp": null},
    "archetype_momentum": {"status": "pending|skipped", "timestamp": null},
    "council": {"status": "pending", "timestamp": null},
    "synthesis": {"status": "pending", "timestamp": null},
    "monitoring": {"status": "pending", "timestamp": null},
    "delta": {"status": "pending", "timestamp": null},
    "delta_applied": {"status": "pending", "timestamp": null},
    "complete": {"status": "pending", "timestamp": null}
  }
}
```

### Phase Dependencies (linear)

```
intake → source_map → source_index → evidence → base_reality → debates →
valuation → [archetype_growth, archetype_value, archetype_quality, archetype_momentum] →
council → synthesis → monitoring → delta → delta_applied → complete
```

Note: The four archetype phases can run in parallel. `archetype_momentum` may be `skipped` if the company lacks sufficient price/momentum data.

## Comps Matrix Schema (S2)

File: `S2_sector_comps_matrix.md`

```markdown
# Sector Comps Matrix — {Sector_Name}

Last updated: {ISO_timestamp}
Companies: {count}

## Comps Table

| Metric | Units | {Company_1} | {Company_2} | ... | Median | Mean |
|--------|-------|-------------|-------------|-----|--------|------|
| Market Cap | $B | 120.5 | 45.2 | | 82.9 | 82.9 |
| Revenue (LTM) | $B | 28.4 | 15.1 | | 21.8 | 21.8 |
| Revenue Growth (YoY) | % | 18.2 | 12.5 | | 15.4 | 15.4 |
| EBITDA Margin | % | 52.3 | 41.8 | | 47.1 | 47.1 |
| Net Margin | % | 18.5 | 12.1 | | 15.3 | 15.3 |
| ROIC | % | 14.2 | 9.8 | | 12.0 | 12.0 |
| ROE | % | 22.1 | 15.3 | | 18.7 | 18.7 |
| Net Debt / EBITDA | x | 1.8 | 2.4 | | 2.1 | 2.1 |
| EV/Revenue | x | 8.2 | 4.5 | | 6.4 | 6.4 |
| EV/EBITDA | x | 15.7 | 10.8 | | 13.3 | 13.3 |
| P/E (Forward) | x | 32.1 | 18.5 | | 25.3 | 25.3 |
| FCF Yield | % | 2.8 | 4.1 | | 3.5 | 3.5 |
| Dividend Yield | % | 0.3 | 1.2 | | 0.8 | 0.8 |
| Capex / Revenue | % | 22.5 | 18.3 | | 20.4 | 20.4 |
| Subscribers / Users | M | 481 | 380 | | 431 | 431 |
| ARPU | $/mo | 2.45 | 3.10 | | 2.78 | 2.78 |

## Notes
- LTM = Last Twelve Months as of most recent reported quarter
- Forward P/E uses consensus estimates where available, else company guidance
- Sector-specific rows (Subscribers, ARPU) added based on sector type
```

### Comps Matrix Rules
1. **Columns grow right** — each new company adds a column
2. **Median/Mean recalculated** after each company addition
3. **Sector-specific rows** added during `/sector-init` based on sector type
4. **Currency normalization** — all values converted to USD for cross-border comparisons (original currency noted in company column header if non-USD)
5. **Data period** — all data from most recently reported period

## Deliverable Schemas

### S1 — Sector Base Reality

```markdown
# S1: Sector Base Reality — {Sector_Name}

## Industry Overview
[2-3 paragraphs: what the industry does, value chain, key players]

## Value Chain Map
[Upstream → Midstream → Downstream with key players at each stage]

## Industry Economics
- Typical cost structure breakdown (% of revenue)
- Capital intensity norms (Capex/Revenue ranges)
- ROIC ranges by segment (low/mid/high)
- Working capital characteristics
- Scale economics (if applicable)

## Growth Drivers
[Numbered list of structural growth/decline drivers with data]

## Regulatory Environment
[Key regulations, licensing requirements, policy risks]

## Sector KPIs
[Industry-specific metrics that matter: ARPU, churn, load factor, etc.]

## Benchmarks
| Metric | Bottom Quartile | Median | Top Quartile |
|--------|-----------------|--------|--------------|
[Populated from known data, updated as companies are added]

## Financial Time Series
[3-5 year revenue, EBITDA, capex, net debt for top operators — table format]

## Sector-Specific Asset Table
[Sector-dependent: spectrum MHz for telecom, reserves for energy, AUM for banking.
 If not applicable to sector type, note "N/A for this sector" and omit.]

## Revenue Segmentation
[Industry-level revenue by service/product type, with per-operator split if available]

## Sector Model Inputs
[Explicit DCF assumption defaults: revenue growth, margins, capex intensity, WACC range]
```

### S3 — Sector Debates

```markdown
# S3: Sector Debates — {Sector_Name}

## Debate Map

### D1: {Debate Title}
- **Bull thesis:** [1-2 sentences]
- **Bear thesis:** [1-2 sentences]
- **Crux variable:** {metric that would resolve the debate}
- **Current evidence:** [brief summary with source refs]
- **Companies affected:** [list]
- **Status:** Open | Leaning Bull | Leaning Bear | Resolved

### D2: {Debate Title}
[same structure]
```

### S4 — Consensus Tracker

```markdown
# S4: Sector Consensus Tracker — {Sector_Name}

## Consensus Estimates

| Company | Metric | Consensus | Bull Case | Bear Case | Source | Updated |
|---------|--------|-----------|-----------|-----------|--------|---------|
```

### Company Deliverable: 00_intake.md

```markdown
# 00: Company Intake — {Company_Name}

## Identity
- **Full Name:** {legal name}
- **Ticker:** {exchange:ticker}
- **Sector:** {sector_name}
- **Sub-sector:** {if applicable}
- **Domicile:** {country}
- **Reporting Currency:** {currency}
- **Fiscal Year End:** {month}
- **Market Cap:** {value as of date}

## Sector Alignment
- **Primary sector match:** {sector_name} — {alignment rationale}
- **Revenue from primary sector:** {%}
- **Cross-sector exposure:** {other sectors, if any}

## Key Questions
[3-5 company-specific questions the analysis should address]

## Source ID Block
- Allocated: S{start} to S{end}
- Next available: S{start}
```

### Company Deliverable: 02_base_reality.md

```markdown
# 02: Base Reality — {Company_Name}

## Business Model
[Description with epistemic tags and citations]

## Revenue Decomposition
### {Segment 1}
- Revenue: {value} [TAG] [S#]
- Growth: {%} [TAG] [S#]
- Drivers: {volume × price breakdown}

### {Segment 2}
[same structure]

## Cost Structure
| Cost Line | Value | % Revenue | Trend | Source |
|-----------|-------|-----------|-------|--------|

## Driver Tree
```
Revenue
├── {Segment 1}: {driver_1} × {driver_2}
│   ├── {driver_1}: {value} ({trend})
│   └── {driver_2}: {value} ({trend})
├── {Segment 2}: {driver_1} × {driver_2}
```

## Capital Allocation
[Capex, M&A, dividends, buybacks with data]

## Sector Benchmarks
| Metric | {Company} | Sector Median | Percentile |
|--------|-----------|---------------|------------|
[Pulled from S2 comps matrix]

## QC Footer
[Per epistemic-tags.md]
```

## Summary File Standard

Every agent output must include a summary file in `_summaries/`:

- **Max size:** 500 bytes
- **Format:** Plain text, no markdown headers
- **Content:** Phase name, status, key metrics (3-5 numbers), file paths created
- **Naming:** `{phase_name}_summary.txt`

Example:
```
EVIDENCE COLLECTION COMPLETE
Sources processed: 8 (P1: 5, P2: 3)
Evidence entries: 127 (EL-001 to EL-127)
Confidence: High=89, Medium=31, Low=7
Files: 01b_evidence_log.md, _summaries/01b_evidence_summary.txt
```

## Cross-Reference Rules

1. **Company → Sector:** Use `S1`, `S2`, etc. to reference sector files by code
2. **Company → Company:** Use `[{Company}/02]` format (e.g., `[Airtel/02]`)
3. **Sector → Company:** Use `{Company}/02` in prose, or link to file path
4. **Within company:** Use document codes: `02`, `03`, `04_valuation`, etc.
5. **Evidence:** Always cite via `[S# / EL-###]` format per epistemic-tags.md
