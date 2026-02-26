---
description: Run council debate, generate synthesis, and create monitoring playbook
allowed-tools: Skill, Task, AskUserQuestion, Read, Write, Bash(python3:*), Glob
---

# Sector Debate

Handles phases: `council`, `synthesis`, `monitoring` for a company within a sector.

Runs the structured council debate between archetype investors, generates the synthesis recommendation with pre-mortem and base-rate checks, and creates the monitoring playbook.

**Required Skills:**
- `/.claude/skills/sector-checkpoint.md` — checkpoint update pattern
- `/.claude/skills/epistemic-tags.md` — tagging standards

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

## Phase 1: Council Debate (05)

### Check if already complete
Read `_company_checkpoint.json`. If `council` is `completed`, skip to Phase 2.

### Update checkpoint
Set `council` → `in_progress`

### Launch council agent

Read agent prompt from `/.claude/agents/company-council.md`.

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
Read `{company_path}/_summaries/05_council_summary.txt`

Display to user:
```
## Council Debate: {company_name}

{summary contents}
```

### Update checkpoint
Set `council` → `completed`

---

## Phase 2: Synthesis + Monitoring (06 + 07)

### Check if already complete
If `synthesis` and `monitoring` are both `completed`, skip to completion.

### Update checkpoint
Set `synthesis` → `in_progress`

### Launch synthesis agent

The synthesis agent generates both 06 and 07 in a single run.

Read agent prompt from `/.claude/agents/company-synthesis.md`.

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

### Read summaries
Read `{company_path}/_summaries/06_synthesis_summary.txt`
Read `{company_path}/_summaries/07_monitoring_summary.txt`

### Update checkpoint
Set `synthesis` → `completed`
Set `monitoring` → `completed`

### Display results

```
## Synthesis: {company_name}

### Recommendation
{06 summary contents}

### Monitoring
{07 summary contents}
```

### User review gate

```
AskUserQuestion: "Review the synthesis and monitoring playbook. This is the final analytical output before the sector delta step."
Options:
  "Looks good — proceed to sector delta" |
  "Show me the pre-mortem analysis" |
  "Show me the monitoring triggers" |
  "I have adjustments"
```

**If user wants details:** Read the relevant section from 06 or 07 and display.
**If user has adjustments:** Apply them to the files.

---

## Phase 3: Display Completion

```
## Debate & Synthesis Complete: {company_name}

**Rating:** {rating} | **Conviction:** {level}
**Expected return:** {weighted return}%
**Top risk:** {failure mode}
**Next catalyst:** {date} — {event}

**Next step:** Run `/sector-delta` to analyze how {company_name} should update the sector layer.
```

---

## Resume Logic

Read `_company_checkpoint.json` and jump to:
- `council` not complete → Phase 1
- `synthesis` or `monitoring` not complete → Phase 2
- All complete → inform user and return
