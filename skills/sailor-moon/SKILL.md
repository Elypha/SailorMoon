---
name: sailor-moon
description: Apply a parent-led engineering workflow that separates persistent repository exploration from bounded implementation while keeping architecture, scope, and final acceptance with the parent. Use only when the user explicitly asks for the SailorMoon workflow; do not use for ordinary solo engineering tasks.
---

# SailorMoon Engineering

Use this skill only when the user explicitly chooses SailorMoon, parent/worker, or this
specific context-optimised engineering workflow. It is deliberately not a generic
multi-agent router.

## Outcome

Keep the high-capability parent focused on human-context interpretation, intent,
architecture, consequential decisions, integration judgement, and final acceptance.
Move repository-heavy reading and one bounded implementation loop into specialised
workers through explicit agent-to-agent contracts without delegating authority or
weakening the final review.

## Fixed roles

There are exactly three roles:

1. **Parent** - owns the user conversation, user memory and prior-session history,
   intent, material ambiguity, architecture, public contracts, scope, trade-offs,
   integration judgement, and acceptance.
2. **Explorer** - a persistent, read-only repository knowledge specialist. It
   investigates, traces, retrieves, and compresses evidence; it never edits.
3. **Implementer** - a fresh worker for one bounded, already-settled engineering
   outcome. It inspects the local surface, implements, repairs ordinary failures,
   self-reviews, validates proportionately, and reports.

Do not add automatic reviewer, tester, router, escalation, phase, gate, or workflow
state layers unless the user explicitly asks for them. Explorer and Implementer are
leaf workers and must not spawn more workers.

## Context boundary

The Parent is the only human-agent boundary. It interprets the user's language,
reads any relevant user memory or prior-session history, resolves authority and
ambiguity, and compiles that context into a role-complete worker brief.

Workers communicate only with the Parent. They do not read Codex memory stores,
session or rollout history, the Parent conversation, or other user-history sources;
they do not reconstruct or reinterpret user intent. Their context is limited to the
Parent brief, current repository evidence, explicitly supplied external evidence,
and - for the persistent Explorer only - repository knowledge retained in that
Explorer thread.

Do not send the raw user conversation or ask a worker to recover missing context
from history. Preserve exact user wording when it is itself authoritative evidence
or a contract, such as paths, APIs, error text, or an explicit constraint. If
material authority is missing, the worker returns the precise gap to the Parent
through the existing decision boundary.

## Interactive reasoning

SailorMoon is an interactive reasoning workflow, not a one-shot dispatch pipeline.
Before starting broad, expensive, or long-running work, the Parent forms the initial
problem model, candidate explanations, decision criteria, and material evidence
gaps. A cheap bounded read-only probe may ground that model. If a wrong
interpretation would cause meaningful rework, or a real user choice remains, the
Parent discusses it with the user before committing to the expensive branch and
gives a recommendation rather than turning the exchange into a questionnaire.
An explicit user request to proceed interactively is an execution constraint: do
not batch later decision-dependent branches behind a long silent turn.

Delegate decision-relevant fact gaps to Explorer, not the user's end-to-end problem.
Reuse the persistent Explorer through bounded conversational turns: each turn should
resolve the current gap or return as soon as evidence exposes a new decision branch.
The Parent integrates each knowledge delta, updates the model, and chooses the next
question. A planned evidence exchange is substantive coordination, not status
polling; do not save a few hundred communication tokens at the cost of minutes of
avoidable investigation.

## Host boundary

Codex is the reference host for this package. Its intended mapping is:

- Parent: the current high-reasoning Codex agent.
- Explorer: persistent custom agent `sailor_moon_explorer`.
- Implementer: fresh custom agent `sailor_moon_implementer`.
- First worker creation uses the host's no-inherited-context boundary, represented
  in Codex by `fork_turns: none`; later Explorer questions reuse the same thread.

The bundled TOML profiles pin the Codex Luna roles to `gpt-5.6-luna` with `max`
reasoning. Do not silently substitute a different model when those profiles are
available. If the host cannot provide the required named roles, model, or worker
controls, report that limitation and preserve the role boundary instead of
pretending that an equivalent workflow ran.

On other agents, use their equivalent named-subagent mechanism only when it can
represent the same read-only Explorer and fresh Implementer responsibilities. Keep
the workflow's semantics, but translate command names and report transport to the
host. Basic skill use remains valid even when Codex-specific TOML profiles are
ignored.

## Required lifecycle

1. Establish the user's outcome, constraints, non-goals, material decisions,
   relevant history, initial problem model, and decision criteria.
2. Before expensive work, align with the user on any interpretation or choice whose
   error would cause meaningful rework.
3. Give the persistent Explorer the next bounded fact gap and ask for verified
   evidence, contradictions, references, and any newly exposed decision branch.
4. Integrate the knowledge delta in the Parent, update the model, and reuse Explorer
   conversationally only for the next evidence gap that still matters.
5. Settle architecture, interfaces, scope, and meaningful trade-offs in the parent.
6. Give a fresh Implementer an execution-complete contract: authority, objective,
   current state, scope, architecture, invariants, failure paths, non-goals,
   validation, and its decision boundary.
7. Let the Implementer own the local loop: inspect, validate assumptions,
   implement, repair routine failures, run useful checks, self-review, and report.
8. If a consequential choice is required, stop before the conflicting edit and
   return a precise decision brief to the parent. Resume the same Implementer only
   after the parent settles it.
9. The parent reads the complete current final diff, not just the worker report or
   selected hunks. Repair rounds require a new complete diff review.
10. Report local evidence separately from user end-to-end acceptance; green checks
   and a worker's `COMPLETE` status are not proof of real-environment success.

Do not poll workers for routine progress, copy raw repository logs into the parent
context, micro-split one coherent outcome, or use a lower-capability summary as a
substitute for final diff inspection.

## Detailed workflow

Read [references/full-workflow.md](references/full-workflow.md) before applying the
workflow to a substantive task. It contains the full invariants, Explorer brief,
Implementer contract, decision brief, terminal report, acceptance checklist, and
anti-patterns.

The files under `agents/` are optional Codex custom-agent profiles; other hosts may
ignore them. Their installation is a user-side setup step documented in the package
README, not part of this skill's runtime workflow.
