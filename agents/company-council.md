---
description: Run structured council debate between archetype investors
subagent_type: general-purpose
run_in_background: true
---

# Company Council Debate Agent

You are running a structured council debate for **{company}** in the **{sector}** sector.

The council debate pits the archetype investors (Growth, Value, Quality, optionally Momentum) against each other in a structured argument format. Each archetype gets 3 questions to challenge the others. The goal is to surface the strongest arguments and expose weaknesses in each thesis.

**Output paths:**
- `{company_path}/05_council_debate.md`
- `{company_path}/_summaries/05_council_summary.txt`

---

## Required Skills

Read and follow:
- `/.claude/skills/epistemic-tags.md` — tagging, QC footer
- `/.claude/skills/sector-data-model.md` — file schemas

---

## STEP 0: Read All Inputs

Read these files from disk (full content):

1. `{company_path}/04_archetype_growth.md`
2. `{company_path}/04_archetype_value.md`
3. `{company_path}/04_archetype_quality.md`
4. `{company_path}/04_archetype_momentum.md` (if exists)
5. `{company_path}/04_valuation.md`
6. `{company_path}/03_market_debates.md` — for crux variable references

---

## STEP 1: Identify Key Disagreements

From the archetype memos, identify:
- Where verdicts diverge (e.g., Growth says Buy, Value says Sell)
- Where the same data point is interpreted differently
- Where one archetype's strength is another's concern
- Which crux variables each archetype weighs most heavily

List the top 5 disagreements ranked by impact on investment decision.

---

## STEP 2: Structure the Council Debate

For each archetype, generate 3 sharp questions directed at the other archetypes:

### Round 1: Growth Investor Challenges

```markdown
**Q1 to Value:** "{Specific challenge about why cheapness might be a trap given growth trajectory}"
**Value responds:** "{Rebuttal with data}"

**Q2 to Quality:** "{Challenge about whether moat is as durable as claimed}"
**Quality responds:** "{Rebuttal with evidence}"

**Q3 to {weakest opposing thesis}:** "{Most pointed challenge}"
**{Archetype} responds:** "{Response}"
```

### Round 2: Value Investor Challenges
[Same structure — 3 questions to other archetypes]

### Round 3: Quality Investor Challenges
[Same structure]

### Round 4: Momentum Investor Challenges (if applicable)
[Same structure]

### Rules for Debate Quality
- Questions must reference specific data points (EL-### or S#)
- Responses must address the question directly, not deflect
- If a response acknowledges weakness, note it as a concession
- Each exchange should move the debate forward, not repeat prior points

---

## STEP 3: Synthesize Debate Outcomes

After all rounds:

```markdown
## Debate Scoreboard

| Matchup | Winner | Key Argument | Concessions Made |
|---------|--------|--------------|------------------|
| Growth vs Value | {winner} | {one-liner} | {what the loser conceded} |
| Growth vs Quality | {winner} | {one-liner} | ... |
| Value vs Quality | {winner} | {one-liner} | ... |
| ... | | | |

## Consensus Points
[Where all archetypes agree]

## Unresolved Tensions
[Where the debate remains genuinely unresolved — these feed into the synthesis]

## Strongest Overall Case
Based on the debate, the strongest case is: **{archetype}**
Reasoning: {2-3 sentences summarizing why this archetype's thesis survived the most challenges}

## Weakest Overall Case
The weakest case is: **{archetype}**
Reasoning: {what was conceded or couldn't be defended}
```

---

## STEP 4: Write 05_council_debate.md

Write to: `{company_path}/05_council_debate.md`

Assemble:
1. Header with company, date, participants
2. Key disagreements summary
3. Full debate rounds (all 3-4 rounds)
4. Debate scoreboard
5. Consensus points
6. Unresolved tensions
7. Strongest/weakest cases
8. QC footer

---

## STEP 5: Write Summary

Write to: `{company_path}/_summaries/05_council_summary.txt`

**Keep under 500 bytes:**
```
COUNCIL DEBATE COMPLETE
Company: {company}
Participants: {count} archetypes
Rounds: {count}
Questions exchanged: {total}
Strongest case: {archetype} ({score}/5)
Weakest case: {archetype} ({score}/5)
Consensus points: {count}
Unresolved tensions: {count}
Key concession: {one-liner}
File: 05_council_debate.md
```

---

## STEP 6: Return

Return only:
- Debate participants
- Strongest and weakest cases
- Key concessions
- Number of unresolved tensions
- File paths created
