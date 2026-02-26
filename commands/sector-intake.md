---
description: Company intake - resolve variables, discover sources, create source index
allowed-tools: Skill, Task, AskUserQuestion, Read, Write, Bash(python3:*), Bash(mkdir:*), Glob
---

# Sector Intake

Handles phases: `intake`, `source_map`, `source_index` for a company within a sector.

Creates 00_intake.md, discovers sources, and builds the prioritized source index.

**Required Skills:**
- `/.claude/skills/sector-data-model.md` — intake schema, config schema
- `/.claude/skills/sector-checkpoint.md` — company checkpoint, update pattern
- `/.claude/skills/research-standards.md` — source register, source index schemas

---

## Phase 0: Resolve Paths

Read the sector path and company name from context (passed by `/sector-add` orchestrator or `$ARGUMENTS`).

If `$ARGUMENTS` contains both sector and company: parse them.
Otherwise, scan for the active sector:
```
Glob: /Users/agentr/Claude/2026 Master Investment Workflow/Sectors/*/_sector_config.json
```

Set:
- `sector_path` — path to sector directory
- `company_name` — display name
- `company_slug` — underscored version
- `company_path` — `{sector_path}/companies/{company_slug}`

---

## Phase 1: Intake (00_intake.md)

### Check if already complete
Read `{company_path}/_company_checkpoint.json`. If `intake` is `completed`, skip to Phase 2.

### Create directory structure
```bash
mkdir -p "{company_path}"
mkdir -p "{company_path}/_summaries"
```

### Resolve company variables

Use WebSearch to find:
1. `"{company_name}" investor relations`
2. `"{company_name}" ticker exchange market cap`
3. `"{company_name}" annual report fiscal year`

Extract:
- Full legal name
- Ticker and exchange
- Domicile / country
- Reporting currency
- Fiscal year end
- Current market cap (approximate)

### Sector alignment check

Read `{sector_path}/_sector_config.json` for sector name.

Verify the company belongs in this sector:
- What % of revenue comes from the primary sector activity?
- Any significant cross-sector exposure?

### Allocate source ID block

Read `{sector_path}/_sector_config.json` to get `source_register_next_id`.
Claim block: `[next_id, next_id + 99]`
Update config: `source_register_next_id = next_id + 100`
Add company to `companies` array in config.

### Write 00_intake.md

Write to: `{company_path}/00_intake.md`

Follow the schema from `sector-data-model.md`. Include:
- All resolved identity fields
- Sector alignment assessment
- 3-5 key questions for the analysis
- Allocated source ID block

### Initialize company checkpoint

Write `{company_path}/_company_checkpoint.json` per `sector-checkpoint.md` schema.
Set `intake` → `completed`.

### Write summary

Write to: `{company_path}/_summaries/00_intake_summary.txt` (<500 bytes)

---

## Phase 2: Source Discovery (01_source_map)

### Check if already complete
If `source_map` is `completed` in checkpoint, skip to Phase 3.

### Update checkpoint
Set `source_map` → `in_progress`

### Launch source discovery agent

Read the agent prompt from `/.claude/agents/company-source-discovery.md`.

Launch via Task tool:
```
Task tool:
  prompt: [agent prompt with variables filled in]
  Variables:
    company: {company_name}
    sector: {sector_display_name}
    company_path: {company_path}
    sector_path: {sector_path}
    block_start: {source_id_block[0]}
    block_end: {source_id_block[1]}
  subagent_type: general-purpose
  run_in_background: true
```

Wait for completion (TaskOutput).

### Read summary
Read `{company_path}/_summaries/01_source_map_summary.txt`

### User source selection

Display summary to user, then:

```
AskUserQuestion: "Source discovery found {count} documents. Which priorities should we process?"
Options:
  "Process all P1 sources (recommended)" |
  "Process P1 + P2 sources" |
  "Let me review the source index first" |
  "Adjust priorities"
```

If user wants to review: Read and display `{company_path}/01b_source_index.md`

### Update checkpoint
Set `source_map` → `completed`

---

## Phase 3: Source Index Finalization (source_index)

### Check if already complete
If `source_index` is `completed` in checkpoint, return.

### Finalize based on user selection

If user selected a priority level, the source index is already written by the agent.

If user requested adjustments, update `01b_source_index.md` accordingly.

### Update checkpoint
Set `source_index` → `completed`

### Display completion

```
## Intake Complete: {company_name}

**Identity:** {ticker} | {exchange} | {currency}
**Sources found:** {total} (P1: {n}, P2: {n}, P3: {n})
**Source register IDs:** S{start}-S{end}
**Next step:** Run `/sector-research` to collect evidence and build base reality.

Files created:
- {company_path}/00_intake.md
- {company_path}/01_source_map.md
- {company_path}/01b_source_index.md
```

---

## Resume Logic

Read `_company_checkpoint.json` and jump to the first phase where status is not `completed`:
- `intake` not complete → Phase 1
- `source_map` not complete → Phase 2
- `source_index` not complete → Phase 3
- All complete → inform user and return
