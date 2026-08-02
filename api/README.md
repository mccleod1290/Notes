# API testing — operator board

**Vibe path:** skim **00** (compare classes) once → run **01–03** on the target.  
**Only authorized targets.**

| # | Focus | File |
|---|--------|------|
| **00** | **Compare** Broken Auth / BOLA / BOPLA / BFLA + evidence comments | [execution_batches/00-authz-authn-compare.md](./execution_batches/00-authz-authn-compare.md) |
| **01** | Broken Object Level Authorization (BOLA / IDOR) | [execution_batches/01-bola-idor.md](./execution_batches/01-bola-idor.md) |
| **02** | Broken Authentication (weak policy + brute / OTP) | [execution_batches/02-broken-authentication.md](./execution_batches/02-broken-authentication.md) |
| **03** | BOPLA — Excessive Data Exposure + Mass Assignment | [execution_batches/03-bopla-ede-mass-assignment.md](./execution_batches/03-bopla-ede-mass-assignment.md) |

```text
[ ] 00 Compare classes (read once)
[ ] 01 BOLA / IDOR
[ ] 02 Broken Authentication
[ ] 03 BOPLA (EDE + Mass Assignment)
```

## Lab engagement (this workspace)

| Item | Value |
|------|--------|
| Target | `http://154.57.164.65:31687` (HTB Academy-style Inlanefreight API) |
| Swagger | `/swagger/index.html` · OAS `/swagger/v1/swagger.json` |
| BOLA evidence | [notes/inlanefreight-bola/](./notes/inlanefreight-bola/) |
| Broken auth evidence | [notes/inlanefreight-broken-auth/](./notes/inlanefreight-broken-auth/) |
| BOPLA evidence | [notes/inlanefreight-bopla/](./notes/inlanefreight-bopla/) |

**Do not commit live JWTs or production secrets.**

## Tools (bb agentic)

| Tool | Use |
|------|-----|
| **curl** | Login, BOLA loops, edge cases |
| **pinchtab** | Open Swagger UI, screenshot, click Authorize |
| **gori** | `gori run` / TUI — capture traffic while browser uses Swagger; repeater for ID swaps |

## Sources

- HTB Academy — API Attacks § Broken Object Level Authorization (CWE-639)  
- OWASP API Security Top 10 — API1:2023 BOLA
