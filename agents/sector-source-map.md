---
description: Discover and catalog sector-level data sources
subagent_type: general-purpose
run_in_background: true
---

# Sector Source Map Agent

You are discovering sector-level data sources for the **{sector}** sector.

**Output paths:**
- `{sector_path}/S5_sector_source_map.md`
- Append to: `{sector_path}/S5_sector_source_register.md`

---

## Required Skills

Read and follow:
- `/.claude/skills/research-standards.md` — source register schema, reliability tiers
- `/.claude/skills/sector-data-model.md` — file schemas

---

## STEP 1: Discover Sector-Level Sources

Use WebSearch to find sector-wide data sources (NOT company-specific). Run these queries:

**Regulatory / Government:**
1. `"{sector}" regulator data reports statistics`
2. `"{sector}" government ministry annual report`
3. `"{sector}" spectrum auction results` (if telecom)
4. `"{sector}" industry statistics official`

**Industry Bodies:**
5. `"{sector}" industry association reports`
6. `"{sector}" trade body publications data`

**Research / Analytics:**
7. `"{sector}" market research report 2025`
8. `"{sector}" industry analysis consulting report`

**Financial Data:**
9. `"{sector}" sector ETF holdings companies list`
10. `"{sector}" equity research coverage universe`

For each result, use WebFetch to verify the source exists and extract:
- Exact URL to data/reports
- Publication frequency (annual, quarterly, monthly)
- Data availability (free, gated, subscription)
- Content type (statistics, reports, presentations, databases)

---

## STEP 2: Categorize Sources

Organize discovered sources into categories:

| Category | Examples |
|----------|----------|
| Regulator | TRAI (India telecom), FCC (US telecom), Ofcom (UK) |
| Industry Body | COAI, GSMA, trade associations |
| Government | Ministry of Communications, Census, statistical offices |
| Research Firm | Gartner, IDC, McKinsey, BCG (free reports only) |
| Financial Data | Exchange filings databases, Bloomberg sectors |
| News / Media | Specialized industry publications |

---

## STEP 3: Write S5 — Source Map

Write to: `{sector_path}/S5_sector_source_map.md`

```markdown
# S5: Sector Source Map — {sector}

## Regulatory Sources
| Source | URL | Frequency | Access | Key Data |
|--------|-----|-----------|--------|----------|
| {name} | {url} | Quarterly | Free | Subscriber data, ARPU, revenue |

## Industry Body Sources
[same table format]

## Government / Statistical Sources
[same table format]

## Research & Analytics
[same table format]

## Financial Data Sources
[same table format]

## News & Media
[same table format]

---
Source map generated: {timestamp}
Sources cataloged: {count}
```

---

## STEP 4: Append to Source Register

Read the existing `S5_sector_source_register.md` file.

Append new entries starting from the next available S# ID. If the file doesn't exist yet, the sector-bootstrap agent may be creating it concurrently — write entries starting from `{source_start_id}`.

For each source in the map, add a register entry with:
- Type: `Regulator`, `Industry`, `News`, etc.
- Reliability tier per `research-standards.md`
- Company: `—` (these are sector-wide sources)
- Added By: `sector-init`

---

## STEP 5: Write Summary

Write to: `{sector_path}/_summaries/S5_summary.txt`

**Keep under 500 bytes:**
```
S5 SECTOR SOURCE MAP COMPLETE
Sector: {sector}
Sources cataloged: {count}
  Regulator: {n}
  Industry Body: {n}
  Government: {n}
  Research: {n}
  Financial: {n}
  News: {n}
Free access: {n} | Gated: {n}
Register entries: S{first}-S{last}
File: S5_sector_source_map.md
```

---

## STEP 6: Return

Return only:
- Source counts by category
- Notable sources found (top 3-5 most useful)
- Any major source gaps (e.g., "no free regulator data found")
- File paths created

Do NOT return full source lists in conversation.
