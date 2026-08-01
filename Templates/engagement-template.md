# [PROGRAM / TARGET NAME]

> Copy this file for every engagement.  
> Rename to something like `acme-2026-03.md` or `acme/notes.md`.  
> Fill as you hunt — empty sections are fine; **Notes** should never stay empty for long.

| Field | Value |
|-------|--------|
| Program / target | |
| Start date | |
| Platform (HackerOne / Bugcrowd / private / lab) | |
| Your handle | |
| Status | active / paused / done |
| Last session | YYYY-MM-DD |

**How to use (Gr3pMe-style, simplified):**

1. Fill **Scope & Credentials** and **Behavior** before deep testing.  
2. Update **Tech Stack** as you fingerprint.  
3. Dump ideas into **Brainstorming / Risks** and **High Signal** without waiting for proof.  
4. Live everything messy and real in **Notes** (this is the main brain).  
5. Promote proven or near-proven items into **Findings**.  
6. Drive the day from **Tracker**.

**Source ideas:** CTBB HackerNotes Ep. 145 — Brandyn (Gr3pMe) note-taking methodology  
https://blog.criticalthinkingpodcast.io/p/hackernotes-ep-145-gr3pme-s-secret-bug-bounty-note-taking-methodology

---

## Scope & Credentials

Assets in scope and how you log in. Wrong scope = wasted work (or worse).

### In scope

| Asset (URL / host / wildcard) | Type (web / api / mobile / other) | Notes |
|-------------------------------|-------------------------------------|-------|
| | | |
| | | |

### Out of scope / explicit no-gos

- 
- 

### Credentials & accounts

| Role / purpose | Username or email | Password / SSO | MFA | Notes |
|----------------|-------------------|----------------|-----|-------|
| Low-priv A | | | | |
| Low-priv B (for IDOR) | | | | |
| Higher role (if allowed) | | | | |
| Other | | | | |

### Rules of engagement (short)

- Rate limits / automation allowed?  
- Special headers required?  
- Data you must not touch?  

```
[paste program policy bullets you care about]
```

---

## Behavior

What is this product **for**? One screen of “what’s going on” so you can resume after a week away.

### One-paragraph product pitch

```
[Who uses it, what job it does, what “success” looks like for a normal user]
```

### Main user flows (walk these once)

| Flow | Steps (short) | Why it matters for security |
|------|---------------|-----------------------------|
| Register / login | | Auth, session, takeover |
| Core action 1 | | Crown jewels |
| Core action 2 | | |
| Share / invite / multi-user | | IDOR, tenancy |
| Settings / integrations | | Tokens, webhooks, SSRF |
| Admin (if any) | | Vertical priv |

### References (docs, changelogs, demos)

| Link | What it is | Date checked |
|------|------------|--------------|
| | Docs / API reference | |
| | Release notes / changelog | |
| | Status / blog / “what’s new” | |
| | Recorded demo / onboarding | |

### Business logic quirks (fill while using the app)

- 
- 

---

## Tech Stack

What it is built with — updates as you learn more.

### Confirmed

| Layer | Tech / product | How you know (header, error, JS path, …) |
|-------|----------------|------------------------------------------|
| Frontend | | |
| Backend / language | | |
| Framework | | |
| Auth | | |
| Database (guess/confirm) | | |
| CDN / WAF / reverse proxy | | |
| Hosting (AWS / Azure / GCP / …) | | |
| Object storage | | |

### Third-party components

| Component | Where used | Risk angle |
|-----------|------------|------------|
| Libraries (from JS) | | |
| Widgets / embeds | | |
| Webhooks / callbacks | | |
| OAuth / SSO providers | | |
| Analytics / chat / support | | |
| Payment | | |

### Fingerprint scraps (raw)

```
Server:
X-Powered-By:
Cookies:
Interesting response headers:
JS paths / sourcemaps:
Error signatures:
```

---

## Brainstorming / Risks

Threat-model light: possible attack vectors. For each, track **tried / not tried** — not only wins.

### Risk board

| ID | Attack idea / risk | Why it might work here | Tried? | Result / link to Notes | Next step |
|----|--------------------|------------------------|--------|------------------------|-----------|
| R1 | | | no / partial / yes | | |
| R2 | | | | | |
| R3 | | | | | |
| R4 | | | | | |
| R5 | | | | | |

### Quick vectors to consider (delete rows that don’t apply)

| Class | Relevant? (y/n) | Where in this app? |
|-------|-----------------|---------------------|
| IDOR / BOLA / broken authZ | | |
| Cross-tenant access | | |
| XSS (reflected / stored / DOM) | | |
| CSRF | | |
| SSRF | | |
| Open redirect | | |
| Injection (SQL / NoSQL / command / SSTI) | | |
| File upload | | |
| Mass assignment | | |
| OAuth / SSO issues | | |
| Info disclosure / error oracle | | |
| Business logic / race | | |
| Subdomain / takeovers | | |

### “Because of this product shape…” (free write)

```
[e.g. multi-tenant SaaS + file share + webhooks → prioritize cross-tenant + SSRF]
```

---

## High Signal

Do not bury this in the diary. Elevate what actually moves the needle.

### Critical or near-critical findings (summary only — detail in Findings)

| ID | Title | Severity (guess) | Status | Link |
|----|-------|------------------|--------|------|
| | | | draft / reported / N/A | |

### Attack vectors with a **high chance** of success

- 
- 

### Important patterns in behavior

```
[e.g. “IDs are sequential ints in /api/v2/…”]
[e.g. “Admin API host differs from www and skips CSRF”]
[e.g. “Same UUID appears in JWT and in body — body is trusted”]
```

### High-priority endpoints / features

| Endpoint or feature | Why high priority | Notes entry date |
|---------------------|-------------------|------------------|
| | | |
| | | |

### High-signal cookies / headers / params

| Name | Where | Why interesting |
|------|-------|-----------------|
| | | |

---

## Error Oracles

Endpoints or behaviors that **leak truth** (user exists, object exists, role wrong, stack, path, filter hit, WAF vs app).

| Oracle | How to trigger | What it tells you | Example response scrap |
|--------|----------------|-------------------|------------------------|
| | | | |
| | | | |

### Useful differences

| Condition A | Condition B | Observable difference |
|-------------|-------------|------------------------|
| Valid id, no access | Invalid id | status / body / timing |
| Wrong tenant id | Right tenant, wrong object | |
| WAF block | App validation error | |

```
[paste raw response snippets that act as oracles — redact secrets]
```

---

## Attack Paths + Findings

> Renamed from “gadgets.” You do **not** need a gadget graph to use this section.  
> Use it for: (1) chains you are building, (2) **findings** you may report.

### Attack paths (chains)

Connect High Signal + Error Oracles + risks into paths. Keep them dumb and concrete.

| Path ID | Steps (1 → 2 → 3) | Goal / impact | Blockers | Status |
|---------|-------------------|---------------|----------|--------|
| P1 | | | | idea / testing / stuck / works |
| P2 | | | | |

```
P1 detail:
1.
2.
3.
Evidence / note refs:
```

### Findings (report candidates)

One block per finding. Expand as you go from “hmm” → “proof”.

#### F-001 — [short title]

| Field | Value |
|-------|--------|
| Status | idea / testing / solid / reported / duplicate / invalid |
| Severity (your guess) | |
| Asset / URL | |
| Weakness type | |
| CWE / VRT (if known) | |
| Accounts used | |
| Date found | |
| Date reported | |
| Report link / ID | |

**Summary (2–4 sentences)**

```
What is wrong, who can abuse it, what they get.
```

**Steps to reproduce**

1.  
2.  
3.  

**Request / response evidence** (redact tokens/passwords)

```http
[paste]
```

**Impact**

```
```

**Notes / open questions**

```
```

**Related Note entries** (dates or anchors)

- 

---

#### F-002 — [short title]

| Field | Value |
|-------|--------|
| Status | |
| Severity (your guess) | |
| Asset / URL | |
| Weakness type | |
| Accounts used | |
| Date found | |

**Summary**

```
```

**Steps to reproduce**

1.  

**Evidence**

```http
```

**Impact**

```
```

<!-- Duplicate F-00x blocks as needed -->

---

## Notes

> **This is the most important section.**  
> Everything else is a dashboard. **Notes** is the work.  
> Write here **during** the session, not after. Messy is correct.  
> If it is not in Notes, it did not happen — chat scrolls away; this file stays.

### Rules for Notes (read once, then obey)

1. **Timestamp every session** (`### YYYY-MM-DD — short focus`).  
2. Write **what you saw**, **where** (URL, param, proxy #), **what you thought**, **what you did next**.  
3. Capture **failures** — “tried X, got Y, so Z is less likely” saves future-you.  
4. Prefer **quotes and scraps** over memory (`status 403 body: {"error":"…"}`).  
5. When something is hot, **promote** a one-liner to High Signal / Findings — leave the trail here.  
6. Link forward: `→ see F-001`, `→ see R3`, `→ retry tomorrow`.  
7. Do not polish. Do not delete. Append.

### Session entry template (copy under the log)

```markdown
### YYYY-MM-DD — [focus for this session]

**Goal this session:** 
**Accounts / roles used:** 
**Timebox:** 

#### Observations
- [proxy/req] …
- [ui] …
- [response] …

#### What I tried
| Action | Input / slot | Result | Keep? |
|--------|--------------|--------|-------|
| | | | y/n |

#### Hypotheses
- H: … because … → next test: …

#### Dead ends (keep these)
- 

#### Promote
- [ ] High Signal: …
- [ ] Risk board R#: …
- [ ] Finding F-00x: …
- [ ] Tracker todo: …

#### End-of-session (2 minutes)
- Still open: 
- First action next time: 
```

---

### Working log

<!-- Newest session on top. Copy the template above for each session. -->

### YYYY-MM-DD — [example: first recon + login]

**Goal this session:** map login, scope assets, first pass of main flows  
**Accounts / roles used:**  
**Timebox:**  

#### Observations

-  
-  

#### What I tried

| Action | Input / slot | Result | Keep? |
|--------|--------------|--------|-------|
| | | | |

#### Hypotheses

-  

#### Dead ends

-  

#### Promote

- [ ]  

#### End-of-session

- Still open:  
- First action next time:  

---

### Scratch (unordered, same-day dumps)

Use when you are mid-flow and do not want to break format. Re-file into a dated session later if needed.

```
[paste URLs, ids, random thoughts, Burp repeater titles, JS filenames]
```

---

### Note anchors (optional index into the log)

| Anchor | Topic | Session date | One-line |
|--------|-------|--------------|----------|
| N1 | | | |
| N2 | | | |

---

### Cross-links (keep the graph small)

| From | To | Why |
|------|----|-----|
| Note N1 | F-001 | evidence for finding |
| R2 | Note … | risk being tested |
| High Signal | P1 | path building on pattern |

---

## Tracker

What is left, in progress, done. Drive sessions from here; details live in **Notes**.

### Todo

- [ ]  
- [ ]  
- [ ]  

### In progress

- [ ]  

### Done

- [x]  

### Blocked / waiting

| Item | Waiting on | Since |
|------|------------|-------|
| | | |

### Reporting pipeline

| Finding | Draft started | Submitted | Follow-up |
|---------|---------------|-----------|-----------|
| F-001 | | | |

### Session plan (next time you open this file)

1.  
2.  
3.  

---

## Appendix (optional)

### Useful local paths / tools for this target

```
Proxy project:
Wordlists:
Scripts:
Screenshots folder:
```

### Program contacts / slack / email

```
```

### Personal reminders for *this* target only

```
[e.g. “slow WAF — wait 3s between heavy tests”]
```

---

*Template adapted from Brandyn (Gr3pMe) / CTBB Ep. 145 note structure: Scope, Behavior, Tech Stack, Brainstorming/Risks, High Signal, Error Oracles, Attack Paths + Findings, Tracker — with an expanded **Notes** working log for manual engagements.*
