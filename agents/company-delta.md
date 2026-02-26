---
description: Analyze how company findings should update sector layer files
subagent_type: general-purpose
run_in_background: true
---

# Company Delta Agent

You are analyzing how the findings from **{company}** should update the sector layer files (S1-S5) for the **{sector}** sector.

This is the recursive feedback step — each company added enriches the sector's base reality, comps, debates, and sources. Your job is to identify specific, justified updates and propose them for user approval.

**Output paths:**
- `{company_path}/08_sector_delta.md`
- `{company_path}/_summaries/08_delta_summary.txt`

---

## Required Skills

Read and follow:
- `/.claude/skills/epistemic-tags.md` — tagging, citations
- `/.claude/skills/sector-data-model.md` — comps matrix rules, S1-S5 schemas

---

## STEP 0: Read All Inputs

Read these files from disk (full content):

### Company files:
1. `{company_path}/06_synthesis_recommendation.md` — final view on company
2. `{company_path}/02_base_reality.md` — company data, driver tree
3. `{company_path}/04_valuation.md` — valuation metrics for comps

### Sector files:
4. `{sector_path}/S1_sector_base_reality.md`
5. `{sector_path}/S2_sector_comps_matrix.md`
6. `{sector_path}/S3_sector_debates.md`
7. `{sector_path}/S4_sector_consensus_tracker.md`
8. `{sector_path}/S5_sector_source_register.md`

---

## STEP 1: Comps Matrix Update (Mandatory)

Every company addition MUST add a row to S2. Extract from 02 and 04:

```markdown
### S2 Update: Add {company} Column

| Metric | {company} Value | Source |
|--------|----------------|--------|
| Market Cap | {value} | [EL-###] |
| Revenue (LTM) | {value} | [EL-###] |
| Revenue Growth (YoY) | {%} | [EL-###] |
| EBITDA Margin | {%} | [EL-###] |
| Net Margin | {%} | [EL-###] |
| ROIC | {%} | [EL-###] |
| ROE | {%} | [EL-###] |
| Net Debt / EBITDA | {x} | [EL-###] |
| EV/Revenue | {x} | [EL-###] |
| EV/EBITDA | {x} | [EL-###] |
| P/E (Forward) | {x} | [EL-###] |
| FCF Yield | {%} | [EL-###] |
| Dividend Yield | {%} | [EL-###] |
| Capex / Revenue | {%} | [EL-###] |
| {Sector KPI 1} | {value} | [EL-###] |
| {Sector KPI 2} | {value} | [EL-###] |

**Recalculated Median/Mean:** {show new medians after adding this company}
```

---

## STEP 2: S1 Base Reality Updates

Compare company findings against current S1. Identify updates where:
- Company data provides more specific industry economics
- Cost structure norms should be adjusted based on new data point
- Benchmark ranges need updating
- Value chain description is incomplete

For each proposed update:
```markdown
### S1 Proposed Update #{n}
- **Section:** {which S1 section}
- **Current text:** "{exact current text}"
- **Proposed text:** "{new text}"
- **Justification:** {why this update improves S1, with evidence}
- **Impact:** {Low/Medium/High — how much this changes sector understanding}
```

Only propose updates where the company data provides genuinely new information, not just confirms what's already there.

---

## STEP 3: S3 Debates Updates

Compare company debates (03) against sector debates (S3). Identify:
- New sector-level debates revealed by this company's analysis
- Existing debates where this company provides new evidence
- Debates that should be resolved or status updated

```markdown
### S3 Proposed Update #{n}
- **Action:** Add new debate / Update existing D{#} / Resolve D{#}
- **Details:** {specific change}
- **Evidence:** {from company analysis, with citations}
```

---

## STEP 4: S4 Consensus Tracker Updates

Add company consensus estimates to S4:
```markdown
### S4 Proposed Update
Add rows:
| {company} | Revenue FY{year} | {value} | {bull} | {bear} | {source} | {date} |
| {company} | EBITDA FY{year} | {value} | {bull} | {bear} | {source} | {date} |
```

---

## STEP 5: Write 08 — Sector Delta

Write to: `{company_path}/08_sector_delta.md`

```markdown
# 08: Sector Delta — {company} → {sector}

Generated: {timestamp}

## Summary
Company {company} adds {count} proposed updates to sector layer.

## Mandatory Updates
### S2 Comps Matrix — Add {company} Column
{full comps row from Step 1}

## Proposed Updates

### S1 Base Reality Updates ({count})
{all S1 updates from Step 2}

### S3 Debate Updates ({count})
{all S3 updates from Step 3}

### S4 Consensus Updates ({count})
{all S4 updates from Step 4}

## Update Log Entry
```
{date} | {company} added | S2: +1 column | S1: {count} updates | S3: {count} updates | S4: {count} updates
```
```

---

## STEP 6: Write Summary

Write to: `{company_path}/_summaries/08_delta_summary.txt`

**Keep under 500 bytes:**
```
SECTOR DELTA COMPLETE
Company: {company} → {sector}
Mandatory: S2 +1 column (new median EV/EBITDA: {x})
S1 updates proposed: {count}
S3 updates proposed: {count} (new debates: {n}, evidence updates: {n})
S4 updates proposed: {count}
Total proposed changes: {count}
File: 08_sector_delta.md
```

---

## STEP 7: Return

Return only:
- Comps matrix update summary (new medians)
- Count of proposed updates per sector file
- Most significant proposed change
- File paths created

Do NOT return full delta content in conversation.
