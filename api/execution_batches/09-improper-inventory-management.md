# Batch 09 — Improper Inventory Management (API9:2023)

> Same idea as **2019 Improper Assets Management** — see [owasp-2019/execution_batches/05](../owasp-2019/execution_batches/05-improper-assets-management-2019.md).

## FILL IN

```bash
BASE="https://api.example.com"
curl -sk "$BASE/swagger/v0/swagger.json" -o swagger-v0.json
```

## GOAL
Find forgotten API **versions/hosts/endpoints** still serving data (often weaker auth).

## DO THIS

1. Swagger “Select a definition” → every version  
2. Diff v0 vs v1 paths and security  
3. Hit `*/deleted`, `/legacy`, `/internal` unauth  
4. Host/DNS inventory for siblings  

## WORKED EXAMPLE (lab)

Unauth `GET /api/v0/supplier-companies/deleted` →  
`HTB{43c2754afea99eba70fb2c8dc443c660}`  

Screenshots: `../owasp-2019/notes/inlanefreight-2019-suite/evidence/swagger-ui-v0.png`  
Full 2019 batch has complete operator depth.
