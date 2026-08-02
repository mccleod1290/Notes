# Batch 04 — Config keys → VIEWSTATE RCE

## GOAL
Use `machineKey` from `web.config` to forge VIEWSTATE and prove code run (OOB).

## TIME
~1–2 hours

## YOU NEED
- Keys from batch 03  
- RCE allowed  
- OAST  

---

## WHY (30 seconds)

ASP.NET WebForms stores page state in a blob called **VIEWSTATE**.  
The server **signs** (and sometimes encrypts) it with secrets from `web.config` called **machineKey**.  

If you have those secrets, you can build a VIEWSTATE that deserializes into **your code** (classic insecure deserialize).  

No keys → almost no forge. Keys → often game over on old ASP.NET.

---

## DO THIS

### 1) Copy keys

```bash
grep -i machineKey web.config
# validationKey=...
# decryptionKey=...
# validation= / decryption=
```

### 2) Confirm page has VIEWSTATE

```bash
curl -sk "https://TARGET/SomePage.aspx" | grep -o '__VIEWSTATE' | head
```

### 3) Forge payload

Use [viewgen](https://github.com/0xacb/viewgen) or ysoserial.net (check `--help` on your install).  
Prefer command that only hits OAST (`nslookup your.oast`).

### 4) Send forged `__VIEWSTATE` in a normal POST to that page

Watch OAST. Save request/response.

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| OOB hit | Critical finding |
| Encrypted VIEWSTATE fails | Re-check decryptionKey + sticky session on load balancer |
| No VIEWSTATE on site | Close card → **05** |

---

## NEXT
→ [05-dnspy-dependencies.md](./05-dnspy-dependencies.md)
