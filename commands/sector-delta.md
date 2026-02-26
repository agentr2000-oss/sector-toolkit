---
description: Analyze and apply sector delta updates from company analysis
allowed-tools: Skill, Task, AskUserQuestion, Read, Write, Edit, Bash(python3:*), Glob
---

# Sector Delta

Handles phases: `delta`, `delta_applied`, `complete` for a company within a sector.

Runs the delta analysis agent to identify how company findings should update sector files (S1-S5), then applies approved changes with a per-file user gate.

**Required Skills:**
- `/.claude/skills/sector-checkpoint.md` — checkpoint update pattern
- `/.claude/skills/sector-data-model.md` — comps matrix update rules

---

## Phase 0: Resolve Paths

Determine sector and company paths from context (passed by `/sector-add` or `$ARGUMENTS`).

Scan if needed:
```
Glob: /Users/agentr/Claude/2026 Master Investment Workflow/Sectors/*/_sector_config.json
```

Find the active company:
```
Glob: {sector_path}/companies/*/_company_checkpoint.json
```

Set: `sector_path`, `company_path`, `company_name`, `sector_name`

---

## Phase 1: Delta Analysis (08)

### Check if already complete
Read `_company_checkpoint.json`. If `delta` is `completed`, skip to Phase 2.

### Update checkpoint
Set `delta` → `in_progress`

### Launch delta agent

Read agent prompt from `/.claude/agents/company-delta.md`.

Launch via Task tool:
```
Task tool:
  prompt: [agent prompt with variables]
  Variables:
    company: {company_name}
    sector: {sector_name}
    company_path: {company_path}
    sector_path: {sector_path}
  subagent_type: general-purpose
  run_in_background: true
```

Wait for completion (TaskOutput).

### Read summary
Read `{company_path}/_summaries/08_delta_summary.txt`

### Update checkpoint
Set `delta` → `completed`

Display:
```
## Sector Delta: {company_name} → {sector_name}

{summary contents}
```

---

## Phase 2: Apply Delta Updates (delta_applied)

### Check if already complete
If `delta_applied` is `completed`, skip to Phase 3.

### Read full delta
Read `{company_path}/08_sector_delta.md` to get all proposed updates.

### Apply S2 Comps Matrix (Mandatory — No Gate)

The comps matrix update is always applied:

1. Read `{sector_path}/S2_sector_comps_matrix.md`
2. Add the new company column with all metrics
3. Recalculate Median and Mean columns
4. Update the "Last updated" timestamp and "Companies" count
5. Write back to `S2_sector_comps_matrix.md`

Display: `S2 updated: Added {company_name} column. New median EV/EBITDA: {x}`

### Gate: S1 Updates

If there are S1 updates proposed:

Display each proposed update and ask:
```
AskUserQuestion: "S1 Base Reality: {count} updates proposed. Apply?"
Options:
  "Apply all" |
  "Review each update" |
  "Skip S1 updates"
```

If "Review each": Show each update with current text / proposed text / justification. For each:
```
AskUserQuestion: "Apply this S1 update?"
Options: "Apply" | "Skip" | "Modify"
```

Apply approved updates via Edit tool to `S1_sector_base_reality.md`.

### Gate: S3 Updates

Same pattern as S1:
```
AskUserQuestion: "S3 Debates: {count} updates proposed. Apply?"
Options: "Apply all" | "Review each" | "Skip S3 updates"
```

Apply approved updates to `S3_sector_debates.md`.

### Gate: S4 Updates

```
AskUserQuestion: "S4 Consensus: {count} updates proposed. Apply?"
Options: "Apply all" | "Skip S4 updates"
```

Apply to `S4_sector_consensus_tracker.md`.

### Update checkpoint
Set `delta_applied` → `completed`

---

## Phase 3: Append Update Log + Complete

### Append to update log

Read (or create) `{sector_path}/update_log.md`.

Append entry:
```markdown
### {ISO_date} — {company_name} Added
- **S2 Comps:** +1 column (total: {count} companies)
- **S1 Updates:** {applied_count} of {proposed_count} applied
- **S3 Updates:** {applied_count} of {proposed_count} applied
- **S4 Updates:** {applied_count} of {proposed_count} applied
- **New median EV/EBITDA:** {value}
- **Analyst:** {company_name} rated {rating} with {conviction} conviction
```

### Update company status in sector config

Read `{sector_path}/_sector_config.json`.
Update the company entry: `"status": "complete"`
Write back.

### Update checkpoint
Set `complete` → `completed`

### Display completion

```
## Company Complete: {company_name}

All 17 phases complete. Sector layer updated.

### Delta Applied
- S2 Comps: +1 column → {total} companies
- S1: {n} updates applied
- S3: {n} updates applied
- S4: {n} updates applied

### Company Output
Rating: {rating} | Conviction: {level} | Expected Return: {%}

### Files
- Company analysis: {company_path}/
- Sector files: {sector_path}/S1-S5

### Next Steps
- `/sector-add [Next Company]` — analyze another company (sector context now richer)
- `/sector-status` — view updated sector state
- `/sector-update [event]` — refresh sector with new information
```

---

## Resume Logic

Read `_company_checkpoint.json` and jump to:
- `delta` not complete → Phase 1
- `delta_applied` not complete → Phase 2
- `complete` not set → Phase 3
- All complete → inform user and return
