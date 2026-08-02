# Web app testing — open this first

## Vibe path

1. Open **[execution_batches/00-endpoint-coverage.md](./execution_batches/00-endpoint-coverage.md)** first (always)  
2. Turn on proxy, click the whole app, build a path list  
3. Then do **01 → 09** one file at a time  
4. Each file = **WHY** (read 30 sec) + **DO THIS** (paste) + **NEXT**  

**Only test systems you are allowed to test.**

---

## Board

| # | Focus | Time | File |
|---|-------|------|------|
| **00** | Map every endpoint + verbs + CORS Match&Replace | 1–2 h | [00](./execution_batches/00-endpoint-coverage.md) |
| **01** | XSS (DOM/reflected/stored), clickjack, old JS, open redirect | 1–2 h | [01](./execution_batches/01-xss-clickjack-redirect.md) |
| **02** | CSRF, CORS, methods, form cache, headers, TLS | 1–2 h | [02](./execution_batches/02-cors-csrf-methods-headers.md) |
| **03** | Sessions + cookie lifetime | 1–2 h | [03](./execution_batches/03-session-lifecycle.md) |
| **04** | Cookie flags, lockout, rate limit, IDOR / priv-esc | 1–2 h | [04](./execution_batches/04-authz-cookies-rate-limit.md) |
| **05** | SQLi, SSTI, cmd, path, XXE, SSRF | 2–3 h | [05](./execution_batches/05-injection-core.md) |
| **06** | Upload, HPP, null byte, CRLF, errors, data leak | 1–2 h | [06](./execution_batches/06-upload-hpp-errors.md) |
| **07** | Request smuggling + client-side desync | 1–2 h | [07](./execution_batches/07-smuggling-desync.md) |
| **08** | WebSockets, XPath, LDAP, CSV | 1–2 h | [08](./execution_batches/08-websocket-xpath-ldap-csv.md) |
| **09** | JWT + OAuth | 1–2 h | [09](./execution_batches/09-jwt-oauth.md) |

```text
[ ] 00  [ ] 01  [ ] 02  [ ] 03  [ ] 04
[ ] 05  [ ] 06  [ ] 07  [ ] 08  [ ] 09
```

Tick sheet: [checklist.md](./checklist.md)

---

## All 46 original checks → batch (complete)

| Check | Batch |
|-------|-------|
| Endpoint / verb / CORS filter workflow | **00** |
| DOM XSS | 01 |
| Reflected XSS | 01 |
| Stored XSS | 01 |
| Clickjacking | 01 |
| Javascript libraries outdated | 01 |
| Open Redirect | 01 |
| CSRF | 02 |
| CORS | 00 + 02 |
| Check HTTP Methods | 00 + 02 |
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

**Count:** 46 named checks + foundation **00** = full original prompt.

---

## CORS “how do I find the hits?” (short)

1. Burp Match & Replace → every request gets `Origin: https://evil-attacker.com`  
2. Browse the app  
3. Filter history for `Access-Control-Allow-Origin`  
4. Bad = evil origin (or reflect) **and** credentials / cookies matter  
5. Turn Match & Replace **off** when done  

Full steps: [00-endpoint-coverage.md](./execution_batches/00-endpoint-coverage.md)

Smuggling pastes: [PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Request%20Smuggling/README.md)
