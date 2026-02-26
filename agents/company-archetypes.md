---
description: Generate archetype memos (Growth, Value, Quality, Momentum)
subagent_type: general-purpose
run_in_background: true
---

# Company Archetypes Agent

You are generating archetype investment memos for **{company}** in the **{sector}** sector.

Each archetype evaluates the company through a distinct investment lens. The archetypes feed into the council debate (05) where they argue against each other.

**Archetypes to generate:** {archetypes}
(Default: Growth, Value, Quality. Add Momentum if `{include_momentum}` is true.)

**Output paths:**
- `{company_path}/04_archetype_growth.md`
- `{company_path}/04_archetype_value.md`
- `{company_path}/04_archetype_quality.md`
- `{company_path}/04_archetype_momentum.md` (conditional)
- `{company_path}/_summaries/04_archetypes_summary.txt`

---

## Required Skills

Read and follow:
- `/.claude/skills/epistemic-tags.md` — tagging, QC footer
- `/.claude/skills/sector-data-model.md` — file schemas

---

## STEP 0: Read All Inputs

Read these files from disk (full content):

1. `{company_path}/02_base_reality.md` — financials, driver tree
2. `{company_path}/03_market_debates.md` — crux variables, debates
3. `{company_path}/04_valuation.md` — valuation scenarios, comps
4. `{sector_path}/S2_sector_comps_matrix.md` — peer benchmarks

---

## ARCHETYPE 1: Growth Investor Memo

Write to: `{company_path}/04_archetype_growth.md`

### Lens: Revenue growth durability, TAM expansion, market share gains

```markdown
# Growth Archetype Memo — {company}

## Thesis
{1-2 sentence growth thesis}

## Growth Scorecard

| Factor | Score (1-5) | Evidence |
|--------|-------------|----------|
| Revenue CAGR (3yr) | {score} | {value}% [EL-###] |
| TAM growth rate | {score} | {value}% [TAG] [S#] |
| Market share trend | {score} | {direction} [TAG] [EL-###] |
| New segment optionality | {score} | {description} [TAG] |
| Revenue quality (recurring %) | {score} | {value}% [EL-###] |
| Reinvestment rate | {score} | {value}% [EL-###] |
| **Composite** | **{avg}/5** | |

## Key Growth Drivers
[Ranked list with data, tied to driver tree nodes from 02]

## Growth Risks
[What could derail the growth story — tied to debates from 03]

## Growth Investor Verdict
- **Rating:** Strong Buy / Buy / Hold / Sell
- **Conviction:** High / Medium / Low
- **Key debate:** DB{#} — {title}
- **Catalyst timeline:** {months}

## QC Footer
[Per epistemic-tags.md]
```

---

## ARCHETYPE 2: Value Investor Memo

Write to: `{company_path}/04_archetype_value.md`

### Lens: Margin of safety, asset value, mean reversion, downside protection

```markdown
# Value Archetype Memo — {company}

## Thesis
{1-2 sentence value thesis}

## Value Scorecard

| Factor | Score (1-5) | Evidence |
|--------|-------------|----------|
| Price vs intrinsic value | {score} | {discount/premium}% to base DCF |
| EV/EBITDA vs sector | {score} | {x} vs {median x} |
| FCF yield | {score} | {%} vs sector {%} |
| Balance sheet strength | {score} | Net Debt/EBITDA {x} |
| Dividend + buyback yield | {score} | {%} |
| Asset replacement value | {score} | {analysis} |
| **Composite** | **{avg}/5** | |

## Margin of Safety Analysis
[Where is the floor? What's the downside in a bear case?]

## Value Traps Check
[Why might this be cheap for a reason? Reference debates from 03]

## Value Investor Verdict
- **Rating:** Strong Buy / Buy / Hold / Sell
- **Conviction:** High / Medium / Low
- **Key risk:** {what could erode value}
- **Catalyst:** {what could unlock value}

## QC Footer
```

---

## ARCHETYPE 3: Quality Investor Memo

Write to: `{company_path}/04_archetype_quality.md`

### Lens: ROIC durability, competitive moat, management quality, earnings quality

```markdown
# Quality Archetype Memo — {company}

## Thesis
{1-2 sentence quality thesis}

## Quality Scorecard

| Factor | Score (1-5) | Evidence |
|--------|-------------|----------|
| ROIC (3yr avg) | {score} | {%} vs WACC {%} [EL-###] |
| ROIC trend | {score} | {improving/stable/declining} |
| Competitive moat | {score} | {type: network/scale/brand/switching} |
| Margin stability | {score} | {std dev of EBITDA margin} |
| Cash conversion | {score} | FCF/Net Income {%} |
| Management track record | {score} | {capital allocation history} |
| **Composite** | **{avg}/5** | |

## Moat Analysis
[What sustains above-average returns? How durable?]

## Quality Risks
[What could erode quality? Competitive threats, regulation, disruption]

## Quality Investor Verdict
- **Rating:** Strong Buy / Buy / Hold / Sell
- **Conviction:** High / Medium / Low
- **Key moat:** {primary competitive advantage}
- **Moat threat:** {biggest risk to moat durability}

## QC Footer
```

---

## ARCHETYPE 4: Momentum Investor Memo (Conditional)

**Only generate if `{include_momentum}` is true.**

Write to: `{company_path}/04_archetype_momentum.md`

### Lens: Price momentum, earnings revisions, sentiment, technical factors

```markdown
# Momentum Archetype Memo — {company}

## Thesis
{1-2 sentence momentum thesis}

## Momentum Scorecard

| Factor | Score (1-5) | Evidence |
|--------|-------------|----------|
| Price momentum (6M) | {score} | {%} [REPORTED] |
| Price momentum (12M) | {score} | {%} [REPORTED] |
| Earnings revision trend | {score} | {direction} [CONSENSUS] |
| Relative strength vs sector | {score} | {vs sector index} |
| Volume trend | {score} | {direction} |
| Institutional flow | {score} | {if available} |
| **Composite** | **{avg}/5** | |

## Momentum Catalysts
[Upcoming events that could sustain/break momentum]

## Momentum Risks
[Crowding, mean reversion, sentiment shifts]

## Momentum Investor Verdict
- **Rating:** Strong Buy / Buy / Hold / Sell
- **Conviction:** High / Medium / Low

## QC Footer
```

---

## FINAL STEP: Write Summary

Write to: `{company_path}/_summaries/04_archetypes_summary.txt`

**Keep under 500 bytes:**
```
ARCHETYPES COMPLETE
Company: {company}
Archetypes: {count} (Growth, Value, Quality{, Momentum})
Scores:
  Growth: {score}/5 — {verdict}
  Value: {score}/5 — {verdict}
  Quality: {score}/5 — {verdict}
  {Momentum: {score}/5 — {verdict}}
Consensus direction: {overall lean}
Key disagreement: {which archetypes disagree most}
Files: 04_archetype_growth.md, 04_archetype_value.md, 04_archetype_quality.md{, 04_archetype_momentum.md}
```

---

## Return

Return only:
- Archetype scores and verdicts (one line each)
- Key disagreements between archetypes
- Which archetype has strongest conviction
- File paths created
