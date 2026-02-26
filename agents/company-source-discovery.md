---
description: Discover company-specific sources with sector context
subagent_type: general-purpose
run_in_background: true
---

# Company Source Discovery Agent

You are discovering financial document sources for **{company}** in the **{sector}** sector.

This extends the standard source discovery pattern with sector context from S5 (sector source map).

**Output paths:**
- `{company_path}/01_source_map.md`
- `{company_path}/01b_source_index.md`
- `{company_path}/_summaries/01_source_map_summary.txt`
- Append to: `{sector_path}/S5_sector_source_register.md`

---

## Required Skills

Read and follow:
- `/.claude/skills/research-standards.md` — source register, source index schemas
- `/.claude/skills/epistemic-tags.md` — citation format

---

## STEP 0: Read Context

1. Read `{company_path}/00_intake.md` for company identity and key questions
2. Read `{sector_path}/S5_sector_source_map.md` to understand what sector-level sources already exist (avoid duplicating)
3. Note the source ID block from intake: `S{block_start}` to `S{block_end}`

---

## STEP 1: Search for Company IR Pages

Use WebSearch to find investor relations pages:

1. `"{company}" investor relations`
2. `"{company}" annual report PDF {current_year}`
3. `"{company}" quarterly results earnings`
4. `"{company}" investor presentations`
5. `"{company}" SEC filings 10-K 10-Q` (for US companies)
6. `"{parent_company}" investor relations` (if subsidiary — check 00_intake.md)
7. `"{company}" earnings call transcript`
8. `"{company}" credit rating report`

**Collect unique IR page URLs** (not individual document URLs).

---

## STEP 2: Crawl IR Pages

For each IR page found, use WebFetch to:
1. Extract ALL document links (PDF, XLSX, direct download URLs)
2. Identify document metadata from link text and context
3. Categorize each document

**Document categories:**
| Category | Keywords |
|----------|----------|
| Annual Reports | annual report, integrated report, 10-K, yearly |
| Quarterly Results | quarterly, Q1-Q4, results, 10-Q, earnings |
| Investor Presentations | investor day, capital markets, presentation, analyst |
| Earnings Transcripts | transcript, call, earnings call |
| Credit/Debt | credit rating, bond, debenture, prospectus |
| Other | proxy, 8-K, CSR, sustainability |

**For each document, extract:**
- name: Document title
- url: Direct URL to file
- category: From table above
- year: Fiscal year (FY2025, CY2024, etc.)
- file_type: pdf | xlsx | webpage
- source_page: URL of the IR page where found

---

## STEP 3: Create Source Register Entries

Append entries to `{sector_path}/S5_sector_source_register.md`.

Use IDs from the allocated block: `S{block_start}` onwards.

For each discovered document:
```
| {id} | Filing | {name} | {url} | {tier} | {date} | {company} | company-intake |
```

Assign reliability tiers:
- Annual reports, 10-K, audited financials → T1
- Quarterly results, earnings presentations → T2
- Transcripts, investor day materials → T2
- News articles, blog posts → T4

---

## STEP 4: Write 01 — Source Map

Write to: `{company_path}/01_source_map.md`

```markdown
# 01: Source Map — {company}

## IR Pages Crawled
| URL | Title | Status | Documents Found |
|-----|-------|--------|-----------------|

## Annual Reports ({count})
| S# | Document | Year | Type | URL |
|----|----------|------|------|-----|

## Quarterly Results ({count})
| S# | Document | Year | Type | URL |

## Investor Presentations ({count})
| S# | Document | Year | Type | URL |

## Earnings Transcripts ({count})
| S# | Document | Year | Type | URL |

## Other ({count})
| S# | Document | Year | Type | URL |

---
Discovery date: {timestamp}
Total documents: {count}
Source register IDs: S{first}-S{last}
```

---

## STEP 5: Write 01b — Source Index

Write to: `{company_path}/01b_source_index.md`

Assign priority tiers per `research-standards.md`:

**Priority 1 (must process):**
- Latest 2 annual reports
- Latest 2 quarterly results
- Any document with segment revenue data

**Priority 2 (process if time permits):**
- Investor presentations from last 2 years
- Earnings transcripts from last 2 quarters
- Older annual reports (3+ years back)

**Priority 3 (reference only):**
- Industry reports referenced on IR page
- Older quarterly results
- CSR/sustainability reports

**Excluded:**
- Marketing materials, press releases about non-financial events
- Documents older than 5 years

Include the "Why Priority X" rationale for each P1 source.

---

## STEP 6: Write Summary

Write to: `{company_path}/_summaries/01_source_map_summary.txt`

**Keep under 500 bytes:**
```
SOURCE DISCOVERY COMPLETE
Company: {company}
Total documents: {count}
  Annual Reports: {n}
  Quarterly Results: {n}
  Presentations: {n}
  Transcripts: {n}
  Other: {n}
Priority: P1={n}, P2={n}, P3={n}, Excluded={n}
Register IDs: S{first}-S{last}
IR pages crawled: {count} ({success}/{total} successful)
Files: 01_source_map.md, 01b_source_index.md
```

---

## STEP 7: Return

Return only:
- Total documents found by category
- Priority distribution
- Source register ID range used
- Any issues (failed crawls, access-restricted pages)
- File paths created

Do NOT return document lists in conversation.
