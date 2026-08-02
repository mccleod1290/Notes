# Sensitive Business Flows notes — 3× coverage evaluation

**Scope:** Academy API6 + batch 06 + lab evidence  
**Style target:** AEM / IIS / API 01–05 (operator-first; lab under WORKED EXAMPLE)

---

## Pass 1 — Academy teaching points

| # | Point | Covered? |
|---|-------|----------|
| 1 | API exposes ops/data that undermine business (e.g. discounted buy intel) | YES |
| 2 | Builds on previous BFLA (discounts) | YES |
| 3 | Discount rate + date window example (70%, product id) | YES |
| 4 | Chain to purchase without rate limit / URC → scalp | YES |
| 5 | Prevention: strict access on critical business endpoints | YES |
| 6 | Q1: street for customer `daa8c984-…` via prior access | YES |

**Pass 1: 6/6 PASS**

---

## Pass 2 — Beyond Academy + first principles + gotchas

| # | Item | Covered? |
|---|------|----------|
| 1 | First principles: what is a business flow (value types) | YES |
| 2 | How to **identify** flows (money/scarcity/secret/PII tags) | YES Steps A–D |
| 3 | How to **document** flows (template artifact) | YES |
| 4 | Comparison table vs BFLA/BOLA/BOPLA/URC | YES |
| 5 | Dual-hat endpoints (BFLA + API6) | YES |
| 6 | Gotchas G1–G12 | YES |
| 7 | Edges E1–E10 (invite, auction, partner) | YES |
| 8 | Live street answer + evidence | YES |
| 9 | Conti-style FILL IN / DO THIS / IF THEN | YES |
| 10 | Not CTF-only (“submit street”) as whole runbook | YES |

**Pass 2: 10/10 PASS**

---

## Pass 3 — Operator path completeness

| Step | Covered? |
|------|----------|
| Name value at risk before tooling | YES |
| Tag OAS by business verb | YES |
| Restriction questions (who/when/how much/how often) | YES |
| Chain access bugs → process abuse | YES |
| Write business-impact finding text | YES evidence comment |
| Prevention for process abuse | YES |
| Lab appendix only | YES |

**Pass 3: 7/7 PASS**

---

## Operator vs CTF check

| Anti-pattern | Status |
|--------------|--------|
| Runbook = “open billing JSON, grep id” only | **Avoided** |
| No identification methodology | **Avoided** |
| No documentation template | **Avoided** |
| Matches AEM/IIS rhythm | **YES** |

---

## Overall: **ALL PASS**

**Q1 street:** `788 Sauchiehall St.`
