# Epistemic Tags & Citation Standards

This skill defines the epistemic tagging system, citation format, and QC footer template used across all sector analysis deliverables.

## 7-Tag System

Every non-trivial claim in deliverables (02 through 08) must carry one epistemic tag:

| Tag | Meaning | When to use |
|-----|---------|-------------|
| `[VERIFIED]` | Confirmed by 2+ independent primary sources | Audited financials, regulatory filings, direct company disclosures |
| `[REPORTED]` | Stated by one primary source, not cross-checked | Single earnings call quote, one press release, one IR document |
| `[ESTIMATED]` | Calculated from data with stated methodology | Bottom-up TAM build, implied market share from revenue/industry size |
| `[INFERRED]` | Logical deduction from verified/reported facts | "If ARPU is X and subs are Y, revenue must be ~Z" |
| `[CONSENSUS]` | Widely held view among analysts/industry | Broker consensus, widely-cited industry forecasts |
| `[SPECULATIVE]` | Hypothesis with limited supporting evidence | Forward-looking scenarios, untested assumptions |
| `[CONTESTED]` | Conflicting evidence exists — flag for debate | When sources disagree on a material fact |

### Non-Trivial Definition

A claim is **non-trivial** if:
- It could materially affect a valuation input (revenue driver, cost assumption, growth rate)
- It relates to a crux variable identified in the debates document (03)
- It is used as an input to any archetype memo (04)
- Reasonable analysts could disagree on its accuracy

**Trivial claims** (company name, publicly known HQ location, listing exchange) do not need tags.

## Citation Format

All citations follow a two-part format: `[Source Register ID / Evidence Log Entry]`

### Source Register References
Format: `[S#]` where `#` is the source register ID from `S5_sector_source_register.md`

Example: `Revenue grew 18% YoY [S14]`

### Evidence Log References
Format: `[EL-###]` where `###` is the evidence log entry number from `01b_evidence_log.md`

Example: `Subscriber additions of 8.2M [EL-042]`

### Combined References
When a claim references both a source and a specific evidence extraction:
`ARPU declined 3% QoQ [S14 / EL-042]`

### Cross-Document References
For sector-level documents (S1-S5), reference company deliverables as:
`[{Company}/02]` — e.g., `[Jio/02]` for Jio's base reality document

## QC Footer Template

Every deliverable (02 through 08) must end with a QC footer:

```markdown
---

## QC Footer

| Metric | Value |
|--------|-------|
| Document | {document_id} ({document_name}) |
| Company | {company_name} |
| Sector | {sector_name} |
| Generated | {ISO_timestamp} |
| Sources cited | {count of unique S# references} |
| Evidence entries cited | {count of unique EL-### references} |
| Tag distribution | VERIFIED: {n}, REPORTED: {n}, ESTIMATED: {n}, INFERRED: {n}, CONSENSUS: {n}, SPECULATIVE: {n}, CONTESTED: {n} |
| Untagged non-trivial claims | {count — target: 0} |
| Crux variables addressed | {list of crux IDs from 03, if applicable} |

### Source Coverage
- Primary sources used: {list S# IDs}
- Evidence log range: EL-{first} to EL-{last}
- Sources with reliability tier < 3: {list, if any — flag for review}
```

## Tag Application Rules

1. **One tag per claim.** If multiple tags could apply, use the most conservative (e.g., `[CONTESTED]` over `[REPORTED]` if sources disagree).
2. **Tags go at the end of the sentence**, before the period: `Revenue was $4.2B [VERIFIED].`
3. **Inline citations follow tags**: `Revenue was $4.2B [VERIFIED] [S14].`
4. **Block-level tags** for multi-sentence passages go on a separate line below the block:
   ```
   The company's cloud segment has shown consistent growth across all reported quarters,
   with management attributing this to enterprise migration trends.
   `[REPORTED] [S22 / EL-087]`
   ```
5. **Tables:** Tag individual cells where the claim is non-trivial. For entire rows sourced from one place, add the tag to the row's source column.

## Agent Instructions

When generating any deliverable:
1. Track tag counts as you write
2. After completing the document, count untagged non-trivial claims — target is 0
3. Fill in the QC footer with actual counts
4. If `SPECULATIVE` or `CONTESTED` tags exceed 30% of all tags, add a warning note in the QC footer
