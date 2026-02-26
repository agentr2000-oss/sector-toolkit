# Sector Toolkit

A Claude Code framework for recursive sector analysis. Provides slash commands, autonomous agents, and reusable skills for building structured investment research from the sector level down to individual company theses.

## Installation

Copy the contents into your Claude Code configuration directory:

```bash
cp commands/*.md .claude/commands/
cp agents/*.md .claude/agents/
cp skills/*.md .claude/skills/
```

## Workflow

```
sector-init → sector-add → sector-intake → sector-research → sector-analyze → sector-debate → sector-delta
     │              │             │               │                │               │              │
     ▼              ▼             ▼               ▼                ▼               ▼              ▼
  Create         Add          Source         Evidence          Base Reality     Debates        Delta
  sector       companies     discovery       gathering        + Valuation     + Council       updates
  (S1, S5)                    (01)            (02)          (03, 05, 06)     (S3, 04, 07)      (S4)
```

## Commands

| Command | Purpose | Phases Owned |
|---------|---------|-------------|
| `/sector-init` | Initialize a new sector workspace with S1, S5 foundation | Bootstrap |
| `/sector-add` | Add a company to an existing sector for analysis | Company setup |
| `/sector-intake` | Run source discovery for a company | Intake |
| `/sector-research` | Gather and organize evidence from discovered sources | Research |
| `/sector-analyze` | Build base reality, valuation, and archetype analysis | Analysis |
| `/sector-debate` | Generate debates and run advisory council | Debate |
| `/sector-delta` | Incremental update pass across sector and companies | Delta |
| `/sector-status` | Check progress across all phases and companies | Monitoring |
| `/sector-update` | Update specific sector or company deliverables | Maintenance |

## Agents

| Agent | Role | Output |
|-------|------|--------|
| `sector-bootstrap` | Build sector base reality and source map | S1, S5 |
| `sector-source-map` | Deep source discovery and categorization | S5 |
| `sector-comps-seed` | Build comparables matrix from sector data | S2 |
| `company-source-discovery` | Find and catalog company-specific sources | 01 |
| `company-evidence` | Extract evidence with epistemic tagging | 02 |
| `company-base-reality` | Build company structure and economics analysis | 03 |
| `company-debates` | Generate bull/bear debates with evidence | 04 |
| `company-valuation` | Bottom-up valuation framework | 05 |
| `company-archetypes` | Historical analog and pattern matching | 06 |
| `company-council` | Multi-perspective advisory council deliberation | 07 |
| `company-synthesis` | Final integrated investment thesis | 08 |
| `company-delta` | Incremental update pass for a company | Delta |

## Skills

| Skill | Purpose |
|-------|---------|
| `sector-data-model` | Schema definitions for sector and company files |
| `sector-checkpoint` | Phase tracking and checkpoint gate logic |
| `epistemic-tags` | Epistemic status tagging standard ([VERIFIED], [REPORTED], etc.) |
| `research-standards` | Citation format, evidence quality, and sourcing requirements |

## Research Output

Analysis output is stored separately in the [sector-research](https://github.com/agentr2000-oss/sector-research) repository. Each sector is a top-level folder containing structured deliverables.
