# 2019 Batch 05 — API9: Improper Assets Management

> **2023 note:** Renamed [Improper Inventory Management](https://owasp.org/API-Security/editions/2023/en/0xa9-improper-inventory-management/). Same operator job: **know every API host/version/endpoint**, retire dead ones.

## FILL IN

```bash
BASE="https://api.example.com"
# Discover non-prod / old versions
for v in v0 v1 v2 beta internal staging; do
  curl -sk -o /dev/null -w "$v %{http_code}\n" "$BASE/swagger/$v/swagger.json"
  curl -sk -o /dev/null -w "api/$v %{http_code}\n" "$BASE/api/$v/"
done
```

## GOAL
Find **undocumented, deprecated, or forgotten** API versions/hosts that still serve sensitive data — often **weaker auth** than production v1.

## WHY (first principles)

| Asset class | Risk |
|-------------|------|
| Old `/api/v0` | “Need to delete… keep for legacy” |
| Debug /admin /internal | No gateway auth |
| Preview hosts | Copy of prod data |
| Partner-only APIs left public | |
| Zombie microservices | Patch lag |

Attacker inventory > defender inventory → free bugs.

## DO THIS

### 1) OAS / Swagger version dropdown

```bash
curl -sk "$BASE/swagger/index.html" | head
curl -sk "$BASE/swagger/v0/swagger.json" -o swagger-v0.json
# Read info.description for “deprecated”, “delete”, “legacy”
```

### 2) Enumerate deleted/legacy paths from v0 OAS

```bash
python3 -c 'import json;d=json.load(open("swagger-v0.json"));print("\n".join(d["paths"]))'
for p in $(python3 -c 'import json;print(" ".join(json.load(open("swagger-v0.json"))["paths"]))'); do
  code=$(curl -sk -o /tmp/b -w "%{http_code}" "$BASE$p")
  echo "$code $(wc -c </tmp/b) $p"
done
```

### 3) Auth comparison

Unauth on v0 vs 401 on v1 for similar data = critical inventory failure.

### 4) Host inventory (beyond this lab)

DNS, cert SANs, wayback, mobile app base URLs, JS bundles, Git history.

### 5) Operator log

```text
Extra version/host:
Auth required?
Sensitive data:
Retirement status:
```

## EDGE CASES

| # | Test |
|---|------|
| E1 | `/api` vs `/api/v1` vs no prefix |
| E2 | GraphQL old schema |
| E3 | gRPC reflection left on |
| E4 | Backup `.json` OpenAPI in web root |
| E5 | Deleted user data still on v0 (GDPR) |

## Prevention

API inventory + CI gate; decommission old versions; auth parity; WAF/gateway only expose approved routes; sunset policy.

## WORKED EXAMPLE (lab)

Swagger **v0** description: *Need to delete this version…*  
Unauth `GET /api/v0/supplier-companies/deleted` → company email flag  
`GET /api/v0/suppliers/deleted` → **PasswordHash** on deleted users (feeds Unsafe Consumption narrative).  

Evidence: `../notes/inlanefreight-2019-suite/evidence/swagger-ui-v0.png`, `v0-*-excerpt.json`.
