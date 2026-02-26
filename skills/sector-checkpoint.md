# Sector Checkpoint System

This skill defines the checkpoint schemas, phase dependencies, and resume logic for the sector analyst workflow.

## Two Checkpoint Levels

### 1. Sector Checkpoint
**File:** `{Sector}/_sector_checkpoint.json`
**Managed by:** `/sector-init`
**Phases:** 4 (bootstrap → source_map → comps_seed → user_review)

### 2. Company Checkpoint
**File:** `{Sector}/companies/{Company}/_company_checkpoint.json`
**Managed by:** `/sector-add` and its sub-commands
**Phases:** 17 (intake through complete)

## Sector Checkpoint — Full Schema

```json
{
  "version": "1.0",
  "sector_name": "India_Telecom",
  "created_at": "2026-02-26T10:00:00Z",
  "last_updated": "2026-02-26T10:30:00Z",
  "phases": {
    "bootstrap": {"status": "pending", "timestamp": null},
    "source_map": {"status": "pending", "timestamp": null},
    "comps_seed": {"status": "pending", "timestamp": null},
    "user_review": {"status": "pending", "timestamp": null}
  }
}
```

| Phase | Description | Agent/Command | User Input |
|-------|-------------|---------------|------------|
| bootstrap | Research sector base reality | `sector-bootstrap` agent | No |
| source_map | Discover sector-level sources | `sector-source-map` agent | No |
| comps_seed | Seed initial comps matrix | `sector-comps-seed` agent | Yes (company names) |
| user_review | User reviews and approves S1-S5 | `/sector-init` command | **Yes** |

## Company Checkpoint — Full Schema

```json
{
  "version": "1.0",
  "company": "Jio Platforms",
  "sector": "India_Telecom",
  "sector_path": "/Users/agentr/Claude/2026 Master Investment Workflow/Sectors/India_Telecom",
  "created_at": "2026-02-26T11:00:00Z",
  "last_updated": "2026-02-26T14:30:00Z",
  "source_id_block": [1, 100],
  "phases": {
    "intake": {"status": "pending", "timestamp": null},
    "source_map": {"status": "pending", "timestamp": null},
    "source_index": {"status": "pending", "timestamp": null},
    "evidence": {"status": "pending", "timestamp": null},
    "base_reality": {"status": "pending", "timestamp": null},
    "debates": {"status": "pending", "timestamp": null},
    "valuation": {"status": "pending", "timestamp": null},
    "archetype_growth": {"status": "pending", "timestamp": null},
    "archetype_value": {"status": "pending", "timestamp": null},
    "archetype_quality": {"status": "pending", "timestamp": null},
    "archetype_momentum": {"status": "pending", "timestamp": null},
    "council": {"status": "pending", "timestamp": null},
    "synthesis": {"status": "pending", "timestamp": null},
    "monitoring": {"status": "pending", "timestamp": null},
    "delta": {"status": "pending", "timestamp": null},
    "delta_applied": {"status": "pending", "timestamp": null},
    "complete": {"status": "pending", "timestamp": null}
  }
}
```

## Phase Dependency Map

### Company Phases (linear with one parallel group)

```
intake
  └→ source_map
       └→ source_index
            └→ evidence
                 └→ base_reality
                      └→ debates
                           └→ valuation
                                └→ [PARALLEL GROUP]
                                │   ├─ archetype_growth
                                │   ├─ archetype_value
                                │   ├─ archetype_quality
                                │   └─ archetype_momentum (may be skipped)
                                └→ council (requires all archetypes complete/skipped)
                                     └→ synthesis
                                          └→ monitoring
                                               └→ delta
                                                    └→ delta_applied
                                                         └→ complete
```

### Sub-Command Mapping

| Sub-Command | Phases Covered | Entry Condition |
|-------------|---------------|-----------------|
| `/sector-intake` | intake, source_map, source_index | First incomplete phase is intake/source_map/source_index |
| `/sector-research` | evidence, base_reality, debates | First incomplete phase is evidence/base_reality/debates |
| `/sector-analyze` | valuation, archetype_* | First incomplete phase is valuation/archetype_* |
| `/sector-debate` | council, synthesis, monitoring | First incomplete phase is council/synthesis/monitoring |
| `/sector-delta` | delta, delta_applied, complete | First incomplete phase is delta/delta_applied/complete |

## Resume Logic

### For `/sector-add` (Master Orchestrator)

```
1. Read _company_checkpoint.json
2. Find first phase where status != "completed" and status != "skipped"
3. Map phase → sub-command (see table above)
4. Invoke sub-command via Skill tool
5. After sub-command completes, re-read checkpoint
6. If more incomplete phases exist, invoke next sub-command
7. Repeat until all phases complete or skipped
```

### For Each Sub-Command

```
1. Read _company_checkpoint.json
2. For each phase this sub-command owns:
   a. If status == "completed" or "skipped" → skip
   b. If status == "pending" or "in_progress" → execute
3. Execute phase:
   a. Update status to "in_progress" + timestamp
   b. Launch agent (Task tool, run_in_background: true)
   c. Wait for agent completion (TaskOutput)
   d. Read summary file to verify success
   e. Update status to "completed" + timestamp
4. After all owned phases complete, return to orchestrator
```

### Handling "in_progress" on Resume

If a phase is `in_progress` when the checkpoint is read (conversation was interrupted):
- Treat as `pending` — re-run the phase from scratch
- Agents are idempotent: they overwrite output files, so re-running is safe

## Checkpoint Update Pattern

```python
# Pseudocode for checkpoint updates (executed via Bash/python3)
import json
from datetime import datetime

def update_checkpoint(checkpoint_path, phase, status):
    with open(checkpoint_path, 'r') as f:
        cp = json.load(f)
    cp['phases'][phase]['status'] = status
    cp['phases'][phase]['timestamp'] = datetime.utcnow().isoformat() + 'Z'
    cp['last_updated'] = datetime.utcnow().isoformat() + 'Z'
    with open(checkpoint_path, 'w') as f:
        json.dump(cp, f, indent=2)
```

In practice, commands update checkpoints using:
```bash
python3 -c "
import json; from datetime import datetime
cp = json.load(open('PATH'))
cp['phases']['PHASE']['status'] = 'STATUS'
cp['phases']['PHASE']['timestamp'] = datetime.utcnow().isoformat() + 'Z'
cp['last_updated'] = datetime.utcnow().isoformat() + 'Z'
json.dump(cp, open('PATH', 'w'), indent=2)
"
```

## Momentum Skip Logic

The `archetype_momentum` phase is skipped when:
1. Company is pre-IPO or recently listed (<2 years of price history)
2. Company is private (no public market data)
3. User explicitly requests skip during `/sector-analyze`

To skip:
```bash
# Set status to "skipped" instead of "completed"
python3 -c "
import json; from datetime import datetime
cp = json.load(open('PATH'))
cp['phases']['archetype_momentum']['status'] = 'skipped'
cp['phases']['archetype_momentum']['timestamp'] = datetime.utcnow().isoformat() + 'Z'
cp['last_updated'] = datetime.utcnow().isoformat() + 'Z'
json.dump(cp, open('PATH', 'w'), indent=2)
"
```

## Context Window Protection

**Rule:** The main conversation (orchestrator) must NEVER read full deliverable files.

Instead:
1. Agents write `_summaries/{phase}_summary.txt` (<500 bytes)
2. Orchestrator reads only summary files
3. Agents read full files from disk when they need prior outputs
4. Sector summaries (S1-S5 headers) are injected into agent prompts by the orchestrator

This keeps the main conversation context lean and prevents context window overflow during multi-company workflows.
