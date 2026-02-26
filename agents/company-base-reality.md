---
description: Generate company base reality document with sector inheritance
subagent_type: general-purpose
run_in_background: true
---

# Company Base Reality Agent

You are generating the base reality document (02) for **{company}** in the **{sector}** sector.

The base reality is the foundational analytical document — a comprehensive, data-driven portrait of the company's business model, financial structure, and competitive position, anchored to sector benchmarks.

**Output paths:**
- `{company_path}/02_base_reality.md`
- `{company_path}/_summaries/02_base_reality_summary.txt`

---

## Required Skills

Read and follow:
- `/.claude/skills/epistemic-tags.md` — 7-tag system, QC footer, citation format
- `/.claude/skills/research-standards.md` — evidence log references
- `/.claude/skills/sector-data-model.md` — 02 schema, comps matrix structure

---

## STEP 0: Read All Inputs

Read these files from disk (full content):

1. `{company_path}/00_intake.md` — company identity, key questions
2. `{company_path}/01b_evidence_log.md` — all extracted data points
3. `{sector_path}/S1_sector_base_reality.md` — sector economics, benchmarks, value chain
4. `{sector_path}/S2_sector_comps_matrix.md` — peer comparables

These are your primary inputs. Every claim in the output must trace back to an evidence log entry (EL-###) or a source register entry (S#).

---

## STEP 1: Business Model Analysis

Write a comprehensive business model description:

- What the company does and how it makes money
- Position in the sector value chain (reference S1)
- Key competitive advantages / moats
- Business model evolution over last 3-5 years

**Tag every non-trivial claim.** Use evidence log entries where possible.

---

## STEP 2: Revenue Decomposition

Break down revenue by segment. For each segment:

```markdown
### {Segment Name}
- **Revenue:** {value} ({period}) [TAG] [S# / EL-###]
- **Growth:** {YoY %} [TAG] [S# / EL-###]
- **Revenue share:** {%} of total
- **Drivers:** {volume metric} × {price metric}
  - Volume: {value} ({trend direction}) [TAG] [S# / EL-###]
  - Price: {value} ({trend direction}) [TAG] [S# / EL-###]
- **Outlook:** {brief forward view} [TAG]
```

If segment data is not available, note the limitation and use total revenue with whatever breakdown exists.

---

## STEP 3: Cost Structure

Build a cost structure table:

```markdown
| Cost Line | Value | % Revenue | YoY Change | Trend (3yr) | Source |
|-----------|-------|-----------|------------|-------------|--------|
| COGS / Network costs | {value} | {%} | {%} | Stable/Rising/Declining | [EL-###] |
| SGA | {value} | {%} | {%} | ... | [EL-###] |
| R&D | {value} | {%} | {%} | ... | [EL-###] |
| D&A | {value} | {%} | {%} | ... | [EL-###] |
| Other opex | {value} | {%} | {%} | ... | [EL-###] |
| **EBITDA** | **{value}** | **{%}** | **{%}** | ... | [EL-###] |
| Interest expense | {value} | ... | ... | ... | [EL-###] |
| **Net Income** | **{value}** | **{%}** | ... | ... | [EL-###] |
```

Compare margins to sector benchmarks from S2:
- Is the company above or below sector median?
- What explains the difference?

---

## STEP 4: Driver Tree

Build a hierarchical driver tree showing how revenue and costs decompose:

```
Revenue ({value})
├── {Segment 1} ({value}, {%} of total)
│   ├── {Volume driver}: {value} ({trend}) [EL-###]
│   └── {Price driver}: {value} ({trend}) [EL-###]
├── {Segment 2} ({value}, {%} of total)
│   ├── {Volume driver}: {value} ({trend}) [EL-###]
│   └── {Price driver}: {value} ({trend}) [EL-###]
│
EBITDA ({value}, {margin}%)
├── Gross margin: {%} [EL-###]
├── Opex/Revenue: {%} [EL-###]
│
FCF ({value})
├── EBITDA: {value}
├── Capex: -{value} ({%} of revenue) [EL-###]
├── Working capital: {change} [EL-###]
└── Interest & tax: -{value} [EL-###]
```

This driver tree is the key input for the debates document (03) — each branch represents a potential crux variable.

---

## STEP 5: Capital Allocation

Analyze how the company allocates capital:

- **Capex:** Total and as % of revenue, maintenance vs growth split if disclosed
- **M&A:** Recent acquisitions, strategic rationale, amounts
- **Dividends:** Yield, payout ratio, history
- **Buybacks:** If applicable
- **Debt management:** Net debt trend, debt/EBITDA, refinancing schedule

---

## STEP 6: Sector Benchmarks Comparison

Create a benchmarks table using data from S2:

```markdown
| Metric | {company} | Sector Median | Percentile | Gap |
|--------|-----------|---------------|------------|-----|
| Revenue Growth | {%} | {%} | {nth} | +/- {pp} |
| EBITDA Margin | {%} | {%} | {nth} | +/- {pp} |
| ROIC | {%} | {%} | {nth} | +/- {pp} |
| Net Debt/EBITDA | {x} | {x} | {nth} | +/- {x} |
| EV/EBITDA | {x} | {x} | {nth} | +/- {x} |
| Capex/Revenue | {%} | {%} | {nth} | +/- {pp} |
```

Identify where the company is a clear outlier (top/bottom quartile) and explain why.

---

## STEP 7: Assemble Document

Write to: `{company_path}/02_base_reality.md`

Combine all sections in order:
1. Header with company name and date
2. Business Model
3. Revenue Decomposition
4. Cost Structure
5. Driver Tree
6. Capital Allocation
7. Sector Benchmarks
8. QC Footer (per epistemic-tags.md)

---

## STEP 8: Write Summary

Write to: `{company_path}/_summaries/02_base_reality_summary.txt`

**Keep under 500 bytes:**
```
BASE REALITY COMPLETE
Company: {company}
Revenue: {value} ({growth}% YoY)
EBITDA margin: {%} (sector median: {%})
Segments: {count} ({names})
Driver tree branches: {count}
Key metrics vs sector: {above/below median on N of M metrics}
Evidence entries cited: {count}
Sources cited: {count}
QC: {untagged claims count} untagged
File: 02_base_reality.md
```

---

## STEP 9: Return

Return only:
- Revenue and margin headline
- Number of segments identified
- Key benchmark gaps (where company is outlier)
- Evidence coverage quality
- File paths created

Do NOT return document content in conversation.
