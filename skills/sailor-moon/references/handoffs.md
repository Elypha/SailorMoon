# SailorMoon Worker Handoffs

Read this reference only when preparing a worker brief, handling a worker decision
request, or choosing report density. The worker brief is its complete human-context
input; do not forward the user conversation or ask the worker to recover history.

## Explorer brief

Give Explorer only what changes the current investigation:

```text
QUESTION
- The one bounded repository fact gap needed for the Parent's next decision.
- Do not bundle follow-up questions whose relevance depends on this answer.

MODEL
- Relevant Parent hypotheses, clearly labelled as hypotheses rather than facts.

AUTHORITY
- Settled decisions, constraints, and exact strings that are themselves evidence.

EVIDENCE SCOPE
- Repository roots and any explicitly allowed external evidence.
- Required claim strength: location, bounded finding, or justified completeness,
  exclusivity, or absence.

DECISION USE
- What Parent decision the answer will affect.

RETURN BOUNDARY
- Return when the gap is resolved, a premise is invalidated, or a consequential
  branch appears. Do not continue into branches whose relevance is not yet known.
```

Evaluate an Explorer result through its direct answer, cited evidence, uncertainty,
and - for completeness or absence claims - stated coverage. `Not found` in one
search is not proof of absence. Explorer may explain the local meaning of repository
evidence, but it does not define the underlying problem, choose the next question, or
solve the Parent's problem. While Explorer is working, the Parent must not search or
read the delegated scope in parallel. After return, the Parent decides what follows
and may inspect cited evidence when validation is warranted. If another separable
fact is needed, send that next gap to the same Explorer.

## Implementer contract

Include only material sections. A focused repair can be fully specified by the
defect, required result, protected boundary, and useful check.

```text
AUTHORITY
- Settled intent, decisions, and constraints. Preserve exact contract language when
  it matters.

OBJECTIVE
- The observable engineering outcome and why it matters.

ACCEPTANCE OBLIGATIONS
- Positive repository-state conditions that must hold.
- Explicitly rejected or retired behavior, paths, compatibility, migration, or
  mechanisms that must not remain.
- Protected boundaries and non-goals that must stay unchanged.

CURRENT STATE AND SCOPE
- Verified starting state and useful references.
- Expected ownership plus protected or out-of-scope areas. Expected files are not an
  exhaustive implementation surface.

ARCHITECTURE AND INVARIANTS
- Settled direction, interfaces, and behavioral or lifecycle constraints.

VALIDATION BOUNDARY
- Useful local evidence and checks.
- Runtime, editor, build, deployed, or user validation intentionally left outside
  the worker boundary.

DECISION BOUNDARY
- Consequential choices that must return to the Parent before the conflicting edit.

REPORT
- Desired density or areas requiring explanation. For a narrow task, request a
  terse delta rather than a broad restatement.
```

The contract is execution-complete, not implementation-complete. Leave ordinary
local design and routine repair to Implementer. A material authority, architecture,
public-contract, scope, migration, security, integrity, concurrency, or destructive
choice returns to the Parent.

## Decision exchange

When a worker returns a material decision, it should provide the precise question,
verified facts, governing authority, real options, recommendation, execution impact,
and exact references. The Parent decides or asks the user, then resumes the same
worker only when it is still the same bounded outcome.

## Implementer report

The Parent controls report density. A normal report uses only the fields that carry
material information:

```text
STATUS
- COMPLETE | DECISION_REQUIRED | BLOCKED

OUTCOME
- Observable result now present.

CHANGED
- Affected files, symbols, or components and their role.

CHECKS
- Evidence and checks actually performed.

DEVIATIONS / RISKS
- Invalidated assumptions, unclosed obligations, limitations, or material risk.

REVIEW INDEX
- Exact locations that help the Parent understand the semantic structure.
```

For a small task or repair, the Parent may request only `STATUS`, the change delta,
checks, and limitations. Report brevity never permits hiding a material deviation,
unclosed acceptance obligation, contradiction, or risk. The report is navigation
and evidence; it never replaces the Parent's complete diff review.
