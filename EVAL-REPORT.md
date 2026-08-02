# Operator notes — evaluation report (3 passes)

Date of evals: 2026-08-02  
Scope: `IIS/`, `AEM/`, `web-app-testing/`

---

## Pass 1 — Structure

| Kit | Files | GOAL / DO THIS / NEXT | FILL IN + WHY + IF/THEN + TIME |
|-----|-------|------------------------|--------------------------------|
| IIS | 7 | All pass | All pass |
| AEM | 16 | All pass | FILL IN enforced on all after pass |
| Web | 10 | All pass | All pass |

**Result:** PASS (no missing required sections)

---

## Pass 2 — Completeness vs sources

### Web app testing
- Original prompt checklist items checked: **46**
- Missing from README map: **NONE**
- Foundation batch 00 (endpoint/verb/CORS workflow): **present**

### IIS vs NahamCon slides
Checked batch corpus for: HTTPAPI, VHost, match-replace, web.config LFI, machineKey, VIEWSTATE, viewgen, DNSpy, Telerik, ELMAH, trace.axd, local DTD (cim20), fragment XXE, shortscan, lidsFUZZ, crunch.

**Missing:** NONE  
**Slide images:** 35 under `IIS/slides-raw/cdn/`

### AEM vs research themes
Checked for: QueryBuilder, bouncer/bypass, semicolon, GraphQL, form selector, rawcontent, listParagraphs, packages, guideContainer, FormServer, accesstoken SSRF, cloudsettings EL, anonymous.

**Missing:** NONE

**Result:** PASS

---

## Pass 3 — Links, dead refs, noise

| Check | Result |
|-------|--------|
| Relative `.md` links resolve | PASS |
| No `AEM/reference/` leaks | PASS |
| No pinchtab `slide-*.png` noise | PASS |
| README vibe start path | PASS (IIS / AEM / web-app) |
| Redundant reference tree | Removed earlier |

**Result:** PASS

---

## Overall

| Pass | Outcome |
|------|---------|
| 1 Structure | **PASS** |
| 2 Completeness | **PASS** |
| 3 Integrity / simplicity gates | **PASS** |

### Operator start (vibe)

```text
IIS/README.md              → execution_batches/01-...
AEM/README.md              → execution_batches/01-...
web-app-testing/README.md  → execution_batches/00-...
```

Each card: FILL IN → WHY → DO THIS → IF/THEN → NEXT.
