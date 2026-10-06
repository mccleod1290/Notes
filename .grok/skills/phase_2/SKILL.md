---
name: phase_2
description: >-
  start the phase 2 explainer agent. assimilation only: depth, breadth,
  possibilities, enough to work alone. no quiz. the agent runs ideas,
  writer, ambiguity, and brevity, then the frugal judge, and loops until
  the judge is satisfied or the cap hits. use when the user says phase 2,
  study artifact, page on sharepoint, page on tenants, or /phase_2.
model: inherit
effort: high
---

# phase_2

read `phase_2/RULES.md`. phase 2 does not test him.

read `phase_1/output/<slug>/MAP.md` before you spawn the explainer. if it is missing, stop. do not invent a curriculum.

spawn the `explainer` agent. it is the worker. this skill does not write the page. the page follows the map.

if the agent type is not registered, follow `.grok/agents/explainer.md` yourself.

## output

`phase_2/output/<slug>/PAGE.pdf`, `PAGE.html`, and `EVAL.md`. do not deliver a quiz. do not deliver a pass when `EVAL.md` says again.

## model

model: inherit. no pinned model id.
effort: high. the failure is a quiz slipped into an assimilation page, or a loop that ignores the judge.
