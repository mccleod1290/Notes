# Batch 00 — Cover every endpoint (foundation)

## FILL IN

```bash
T="https://TARGET"
```

## GOAL
Build a **full request list** for the app. Later batches use this list. Skip this → you miss doors.

## TIME
1–2 hours (first day on a target)

## YOU NEED
- In-scope target
- Proxy (Burp / Caido / gori)
- Browser through proxy
- Optional: `ffuf`

---

## WHY (30 seconds)

Clicking the UI only tests ~20% of the app.  
Bugs hide on **hidden paths** and **wrong HTTP verbs**.  

**Four dumb steps = full map:**

1. Click everything while proxy records  
2. Add hidden paths (ffuf)  
3. Retry each path with many verbs  
4. For CORS: auto-add `Origin:` on every request (Match & Replace), then filter responses  

---

## DO THIS

### 1) Create the map (browse + save history)

1. Browser proxy → Burp/Caido.  
2. Log in (user A; later user B if you have two).  
3. Click **every** menu, form, upload, settings, logout, reset, API action.  
4. Keep Burp project **or** export history.  
5. Make a simple list (spreadsheet or text):

```text
METHOD  PATH                     NOTES
GET     /api/users?id=1
POST    /api/login
PUT     /api/profile
```

### 2) Add paths you never clicked (forced browsing)

```bash
T="https://TARGET"
ffuf -u "$T/FUZZ" -w /usr/share/seclists/Discovery/Web-Content/common.txt \
  -mc 200,201,204,301,302,401,403,405,500 -t 40 -o paths.json
```

Merge new paths into your list.  
**405 Method Not Allowed** is still a **win** (path exists).

### 3) Verb × path matrix (full method coverage)

**Idea:** for each path, try many verbs. One Intruder/ffuf job beats manual chaos.

**Verbs to use (minimum):**

```text
GET POST PUT PATCH DELETE OPTIONS HEAD TRACE CONNECT
```

**Burp Intruder style**

1. Send one request to Intruder.  
2. Mark positions:

```http
§GET§ /§api/users§ HTTP/1.1
Host: target
```

3. Payload set 1 = verbs list.  
4. Payload set 2 = path list (from your map + ffuf).  
5. Attack type: **Cluster bomb**.  
6. Sort by status / length. Keep:

| Code | Meaning |
|------|---------|
| 200/201 | Works — test deeper |
| 401/403 | Exists, needs authz tests (batch 04) |
| 405 | Verb wrong, path real |
| 501 | Maybe TRACE etc. interesting |

**ffuf style (verb fixed, path fuzz)**

```bash
for m in GET POST PUT PATCH DELETE OPTIONS; do
  echo "===== $m ====="
  ffuf -X "$m" -u "$T/FUZZ" -w paths.txt -mc all -fc 404 -t 30 \
    -o "verb-$m.json"
done
```

**ffuf style (path fixed, verb fuzz)** — good for one juicy API:

```bash
ffuf -u "$T/api/users/1" -X FUZZ -w verbs.txt -mc all -t 10
# verbs.txt one method per line
```

Save a **coverage sheet**:

```text
path | GET | POST | PUT | DELETE | OPTIONS | notes
```

### 4) CORS on every request (Match & Replace + how to find hits)

**Problem:** CORS must be re-tested on **many** responses. Doing Origin by hand = miss 90%.

#### 4a) Burp Match & Replace (always on)

**Proxy → Options → Match and Replace → Add**

| Field | Value |
|-------|--------|
| Type | Request header |
| Match | `^Origin:.*$` (regex on) **or** leave empty and **Add** header |
| Replace | `Origin: https://evil-attacker.com` |
| Comment | CORS test origin |

Also add if missing:

```text
Type: Request header
Match: (leave empty / add header)
Replace: Origin: https://evil-attacker.com
```

Optional second rule for null origin:

```text
Origin: null
```

(use one rule at a time so you know which fired)

#### 4b) How do you **filter responses** and find the bad ones?

You need responses that echo trust of evil origin.

**What “bad” looks like**

```http
Access-Control-Allow-Origin: https://evil-attacker.com
Access-Control-Allow-Credentials: true
```

or

```http
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true   ← invalid combo but still note
```

or reflected:

```http
Access-Control-Allow-Origin: https://evil-attacker.com
```

**Burp ways to find them (pick one)**

| Method | How |
|--------|-----|
| **A. Logger++** (BApp, free) | Install Logger++. Filter column / search: `Access-Control-Allow-Origin` |
| **B. Proxy HTTP history filter** | Filter → search response header contains `Access-Control-Allow-Origin` then sort/read Origin value |
| **C. Burp ** **`grep -i` on saved** | Right-click host → save items → `grep -R "Access-Control-Allow-Origin" *` |
| **D. Extension: CORS* / AutoRepeater** | Optional BApps that flag ACAO+credentials |
| **E. Manual passive** | While Match & Replace is on, watch **Response** tab for `Access-Control` as you browse |

**Operator recipe (Conti-simple)**

1. Turn Match & Replace **ON** (`Origin: https://evil-attacker.com`).  
2. Browse the whole app again (or Intruder all GETs).  
3. In HTTP history filter box type: `Access-Control-Allow-Origin`.  
4. Open each hit → if ACAO is **evil** or **reflects** your Origin **and** cookies matter (`Allow-Credentials: true` or cookie-based session) → **finding**.  
5. Turn Match & Replace **OFF** when done (do not leave evil Origin forever).

**Preflight check** (APIs):

```http
OPTIONS /api/whatever HTTP/1.1
Host: target
Origin: https://evil-attacker.com
Access-Control-Request-Method: PUT
Access-Control-Request-Headers: content-type
```

If response allows evil origin + dangerous methods/headers → note it.

### 5) Param surface for later batches

From history, list every:

```text
?id=  ?userId=  ?redirect=  ?url=  ?file=  ?q=  JSON body fields
```

You will reuse this list in SQLi, IDOR, open redirect, SSRF, etc.

### 6) Write down (session end)

```text
Target:
Auth users: A / B
# paths mapped:
# verbs tried:
CORS M&R: on/off
CORS hits found:
Param list file:
```

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| Map has &lt; 10 paths | Walk app more; enable JS; try mobile/API host |
| Many 401 | Good — you found auth walls for batch 04 |
| CORS hit with credentials | Ticket it; still finish 00 |
| No proxy | Use browser only is **not enough** — install proxy |

---

## NEXT
→ [01-xss-clickjack-redirect.md](./01-xss-clickjack-redirect.md)
