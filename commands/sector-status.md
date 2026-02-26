---
description: View current sector state and company completion status
allowed-tools: Read, Glob, Bash(python3:*)
---

# Sector Status

Read-only command that displays the current state of a sector and its companies.

---

## Phase 0: Find Sector

If `$ARGUMENTS` is provided, use it as the sector name.

Otherwise, scan for existing sectors:
```
Glob: /Users/agentr/Claude/2026 Master Investment Workflow/Sectors/*/_sector_config.json
```

If multiple sectors exist, list them and ask user which to view.

If only one exists, use it.

Set: `sector_path` from the found config file's directory.

---

## Phase 1: Read Sector State

Read `{sector_path}/_sector_config.json` and `{sector_path}/_sector_checkpoint.json`.

---

## Phase 2: Display Sector Overview

```markdown
## Sector: {display_name}

**Status:** {Initialized | In Progress | Active}
**Created:** {created_at}
**Last Updated:** {last_updated}
**Companies:** {count}
**Source Register:** {source_register_next_id - 1} entries allocated

### Sector Files
| File | Status |
|------|--------|
| S1 Base Reality | {exists: Yes/No} |
| S2 Comps Matrix | {exists: Yes/No, company count} |
| S3 Debates | {exists: Yes/No, debate count} |
| S4 Consensus | {exists: Yes/No} |
| S5 Source Map | {exists: Yes/No, source count} |
| S5 Source Register | {exists: Yes/No, entry count} |

### Sector Init Phases
| Phase | Status |
|-------|--------|
| bootstrap | {status} |
| source_map | {status} |
| comps_seed | {status} |
| user_review | {status} |
```

---

## Phase 3: Display Company Status

For each company in `_sector_config.json`:

Read `{sector_path}/companies/{slug}/_company_checkpoint.json`

Count phases: completed, in_progress, pending, skipped.

```markdown
### Companies

| Company | Status | Progress | Current Phase | Added |
|---------|--------|----------|---------------|-------|
| {name} | {status} | {completed}/{total} | {first_incomplete} | {added_at} |
```

---

## Phase 4: Recent Activity

Read `{sector_path}/update_log.md` (last 10 entries, if file exists).

```markdown
### Recent Updates
| Date | Source | Change |
|------|--------|--------|
```

If no update log exists, show: `No updates logged yet.`

---

## Phase 5: Quick Actions

```markdown
### Quick Actions
- `/sector-add [Company]` — Add a new company for deep analysis
- `/sector-update [event]` — Refresh sector with new information
- `/sector-init {sector_name}` — Resume sector initialization (if incomplete)
```
