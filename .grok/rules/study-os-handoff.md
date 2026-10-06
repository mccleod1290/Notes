# Study OS handoff

One slug, underscores. `AWS OIDC flow` is `aws_oidc_flow`.

The phase 1 artifact flows into phase 2 and into phase 3. The explainer relies on phase 1. The exam relies on phase 1 and phase 2. The logger, the diagnostician, and the clerk rely on the phases before them. A later phase does not invent the file the earlier phase was supposed to write.

The workflow script is the gate. A prompt that says "stop if missing" is not the gate. If the required file is missing, the workflow returns `blocked` and does not start the next agent.

## What moves

| Step | Required before it runs | Writes |
| --- | --- | --- |
| Interviewer | A book, a course, or a work material | `phase_1/output/<slug>/TARGET.md`, `interview.md` |
| `study_clerk` | `interview.md` | `CONTEXT.md` in that same folder |
| Map maker | `TARGET.md` and `CONTEXT.md` | `MAP.md` |
| Explainer | `MAP.md` and `TARGET.md` | `phase_2/output/<slug>/PAGE.md`, then the html and pdf |
| Exam | `MAP.md`, `TARGET.md`, and `PAGE.md` | `phase_3/output/<slug>/` papers and the build brief |
| Logger | `MAP.md` and `logs/sessions/LATEST.md` | Nothing. It names which earlier files are on disk |
| Diagnostician | The logger returned `ok` | `study_os/topics/<slug>/phase_4/DIAGNOSIS.md` |
| Clerk | `DIAGNOSIS.md` | `study_os/topics/<slug>/INDEX.md` and symlinks |

## Who reads what

Phase 2 reads the phase 1 map and target. Section order is the map order. It does not read the exam. It does not quiz.

Phase 3 reads the phase 1 map for the topics and the phase 2 page for what a question is allowed to ask. A domain the map dropped is not on the paper and not in the build. A question the page cannot support is not a question. It does not read phase 4.

Phase 4 reads phase 1, phase 2, and phase 3, and the harness. The logger checks the ledger first. The diagnostician runs next. The clerk files last. A phase 2 or phase 3 file that is not on disk is recorded as absent. It is not created here, and its contents are not guessed.

`study_clerk` freezes the interview. It is not the phase 4 clerk. The logger does not write a second copy of `logs/sessions/`.

## Run

```text
/interviewer
/workflow study-map {"slug":"aws_oidc_flow"}
/workflow phase-2 {"slug":"aws_oidc_flow","topic":"AWS OIDC flow"}
/workflow phase-3 {"slug":"aws_oidc_flow"}
/workflow phase-4 {"slug":"aws_oidc_flow"}
```

Phase 3 mail is the examiner skill, when he asks. The phase-3 workflow does not email. The key stays on disk.
