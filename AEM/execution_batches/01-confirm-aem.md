# Batch 01 — Is it AEM? Get one page path

## FILL IN

```bash
T="https://PUT-THE-SITE-HERE"    # no slash at end
```

## GOAL
Know if this site is Adobe Experience Manager. Save **one** page path for later cards.

## TIME
~1 hour

## YOU NEED
- URL you may test
- Terminal with `curl`

---

## WHY (30 seconds)

AEM is a big company website tool. Adobe leaves the same doors on many sites (login page, CSS/JS folders).  
If those doors answer, it is probably AEM.  
Later tricks need a real page path like `/content/.../home`. Grab one now so you never hunt for it again mid-fight.

**Permissions footgun:** unauthenticated visitors are the `anonymous` user, who sits in the `everyone` group. Anything granted to “everyone” is free to the internet.

---

## DO THIS

### 1) Knock on three Adobe doors

```bash
curl -sk -o /tmp/aem-login.html -w "login:%{http_code}\n" \
  "$T/libs/granite/core/content/login.html"
head -c 300 /tmp/aem-login.html; echo

curl -sk -o /dev/null -w "js1:%{http_code}\n" \
  "$T/etc.clientlibs/clientlibs/granite/jquery.js"

curl -sk -o /dev/null -w "js2:%{http_code}\n" \
  "$T/etc/clientlibs/granite/jquery.js"
```

**Win look:** login shows Adobe/AEM text, or js1/js2 is **200** (not only 404).

### 2) Steal one page path from the homepage

```bash
curl -sk "$T/" -o /tmp/home.html
grep -oE '/content/[^"'\'' <>]+' /tmp/home.html | sort -u | head -40
```

Pick **one** line that looks like a page (not a random image). Put it here:

```bash
PAGE="/content/something/en/home"
curl -sk -o /dev/null -w "page:%{http_code}\n" "$T${PAGE}.html"
```

### 3) Quick Forms check (yes/no only)

```bash
curl -sk -o /dev/null -w "forms:%{http_code}\n" \
  "$T/lc/libs/livecycle/core/content/login.html"
curl -sk -o /dev/null -w "FormServer:%{http_code}\n" "$T/FormServer/"
```

### 4) Write 3 lines in your notes

```text
AEM: yes / no / maybe
PAGE=...
Forms: yes / no
```

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| Login or js = AEM | Go **NEXT** |
| All 404 | Open homepage HTML, search `etc.clientlibs` or `cq`. Still nothing → **stop AEM board** |
| Forms = 200 | Write "Forms=yes". Do Forms cards after 02–03 |

---

## NEXT
→ [02-json-node-dumps.md](./02-json-node-dumps.md)
