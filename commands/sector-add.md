---
description: Master orchestrator - add a company to a sector for deep analysis
allowed-tools: Skill, Task, AskUserQuestion, Read, Write, Bash(python3:*), Bash(mkdir:*), Glob
---

# Sector Add (Master Orchestrator)

Runs the full company analysis pipeline for a sector. Chains sub-commands in sequence:
1. `/sector-intake` — resolve identity, discover sources, build source index
2. `/sector-research` — collect evidence, build base reality, map debates
3. `/sector-analyze` — valuation + archetype memos
4. `/sector-debate` — council debate, synthesis, monitoring playbook
5. `/sector-delta` — recursive sector layer updates

Each sub-command handles its own checkpoint phases. This orchestrator reads the company checkpoint and routes to the first incomplete sub-command.

**Required Skills:**
- `/.claude/skills/sector-checkpoint.md` — phase-to-subcommand mapping, resume logic

---

## Phase 0: Resolve Sector

If `$ARGUMENTS` contains a company name, extract it.

Find the active sector:
```
Glob: /Users/agentr/Claude/2026 Master Investment Workflow/Sectors/*/_sector_config.json
```

If multiple sectors exist:
```
AskUserQuestion: "Which sector?"
Options: [list sector names from found configs]
```

If no sectors exist:
```
No sectors initialized. Run `/sector-init [Sector Name]` first.
```
Return.

Read `_sector_config.json` and `_sector_checkpoint.json`.

**Verify sector init is complete:** All 4 sector checkpoint phases must be `completed`. If not:
```
Sector "{sector}" initialization is incomplete. Run `/sector-init {sector}` to finish setup.
```
Return.

Set: `sector_path`, `sector_name`

---

## Phase 1: Resolve Company

If company name not in arguments, ask:
```
AskUserQuestion: "Which company to analyze in the {sector} sector?"
```

Normalize company name:
- `company_name` — display name
- `company_slug` — underscored version
- `company_path` — `{sector_path}/companies/{company_slug}`

### Check for existing checkpoint

```
Glob: {company_path}/_company_checkpoint.json
```

If checkpoint exists, read it. If all phases `completed`:
```
{company_name} analysis is already complete. To re-analyze, delete {company_path}/_company_checkpoint.json and run again.
```
Return.

If checkpoint exists with incomplete phases:
```
AskUserQuestion: "Found incomplete analysis for {company_name} (last updated {date}). Resume?"
Options: "Resume from {first_incomplete_phase}" | "Start fresh"
```

If start fresh: delete company_path contents and proceed.
If resume: proceed to routing.

---

## Phase 2: Route to Sub-Commands

Read `_company_checkpoint.json` (or note that it doesn't exist yet for a new company).

### Phase-to-SubCommand Mapping

| Phases | Sub-Command |
|--------|-------------|
| `intake`, `source_map`, `source_index` | `/sector-intake` |
| `evidence`, `base_reality`, `debates` | `/sector-research` |
| `valuation`, `archetype_*` | `/sector-analyze` |
| `council`, `synthesis`, `monitoring` | `/sector-debate` |
| `delta`, `delta_applied`, `complete` | `/sector-delta` |

### Determine first incomplete phase

Find the first phase in order where `status` is not `completed` and not `skipped`:
```
intake → source_map → source_index → evidence → base_reality → debates →
valuation → archetype_growth → archetype_value → archetype_quality → archetype_momentum →
council → synthesis → monitoring → delta → delta_applied → complete
```

Map that phase to its sub-command.

### Execute sub-command chain

Invoke the sub-command via Skill tool:

```
Skill: sector-intake
Args: {company_name}
```

After it returns, re-read the checkpoint and check for the next incomplete phase. If the next phase maps to a different sub-command, invoke it:

```
Skill: sector-research
```

Continue until all sub-commands have run:

```
Skill: sector-analyze
```

```
Skill: sector-debate
```

```
Skill: sector-delta
```

---

## Phase 3: Completion

After all sub-commands complete:

Read final summaries:
- `{company_path}/_summaries/06_synthesis_summary.txt`
- `{company_path}/_summaries/08_delta_summary.txt`

Display:

```
## Analysis Complete: {company_name} in {sector_name}

### Recommendation
{synthesis summary}

### Sector Impact
{delta summary}

### All Deliverables
| # | Document | File |
|---|----------|------|
| 00 | Intake | 00_intake.md |
| 01 | Source Map | 01_source_map.md |
| 01b | Source Index | 01b_source_index.md |
| 01b | Evidence Log | 01b_evidence_log.md |
| 02 | Base Reality | 02_base_reality.md |
| 03 | Market Debates | 03_market_debates.md |
| 04 | Valuation | 04_valuation.md |
| 04 | Growth Archetype | 04_archetype_growth.md |
| 04 | Value Archetype | 04_archetype_value.md |
| 04 | Quality Archetype | 04_archetype_quality.md |
| 04 | Momentum Archetype | 04_archetype_momentum.md (if generated) |
| 05 | Council Debate | 05_council_debate.md |
| 06 | Synthesis | 06_synthesis_recommendation.md |
| 07 | Monitoring Playbook | 07_monitoring_playbook.md |
| 08 | Sector Delta | 08_sector_delta.md |

**Location:** {company_path}/

### Next Steps
- `/sector-add [Next Company]` — analyze another company (sector context enriched)
- `/sector-status` — view updated sector state
```

---

## Error Handling

If a sub-command fails or a background agent returns an error:
1. Display the error to the user
2. The checkpoint preserves the last successful phase
3. User can re-run `/sector-add {company_name}` to resume from the failed phase
4. All agents are idempotent — re-running is safe
