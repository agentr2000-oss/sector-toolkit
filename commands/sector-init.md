---
description: Initialize a new sector for the recursive sector analyst
allowed-tools: Skill, Task, AskUserQuestion, Read, Write, Bash(python3:*), Bash(mkdir:*), Glob
---

# Sector Init

Initializes a new sector by creating the directory structure, launching 3 bootstrap agents in parallel, and writing S1-S5 sector files.

**Required Skills:**
- `/.claude/skills/sector-data-model.md` — config and file schemas
- `/.claude/skills/sector-checkpoint.md` — sector checkpoint schema
- `/.claude/skills/research-standards.md` — source register format

---

## Phase 0: Parse Arguments

Extract sector name from `$ARGUMENTS`. If not provided, ask:

```
AskUserQuestion: "What sector do you want to initialize?"
Options: "India Telecom" | "US Cloud Infrastructure" | "India Financials"
```

Normalize the sector name:
- Display name: as provided (e.g., "India Telecom")
- Slug: replace spaces with underscores (e.g., "India_Telecom")

Set: `sector_path = /Users/agentr/Claude/2026 Master Investment Workflow/Sectors/{slug}`

---

## Phase 1: Create Directory Structure

```bash
mkdir -p "{sector_path}"
mkdir -p "{sector_path}/companies"
mkdir -p "{sector_path}/_summaries"
```

---

## Phase 2: Initialize Config + Checkpoint

Write `{sector_path}/_sector_config.json`:
```json
{
  "version": "1.0",
  "sector_name": "{slug}",
  "display_name": "{display_name}",
  "created_at": "{ISO_timestamp}",
  "last_updated": "{ISO_timestamp}",
  "source_register_next_id": 1,
  "companies": [],
  "sector_files": {
    "S1": "S1_sector_base_reality.md",
    "S2": "S2_sector_comps_matrix.md",
    "S3": "S3_sector_debates.md",
    "S4": "S4_sector_consensus_tracker.md",
    "S5_map": "S5_sector_source_map.md",
    "S5_register": "S5_sector_source_register.md"
  }
}
```

Write `{sector_path}/_sector_checkpoint.json`:
```json
{
  "version": "1.0",
  "sector_name": "{slug}",
  "created_at": "{ISO_timestamp}",
  "last_updated": "{ISO_timestamp}",
  "phases": {
    "bootstrap": {"status": "pending", "timestamp": null},
    "source_map": {"status": "pending", "timestamp": null},
    "comps_seed": {"status": "pending", "timestamp": null},
    "user_review": {"status": "pending", "timestamp": null}
  }
}
```

Initialize empty source register:
```markdown
# Sector Source Register — {display_name}

| S# | Type | Name | URL | Reliability | Date | Company | Added By |
|----|------|------|-----|-------------|------|---------|----------|
```

Write to: `{sector_path}/S5_sector_source_register.md`

---

## Phase 3: Ask for Initial Companies

```
AskUserQuestion: "Which companies should I include in the initial comps matrix? (These are for benchmarking — you'll do deep analysis later via /sector-add)"
Options: "Let me list them" | "Research top players for me"
```

If user lists companies: collect the names.
If user wants auto-research: Use WebSearch for `"{sector}" top companies market cap` and propose 5-8 names for confirmation.

---

## Phase 4: Launch Bootstrap Agents (Parallel)

Update checkpoint: `bootstrap`, `source_map`, `comps_seed` → `in_progress`

Launch 3 agents in parallel using the Task tool:

### Agent 1: Sector Bootstrap
```
Task tool:
  prompt: [Read /.claude/agents/sector-bootstrap.md]
  Variables:
    sector: {display_name}
    sector_path: {sector_path}
    source_start_id: 1
  subagent_type: general-purpose
  run_in_background: true
```

### Agent 2: Sector Source Map
```
Task tool:
  prompt: [Read /.claude/agents/sector-source-map.md]
  Variables:
    sector: {display_name}
    sector_path: {sector_path}
    source_start_id: 51 (reserve 1-50 for bootstrap agent)
  subagent_type: general-purpose
  run_in_background: true
```

### Agent 3: Sector Comps Seed
```
Task tool:
  prompt: [Read /.claude/agents/sector-comps-seed.md]
  Variables:
    sector: {display_name}
    sector_path: {sector_path}
    companies: {comma-separated company list}
  subagent_type: general-purpose
  run_in_background: true
```

**After launching all 3:** Update `_sector_config.json` `source_register_next_id` to 101 (reserving 1-50 for bootstrap, 51-100 for source map).

Wait for all 3 agents to complete (TaskOutput for each).

---

## Phase 5: Read Summaries + Update Checkpoint

After all agents complete:

1. Read `{sector_path}/_summaries/S1_summary.txt`
2. Read `{sector_path}/_summaries/S5_summary.txt`
3. Read `{sector_path}/_summaries/S2_summary.txt`

Update checkpoint: `bootstrap`, `source_map`, `comps_seed` → `completed`

Display to user:
```
## Sector Initialized: {display_name}

**S1 Base Reality:** {key stats from S1 summary}
**S2 Comps Matrix:** {companies seeded, completeness %}
**S3 Debates:** {count} sector debates identified
**S5 Sources:** {count} sector-level sources cataloged

Files created in: {sector_path}/
```

---

## Phase 6: User Review Gate

```
AskUserQuestion: "Review the sector foundation before proceeding. You can open the files directly to inspect them."
Options:
  "Looks good — finalize" |
  "I want to review S1 (base reality)" |
  "I want to review S2 (comps matrix)" |
  "I want to review S3 (debates)" |
  "Make changes"
```

**If user wants to review:** Read and display the requested file summary. Let them suggest edits.

**If user approves:** Update checkpoint: `user_review` → `completed`

---

## Phase 7: Completion

Display:
```
## Sector Ready: {display_name}

Sector layer initialized with {company_count} comparables.
Use `/sector-add [Company Name]` to begin deep analysis of a specific company.
Use `/sector-status` to view sector state at any time.

Sector path: {sector_path}
```

---

## Resume Logic

If `_sector_checkpoint.json` already exists at the sector path:

1. Read checkpoint
2. Find first incomplete phase
3. If `bootstrap`/`source_map`/`comps_seed` incomplete → re-launch those agents
4. If `user_review` incomplete → jump to Phase 6
5. If all complete → inform user sector is already initialized
