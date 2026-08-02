# Web application testing — Operator board

**Rule:** open **one batch**. Read **WHY**. Run **DO THIS**. Follow **NEXT**.  
Do **not** open all 46 checks at once.

**Only test systems you are allowed to test.**

---

## Card shape (same as AEM / IIS)

| Part | Meaning |
|------|---------|
| **WHY** | Short theory so you understand |
| **DO THIS** | Numbered copy-paste |
| **IF / THEN** | Branch without thinking |
| **NEXT** | Only card to open after |

---

## Board (do in order)

| # | Session focus | Checks | Time | File |
|---|---------------|--------|------|------|
| **00** | **Cover every endpoint** (verbs, paths, CORS workflow) | Foundation | 1–2 h | [00](./execution_batches/00-endpoint-coverage.md) |
| **01** | XSS family + clickjack + old JS + open redirect | 6 | 1–2 h | [01](./execution_batches/01-xss-clickjack-redirect.md) |
| **02** | CSRF, CORS, methods, caching, headers, TLS | 6 | 1–2 h | [02](./execution_batches/02-cors-csrf-methods-headers.md) |
| **03** | Sessions + cookie lifetime | 6 | 1–2 h | [03](./execution_batches/03-session-lifecycle.md) |
| **04** | Cookie flags, lockout, rate limit, IDOR / priv-esc | 6 | 1–2 h | [04](./execution_batches/04-authz-cookies-rate-limit.md) |
| **05** | Injection core (SQLi, SSTI, cmd, path, XXE, SSRF) | 6 | 2–3 h | [05](./execution_batches/05-injection-core.md) |
| **06** | Upload, HPP, null byte, CRLF, errors, data leak | 6 | 1–2 h | [06](./execution_batches/06-upload-hpp-errors.md) |
| **07** | Request smuggling + client-side desync | 2 deep | 1–2 h | [07](./execution_batches/07-smuggling-desync.md) |
| **08** | WebSockets + XPath / LDAP / CSV injection | 4 | 1–2 h | [08](./execution_batches/08-websocket-xpath-ldap-csv.md) |
| **09** | JWT + OAuth | 4 | 1–2 h | [09](./execution_batches/09-jwt-oauth.md) |

---

## Progress ticks

```text
[ ] 00 endpoint-coverage   ← always start here on a new app
[ ] 01 xss-clickjack-redirect
[ ] 02 cors-csrf-methods-headers
[ ] 03 session-lifecycle
[ ] 04 authz-cookies-rate-limit
[ ] 05 injection-core
[ ] 06 upload-hpp-errors
[ ] 07 smuggling-desync
[ ] 08 websocket-xpath-ldap-csv
[ ] 09 jwt-oauth
```

---

## Full checklist map (where each item lives)

| Check | Batch |
|-------|-------|
| How to test all endpoints / verbs / CORS filter workflow | **00** |
| DOM XSS | 01 |
| Reflected XSS | 01 |
| Stored XSS | 01 |
| Clickjacking | 01 |
| Javascript libraries outdated | 01 |
| Open Redirect | 01 |
| CSRF | 02 |
| CORS | 02 (+ workflow in 00) |
| Check HTTP Methods | 02 (+ verb×path in 00) |
| Form Caching | 02 |
| HTTP Headers | 02 |
| TLS 1.2 or more | 02 |
| Session Storage / Local Storage | 03 |
| Broken Session Management | 03 |
| Session Fixation | 03 |
| Session Timeout | 03 |
| Back and Refresh Attack | 03 |
| Cookies Expire Time | 03 |
| Cookie Vulnerabilities | 04 |
| Weak Lockout Account Mechanism | 04 |
| Rate Limit | 04 |
| Horizontal Privilege Escalation | 04 |
| Vertical Privilege Escalation | 04 |
| IDOR | 04 |
| SQL Injection | 05 |
| SSTI | 05 |
| Command Injection | 05 |
| Path Traversal | 05 |
| XXE | 05 |
| SSRF | 05 |
| File Upload | 06 |
| HPP | 06 |
| Null Byte Injection | 06 |
| CRLF Injection | 06 |
| Improper Error Handling | 06 |
| Excessive Data Exposure | 06 |
| HTTP Request Smuggling | 07 |
| Client-Side Desynchronization | 07 |
| Web Sockets | 08 |
| XPath Injection | 08 |
| LDAP Injection | 08 |
| CSV Injection | 08 |
| JWT None Algorithm | 09 |
| JWT Signature Validation Embedded JWK | 09 |
| JWT Config | 09 |
| OAuth Checks | 09 |

**Original checklist count:** 46 named checks + foundation (endpoint/verb/CORS workflow) = all mapped above.

---

## Tools you will use often

| Tool | When |
|------|------|
| Burp / Caido / gori | Proxy all traffic (batch 00) |
| Burp Match & Replace | CORS Origin on **every** request |
| Logger++ / AutoRepeater / filter by header | Spot `Access-Control-Allow-Origin` |
| ffuf / turbo intruder | Verb × path matrix |
| HTTP Request Smuggler (BApp) | Batch 07 |
| Retire.js / snyk | Outdated JS (batch 01) |

Sources for smuggling pastes: [PayloadsAllTheThings — Request Smuggling](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Request%20Smuggling/README.md)
