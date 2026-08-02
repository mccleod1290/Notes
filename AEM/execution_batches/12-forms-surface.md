# Batch 12 — Is AEM Forms here? (look only)

## FILL IN

```bash
T="https://TARGET"
PAGE="/content/YOUR/PAGE"
```

## GOAL
Map Forms doors. **No exploit payloads** this hour.

## TIME
~1 hour

## YOU NEED
- Forms hint from 01, or program lists Forms

---

## WHY (30 seconds)

**AEM Sites** = the public website CMS.  
**AEM Forms** = form/workflow product (sometimes on the same host, sometimes alone on JBoss).  

Forms has had **huge** bugs. First you only answer:  
“Is it here? Standalone or bolted on? Are scary paths open?”

---

## DO THIS

```bash
T="https://PUT-THE-SITE-HERE"
```

### 1) Knock every common Forms door

```bash
for p in \
  "/lc/libs/livecycle/core/content/login.html" \
  "/edcws/" \
  "/adminui/" \
  "/adminui/login.do" \
  "/FormServer/" \
  "/FormServer/servlet/GetDocumentServlet" \
  "/content/forms/af/"
do
  curl -sk -o /tmp/f -w "%{http_code} %{size_download}  $p\n" --max-time 10 "$T$p"
done
```

### 2) Sort it (pick one)

```text
Standalone smell = FormServer / adminui / lc login without normal marketing site
Together smell   = /content/forms on same AEM site as batch 01
```

### 3) If you have QB — count guide containers

```bash
curl -sk -G "$QB" \
  --data-urlencode "property=sling:resourceType" \
  --data-urlencode "property.value=fd/af/components/guideContainer" \
  --data-urlencode "p.limit=10" | head -c 400; echo
```

### 4) Write down

```text
Forms: yes/no
Kind: standalone / together / unknown
Open paths:
RCE allowed in scope: yes/no
```

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| No Forms | Skip 13–14 → **15** |
| Together + guides | → **13** |
| Standalone + RCE OK | → **14** |
| Standalone but no RCE in rules | Report open admin doors only; → **15** |

---

## NEXT
→ [13-forms-classic-xxe.md](./13-forms-classic-xxe.md) or [14-forms-modern-rce.md](./14-forms-modern-rce.md) or [15-modern-ssrf-xxe.md](./15-modern-ssrf-xxe.md)
