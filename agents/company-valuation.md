---
description: Generate valuation document anchored to sector comps
subagent_type: general-purpose
run_in_background: true
---

# Company Valuation Agent

You are generating the valuation document (04_valuation) for **{company}** in the **{sector}** sector.

This is a multi-methodology valuation anchored to the sector comps matrix (S2), not a standalone DCF. The goal is to triangulate intrinsic value from multiple approaches and identify where the market price diverges.

**Output paths:**
- `{company_path}/04_valuation.md`
- `{company_path}/_summaries/04_valuation_summary.txt`

---

## Required Skills

Read and follow:
- `/.claude/skills/epistemic-tags.md` — tagging, citations
- `/.claude/skills/sector-data-model.md` — comps matrix structure

---

## STEP 0: Read All Inputs

Read these files from disk (full content):

1. `{company_path}/02_base_reality.md` — financial data, driver tree
2. `{company_path}/03_market_debates.md` — crux variables, scenarios
3. `{sector_path}/S2_sector_comps_matrix.md` — peer multiples
4. `{company_path}/01b_evidence_log.md` — source data

---

## STEP 1: Relative Valuation (Comps-Based)

Using S2 comps matrix multiples:

### EV/EBITDA Approach
```markdown
| Scenario | Multiple | EBITDA | EV | Net Debt | Equity Value | Per Share |
|----------|----------|--------|-----|----------|--------------|-----------|
| Sector median | {x} | {value} | {value} | {value} | {value} | {value} |
| Premium (+1 SD) | {x} | {value} | {value} | {value} | {value} | {value} |
| Discount (-1 SD) | {x} | {value} | {value} | {value} | {value} | {value} |
```

### EV/Revenue Approach
[Same table structure]

### P/E Approach
[Same table structure]

For each approach:
- Justify why the company deserves a premium/discount vs sector median
- Reference specific debates from 03 that affect the multiple
- Tag assumptions: `[ESTIMATED]` for calculated values, `[CONSENSUS]` for market data

---

## STEP 2: Intrinsic Valuation (Simplified DCF)

Build a 5-year simplified DCF:

```markdown
| Item | Year 1 | Year 2 | Year 3 | Year 4 | Year 5 | Terminal |
|------|--------|--------|--------|--------|--------|----------|
| Revenue | | | | | | |
| Growth % | | | | | | |
| EBITDA | | | | | | |
| Margin % | | | | | | |
| Capex | | | | | | |
| FCF | | | | | | |
```

### Assumptions
- Revenue growth: tied to crux variables from 03
- Margins: anchored to sector benchmarks from S2
- Capex: based on capital allocation analysis from 02
- Terminal growth: {rate} — justified by {reasoning}
- WACC: {rate} — based on {methodology}

### Scenarios

| Scenario | Revenue CAGR | Terminal Margin | WACC | Terminal Growth | Equity Value/Share |
|----------|-------------|----------------|------|----------------|-------------------|
| Bull | {%} | {%} | {%} | {%} | {value} |
| Base | {%} | {%} | {%} | {%} | {value} |
| Bear | {%} | {%} | {%} | {%} | {value} |

Map each scenario to debate resolutions:
- Bull = which debates resolve favorably?
- Bear = which debates resolve unfavorably?

---

## STEP 3: Valuation Summary Football Field

```markdown
## Valuation Range

| Method | Bear | Base | Bull | Weight |
|--------|------|------|------|--------|
| EV/EBITDA comps | {value} | {value} | {value} | {%} |
| EV/Revenue comps | {value} | {value} | {value} | {%} |
| P/E comps | {value} | {value} | {value} | {%} |
| Simplified DCF | {value} | {value} | {value} | {%} |
| **Weighted** | **{value}** | **{value}** | **{value}** | 100% |

Current market price: {price} ({date})
Implied upside/downside to base: {%}
```

---

## STEP 4: Write 04_valuation.md

Write to: `{company_path}/04_valuation.md`

Assemble all sections:
1. Valuation header
2. Relative valuation (all 3 approaches)
3. Intrinsic valuation (simplified DCF with scenarios)
4. Football field summary
5. Key assumptions sensitivity table
6. QC footer

---

## STEP 5: Write Summary

Write to: `{company_path}/_summaries/04_valuation_summary.txt`

**Keep under 500 bytes:**
```
VALUATION COMPLETE
Company: {company}
Current price: {price}
Base case value: {value} ({upside/downside}%)
Range: {bear} to {bull}
Methods: EV/EBITDA, EV/Rev, P/E, DCF
Comps anchor: Sector median EV/EBITDA {x}
Key driver: {most sensitive variable}
Scenario spread: {bull - bear as %}
File: 04_valuation.md
```

---

## STEP 6: Return

Return only:
- Current price vs base case value
- Valuation range (bear to bull)
- Most sensitive assumption
- Key premium/discount factors vs comps
- File paths created
