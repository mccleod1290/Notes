# Batch 06 — Blind XXE: local DTD + fragment identifier

## objective

When outbound HTTP is dead but stack traces exist, use **local DTD** redefinition and the **`#` fragment** trick for partial file leak (e.g. `web.config`).

## estimated_time

60–90 minutes

## prerequisites

- XML upload/API endpoint
- Error messages / stack traces visible
- OAST optional (DNS may work)

## testing_workflow

### 1) Technique A — confirm XML parse + errors

Send well-formed vs broken XML; note stack traces.

### 2) Technique B — local DTD attempt 1

Use Windows `cim20.dtd` + error-based leak of `system.ini` (payload in operator reference §6).

### 3) Technique C — fragment identifier attempt 2

Put file entity after `#` in error URI so partial contents appear in exception (nytr0gen technique). Target `web.config` paths.

## decision_points

| If… | Then… |
|-----|--------|
| Partial web.config | → **04** with keys |
| No errors | Stop XXE track; → **07** |
| DNS OOB only | Document limited XXE |

## expected_findings

- Partial file disclosure via XXE error oracle

## next_batch_to_continue_with

→ **[07-shortname-fuzz.md](./07-shortname-fuzz.md)**  
or **04** if keys recovered
