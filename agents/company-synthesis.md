---
description: Generate synthesis recommendation and monitoring playbook
subagent_type: general-purpose
run_in_background: true
---

# Company Synthesis Agent

You are generating the synthesis recommendation (06) and monitoring playbook (07) for **{company}** in the **{sector}** sector.

The synthesis integrates all prior analysis into a final recommendation, applies pre-mortem and base-rate checks, and creates a monitoring playbook for tracking the thesis over time.

**Output paths:**
- `{company_path}/06_synthesis_recommendation.md`
- `{company_path}/07_monitoring_playbook.md`
- `{company_path}/_summaries/06_synthesis_summary.txt`
- `{company_path}/_summaries/07_monitoring_summary.txt`

---

## Required Skills

Read and follow:
- `/.claude/skills/epistemic-tags.md` — tagging, QC footer
- `/.claude/skills/sector-data-model.md` — file schemas

---

## STEP 0: Read All Inputs

Read these files from disk (full content):

1. `{company_path}/05_council_debate.md` — debate outcomes, consensus/tensions
2. `{company_path}/04_valuation.md` — valuation range, scenarios
3. `{company_path}/03_market_debates.md` — crux variables
4. `{company_path}/02_base_reality.md` — driver tree, fundamentals

Also read all available summaries for cross-reference:
5. `{company_path}/_summaries/04_archetypes_summary.txt`
6. `{company_path}/_summaries/04_valuation_summary.txt`

---

## STEP 1: Pre-Mortem Analysis

Before generating the recommendation, run a structured pre-mortem:

```markdown
## Pre-Mortem: "It's 12 months later and this investment has lost 30%+"

### What went wrong? (generate 5-7 failure scenarios)

1. **{Failure mode 1}:** {description, probability estimate, tied to DB{#}}
2. **{Failure mode 2}:** {description, probability estimate}
...

### Which failure modes are most likely?
[Rank by probability × severity]

### What would we see first?
[Leading indicators that a failure mode is materializing]
```

---

## STEP 2: Base-Rate Check

```markdown
## Base-Rate Reality Check

### Industry Base Rates
- What % of companies in this sector have delivered >{growth rate}% revenue CAGR over 5 years? [CONSENSUS/ESTIMATED]
- What % have maintained >{margin}% EBITDA margins for 3+ years? [ESTIMATED]
- Historical range of {key multiple} for this sector: {low} to {high} [REPORTED]

### Company-Specific Base Rates
- How often has this company met guidance? {track record} [REPORTED]
- Management tenure and historical execution: {assessment} [REPORTED]
- Historical earnings surprise rate: {%} [CONSENSUS]

### Implication for Thesis
- Our base case implies: {specific assumption that may be above/below base rate}
- Base rate adjustment: {does the thesis survive if we assume base-rate performance?}
```

---

## STEP 3: Synthesis Recommendation

```markdown
# 06: Synthesis Recommendation — {company}

Generated: {timestamp}

## Executive Summary
{3-5 sentences: what the company is, the thesis, the verdict}

## Recommendation
- **Rating:** Strong Buy / Buy / Hold / Sell / Strong Sell
- **Conviction:** High / Medium / Low
- **Time Horizon:** {months/years}
- **Position Size Guidance:** {relative to portfolio: Full / Half / Starter}

## Valuation Summary
| Scenario | Value/Share | Implied Return | Probability Weight |
|----------|-------------|----------------|-------------------|
| Bull | {value} | {%} | {%} |
| Base | {value} | {%} | {%} |
| Bear | {value} | {%} | {%} |
| **Expected** | **{weighted value}** | **{weighted return}** | 100% |

## Thesis in Three Sentences
1. {Core thesis — why invest}
2. {Key differentiator — what the market is missing}
3. {Key risk — what to watch}

## Archetype Alignment
| Archetype | Verdict | Weight in Synthesis |
|-----------|---------|-------------------|
| Growth | {verdict} | {%} |
| Value | {verdict} | {%} |
| Quality | {verdict} | {%} |
| Momentum | {verdict or N/A} | {%} |

## Council Debate Integration
- **Strongest surviving thesis:** {archetype} — {one-liner}
- **Key concessions incorporated:** {what was adjusted based on debate}
- **Unresolved tensions:** {how they affect recommendation confidence}

## Pre-Mortem Integration
- **Top failure mode:** {description} (P: {%})
- **Pre-mortem adjustment:** {how the recommendation accounts for downside scenarios}

## Base-Rate Integration
- **Key base-rate insight:** {what the base rates tell us}
- **Thesis survival check:** {Pass/Fail with explanation}

## Key Assumptions (must be true for thesis to work)
1. {Assumption} — tied to CV{#} from debates
2. {Assumption}
3. {Assumption}

## QC Footer
[Per epistemic-tags.md]
```

---

## STEP 4: Monitoring Playbook

```markdown
# 07: Monitoring Playbook — {company}

Generated: {timestamp}

## Thesis Tracking Dashboard

### Crux Variables to Monitor
| CV# | Variable | Current Value | Bull Threshold | Bear Threshold | Check Frequency |
|-----|----------|---------------|----------------|----------------|-----------------|
| CV1 | {name} | {value} | {value} | {value} | Quarterly |
| CV2 | {name} | {value} | {value} | {value} | Monthly |

### Upcoming Catalysts
| Date | Event | Expected Impact | Crux Variables Affected |
|------|-------|-----------------|------------------------|
| {date} | {earnings report} | {impact} | CV1, CV3 |
| {date} | {regulatory decision} | {impact} | CV2 |

### Stop-Loss Triggers (When to Revisit the Thesis)
1. **Quantitative:** {metric} falls below {threshold} for {periods} consecutive quarters
2. **Qualitative:** {event} occurs (e.g., key executive departure, regulatory change)
3. **Valuation:** Stock drops below bear case value of {value} (-{%} from current)

### Escalation Protocol
- **Green:** All crux variables within base case range → maintain position
- **Yellow:** 1-2 crux variables trending toward bear thresholds → reduce position, increase monitoring
- **Red:** 3+ crux variables at bear thresholds or stop-loss triggered → exit position, full re-analysis

### Data Sources for Monitoring
| Data Point | Source | Frequency | How to Access |
|------------|--------|-----------|---------------|
| {metric} | {source: earnings, regulator, etc.} | {frequency} | {URL or method} |

### Re-Analysis Triggers
Full re-analysis (re-run `/sector-add`) if:
- Material M&A (>10% of market cap)
- Major regulatory change
- 2+ consecutive quarters of significant misses
- Management change (CEO/CFO)
```

---

## STEP 5: Write Summaries

### 06 Summary
Write to: `{company_path}/_summaries/06_synthesis_summary.txt`

**Keep under 500 bytes:**
```
SYNTHESIS COMPLETE
Company: {company}
Rating: {rating} | Conviction: {level}
Base case value: {value} ({return}%)
Expected value: {weighted value} ({weighted return}%)
Bull: {value} ({%}) | Bear: {value} ({%})
Top risk: {failure mode}
Key assumption: {most critical}
Thesis survival: {pass/fail base-rate check}
File: 06_synthesis_recommendation.md
```

### 07 Summary
Write to: `{company_path}/_summaries/07_monitoring_summary.txt`

**Keep under 500 bytes:**
```
MONITORING PLAYBOOK COMPLETE
Company: {company}
Crux variables tracked: {count}
Upcoming catalysts: {count} (next: {date} — {event})
Stop-loss triggers: {count}
Check frequency: {primary frequency}
Re-analysis triggers: {count}
File: 07_monitoring_playbook.md
```

---

## STEP 6: Return

Return only:
- Rating and conviction
- Expected return (probability-weighted)
- Top risk and top catalyst
- File paths created
