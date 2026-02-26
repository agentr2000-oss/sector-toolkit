---
description: Manually update sector layer with new information
allowed-tools: Skill, Task, AskUserQuestion, Read, Write, Edit, Bash(python3:*), Glob, WebSearch, WebFetch
---

# Sector Update

Accepts an event or new information, researches its impact on the sector, proposes updates to sector files (S1-S5), and applies approved changes.

Use this for:
- Earnings announcements that affect sector view
- Regulatory changes
- M&A activity
- Market developments
- Manual corrections

---

## Phase 0: Resolve Sector

If `$ARGUMENTS` is provided, parse for sector name and event description.

Find the sector:
```
Glob: /Users/agentr/Claude/2026 Master Investment Workflow/Sectors/*/_sector_config.json
```

If multiple sectors, ask which one.

Set: `sector_path`, `sector_name`

---

## Phase 1: Capture Event

If event description not in arguments:
```
AskUserQuestion: "What event or information should update the sector?"
Options:
  "Earnings result (specific company)" |
  "Regulatory change" |
  "Market/industry development" |
  "Manual correction to sector files"
```

Based on category, gather details:

**Earnings result:**
```
AskUserQuestion: "Which company and which quarter?"
```

**Regulatory change:**
```
AskUserQuestion: "Describe the regulatory change and affected companies."
```

**Market development:**
```
AskUserQuestion: "Describe the development."
```

**Manual correction:**
```
AskUserQuestion: "Which sector file (S1-S5) and what should change?"
```
Skip to Phase 3 (direct edit).

---

## Phase 2: Research Impact

For non-manual updates, research the event:

Use WebSearch:
1. `"{event description}" {sector} impact analysis`
2. `"{company}" {event} results` (if company-specific)
3. `"{sector}" sector outlook {event}`

Use WebFetch on promising results to extract specific data.

### Assess impact on each sector file:

**S1 Base Reality:** Does this change industry economics, growth drivers, or regulatory environment?

**S2 Comps Matrix:** Does this update financial metrics for any company in the matrix?

**S3 Debates:** Does this resolve any open debates, add evidence, or create new debates?

**S4 Consensus Tracker:** Does this change consensus estimates?

**S5 Source Register:** Are there new sources to register?

---

## Phase 3: Propose Updates

For each affected sector file, display the proposed change:

```
### Proposed S{n} Update

**File:** S{n}_{name}.md
**Section:** {section}
**Change type:** {add/modify/remove}
**Current:** {relevant excerpt}
**Proposed:** {new text}
**Justification:** {why this update is warranted}
```

---

## Phase 4: User Approval Gate

```
AskUserQuestion: "Apply these sector updates?"
Options:
  "Apply all {count} updates" |
  "Review one by one" |
  "Apply selected updates only" |
  "Cancel — no changes"
```

If "Review one by one": iterate through each update with approve/reject.

Apply approved updates using the Edit tool.

---

## Phase 5: Update Log + Impact on Companies

### Append to update log

Read `{sector_path}/update_log.md` (create if doesn't exist).

Append:
```markdown
### {ISO_date} — {event_category}: {event_title}
- **Trigger:** {event description}
- **S1 Updates:** {count applied}
- **S2 Updates:** {count applied}
- **S3 Updates:** {count applied}
- **S4 Updates:** {count applied}
- **S5 Updates:** {count applied}
- **Source:** {research sources used}
```

### Check if any company analyses need refresh

Read `{sector_path}/_sector_config.json` for completed companies.

For each completed company, assess whether the event materially changes their analysis:

```
AskUserQuestion: "This update may affect {company_name}'s analysis. Re-analyze?"
Options:
  "Yes — re-run /sector-add {company_name}" |
  "No — the existing analysis is still valid" |
  "Flag for later review"
```

If flagged: Add a note to the company's `07_monitoring_playbook.md`.

### Display completion

```
## Sector Updated: {sector_name}

**Event:** {event_title}
**Updates applied:** {count}
**Files modified:** {list}
**Companies potentially affected:** {list, if any}
```
