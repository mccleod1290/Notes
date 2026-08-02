# IIS slide → batch coverage — 3 evaluations

**Deck:** NahamCon “Hacking IIS” (shubs / Assetnote) — **35 slides**  
**Images:** `slides-raw/cdn/slide-01.jpg` … `slide-35.jpg`  
**Batches:** `execution_batches/01` … `07`  
**Method:** read each slide image → list teaching points → search batch corpus (3 passes with different strictness)

---

## Pass 1 — Every slide (1–35)

| Result | Count |
|--------|-------|
| Covered | **35 / 35** (after resource branding fix) |
| Missed operational content | **0** |

Title/section divider slides count as covered if the following operational batch exists.

---

## Pass 2 — Operational + resource slides only

| Result | Count |
|--------|-------|
| Covered | **24 / 24** |
| Missed | **0** |

Excludes pure title cards (1, 3, 8, 13, 16, 18, 23, 29, 35) except their topics still land in a batch.

---

## Pass 3 — Teaching points only (strict)

Every non-title slide that teaches a technique must have **actionable text** in a batch (command, payload, or explicit step).

| Result | Count |
|--------|-------|
| Covered | **23 / 23** |
| Missed | **0** |

---

## Full matrix (slide → batch)

| # | Slide content | Batch | Status |
|---|---------------|-------|--------|
| 01 | Title Hacking IIS w/ shubs | 01 | OK (intro) |
| 02 | Tweet: case, shortname, VIEWSTATE, web.config, ELMAH/Trace, Telerik | 01,04,05,07 | OK |
| 03 | Section HTTPAPI 2.0 Assets | 01 | OK |
| 04 | HTTPAPI 404 = missing Host / cert name | 01 | OK |
| 05 | Fix Host header; cert partial; VHost brute | 01 | OK |
| 06 | Demo wrong Host → HTTPAPI vs right Host → real IIS | 01 | OK |
| 07 | /etc/hosts, rescan + shortname, VHost, rinse all HTTPAPI | 01→02→07 | OK |
| 08 | Section VHost Hopping | 02 | OK |
| 09 | $1900 apply→mssql VHost; asp-ent-man | 02 | OK |
| 10 | Burp Match&Replace Host regex | 02 | OK |
| 11–12 | Reap benefits (Enterprise Manager UI) | 02 outcome | OK |
| 13 | Section LFI → DLLs | 03 | OK |
| 14 | C# MapPath + fileName LFI | 03 | OK |
| 15 | web.config → global.asax → bin DLL | 03 | OK |
| 16 | Section LFI → RCE | 04 | OK |
| 17 | machineKey, viewgen, ObjectStateFormatter | 04 | OK |
| 18 | Section DNSpy | 05 | OK |
| 19 | CuteSoft uploader.ashx + vendor zip | 05 | OK |
| 20–22 | DNSpy open/export/navigate | 05 | OK |
| 23 | Section Complex XXE | 06 | OK |
| 24 | Constraints (no HTTP OOB, stack traces) | 06 | OK |
| 25 | Local DTD attempt 1 (cim20 / system.ini) | 06 | OK |
| 26 | Stack trace EntityName no data | 06 | OK |
| 27 | Attempt 2 fragment `#` + web.config | 06 | OK |
| 28 | Partial file contents win | 06 | OK |
| 29 | Section shortname partial fuzz | 07 | OK |
| 30 | shortscan LIDSDI/LIDSSE/EASYFI | 07 | OK |
| 31 | ffuf lidsFUZZ logical cut | 07 | OK |
| 32 | ffuf result example | 07 | OK |
| 33 | crunch 0 3 leftover chars | 07 | OK |
| 34 | Resource links | resources.md | OK |
| 35 | assetnote.io branding | resources.md | OK |

---

## Pass conclusions

| Pass | Focus | Outcome |
|------|--------|---------|
| **1** | All 35 slides present in kit | **PASS** |
| **2** | Ops + resources only | **PASS** |
| **3** | Strict teaching points | **PASS** |

**Verdict:** Every NahamCon slide’s *teachable* content is represented in IIS execution batches (or `resources.md` for link/branding slides). Operators should use **batches only**; slide JPGs are evidence, not the runbook.
