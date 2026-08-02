# Batch 05 — Vendor dependencies + DNSpy

## objective

Fingerprint third-party ASP.NET components (e.g. editors/uploaders), acquire DLLs (LFI or vendor zip), reverse with DNSpy/ilspycmd for sinks.

## estimated_time

60–90 minutes

## prerequisites

- Paths or DLLs from recon/LFI
- Windows VM or Linux decompiler

## testing_workflow

### 1) Technique A — path probes

```bash
ffuf -u "https://TARGET/FUZZ" -w - -mc all -fc 404 -t 20 <<'EOF'
admin/cutesoft_client/cuteeditor/uploader.ashx
CuteSoft_Client/CuteEditor/Load.ashx
Telerik.Web.UI.WebResource.axd
elmah.axd
trace.axd
EOF
```

### 2) Technique B — get binaries

LFI to `../../bin/Vendor.dll` or download matching vendor package offline.

### 3) Technique C — reverse + map HTTP → sink

DNSpy: open DLL → search Upload/MapPath/Xml/Process/Deserialize → craft one PoC request.

## decision_points

| If… | Then… |
|-----|--------|
| Sink found | Exploit per scope |
| No vendor surface | → **06** if XML; else **07** |

## expected_findings

- RCE/upload/XXE in third-party handlers

## next_batch_to_continue_with

→ **[06-xxe-fragment.md](./06-xxe-fragment.md)** if XML parsers  
else → **[07-shortname-fuzz.md](./07-shortname-fuzz.md)**
