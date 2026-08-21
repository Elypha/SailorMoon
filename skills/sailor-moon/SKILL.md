---
name: sailor-moon
description: Apply a parent-led engineering workflow that uses a persistent read-only Explorer to filter repository discovery from the parent context and bounded Implementers for execution, while keeping intent, reasoning, decisions, and acceptance with the parent. Use only when the user explicitly asks for SailorMoon or this parent/worker workflow.
---

# SailorMoon Engineering

Use this skill only when the user explicitly chooses SailorMoon or this specific
parent/worker workflow. It is not a generic multi-agent router.

## Purpose

Protect the Parent's context for user intent, problem solving, architecture,
consequential decisions, integration judgement, and final acceptance. Explorer is a
context filter: it absorbs noisy repository discovery for one Parent-chosen fact gap
and returns compressed evidence. It does not take over the Parent's investigation or
solve the underlying problem. Implementer instead absorbs execution churn for one
settled outcome. When the Parent already holds the complete context for a bounded
change, it may implement the change directly.

Delegation changes where evidence is acquired or execution happens; it never
delegates problem framing, reasoning, or authority.

## Roles and context

There are three roles:

- **Parent** owns the user conversation, authority, material ambiguity,
  architecture, scope, trade-offs, worker contracts, integration, and acceptance.
- **Explorer** is one persistent read-only repository specialist. It retrieves and
  compresses decision-ready evidence for the next bounded fact gap chosen by the
  Parent; it never edits or approves a result, and does not choose the investigation.
- **Implementer** is fresh for each delegated engineering outcome. It owns the local
  implementation loop inside the settled contract.

The Parent is both the human-agent and agent-agent boundary. It converts user
language, corrections, relevant history, and decisions into the smallest
role-complete worker brief. Workers use that brief, current repository evidence, and
explicitly supplied external evidence. They do not read user memory, session or
rollout history, the Parent conversation, or another worker's transcript, and they
do not reconstruct user intent from those sources.

Workers are leaves and communicate only with the Parent. Do not add automatic
reviewer, tester, router, escalation, phase, or workflow-state agents.

On Codex, use `sailor_moon_explorer` and `sailor_moon_implementer`. Their profiles
pin GPT-5.6 Luna with `max` reasoning. Create workers with `fork_turns: none`; reuse
the Explorer for later repository questions and reuse an Implementer only for repair
of the same outcome. If the required role or controls are unavailable, report the
limitation rather than silently substituting another workflow.

## Parent loop

1. Establish the authority frame: observable outcome, positive requirements,
   explicit rejections, non-goals, protected boundaries, and the validation boundary.
2. Form the initial problem model and identify the evidence or decision gaps that
   would change the route. Align with the user before expensive work when a wrong
   interpretation would cause meaningful rework.
3. Identify the smallest repository fact gap needed for the next decision. Before
   reading, estimate the likely context cost of acquiring that fact. If discovery may
   expand beyond small decisive evidence, give the gap to Explorer first; if direct
   reading starts to expand, stop and delegate the unresolved gap. While Explorer is
   working, do not investigate the same gap in the Parent. On return, update the
   problem model and decide the next gap; inspect evidence when verification is
   warranted.
4. Settle material architecture, interfaces, scope, and trade-offs in the Parent.
5. Choose the implementation location by expected context savings. Keep a narrow,
   already-understood edit in the Parent; otherwise delegate one coherent outcome to
   a fresh Implementer.
6. Integrate the final repository state against the authority frame and decide
   acceptance. A worker report, green checks, or an internally coherent diff is not
   acceptance by itself.

## Delegation

Give Explorer one current repository fact gap, not the user's problem, a broad
investigation, or dependent follow-up questions. Explorer may trace and interpret
repository evidence only far enough to answer that gap. The Parent integrates the
answer into its own reasoning and decides what question follows; when another gap is
revealed, send a new brief to the same Explorer. State the required claim strength:
locating evidence is different from proving completeness, exclusivity, or absence.
Explorer must qualify conclusions to its actual coverage.

Give Implementer an execution-complete contract, not a forwarded user prompt or a
prewritten implementation. The contract must make material positive and negative
acceptance obligations explicit. Named files are expected ownership and navigation,
not proof of the complete implementation surface.

Read [references/handoffs.md](references/handoffs.md) only when preparing a worker
brief, handling a worker decision request, or specifying report density.

## Coordination

Use worker exchanges for evidence, invalidated premises, consequential decisions,
completed outcomes, or material blockers. Do not poll for routine progress, relay
"still working", or copy raw search and build output into the Parent context. Wait
silently when no action is available.

When the user explicitly asks to proceed interactively, return at material evidence
or decision boundaries instead of batching later decision-dependent work.

Explorer returns when the bounded gap is resolved or a consequential branch appears.
Implementer normally owns inspect, implement, routine repair, proportionate checks,
contract closure, self-review, and report. A consequential authority gap returns to
the Parent before the conflicting edit. After review, the Parent may fix a small,
fully understood defect directly or send a focused repair to the same Implementer.

## Acceptance

Before accepting, the Parent re-establishes the current authority frame from the
human conversation. User corrections replace invalidated assumptions; they are not
legacy cases to preserve beside the new decision. Negative requirements have the
same authority as requested features.

The Parent personally reads the complete current diff and enough surrounding source
to judge the integrated behavior. It may use this review to validate Explorer
conclusions where the final state creates a concrete concern. Compare the final state
to the authority frame before judging code quality. Check especially for missed
callers or integration surfaces and for old paths, compatibility, migration, or
workflow behavior the user explicitly retired. After any repair, read the complete
current diff again.

Do not rerun a worker's successful checks solely for duplication. Repeat a check
only when a concrete risk or later change makes the earlier evidence insufficient.

Report local evidence separately from user end-to-end validation. State precisely
which runtime, build, editor, deployed, or manual behavior remains unverified.
