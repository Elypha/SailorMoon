# SailorMoon - Sol / Luna Engineering - Detailed Workflow

Use this skill only when the user explicitly chooses this workflow.

The purpose of this skill is not generic multi-agent orchestration. It has one fixed topology and one optimization target:

> Spend GPT-5.6 Sol context on intent, architecture, decisions, and final judgment.  
> Spend GPT-5.6 Luna context on repository ingestion, local implementation, routine repair, and operational evidence.

There are exactly three roles:

1. **Parent Sol** — authoritative intent, architecture, decisions, integration judgment, and acceptance.
2. **Explorer** — persistent, read-only Luna repository knowledge specialist.
3. **Implementer** — fresh Luna implementation specialist for one bounded engineering outcome.

Do not introduce route selection, reviewer agents, tester agents, Terra escalation, phase machinery, or other orchestration layers unless the user explicitly asks for them.

The companion custom-agent profiles are expected to exist as:

- `sailor_moon_explorer`
- `sailor_moon_implementer`

Both Luna roles are expected to be pinned to GPT-5.6 Luna with `max` reasoning by their custom-agent profiles. Do not override model or effort per spawn. Never silently substitute another model or role.

This skill is designed for a GPT-5.6 Sol parent with high reasoning. Do not spend turns performing routine model preflight. If runtime metadata already exposed by the host clearly contradicts this requirement, report the mismatch rather than silently changing the workflow.

---

## Core invariants

These rules are mandatory.

### 1. Sol owns human context and every consequential decision

Keep in the parent Sol context:

- the raw user conversation and its language noise;
- user memory, prior-session context, rollout history, and historical preferences;
- user intent and current constraints;
- requirement interpretation;
- material ambiguity resolution;
- architecture and design direction;
- public interfaces and contracts;
- important invariants;
- scope and ownership decisions;
- trade-offs that materially affect behavior, maintainability, compatibility, or product semantics;
- adjudication of worker-discovered contradictions;
- final inspection of the complete implementation diff;
- final engineering acceptance.

Sol alone decides which historical facts remain authoritative, which may be stale,
and which belong in the current engineering brief. Luna workers do not access Codex
memory stores, session or rollout history, the parent conversation, or other
user-history sources, even when generic context guidance suggests that memory might
help. They do not reconstruct or reinterpret user intent.

Sol supplies only the conclusions and exact authority needed for the worker's role.
If a material authority gap remains, the worker returns that gap through the
existing decision boundary instead of searching user history or asking the user.

Luna may investigate a decision surface and recommend an answer. Luna does not become the authority merely because it has read more repository context.

### 2. Sol owns decision-bearing exploration

Sol does not hand the user's end-to-end problem to Explorer and wait for a finished
answer. Before delegation, Sol forms the initial causal model, candidate
explanations, decision criteria, and the material evidence gaps that distinguish
those candidates.

Keep in Sol:

- choosing which hypotheses are plausible;
- deciding which facts would discriminate between them;
- judging evidence sufficiency and risk;
- recognizing when a result invalidates the current route;
- selecting the next branch of investigation;
- synthesizing repository facts into product and architecture decisions.

Explorer retrieves, traces, measures, and compresses repository evidence for a
defined gap. It may explain repository implications and recommend an interpretation
of a bounded mechanism when asked. It does not replace Sol's problem model, choose
the overall product direction, or decide that the accumulated evidence is sufficient
for the user's decision.

Sol should personally inspect the small amount of primary evidence that dominates a
high-risk decision. This is not permission to duplicate Explorer's broad repository
work; it preserves the causal chain needed for authoritative judgement.

### 3. Interaction prunes work before it compounds

SailorMoon is interactive at both boundaries.

At the human-agent boundary, Sol may perform a cheap bounded read-only probe to
ground the discussion, but it does not silently enter a broad or long-running
investigation when a misunderstood intent, constraint, or user choice could make
that work largely irrelevant. Present the current model, the material choice, a
recommendation, and the consequence; align before committing to the expensive
branch. Do not turn this into a generic questionnaire or ask about details that are
cheaply reversible.

If the user explicitly asks to proceed interactively, treat that as an execution
constraint. Return at material knowledge or decision boundaries instead of batching
later decision-dependent branches into one long silent turn.

At the agent-agent boundary, use the persistent Explorer as a conversation. Give it
the current decision-relevant fact gap. When that gap is resolved, or when evidence
invalidates a premise or exposes a consequential branch, Explorer returns the
knowledge delta promptly. Sol integrates it and decides the next question. Do not
bundle adjacent branches merely to avoid a few hundred tokens of coordination.

This is not status polling. Routine "still working" checks and progress narration
remain noise. Planned exchanges of evidence, changed assumptions, and decision
branches are the mechanism that prevents minutes of avoidable work.

### 4. Explorer and Implementer are different jobs

Never merge their responsibilities for convenience.

Explorer exists to:

- investigate;
- retrieve;
- trace;
- understand;
- maintain repository context;
- compress operational evidence into decision-ready knowledge.

Explorer never implements.

Implementer exists to:

- inspect the local implementation surface;
- implement a settled outcome;
- perform routine local design;
- repair ordinary implementation failures;
- self-review;
- perform proportionate checks;
- report the resulting state clearly.

Implementer does not become the persistent repository-memory agent.

This separation is deliberate. Luna is less capable than Sol; keep each Luna thread focused on one stable cognitive role.

### 5. Explorer is persistent; Implementers are fresh

Use one Explorer thread per active root/session when possible. Its persistence means
repository knowledge retained inside that Explorer thread; it does not grant access
to external user memory or prior sessions.

On the first Explorer use:

```text
spawn_agent
agent_type: sailor_moon_explorer
task_name: repo_explorer
fork_turns: none
```

Reuse that same Explorer with `followup_task` for later repository questions.

Do not create a new Explorer for every question. Do not copy the parent conversation into it.

Every new implementation outcome gets a fresh Implementer:

```text
spawn_agent
agent_type: sailor_moon_implementer
task_name: <short semantic task name>
fork_turns: none
```

Do not inherit the Sol conversation, Explorer conversation, or a previous implementation task.

A focused repair of the same implementation outcome should normally reuse that Implementer thread with `followup_task`, because its local implementation context is still useful.

### 6. `fork_turns:none` is the default boundary

Never fork the parent conversation into a Luna worker merely for convenience.

The parent must provide the worker with the smallest execution-complete context needed for its role.

The expensive parent conversation may contain large amounts of irrelevant history. Do not purchase and distract Luna with that history.

The worker brief is an agent-to-agent contract, not a forwarded user prompt. Normalize
the outcome, settled authority, relevant current or historical context, repository
scope, exact questions or implementation objective, and non-goals. Preserve exact
user wording when it is itself authoritative evidence or a contract, such as paths,
APIs, error text, or an explicit constraint. Label historical context as such rather
than presenting it as verified current repository state.

### 7. Workers are leaves

Explorer and Implementer are leaf agents.

Do not ask or encourage them to spawn their own subagents.

The intended topology is flat:

```text
                 Explorer / Luna
                       ▲
                       │
                       │
User ───────────────► Sol
                    /  |  \
                   /   |   \
              Impl A Impl B Impl C
```

All consequential decisions pass through Sol.

### 8. Use decision checkpoints, not status polling

Do not repeatedly:

- list agents to see whether they are still running;
- ask for routine progress;
- inspect files merely to infer activity;
- request intermediate narration;
- wake Sol just to relay “still working”.

Instead, bound Explorer turns by the current evidence gap. A completed knowledge
delta, invalidated premise, newly exposed branch, user steering, blocker, or decision
request is a meaningful event and should return to Sol promptly. Sol may then update
or redirect the same persistent Explorer.

Once architecture is settled, Implementer normally owns the complete local loop.
Use an intermediate Implementer checkpoint only when the contract identifies a
specific early uncertainty whose result would materially branch or invalidate the
remaining work. Do not manufacture checkpoints for routine implementation.

Use the longest practical native wait when waiting is required.

### 9. Tests and checks are evidence, not acceptance

Implementer should run proportionate checks that help catch ordinary breakage.

However:

- green tests do not prove the requested behavior is correct;
- this workflow does not assume TDD;
- do not manufacture test ceremony merely to create proof;
- do not weaken existing validation;
- do not claim an unrun check passed.

The parent Sol normally does **not** rerun checks already performed successfully by the Implementer solely for duplication.

The final engineering judgment comes from intent, architecture, report evidence, and direct inspection of the actual final implementation.

User-performed end-to-end validation may still be required.

### 10. Sol must read the complete final diff

This is the quality backstop and must not be optimized away.

Worker reports provide a semantic map of the implementation. They do **not** replace the implementation itself.

Before accepting an implementation, parent Sol must personally inspect the complete current diff for the touched implementation state.

Do not replace complete diff review with:

- Explorer summaries;
- Implementer summaries;
- selected “important” hunks only;
- another lower-capability reviewer;
- test results;
- confidence claims.

Reports and references should make the complete diff faster and easier to understand, but the final diff itself is authoritative evidence.

If the working tree contained unrelated user changes, preserve them. Review the complete integrated diff of touched files carefully enough to distinguish worker work from pre-existing work. Never revert unrelated changes merely to simplify review.

After any repair that changes code, the prior diff review is stale. Read the complete current diff again before acceptance.

---

# Workflow

## 1. Establish intent and authority

Before delegating implementation, parent Sol must understand:

- what the user actually wants;
- which behavior matters;
- important constraints and non-goals;
- any architecture or interface decisions already settled;
- what would constitute a material decision requiring Sol or user judgment.

Sol also forms an initial problem model:

- candidate explanations or solution directions;
- the facts that would distinguish them;
- the consequence of choosing the wrong branch;
- the cheapest evidence that can safely reduce uncertainty.

When relevant, Sol also reads and interprets user memory or prior-session history
before delegation. Do not delegate that lookup. Convert only the conclusions that
matter into explicit authority, context, constraints, or uncertainty in the worker
brief.

Do not require complete repository knowledge in Sol before using Explorer.

The point of Explorer is to prevent Sol from doing broad repository archaeology itself.

If resolving the remaining ambiguity requires a real user preference or would start
a broad, expensive, or long-running branch, share the model and recommendation with
the user first. Discussion that is inevitably required belongs before the avoidable
work, not after it.

---

## 2. Use Explorer for repository knowledge

Explorer is the default place for repository-heavy, read-only investigation.

Use it iteratively. The first Explorer request should usually target the earliest
fact gap that can eliminate candidate branches, not enumerate every question that
might become relevant if all current assumptions survive.

Use Explorer when Sol needs information such as:

- where a behavior is implemented;
- architecture and module relationships;
- existing extension mechanisms;
- interfaces and call chains;
- lifecycle or persistence paths;
- relevant callers and sibling implementations;
- existing conventions;
- likely implementation surfaces;
- contradictory repository evidence;
- dependency or configuration semantics;
- navigation help while interpreting an implementation.

Prefer `followup_task` to the existing Explorer when one already exists.

Do not routinely duplicate Explorer discovery in the Sol context.

### Explorer request

Give Explorer:

- normalized engineering goal rather than raw conversational language, while
  preserving exact strings that are themselves evidence or contract;
- Sol's current problem model and candidate explanations relevant to this probe,
  explicitly labelled as hypotheses rather than repository facts;
- settled authority and constraints;
- relevant historical conclusions, clearly distinguished from verified current
  repository facts;
- exact investigation questions;
- repository and explicitly allowed external-evidence boundaries;
- what decision each requested fact would affect;
- the condition that should cause Explorer to return early instead of continuing
  into adjacent branches.

The brief is the Explorer's complete human-context input. Do not tell Explorer to
inspect memory, recover the parent conversation, infer user preferences, or search
prior sessions. Explorer may validate repository assumptions and surface a missing
authority; it may not refill that gap from user history.

Explorer treats settled decisions and constraints as authority, but it tests the
Parent's candidate explanations and actively surfaces disconfirming or contradictory
repository evidence. Efficient search must not become confirmation bias.

Ask for a decision-ready brief rather than raw repository output.

Do not ask Explorer to solve the whole user problem, choose the final product or
architecture direction, or perform later branches whose relevance depends on the
current result. After each brief, Sol updates the causal model and decides whether a
follow-up is still worth doing.

A useful Explorer brief contains:

```text
OUTCOME
- Direct answer to the investigation question.

VERIFIED REPOSITORY FACTS
- Important facts with exact file/symbol references.

ARCHITECTURE / FLOW
- Relevant modules, interfaces, call chains, ownership, and data flow.

EXISTING MECHANISMS
- Reusable implementations, abstractions, patterns, or conventions.

IMPLEMENTATION SURFACE
- Likely files/symbols/callers that an implementation would affect.

INVARIANTS / CONSTRAINTS
- Behaviors or contracts that must remain true.

CONTRADICTIONS / UNCERTAINTIES
- Repository evidence that conflicts with the current assumption.

RECOMMENDATION
- Explorer's recommended interpretation or implementation direction and why.

DECISION REQUIRED
- none, or one precise decision Sol must make.

REFERENCES
- Exact useful paths and symbols.
```

Explorer may retain detailed repository knowledge in its own thread.

Do not require it to re-explain unchanged background on every follow-up. Ask for the new answer or knowledge delta.

Explorer may recommend an interpretation of the bounded repository mechanism it was
asked to investigate. Sol decides how that evidence changes the overall problem and
whether more investigation is justified.

---

## 3. Sol decides the implementation direction

Use the Explorer brief and authoritative user/project context to settle material choices.

Do not hand unresolved architecture or product decisions to Implementer and hope it chooses correctly.

Resolve, as appropriate:

- intended behavior;
- architecture;
- interface shape;
- important invariants;
- compatibility requirements;
- expected ownership/scope;
- recommended approach;
- meaningful non-goals;
- any known trade-offs.

The implementation handoff should be **execution-complete, not implementation-complete**.

Sol should resolve important decisions, but does not need to pre-write the code or dictate every local helper and statement.

Leave ordinary local engineering choices to Implementer.

---

## 4. Build the Implementer execution contract

Each Implementer receives one largest coherent implementation outcome that it can safely own end-to-end.

Do not micro-split work merely to create more agents.

A task may touch many files if those files form one coherent outcome.

The execution contract should contain the following sections.

```text
AUTHORITY

State the settled intent, decisions, constraints, and decision ownership compiled
by Sol. Include only historical conclusions that materially affect this outcome,
and label their freshness or uncertainty when relevant.

OBJECTIVE

Describe the observable outcome and why it matters.

CURRENT STATE

Summarize the relevant current behavior and prerequisites.
Include exact repository references when useful.

OWNERSHIP AND SCOPE

Expected implementation surface.
Protected or explicitly out-of-scope areas.
The worker may inspect adjacent code freely.
It must not silently make a material expansion of the implementation contract.

ARCHITECTURE AND APPROACH

State the settled architecture/design direction.
Give the recommended implementation approach and the reason for it.
Do not reduce the worker to a transcription engine; local details remain its responsibility.

INTERFACES AND INVARIANTS

Public/internal contracts that must remain compatible.
Important behavioral, data, lifecycle, persistence, concurrency, or integration invariants.

EDGE CASES AND FAILURE PATHS

Important cases the implementation must handle.
Known compatibility requirements.
Relevant failure behavior.

NON-GOALS

Changes that are specifically not part of this task.
Unrelated cleanup or speculative redesign to avoid.

EXECUTION GUIDANCE

Give an ordered high-level sequence when it materially helps:
- relevant file or symbol;
- required semantic change;
- rationale;
- affected interface/invariant;
- useful focused check.

Do not force fake precision when the repository must be inspected first.

VALIDATION EXPECTATIONS

State useful existing checks, commands, observable evidence, or manual surfaces.
These are evidence requirements, not a claim that passing them proves correctness.

DECISION BOUNDARY

List conditions under which the worker must stop before making the conflicting change and return DECISION_REQUIRED.

REPORT

Require the structured terminal report defined by this skill.
```

Use exact references rather than pasting large source files, logs, or parent conversation history.

The contract is the Implementer's complete human-context input. Do not ask it to
read memory, prior sessions, Explorer transcripts, or the user conversation. It may
verify current repository assumptions; it must return a material authority gap to
Sol instead of reconstructing intent.

---

## 5. Implementer owns the full local loop

Once the execution contract is assigned, Implementer owns:

```text
inspect relevant local repository state
→ validate the supplied assumptions
→ implement
→ run useful focused checks
→ repair ordinary implementation failures
→ inspect the complete local result
→ self-review
→ fix issues found
→ perform final proportionate checks
→ report
```

Routine repair stays with Implementer.

If the contract names a specific early checkpoint because one unresolved repository
fact would materially branch the implementation, Implementer validates that fact
and returns it before the conflicting work. Otherwise, do not fragment the coherent
local loop into conversational micro-steps.

Examples that normally do **not** require waking Sol:

- compiler/type errors;
- lint/format issues;
- incorrect imports;
- minor call-site adaptation;
- private helper structure;
- obvious local compatibility fixes;
- implementation details not fixed by the contract;
- repository state differing slightly from the handoff while preserving the same architecture and scope;
- ordinary failures found by its own checks.

Do not use Sol as a help desk for problems Luna can solve locally.

---

# Decision and escalation boundary

The worker must distinguish **implementation judgment** from **authority judgment**.

## Implementer may decide locally

Examples:

- private implementation structure;
- local helper organization;
- straightforward refactoring required by the task;
- adaptation to nearby existing conventions;
- exact internal naming;
- obvious local error handling consistent with established behavior;
- routine caller changes already implied by the contract;
- reasonable reuse of existing abstractions;
- small deviations from the suggested sequence when repository evidence makes them clearly better.

Report material local choices afterward.

## Implementer must return to Sol before proceeding when

Correct completion would require a consequential decision such as:

- materially ambiguous requested behavior;
- contradiction of a settled architectural assumption;
- changing a public or cross-module contract not already authorized;
- materially changing schema, persistence format, protocol, or externally visible behavior;
- significant ownership or scope expansion;
- choosing between alternatives with a real product/architecture/compatibility trade-off;
- invalidating an important parent decision;
- introducing a new subsystem or parallel mechanism instead of the expected architecture;
- security, integrity, concurrency, migration, or destructive behavior whose correct direction is not already settled;
- evidence that the requested approach is fundamentally wrong;
- low confidence about the correct architectural direction.

Do not ask Sol the instant the first ambiguity appears.

Perform enough bounded read-only investigation to understand the issue and consolidate related contradictions into one decision surface.

Then stop before the consequential edit.

### Decision brief

Return:

```text
DECISION_REQUIRED

QUESTION
- One precise question that must be decided.

FACTS
- Verified repository facts relevant to the decision.

AUTHORITY / CONSTRAINTS
- User requirements, interfaces, invariants, or existing architecture that constrain the choice.

OPTIONS
- A — behavior and trade-offs.
- B — behavior and trade-offs.
- Additional real options only when useful.

RECOMMENDATION
- The worker's recommended choice and why.

EXECUTION IMPACT
- What work changes or becomes unblocked after the decision.

EVIDENCE
- Exact repository references.
```

Luna should use its cheap repository context to make the decision surface as good as possible.

Sol then decides, or asks the user when the choice properly belongs to the user.

Send the resulting decision back to the same Implementer with `followup_task`.

---

# Implementer terminal report

Do not optimize Luna output length at the expense of Sol understanding.

The goal is a layered, accurate semantic map of the finished implementation.

Be concise on routine facts and detailed on material facts.

The report has two layers.

## CONTROL

```text
STATUS
- COMPLETE | NEEDS_DECISION | BLOCKED

OUTCOME
- What observable result now exists.

CHANGED SURFACES
- Compact list of files/modules/components affected and their role.

KEY IMPLEMENTATION DECISIONS
- Important local choices that affect how Sol should understand the diff.

DEVIATIONS
- Material differences from the execution contract, or none.

DECISION REQUIRED
- none, or the precise outstanding decision.

RESIDUAL RISK
- Important remaining uncertainty, limitation, or none.
```

## DETAIL

```text
CHANGES BY FILE / SYMBOL
- file:symbol — what changed and why.

LOCAL DESIGN CHOICES
- Non-trivial implementation choices and rationale.
- Reuse/extension decisions.
- Alternatives rejected when materially relevant.

DISCOVERED FACTS
- Repository facts learned during implementation that Sol did not previously know and that matter to correctness or future decisions.

DEVIATIONS / INVALIDATED ASSUMPTIONS
- Anything in the handoff that turned out not to match repository reality.
- How the worker adapted without changing the authorized architecture.

SCOPE AND INTEGRATION
- Important callers, sibling paths, lifecycle/persistence boundaries, or integration surfaces considered.
- Any relevant surface deliberately not changed and why.

CHECKS PERFORMED
- Exact checks or methods actually used.
- Actual result.
- Report failures encountered only when they materially explain the final implementation.

CHECKS NOT PERFORMED / LIMITATIONS
- Relevant validation that was not possible or not appropriate.

UNCERTAINTIES / RISKS
- Anything Sol should keep in mind during diff review or user E2E.

DIFF REVIEW INDEX
- Exact files/symbols/hunks that are especially important for understanding the semantic structure of the change.
- This is navigation help only. It does not reduce Sol's obligation to inspect the complete final diff.
```

Never write merely:

> implemented as requested, tests pass

when material reasoning or repository facts exist that would help Sol judge the result.

---

# Parent Sol acceptance

When Implementer reports COMPLETE:

## 1. Read the report first

Use CONTROL to understand the overall result.

Read DETAIL to understand:

- semantic changes;
- local decisions;
- deviations;
- discovered repository facts;
- validation evidence;
- likely risk points.

The report is a map, not proof of correctness.

## 2. Inspect the complete final diff

Parent Sol must personally read the complete current implementation diff.

Inspect every hunk sufficiently to understand what it does in the integrated repository state.

Use the report's references to navigate, but do not skip unreferenced hunks.

During review, judge at least:

- Does the implementation actually satisfy the user's requested behavior?
- Does the code implement the architecture Sol intended?
- Were interfaces and invariants preserved?
- Did Luna silently change semantics?
- Are all changed files justified?
- Did it miss important callers or integration paths visible from the diff and known architecture?
- Did it introduce unnecessary abstractions or a parallel mechanism?
- Are local design choices coherent with the existing system?
- Are error/failure paths sensible?
- Did it over-expand scope?
- Did it accidentally include unrelated cleanup?
- Are comments/documentation consistent with actual behavior where relevant?
- Do the reported checks and limitations make sense for the code that was changed?
- Is there any suspicious implementation that requires deeper inspection of surrounding code?

Sol may read surrounding source directly when necessary to judge a hunk.

Sol may ask Explorer for architecture/history/navigation when useful.

Explorer may assist understanding, but **must never replace complete final diff review with a lossy summary**.

## 3. Decide

If correct:

- accept the engineering result;
- explain the meaningful outcome to the user;
- distinguish automated/local evidence from user end-to-end validation.

If a bounded implementation defect exists:

- send one focused repair task to the same Implementer;
- state the exact defect and required outcome;
- preserve the existing architecture and scope unless Sol intentionally changes them;
- wait for a fresh terminal report;
- read the complete current diff again after the repair.

If the defect reveals a material architecture/product decision:

- Sol decides it, or asks the user when appropriate;
- then send the updated decision/contract to Implementer.

Do not automatically spawn a reviewer or tester.

---

# Explorer during and after implementation

Explorer remains available throughout the parent session.

Appropriate follow-up uses include:

- verify how an existing interface is supposed to behave;
- trace an unfamiliar call chain revealed by the diff;
- explain existing architectural precedent;
- investigate a contradiction reported by Implementer;
- locate all known consumers of a changed contract;
- determine whether a suspicious pattern in the diff matches established repository conventions;
- prepare a compact decision surface for Sol.

Explorer should return facts and references rather than implementation instructions unless Sol explicitly requests a recommendation.

Do not ask Explorer to approve the final implementation.

Do not delegate Sol's final engineering judgment.

---

# Parent context discipline

Outside complete final diff review, aggressively protect Sol context from operational noise.

Prefer Luna for:

- broad repository search;
- directory and source inventory;
- long source-reading chains;
- caller enumeration;
- dependency tracing;
- large logs;
- build/test diagnostics;
- repetitive implementation debugging;
- repository-wide surveys.

Keep in Sol:

- raw user language, memory, and prior-session history;
- semantic summaries;
- exact facts needed for a decision;
- relevant authority;
- compact evidence;
- complete final implementation diff;
- targeted surrounding code necessary to judge that diff.

Do not dump raw worker logs into Sol context merely because they exist.

Do not repeatedly copy unchanged repository facts between turns. Reuse the persistent Explorer's context.

Workers communicate with Sol, not the user. They should not emit routine progress
narration, user-facing explanations, or conversational restatements of the brief.
Explorer returns a completed bounded knowledge delta or a newly exposed decision
branch; Implementer returns its terminal report, a contract-defined early checkpoint,
a genuine consolidated decision request, or a material blocker.

Optimization target:

> Reduce expensive operational context, not authoritative judgment.

---

# User interaction

The user remains the final end-to-end acceptance authority.

Do not imply that:

- tests passing;
- Luna reporting COMPLETE;
- or Sol accepting the code diff

necessarily proves the feature works correctly in its real environment.

When relevant, tell the user what manual E2E behavior remains worth checking.

If the user reports an E2E failure:

1. Sol interprets the observed behavior.
2. Use Explorer when repository investigation is needed.
3. Sol decides whether the issue is implementation-local or changes the design.
4. Send a focused repair to a fresh or existing appropriate Implementer.
5. Repeat report → complete diff review → user E2E.

---

# Anti-patterns

Do not do any of the following unless the user explicitly overrides this skill:

- silently implement the task in Sol after this skill was explicitly invoked;
- treat the user's first message as an execution-complete specification when a
  material interpretation or preference still needs alignment;
- give Explorer the user's end-to-end problem and ask it to return the final
  engineering answer;
- bundle decision-dependent Explorer branches into one long investigation merely
  to reduce agent-agent communication;
- wait until a long investigation finishes before discussing a choice that was
  already known to require user input;
- invent Light / Medium / Heavy modes;
- default back to solo execution;
- use Terra as an escalation tier;
- spawn automatic reviewer agents;
- spawn automatic tester agents;
- require TDD;
- rerun Luna's successful checks in Sol merely for duplication;
- let Explorer implement;
- reuse Explorer as Implementer;
- reuse an old unrelated Implementer for a new task;
- fork parent conversation history into workers;
- let workers read user memory, session history, rollout history, or the parent
  conversation;
- forward raw user prompts and ask workers to reinterpret intent;
- ask workers to recover missing authority from historical context;
- let workers recursively delegate;
- poll workers for status;
- confuse planned evidence exchange with status polling;
- micro-split coherent work merely for parallelism;
- distort architecture to create parallel tasks;
- accept a worker report without examining the actual final implementation;
- replace complete final diff review with a lower-capability summary;
- treat green tests as proof of requested behavior;
- let Luna silently expand material scope;
- wake Sol for routine implementation repair;
- force Luna reports to be so short that material reasoning is lost;
- create workflow state files, phase databases, gate artifacts, or orchestration paperwork that the user's task does not require;
- silently substitute a different agent model when a required role is unavailable.

If a required Luna custom agent cannot be created or reused, report that clearly. Do not silently change the workflow into something else.

---

# Default lifecycle summary

```text
User explicitly invokes skill
          │
          ▼
      Parent Sol
 human context / memory / intent
 problem model / decision criteria
          │
          ├──── align material intent/choice ────► User
          │                    │
          │◄───────────────────┘
          │
          ├──── bounded fact gap ─────► Persistent Explorer / Luna Max
          │                             read-only repository evidence
          │                    │
          │◄── knowledge delta / branch ┘
          │
          ├──── update model; ask next gap only if it still matters ───┐
          │◄───────────────────────────────────────────────────────────┘
          │
          │ architecture / decisions settled
          │
          │ execution-complete contract
          ▼
 Fresh Implementer / Luna Max
       fork_turns:none
          │
          │ inspect
          │ implement
          │ routine repair
          │ self-review
          │ proportionate checks
          │
          ├──── DECISION_REQUIRED ───► Sol decides ───► same Implementer
          │
          ▼
   CONTROL + DETAIL report
          │
          ▼
         Sol
   read report first
          │
   read COMPLETE final diff
          │
 architecture/correctness judgment
          │
       ┌──┴──┐
       │     │
      OK    repair
       │     │
       │     └────────► same Implementer
       │                 new report
       │                 new complete diff review
       ▼
      User
 manual end-to-end acceptance where appropriate
```

The system is intentionally asymmetric:

- Luna may consume large amounts of repository context.
- Luna may spend extra tokens explaining material implementation facts.
- Sol should consume as little operational noise as practical.
- Sol must spend the context necessary to make the final authoritative judgment.

Never optimize away the part of the workflow that provides the quality guarantee.
