# Lab findings — Unrestricted Resource Consumption (CWE-400 / API4)

**Target:** `http://154.57.164.65:31687`  
**Date:** 2026-08-02  
**Tools:** curl, OpenAPI, Python flood  

## 1) Academy demo — certificate upload (storage + type + static)

| Item | Detail |
|------|--------|
| Auth | Supplier `htbpentester8@pentestercompany.com` |
| Roles | `SupplierCompanies_Get`, `SupplierCompanies_UploadCertificateOfIncorporation` |
| Endpoint | `POST /api/v1/supplier-companies/certificates-of-incorporation` |
| Form fields | `CertificateOfIncorporationPDFFormFile`, `CompanyID` |
| Size | 30 MB and 40 MB random accepted (`successStatus: true`, `fileSize` returned) |
| Type | `.exe` accepted (not PDF-only) |
| Store path | `file:///app/wwwroot/SupplierCompaniesCertificatesOfIncorporations/...` |
| Static | Unauth `GET /SupplierCompaniesCertificatesOfIncorporations/<name>` → full bytes |

**Impact:** disk fill, malware hosting on marketplace origin, unauth download of “company certificates.”

## 2) Parallel surface — product photo upload (storage + type + static)

| Item | Detail |
|------|--------|
| Auth | Supplier `htbpentester11@pentestercompany.com` |
| Roles | includes `Products_CreateByCurrentUser`, `Products_UploadPhoto` |
| Create | `POST /api/v1/products/current-user` (+ `PNGPhotoFileURI`) |
| Upload | `POST /api/v1/products/photo` field `ProductPNGFormFile` |
| Size | 20 MB and 40 MB accepted |
| Type | `.exe`, `.jpg`, `.php` accepted despite “PNG” docs |
| Static | Unauth `GET /ProductsPhotos/<filename>` for many types |

**Impact:** same cost class as certs; product catalog as free object store.

## 3) Flag hunt — SMS OTP financial URC (no rate limit)

| Item | Detail |
|------|--------|
| Endpoint | `POST /api/v1/authentication/customers/passwords/resets/sms-otps` |
| Auth | **None** (Role: None) |
| OAS note | *“The SMS provider we are working with charges us a significant amount per message.”* |
| Body | `{"Email":"<any>"}` |
| Behavior | First responses `{"SuccessStatus":false}` (fixture); **no 429** across burst |
| Flag (call ~11) | `HTB{01de742d8cd942ad682aeea9ce3c5428}` |

**Impact:** unbounded third-party SMS spend → financial DoS to stakeholders. This is the “another” URC beyond file upload.

```json
{"flag":"HTB{01de742d8cd942ad682aeea9ce3c5428}"}
```

## Evidence

```text
evidence/roles-p8.json
evidence/company-p8.json
evidence/upload-30mb-pdf.json
evidence/upload-exe.json
evidence/upload-huge-cert.json
evidence/roles-p11.json
evidence/create-product-p11.json
evidence/upload-20mb-png.json
evidence/upload-exe-photo.json
evidence/upload-php-photo.json
evidence/product-detail.json
evidence/sms-flood-flag.json
evidence/sms-flood-notes.txt
evidence/swagger.json
```

Login JWTs redacted to `[REDACTED]`. Large binaries not kept in git.

## Operator runbook

[../../execution_batches/04-unrestricted-resource-consumption.md](../../execution_batches/04-unrestricted-resource-consumption.md)
