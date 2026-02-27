---
description: Initialize a new sector for the recursive sector analyst
allowed-tools: Skill, Task, AskUserQuestion, Read, Write, Bash(python3:*), Bash(mkdir:*), Bash(~/repos/sector-research/sync.sh:*), Glob
---

# Sector Init

Initializes a new sector by creating the directory structure, running a multi-phase research pipeline (discovery → synthesis → deepening), and writing S1-S5 sector files.

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

Set: `sector_path = /Users/agentr/Claude/Code/2026 Master Investment Workflow/Sectors/{slug}`

---

## Phase 1: Create Directory Structure

```bash
mkdir -p "{sector_path}"
mkdir -p "{sector_path}/companies"
mkdir -p "{sector_path}/_summaries"
mkdir -p "{sector_path}/_working"
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
    "discovery": {"status": "pending", "timestamp": null},
    "source_map": {"status": "pending", "timestamp": null},
    "comps_seed": {"status": "pending", "timestamp": null},
    "bootstrap": {"status": "pending", "timestamp": null},
    "deepen": {"status": "pending", "timestamp": null},
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

## Phase 4a: Launch Discovery + Source Map + Comps Seed (Parallel)

Update checkpoint: `discovery`, `source_map`, `comps_seed` → `in_progress`

Launch 3 agents in parallel using the Task tool:

### Agent 1: Sector Discovery (NEW — evidence collection)
```
Task tool:
  prompt: [Read /.claude/agents/sector-discovery.md]
  Variables:
    sector: {display_name}
    sector_path: {sector_path}
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

**After launching all 3:** Update `_sector_config.json` `source_register_next_id` to 151 (reserving 1-50 for bootstrap, 51-100 for source map, 101-150 for deepen).

Wait for all 3 agents to complete (TaskOutput for each).

Update checkpoint: `discovery`, `source_map`, `comps_seed` → `completed`

---

## Phase 4b: Launch Bootstrap (Sequential — after 4a)

The bootstrap agent reads the discovery output and synthesizes it into S1.

Update checkpoint: `bootstrap` → `in_progress`

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

Wait for the bootstrap agent to complete (TaskOutput).

Update checkpoint: `bootstrap` → `completed`

---

## Phase 4c: Launch Deepen (Sequential — after 4b)

The deepen agent reads S1 + gap list, fills gaps, cross-verifies claims, and updates S1.

Update checkpoint: `deepen` → `in_progress`

```
Task tool:
  prompt: [Read /.claude/agents/sector-deepen.md]
  Variables:
    sector: {display_name}
    sector_path: {sector_path}
    source_start_id: 101
  subagent_type: general-purpose
  run_in_background: true
```

Wait for the deepen agent to complete (TaskOutput).

Update checkpoint: `deepen` → `completed`

---

## Phase 5: Read Summaries + Display Results

After all agents complete:

1. Read `{sector_path}/_summaries/S1_summary.txt`
2. Read `{sector_path}/_summaries/S5_summary.txt`
3. Read `{sector_path}/_summaries/S2_summary.txt`
4. Read `{sector_path}/_summaries/deepen_summary.txt`

Display to user:
```
## Sector Initialized: {display_name}

**S1 Base Reality:** {key stats from S1 summary}
**S1 Deepening:** {quality gates passed, gaps filled from deepen summary}
**S2 Comps Matrix:** {companies seeded, completeness %}
**S3 Debates:** {count} sector debates identified
**S5 Sources:** {count} sector-level sources cataloged

Research pipeline: Discovery → Bootstrap → Deepen (3-agent chain)
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

## Phase 6.5: Publish to GitHub

After user approves in Phase 6, sync the sector output to the sector-research repo.

Run via Bash:
```
~/repos/sector-research/sync.sh push {slug}
```

If the sync script doesn't exist or the repo isn't cloned:
```
echo "⚠ sector-research repo not found at ~/repos/sector-research/"
echo "Clone it with: git clone https://github.com/agentr2000-oss/sector-research.git ~/repos/sector-research"
```

Skip this phase gracefully if the repo isn't set up — don't block sector-init completion.

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
3. If `discovery`/`source_map`/`comps_seed` incomplete → re-launch Phase 4a agents
4. If `bootstrap` incomplete → re-launch Phase 4b (requires discovery to be complete)
5. If `deepen` incomplete → re-launch Phase 4c (requires bootstrap to be complete)
6. If `user_review` incomplete → jump to Phase 6
7. If all complete → inform user sector is already initialized
