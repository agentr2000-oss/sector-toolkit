---
description: Collect evidence, build base reality, map debates for a company
allowed-tools: Skill, Task, AskUserQuestion, Read, Write, Bash(python3:*), Glob
---

# Sector Research

Handles phases: `evidence`, `base_reality`, `debates` for a company within a sector.

Collects evidence from priority sources, generates the base reality document (02) with sector inheritance, and maps market debates to crux variables (03).

**Required Skills:**
- `/.claude/skills/sector-checkpoint.md` — checkpoint update pattern
- `/.claude/skills/epistemic-tags.md` — tagging standards
- `/.claude/skills/sector-data-model.md` — file schemas

---

## Phase 0: Resolve Paths

Determine sector and company paths from context (passed by `/sector-add` or `$ARGUMENTS`).

Scan if needed:
```
Glob: /Users/agentr/Claude/2026 Master Investment Workflow/Sectors/*/_sector_config.json
```

Then find the active company:
```
Glob: {sector_path}/companies/*/_company_checkpoint.json
```

Read the company checkpoint to verify we're at the right phase.

Set: `sector_path`, `company_path`, `company_name`, `sector_name`

---

## Phase 1: Evidence Collection

### Check if already complete
Read `_company_checkpoint.json`. If `evidence` is `completed`, skip to Phase 2.

### Update checkpoint
Set `evidence` → `in_progress`

### Launch evidence agent

Read agent prompt from `/.claude/agents/company-evidence.md`.

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
Read `{company_path}/_summaries/01b_evidence_summary.txt`

Display to user:
```
## Evidence Collection: {company_name}

{summary contents}

Evidence is ready for base reality generation.
```

### Update checkpoint
Set `evidence` → `completed`

---

## Phase 2: Base Reality (02)

### Check if already complete
If `base_reality` is `completed`, skip to Phase 3.

### Update checkpoint
Set `base_reality` → `in_progress`

### Launch base reality agent

Read agent prompt from `/.claude/agents/company-base-reality.md`.

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
Read `{company_path}/_summaries/02_base_reality_summary.txt`

### Revision gate (02)

Display summary to user:

```
## Base Reality: {company_name}

{summary contents}

The base reality document includes a driver tree, sector benchmarks, and cost structure analysis.
```

```
AskUserQuestion: "Review the base reality before proceeding to debates. This is a critical checkpoint — the driver tree drives all downstream analysis."
Options:
  "Looks good — proceed to debates" |
  "Show me the driver tree" |
  "Show me the sector benchmarks" |
  "I have corrections"
```

**If user wants to see specific sections:** Read just that section from `02_base_reality.md` and display it. Then re-ask.

**If user has corrections:** Apply them to `02_base_reality.md`, then update the summary.

**If user approves:** Continue.

### Update checkpoint
Set `base_reality` → `completed`

---

## Phase 3: Market Debates (03)

### Check if already complete
If `debates` is `completed`, return.

### Update checkpoint
Set `debates` → `in_progress`

### Launch debates agent

Read agent prompt from `/.claude/agents/company-debates.md`.

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
Read `{company_path}/_summaries/03_debates_summary.txt`

### Revision gate (03)

Display summary to user:

```
## Market Debates: {company_name}

{summary contents}
```

```
AskUserQuestion: "Review the debates before proceeding to valuation. These crux variables drive all archetype memos and the council debate."
Options:
  "Looks good — proceed to valuation" |
  "Show me the crux variable map" |
  "I want to add a debate" |
  "I have corrections"
```

Handle each option as with the 02 gate.

### Update checkpoint
Set `debates` → `completed`

### Display completion

```
## Research Phase Complete: {company_name}

Evidence → Base Reality → Debates pipeline complete.

**Driver tree:** {segment count} segments, {branch count} branches
**Debates:** {count} mapped to crux variables
**Next step:** Run `/sector-analyze` to generate valuation and archetype memos.
```

---

## Resume Logic

Read `_company_checkpoint.json` and jump to:
- `evidence` not complete → Phase 1
- `base_reality` not complete → Phase 2
- `debates` not complete → Phase 3
- All complete → inform user and return
