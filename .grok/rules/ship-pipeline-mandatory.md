# HARD RULE: ship pipeline (content → eval 3× → git → mail)

**Non-negotiable** default for this vault. Canonical detail: `AGENTS.md`.

```text
CONTENT GEN → content_eval 3× → git commit+push → email PDF+md
```

| Step | Required | Skip phrase only |
|------|----------|------------------|
| Content gen | Write files on disk | — |
| content_eval 3× | slop → first_principles → core_questions → SHIP | `skip content-eval` / `raw dump ok` |
| Git | commit + push origin | `skip git` / `no push` / `local only` |
| Mail | send_report_email (PDF+md) | `skip mail` / `no email` |

Never treat chat-only delivery as complete when git+mail apply.
Never force-add `logs/` or secrets.
