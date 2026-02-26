# Research Standards

This skill defines the source register, evidence log, and source index schemas used across all sector analysis deliverables.

## Source Register Schema

The sector-level source register (`S5_sector_source_register.md`) is an **append-only** master list of all sources used across all companies in the sector. Each source gets a unique sequential ID.

### Format

```markdown
# Sector Source Register — {Sector_Name}

| S# | Type | Name | URL | Reliability | Date | Company | Added By |
|----|------|------|-----|-------------|------|---------|----------|
| 1 | Filing | Jio FY2025 Annual Report | https://... | T1 | 2025-06-15 | Jio Platforms | sector-init |
| 2 | Filing | Airtel FY2025 Annual Report | https://... | T1 | 2025-07-01 | Bharti Airtel | company-intake |
| 3 | Regulator | TRAI Performance Indicators Q3 2025 | https://... | T1 | 2025-10-30 | — | sector-init |
```

### Fields

| Field | Description |
|-------|-------------|
| S# | Sequential integer, never reused. Managed via `_sector_config.json: source_register_next_id` |
| Type | `Filing`, `Transcript`, `Regulator`, `Industry`, `News`, `Broker`, `Academic`, `Company` |
| Name | Human-readable document title |
| URL | Direct URL to source (or "local: {path}" for downloaded PDFs) |
| Reliability | Tier: T1-T4 (see below) |
| Date | Publication date (YYYY-MM-DD) |
| Company | Company name, or `—` for sector-wide sources |
| Added By | Which phase added it: `sector-init`, `company-intake`, `company-evidence` |

### Reliability Tiers

| Tier | Description | Examples |
|------|-------------|----------|
| T1 | Audited/regulatory primary source | Annual reports, 10-K/10-Q, regulator data, audited financials |
| T2 | Unaudited primary source | Earnings calls, investor presentations, management commentary |
| T3 | Reputable secondary source | Industry reports (Gartner, McKinsey), quality financial journalism |
| T4 | Unverified/opinion | Blog posts, social media, anonymous sources, broker notes without data |

**Rule:** Any claim sourced exclusively from T4 sources must carry the `[SPECULATIVE]` epistemic tag.

### ID Allocation

When a new company is added via `/sector-intake`:
1. Read `_sector_config.json` to get `source_register_next_id`
2. Claim a block of 100 IDs: `{next_id}` to `{next_id + 99}`
3. Update `source_register_next_id` to `{next_id + 100}`
4. Use IDs from this block as sources are discovered

This prevents ID collisions when multiple companies are being researched.

## Evidence Log Schema

Each company has an evidence log (`01b_evidence_log.md`) that records specific data points extracted from sources.

### Format

```markdown
# Evidence Log — {Company_Name}

| EL# | Source | Datum | Value | Period | Context | Confidence |
|-----|--------|-------|-------|--------|---------|------------|
| 001 | S14 | Revenue | ₹2,41,000 Cr | FY2025 | Consolidated, as reported | High |
| 002 | S14 | EBITDA Margin | 52.3% | FY2025 | Consolidated | High |
| 003 | S17 | Wireless Subscribers | 481M | Q3 FY2025 | Active 30-day | Medium |
| 004 | S22 | ARPU | ₹203 | Q3 FY2025 | Blended, per month | High |
```

### Fields

| Field | Description |
|-------|-------------|
| EL# | Sequential 3-digit integer per company (001, 002, ...) |
| Source | Source register ID (`S#`) |
| Datum | What is being measured (metric name) |
| Value | The extracted value with units |
| Period | Time period (FY2025, Q3 FY2025, CY2024, etc.) |
| Context | Qualifiers: consolidated/standalone, adjusted/reported, methodology notes |
| Confidence | `High` (directly stated), `Medium` (calculated from stated values), `Low` (implied/estimated) |

### Rules
- Every data point used in 02_base_reality or later documents must have an EL entry
- One entry per discrete data point — do not combine multiple metrics
- If the same metric appears in multiple sources with different values, create separate entries and flag with `[CONTESTED]`

## Source Index Schema

Each company has a source index (`01b_source_index.md`) that maps discovered sources to priority tiers for evidence collection.

### Format

```markdown
# Source Index — {Company_Name}

## Priority 1 — Must Process (fetch + extract)
| S# | Name | Type | Why Priority 1 |
|----|------|------|----------------|
| 14 | FY2025 Annual Report | Filing | Latest audited financials |
| 15 | Q3 FY2025 Results | Filing | Most recent quarterly |

## Priority 2 — Process If Time Permits
| S# | Name | Type | What to Extract |
|----|------|------|-----------------|
| 22 | Investor Day 2025 | Transcript | Forward guidance, capex plans |

## Priority 3 — Reference Only (do not actively fetch)
| S# | Name | Type | Relevance |
|----|------|------|-----------|
| 30 | Sector Report 2024 | Industry | Background context |

## Excluded (with reason)
| S# | Name | Reason |
|----|------|--------|
| 45 | Press release - CSR award | Not relevant to financial analysis |
```

### Priority Definitions

| Priority | Action | Criteria |
|----------|--------|----------|
| P1 | Fetch + full extraction | Latest 2 annual reports, latest 2 quarterly results, any filing with segment data |
| P2 | Fetch + selective extraction | Investor presentations, earnings transcripts, prior-year reports |
| P3 | Reference only | Industry reports, news articles, older filings |
| Excluded | Skip | Non-financial content, duplicate sources, marketing materials |

## Agent Instructions

### For source discovery agents:
- Register all discovered sources in `S5_sector_source_register.md` using allocated ID block
- Create the source index with priority assignments
- Write a `_summaries/01_source_map_summary.txt` (<500 bytes) with source counts by priority

### For evidence collection agents:
- Process all P1 sources first, then P2 if token budget allows
- Create one EL entry per extracted data point
- After extraction, write `_summaries/01b_evidence_summary.txt` (<500 bytes) with extraction stats
