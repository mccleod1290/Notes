# Batch 07 — Short names → finish the name (talk recipe)

## FILL IN

```bash
T="https://TARGET"
# after shortscan, example:
# LIDSDI~1  → use prefix lids
```

## GOAL
1) Leak short names (`LIDSDI~1`)  
2) Fuzz **only the missing ending** with ffuf  
3) Optional tiny brute with crunch  

## TIME
~1–2 hours

## YOU NEED
- Working IIS host (use NAME from batch 01)  
- `shortscan` **or** IIS-ShortName-Scanner  
- `ffuf`  
- Optional: `crunch`  
- A wordlist file for completions  

---

## WHY (kid version) — matches slides 29–33

Windows keeps short names: long folder → `VERYLO~1`.  
Buggy IIS leaks those even when full path 404s.

Talk example output:

```text
LIDSDI~1
LIDSSE~1
LIDSTE~1
EASYFI~1
```

You do **not** guess the whole site. You cut at a smart place:

```text
LIDSDI~1  →  /lidsFUZZ
EASYFI~1  →  /easyFUZZ
```

Then ffuf + extensions `asp,aspx,ashx,asmx`.

---

## DO THIS

### 1) Enum short names

```bash
shortscan "$T/"
# or: go run ... shortscan as tool docs say
```

**Win line:** `Vulnerable: Yes!` plus names like `LIDSDI~1`.

### 2) Logical ffuf (exact talk idea)

```text
LIDSDI~1 / LIDSSE~1 / LIDSTE~1  →  one fuzz: /lidsFUZZ
EASYFI~1                        →  /easyFUZZ
```

```bash
# wordlist = normal words that could finish the name
ffuf -w wordlist.txt -D \
  -e asp,aspx,ashx,asmx \
  -t 100 -c \
  -u "$T/lidsFUZZ"
```

Talk command shape:

```bash
./ffuf -w final_wordlist.txt -D -e asp,aspx,ashx,asmx -t 1000 -c \
  -u http://redacted/lidsFUZZ
```

(Use lower threads if the site is fragile.)

### 3) Optional — only 1–3 letters left (slide crunch)

```bash
crunch 0 3 abcdefghijklmnopqrstuvwxyz0123456789 -o 3chars.txt
ffuf -w 3chars.txt -e aspx,ashx,asp -u "$T/lidsdiFUZZ"
```

### 4) Write 3 lines

```text
Vulnerable: yes/no
Short names:
Full paths found:
```

---

## IF / THEN

| You see | You do |
|---------|--------|
| admin / backup / config path | Open it; feed to **03** if file read |
| Not vulnerable | Board done |
| Hit mid-fuzz | Stop fuzz; exploit that path |

---

## NEXT
**IIS board complete** for this track.  
Loop to **03–06** if new paths open LFI/XML/vendor doors.  
Resources (slides 34–35): [../resources.md](../resources.md)

**Slides:** 29–33
