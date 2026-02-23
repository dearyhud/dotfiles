# AI Agent Team

A structured team of specialized agents for planning, building, and operating software.
Each agent has a narrow, non-overlapping purpose. Use them in sequence or in isolation
depending on the task at hand.

---

## The Roster

| Agent | File | Purpose |
|-------|------|---------|
| Architect | `agents/01-architect.md` | System design, technology selection, ADRs |
| Planner | `agents/02-planner.md` | Break approved designs into sequenced work |
| Engineer | `agents/03-engineer.md` | Write production code |
| Reviewer | `agents/04-reviewer.md` | Code review before merge |
| Tester | `agents/05-tester.md` | Write and evaluate test suites |
| Debugger | `agents/06-debugger.md` | Root cause analysis on bugs and incidents |
| SRE | `agents/07-sre.md` | Deployment, reliability, observability |

---

## Typical Flow

```
Problem / Feature Request
        │
        ▼
  [01 Architect]  ──── produces ────►  Architecture Decision Record (ADR)
        │
        ▼
  [02 Planner]    ──── produces ────►  Ordered task list with acceptance criteria
        │
        ▼
  [03 Engineer]   ──── produces ────►  Code changes + implementation notes
        │
        ├──────────────────────────────►  [05 Tester]   → test suite
        │
        ▼
  [04 Reviewer]   ──── produces ────►  Structured review (blocking / non-blocking)
        │
        ▼
      Merge
        │
        ▼
  [07 SRE]        ──── produces ────►  Runbook, alerts, deployment checklist

      (at any point)
  [06 Debugger]   ──── produces ────►  RCA + reproduction steps + fix recommendation
```

---

## When to Skip Steps

| Situation | Skip |
|-----------|------|
| Bug fix under ~50 LOC | Architect, Planner |
| Greenfield service | Nothing — run the full sequence |
| Internal refactor (no behavior change) | Architect, SRE |
| Hotfix in production | Architect, Planner — go straight to Debugger → Engineer → Reviewer |
| Writing tests for existing code | All except Tester |

---

## Handoff Format

Each agent produces a structured artifact. When chaining agents, pass the prior
agent's full output as context to the next agent. Do not summarize — pass the
raw artifact so the receiving agent has full fidelity.

---

## Global Constraints (apply to all agents)

- Do not log or expose PII (email, name, card numbers, SSNs) — use IDs
- Secrets in environment variables only — never hardcoded, never in output
- Flag anything irreversible before doing it
- When uncertain, say so explicitly rather than hedging with vague language
- Primary languages: Ruby, Python, Node.js (TypeScript)
