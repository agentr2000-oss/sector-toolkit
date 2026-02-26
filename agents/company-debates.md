---
description: Generate market debates document mapped to crux variables
subagent_type: general-purpose
run_in_background: true
---

# Company Debates Agent

You are generating the market debates document (03) for **{company}** in the **{sector}** sector.

The debates document maps the key bull/bear arguments to specific crux variables from the driver tree — making debates testable and trackable rather than vague narratives.

**Output paths:**
- `{company_path}/03_market_debates.md`
- `{company_path}/_summaries/03_debates_summary.txt`

---

## Required Skills

Read and follow:
- `/.claude/skills/epistemic-tags.md` — 7-tag system, QC footer
- `/.claude/skills/sector-data-model.md` — S3 debates format

---

## STEP 0: Read All Inputs

Read these files from disk (full content):

1. `{company_path}/02_base_reality.md` — driver tree is the primary input
2. `{sector_path}/S3_sector_debates.md` — sector-level debates to align with
3. `{company_path}/01b_evidence_log.md` — for sourcing claims
4. `{sector_path}/S2_sector_comps_matrix.md` — for valuation context

---

## STEP 1: Extract Driver Tree Variables

From 02_base_reality.md, identify all nodes in the driver tree. Each node is a potential crux variable:

- Revenue drivers (volume, price per segment)
- Margin drivers (cost lines as % of revenue)
- Capital efficiency drivers (capex, working capital)
- Growth rate assumptions

Rank by materiality: which variables, if they moved ±20%, would have the largest impact on intrinsic value?

---

## STEP 2: Map Debates to Crux Variables

For each high-materiality variable, identify the bull/bear argument:

Use WebSearch to supplement evidence:
1. `"{company}" bull case bear case analysis`
2. `"{company}" risks opportunities`
3. `"{company}" competitive threats`
4. `"{company}" growth concerns`
5. `"{company}" {crux_variable} outlook`

---

## STEP 3: Align with Sector Debates

Read S3_sector_debates.md. For each sector-level debate:
- Does it apply to this company? If yes, create a company-specific version
- How does this company's position differ from peers?
- Add any company-specific debates not covered at sector level

---

## STEP 4: Write 03 — Market Debates

Write to: `{company_path}/03_market_debates.md`

```markdown
# 03: Market Debates — {company}

Generated: {timestamp}
Crux variables identified: {count}
Debates mapped: {count}

## Crux Variable Map

| ID | Variable | Driver Tree Node | Materiality | Current Value | Bull Case | Bear Case |
|----|----------|------------------|-------------|---------------|-----------|-----------|
| CV1 | {name} | Revenue/{Seg}/{driver} | High | {value} [EL-###] | {value} | {value} |
| CV2 | {name} | Cost/{line} | High | {value} [EL-###] | {value} | {value} |

## Debate Details

### DB1: {Debate Title}
- **Crux variable:** CV{#} — {variable name}
- **Bull thesis:** {2-3 sentences} [TAG]
- **Bear thesis:** {2-3 sentences} [TAG]
- **Current evidence:**
  - For bull: {evidence with [S# / EL-###] citations}
  - For bear: {evidence with [S# / EL-###] citations}
- **Resolution signal:** {what data point or event would resolve this}
- **Timeline:** {when resolution might occur}
- **Sector debate link:** {S3 debate ID, if aligned} or "Company-specific"
- **Impact on value:** {qualitative: High/Medium/Low, directional}

### DB2: {Debate Title}
[same structure]

...

## Debate Interaction Matrix

Which debates are correlated? If DB1 resolves bull, does it affect DB2?

| | DB1 | DB2 | DB3 | ... |
|------|-----|-----|-----|-----|
| DB1 | — | {correlated/independent} | ... | |
| DB2 | | — | ... | |

## Summary Assessment

- **Total debates:** {count}
- **High materiality:** {count}
- **Leaning bull:** {count} | **Leaning bear:** {count} | **Balanced:** {count}
- **Sector-aligned:** {count} | **Company-specific:** {count}
- **Near-term resolution (< 12 months):** {list debate IDs}

## QC Footer
[Per epistemic-tags.md]
```

---

## STEP 5: Write Summary

Write to: `{company_path}/_summaries/03_debates_summary.txt`

**Keep under 500 bytes:**
```
DEBATES COMPLETE
Company: {company}
Crux variables: {count} (High: {n}, Medium: {n})
Debates mapped: {count}
  Leaning bull: {n}
  Leaning bear: {n}
  Balanced: {n}
Sector-aligned: {n} | Company-specific: {n}
Top crux: {CV1 name}, {CV2 name}, {CV3 name}
Near-term resolution: {debate IDs}
File: 03_market_debates.md
```

---

## STEP 6: Return

Return only:
- Number of crux variables and debates
- Top 3 crux variables by materiality
- Bull/bear balance
- Debates with near-term resolution signals
- File paths created

Do NOT return debate content in conversation.
