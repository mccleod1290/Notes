# Batch 05 — Break vendor plugins (DNSpy / Telerik / editors)

## FILL IN

```bash
T="https://TARGET"
```

## GOAL
Find third-party ASP.NET tools (Telerik, CuteEditor, …), get their DLLs, reverse them, find one bad sink.

## TIME
~1 hour

## YOU NEED
- Site map / proxy history  
- DLL from LFI (batch 03) **or** vendor zip offline  
- DNSpy on Windows **or** `ilspycmd` on Linux  

---

## WHY (kid version)

Talk + tweet: **Telerik RCE** and other vendors are high ROI on IIS.  
Companies bolt on editors/uploaders. Code ships as **DLL** without source.  
You reverse the DLL → find “save file from user input” → PoC.

---

## DO THIS

### 1) Probe common plugin paths (include Telerik from slide 2)

```bash
ffuf -u "$T/FUZZ" -w - -mc all -fc 404 -t 20 <<'EOF'
Telerik.Web.UI.WebResource.axd
Telerik.Web.UI.DialogHandler.aspx
admin/cutesoft_client/cuteeditor/uploader.ashx
CuteSoft_Client/CuteEditor/Load.ashx
elmah.axd
trace.axd
ScriptResource.axd
WebResource.axd
EOF
```

**Win:** not 404 → note path for deeper tests / known CVEs.

### 2) Get a DLL

```bash
# if you still have LFI from batch 03:
# curl ... fileName=../../bin/Some.Vendor.dll -o vendor.dll
file vendor.dll
```

Or download matching product zip offline (talk: CuteSoft zip with DLLs, no source).

### 3) Reverse (pick one)

**Windows:** open `vendor.dll` in [DNSpy](https://github.com/dnSpy/dnSpy/releases)  
**Linux:**

```bash
ilspycmd -p -o out/ vendor.dll
grep -RniE 'Upload|MapPath|File\.|Process|Xml|Deserialize' out/ | head -40
```

### 4) Hunt sinks then one PoC request

Search for: upload, path, filename, XML, process start.  
Map HTTP path (`.ashx` / `.aspx`) → method → craft **one** request in Burp.

### 5) Write 3 lines

```text
Plugin paths:
DLL:
Sink / PoC:
```

---

## IF / THEN

| You see | You do |
|---------|--------|
| Known Telerik CVE path | Check version / public PoC carefully in scope |
| New sink | Document request |
| Nothing | → **06** or **07** |

---

## NEXT
→ [06-xxe-fragment.md](./06-xxe-fragment.md) if app takes XML  
else → [07-shortname-fuzz.md](./07-shortname-fuzz.md)

**Slides:** 18–22 (+ Telerik on slide 2)
