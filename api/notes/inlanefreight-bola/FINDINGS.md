# Lab findings — BOLA on Inlanefreight API

**Target:** `http://154.57.164.65:31687`  
**Date:** 2026-08-02  
**Auth:** Supplier `htbpentester1@pentestercompany.com`  
**Tools:** curl, pinchtab (Swagger screenshot), OpenAPI inventory  

## Confirmed: BOLA (CWE-639)

| Field | Detail |
|-------|--------|
| Endpoint | `GET /api/v1/supplier-companies/yearly-reports/{ID}` |
| Auth | Required (401 without JWT) |
| Role | `SupplierCompanies_GetYearlyReportByID` |
| Bug | No check that report.`companyID` == authenticated supplier’s company |
| Own company | `b75a7c76-e149-4ca7-9c55-d9fc4ffa87be` |
| Proof id=1 | company `f9e58492-b594-4d82-a4de-16e4f230fce1`, revenue `794425112` |
| Proof id=13 | company `96dcb320-5481-441b-8c36-95a300058bde`, revenue `588820631` |
| Range | Integer IDs **1–18** return data (this spawn) |
| Impact | Cross-tenant business financials + internal C-level comments |

## Related observations

| Endpoint | Result | Note |
|----------|--------|------|
| `GET …/yearly-reports` (no id) | 403 | List blocked; item BOLA still works |
| `GET …/supplier-companies/{GUID}` | 403 | Object read by company GUID not granted |
| Invalid / missing IDs | 200 + `errorMessage` | Soft 404 pattern (still an oracle) |
| Other methods on report by ID | 405 | GET-only |

## Evidence files

```text
evidence/OWN.txt
evidence/current-user-supplier.json
evidence/current-user-company.json
evidence/roles-current-user.json
evidence/bola-proof-id1.json
evidence/bola-proof-id13.json
evidence/yearly-reports-1-20.jsonl
evidence/edge-cases.txt
evidence/swagger.json
evidence/swagger-ui.png
```

## Operator path

Use [../../execution_batches/01-bola-idor.md](../../execution_batches/01-bola-idor.md).
