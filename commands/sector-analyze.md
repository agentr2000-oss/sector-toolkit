---
description: Generate valuation and archetype memos for a company
allowed-tools: Skill, Task, AskUserQuestion, Read, Write, Bash(python3:*), Glob
---

# Sector Analyze

Handles phases: `valuation`, `archetype_growth`, `archetype_value`, `archetype_quality`, `archetype_momentum` for a company within a sector.

Generates the multi-methodology valuation (04_valuation) and archetype investment memos, with archetypes running in parallel after valuation completes.

**Required Skills:**
- `/.claude/skills/sector-checkpoint.md` — checkpoint update, momentum skip logic
- `/.claude/skills/epistemic-tags.md` — tagging standards
- `/.claude/skills/sector-data-model.md` — file schemas

---

## Phase 0: Resolve Paths

Determine sector and company paths from context (passed by `/sector-add` or `$ARGUMENTS`).

Scan if needed:
```
Glob: /Users/agentr/Claude/2026 Master Investment Workflow/Sectors/*/_sector_config.json
```

Find the active company (most recent with incomplete checkpoint):
```
Glob: {sector_path}/companies/*/_company_checkpoint.json
```

Set: `sector_path`, `company_path`, `company_name`, `sector_name`

---

## Phase 1: Valuation (04_valuation)

### Check if already complete
Read `_company_checkpoint.json`. If `valuation` is `completed`, skip to Phase 2.

### Update checkpoint
Set `valuation` → `in_progress`

### Launch valuation agent

Read agent prompt from `/.claude/agents/company-valuation.md`.

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
Read `{company_path}/_summaries/04_valuation_summary.txt`

Display to user:
```
## Valuation: {company_name}

{summary contents}
```

### Update checkpoint
Set `valuation` → `completed`

---

## Phase 2: Momentum Decision

### Check checkpoint for momentum status
If `archetype_momentum` is already `completed` or `skipped`, skip this decision.

### Ask user about momentum

```
AskUserQuestion: "Should the momentum archetype memo be generated? This requires public market price data."
Options:
  "Yes — include momentum analysis (Recommended)" |
  "No — skip momentum (pre-IPO or insufficient data)" |
  "Let me decide after seeing the other archetypes"
```

If skip: Update `archetype_momentum` → `skipped` in checkpoint.
If defer: Set `include_momentum = false` for now; revisit after Phase 3.

Set: `include_momentum` based on user choice.

---

## Phase 3: Archetype Memos (Parallel)

### Check which archetypes are incomplete
Read checkpoint. For each of `archetype_growth`, `archetype_value`, `archetype_quality`, `archetype_momentum`:
- If `completed` or `skipped` → skip
- If `pending` or `in_progress` → include in batch

### Launch archetype agent

The archetypes agent generates all memos in a single run. Set which to include based on checkpoint status.

Read agent prompt from `/.claude/agents/company-archetypes.md`.

Launch via Task tool:
```
Task tool:
  prompt: [agent prompt with variables]
  Variables:
    company: {company_name}
    sector: {sector_name}
    company_path: {company_path}
    sector_path: {sector_path}
    archetypes: "Growth, Value, Quality{, Momentum}"
    include_momentum: {true/false}
  subagent_type: general-purpose
  run_in_background: true
```

Wait for completion (TaskOutput).

### Read summary
Read `{company_path}/_summaries/04_archetypes_summary.txt`

### Update checkpoint
Set completed archetypes to `completed`.
If momentum was deferred and user chose "Let me decide after":

```
AskUserQuestion: "The Growth, Value, and Quality archetypes are complete. Would you like to add the Momentum archetype?"
Options: "Yes — generate momentum" | "No — skip"
```

If yes: re-launch agent with just momentum. If no: set `archetype_momentum` → `skipped`.

---

## Phase 4: Display Completion

Read all archetype summaries and display:

```
## Analysis Phase Complete: {company_name}

### Valuation
{04_valuation summary}

### Archetype Scores
| Archetype | Score | Verdict | Conviction |
|-----------|-------|---------|------------|
| Growth | {x}/5 | {verdict} | {level} |
| Value | {x}/5 | {verdict} | {level} |
| Quality | {x}/5 | {verdict} | {level} |
| Momentum | {x}/5 or Skipped | {verdict} | {level} |

**Key disagreement:** {which archetypes disagree}
**Next step:** Run `/sector-debate` for council debate and synthesis.
```

---

## Resume Logic

Read `_company_checkpoint.json` and jump to:
- `valuation` not complete → Phase 1
- Any archetype not complete/skipped → Phase 3
- All complete → inform user and return
