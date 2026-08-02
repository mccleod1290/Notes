# Batch 06 — Blind XXE + partial file leak

## GOAL
When XML is parsed with stack traces but no outbound HTTP, leak file bits via **local DTD + `#` fragment**.

## TIME
~1 hour

## YOU NEED
- XML endpoint  
- Errors/stack traces on  
- Optional OAST  

---

## WHY (30 seconds)

**XXE** = evil XML says “also load this file/URL.”  

Hard mode:

- No outbound HTTP  
- File content not shown in normal response  
- But **errors are on**

Trick:

1. Use a **local DTD file** already on Windows to redefine entities.  
2. Put file data in a URL **fragment** (`#...`) so .NET error text prints a **piece** of the file (nytr0gen idea).  

Even partial `web.config` can give keys → batch 04.

---

## DO THIS

### 1) Prove XML + errors

Send good XML vs broken XML. Save stack trace sample.

### 2) Local DTD attempt (system.ini first)

Use payload shape from full notes §6 (local `cim20.dtd` + error entity).  
Win = any file text in error.

### 3) Fragment attempt for web.config

Same idea with `#` before the file entity (see full operator notes for paste).  
Target `web.config` path guesses.

### 4) Write down

```text
XXE errors: yes/no
Partial file: yes/no
```

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| Partial web.config | → **04** with keys |
| No errors | Stop XXE → **07** |
| DNS only | Report limited XXE |

---

## NEXT
→ [07-shortname-fuzz.md](./07-shortname-fuzz.md)  
or **04** if keys found  

Full payload text: [OPERATOR-NOTES §6](../OPERATOR-NOTES-hacking-iis-nahamcon.md)
