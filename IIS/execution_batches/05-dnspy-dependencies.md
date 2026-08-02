# Batch 05 — Break vendor plugins (DNSpy)

## GOAL
Find third-party ASP.NET tools, get their DLLs, reverse, find one bad upload/XML/path sink.

## TIME
~1 hour

## YOU NEED
- Paths or DLLs from recon/LFI  
- DNSpy (Windows) or `ilspycmd`  

---

## WHY (30 seconds)

Companies bolt on editors/uploaders (CuteEditor, Telerik, …).  
Those ship as **DLL files** without source.  
You download the same product (or steal DLL via LFI) and reverse it like source.  
Hunt: file path from user, XML parse, process start.  
One weak plugin beats a hardened main app.

---

## DO THIS

### 1) Probe common plugin paths

```bash
ffuf -u "https://TARGET/FUZZ" -w - -mc all -fc 404 -t 20 <<'EOF'
admin/cutesoft_client/cuteeditor/uploader.ashx
CuteSoft_Client/CuteEditor/Load.ashx
Telerik.Web.UI.WebResource.axd
elmah.axd
trace.axd
EOF
```

### 2) Get DLL

- LFI: `../../bin/Something.dll`  
- or vendor zip offline  

### 3) Reverse

Open in DNSpy → search `Upload`, `MapPath`, `File.`, `Xml`, `Process` → map URL → method → one PoC request.

---

## IF / THEN

| What you saw | What you do |
|--------------|-------------|
| Sink found | Exploit per scope |
| No plugins | → **06** or **07** |

---

## NEXT
→ [06-xxe-fragment.md](./06-xxe-fragment.md) if XML  
else → [07-shortname-fuzz.md](./07-shortname-fuzz.md)

**Slide map:** deck slides 18–22 (vendor path → zip/DLL → DNSpy).
