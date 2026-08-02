# Batch 06 — Unrestricted Access to Sensitive Business Flows (operator)

## FILL IN (any API)

```bash
BASE="https://api.example.com"
EMAIL="user@example.com"; PASS="..."
LOGIN="/api/v1/authentication/.../sign-in"
# After BFLA / EDE / inventory — paths that feed money, inventory, pricing, PII workflows
```

## GOAL
Prove a principal can **see or drive a business process that should be restricted**, so they can **distort revenue, inventory, competition, or privacy at process scale** — not only “one extra field” or “one wrong id.”

## TIME
1–2 hours (after BFLA / surface map)

## YOU NEED
- Business context (what the company sells / how it makes money)  
- Endpoint map + roles (batches 00–05)  
- At least one low-priv principal  

---

## WHY (first principles)

### What is a “business flow”?

A **business flow** is a multi-step (or multi-data) process that moves **value**:

| Value type | Examples |
|------------|----------|
| Money | Checkout, refund, fee exemption, coupon, FX, payout |
| Inventory | Reserve stock, bulk order, warehouse transfer |
| Pricing intelligence | Future discounts, cost, margin, competitor quotes |
| Access / entitlement | Seat licenses, feature flags, invite codes |
| Trust / identity | KYC result, credit decision, risk score |
| PII as process fuel | Full customer address book for logistics/marketing |

An API is vulnerable to **Unrestricted Access to Sensitive Business Flows** (OWASP **API6**) when an endpoint (or chain) exposes that process **without appropriate restriction** — access control, rate limits, step-up auth, fraud controls, or “need to know.”

### How this differs from neighbors

| Class | Failure | Typical proof |
|-------|---------|----------------|
| **BFLA** | Call a **function** you should not | 200 on admin/GetAll with empty roles |
| **BOLA** | Touch **another’s object** on allowed function | Other tenant order by id |
| **BOPLA EDE** | **Too many fields** on allowed response | Cost/margin/email on public list |
| **Mass assign** | **Write** forbidden properties | Set price/fee/role |
| **URC** | **Too much volume/size/$** | SMS flood, huge upload |
| **API6 business flow** | Abuse the **process** / **intelligence** to game the business | Discount calendar → scalp stock; full address book → mass phishing / fraud |

**Same endpoint can wear two hats:**

- `GET /products/discounts` as **BFLA** (no role)  
- Same response as **API6** (discount **schedule** enables arbitrage / bulk buy on sale day)  
- `GET /customers/billing-addresses` as **BFLA** + **API6** (PII at **catalog scale** is a logistics/marketing/fraud flow, not one self-address)

Always report **impact in business language**, not only “200 OK.”

---

## FIRST PRINCIPLES — Identifying sensitive business flows

### Step A — Name the money / risk

Before tools, write one page:

```text
Who pays whom?
What is scarce (stock, seats, invites)?
What is secret until a date (sale, IPO, campaign)?
What data, if bulk-read, enables fraud/phishing/scalping?
```

### Step B — Tag endpoints by business verb

From OAS / traffic, tag each operation:

| Tag | Verbs / paths (examples) |
|-----|---------------------------|
| `PRICE` | price, discount, coupon, fee, tax, quote |
| `BUY` | order, cart, checkout, purchase, bid |
| `STOCK` | inventory, reserve, allocate, warehouse |
| `PAY` | payment, refund, payout, transfer |
| `IDV` | kyc, verify, credit, risk |
| `PII_BULK` | customers*, billing*, addresses*, export |
| `ADMIN_OPS` | approve, ship, cancel, override |
| `GROWTH` | invite, referral, trial, promo |

**Sensitive flow candidates** = tags that affect revenue, scarcity, or regulated PII **and** are callable by broad roles (or no role).

### Step C — Ask the restriction questions

For each candidate:

1. **Who should know this?** (role, partner, only self)  
2. **When should they know?** (not before campaign launch)  
3. **How much?** (one object vs full catalog)  
4. **How often?** (rate / velocity / device)  
5. **What happens if abused?** (scalp, dump stock, undercut fees, dox customers)

If any answer is weak → **API6 candidate**.

### Step D — Chain, don’t silo

Business flows are often **compositions**:

```text
BFLA discounts  →  know sale windows
     +
URC no rate limit on order create  →  buy entire stock at 70% off
     =
API6 inventory arbitrage story
```

```text
BFLA billing GetAll  →  every street address
     =
API6 mass customer-location flow (fraud / social eng / physical risk)
```

Document the **chain** in the finding, even if one ticket is filed as BFLA.

---

## HOW TO document a business flow (operator artifact)

Create `notes/{target}/business-flows.md` (or a section in the report):

```markdown
## Flow: <short name>
- Goal (attacker): ...
- Value at risk: money | stock | PII | reputation
- Steps (API):
  1. METHOD path — authz expected vs actual
  2. ...
- Data that enables step N: ...
- Restrictions missing: role | rate | step-up | geo | inventory cap
- Abuse scenario (1 paragraph, $ or people impact)
- Related classes: BFLA / BOLA / URC / ...
- Evidence paths: ...
```

**Good:** “Zero-role JWT dumps all future discount windows; on start date buyer can exhaust stock.”  
**Bad:** “Endpoint returns JSON.”

---

## DO THIS (generic test procedure)

### 1) Reuse authz inventory

```bash
JWT=$(curl -sk -X POST "$BASE$LOGIN" -H 'Content-Type: application/json' \
  -d "{\"Email\":\"$EMAIL\",\"Password\":\"$PASS\"}" \
  | python3 -c 'import sys,json;print(json.load(sys.stdin)["jwt"])')
curl -sk -H "Authorization: Bearer $JWT" "$BASE/api/v1/roles/current-user"
```

Run BFLA matrix (batch 05) and EDE list (batch 03) — **API6 is often impact framing on those results.**

### 2) Pull every PRICE / PII_BULK / BUY surface

```bash
for p in \
  /api/v1/products/discounts \
  /api/v1/products \
  /api/v1/customers/billing-addresses \
  /api/v1/customers \
  /api/v1/.../coupons \
  /api/v1/.../inventory
do
  curl -sk -H "Authorization: Bearer $JWT" "$BASE$p" -o "bf_$(echo $p|tr / _).json"
  echo "$p -> $(wc -c < bf_$(echo $p|tr / _).json)"
done
```

### 3) Translate raw data → process abuse

| Data seen | Business question |
|-----------|-------------------|
| discount % + start/end dates | Can I time bulk purchase / resale? |
| all billing streets | Can I run mass fraud / phishing / stalk? |
| fee exemption flags for all companies | Can I undercut marketplace? |
| invite codes / trial limits | Can I farm free tier? |
| stock levels + low rate limit on buy | Can I scalp? |

### 4) Prove restriction failure (pick one strong story)

Minimum bar for a finding:

1. **Access** — who called it (role empty / wrong)  
2. **Sensitivity** — why the *flow* matters  
3. **Abuse path** — concrete steps (even if you stop short of DoS in production)  
4. **Missing control** — role, rate, eligibility, step-up  

### 5) Operator log

```text
Flow name:
Endpoints:
Principal / roles:
Sensitive artifact (e.g. discount calendar, address book):
Missing restriction:
Business impact one-liner:
```

---

## GOTCHAS

| # | Gotcha | What to do |
|---|--------|------------|
| G1 | Filing only “BFLA” and ignoring business impact | Always add API6 **impact paragraph** when process-scale |
| G2 | Calling every data leak API6 | Need **process / competitive / fraud** angle, not any PII |
| G3 | Testing only happy UI path | Business abuse often needs **bulk API** not browser |
| G4 | Discount dates in past still “intel” | Still proves unrestricted pricing flow; note live vs historical |
| G5 | Confusing self `current-user` address with GetAll | Self is normal; **catalog of all customers** is the flow |
| G6 | Stopping at read | Check write side: order create, coupon apply, fee patch (mass assign) |
| G7 | No rate limit assumed | Confirm with short authorized burst; don’t DoS prod |
| G8 | Multi-tenant SaaS | “Business flow” may be **cross-tenant analytics** leak |
| G9 | Partner / B2B APIs | Wholesale price lists are classic API6 |
| G10 | Same street/flag used in BOPLA lab | Class by **access path**: zero-role GetAll = BFLA+API6; authorized overshare = EDE+API6 |
| G11 | Over-claiming “we bought all stock” without evidence | Prefer **capable of** + missing controls unless lab asks for exploit |
| G12 | Missing documentation | Without flow writeup, retest and report writers re-discover from scratch |

---

## EDGE CASES

| # | Test | Notes |
|---|------|--------|
| E1 | Discount schedule full dump | Pricing flow |
| E2 | Coupon enumerate / reuse | Promo flow |
| E3 | Referral / invite mint without limit | Growth flow |
| E4 | Bulk address / phone export | PII process fuel |
| E5 | Early access / feature flag read | Competitive flow |
| E6 | Auction bid timing + no velocity limit | Marketplace flow |
| E7 | Ticket scalping (event APIs) | Scarcity flow |
| E8 | Fee exemption list for all suppliers | Revenue flow |
| E9 | Chain BFLA → order storm (URC) | Compound API6 |
| E10 | GraphQL batch export of same data | Same flow, different transport |

---

## Evidence comments (paste)

```text
Class: Unrestricted Access to Sensitive Business Flows (OWASP API6).
Principal P (roles R) obtained process-critical data or operations F that should be restricted
(need-to-know / partner-only / rate-limited / step-up).
Business impact: <arbitrage | scalping | mass PII abuse | fee evasion intel>.
Often chains: BFLA/EDE provides the data; missing velocity controls amplify.
Not only BFLA: impact is the business process, not solely the missing role check
(though BFLA may be the root access bug).
```

## Prevention

| Control | Against |
|---------|---------|
| Strict RBAC/ABAC on pricing & PII catalogs | Unauthorized read of flows |
| Time-bound disclosure (discounts only when live) | Pre-sale intel |
| Rate / inventory caps / bot management on BUY | Scalping |
| Step-up auth for high-risk ops | Takeover → drain |
| Fraud velocity & device binding | Automated abuse |
| Monitor bulk export anomalies | Silent address dumps |
| Separate partner APIs with contracts + quotas | Wholesale leak |

## IF / THEN

| See | Do |
|-----|-----|
| Zero-role full discount calendar | BFLA **and** API6 pricing flow |
| Zero-role all billing streets | BFLA **and** API6 PII/logistics flow |
| Allowed role but full cost/margin | BOPLA EDE + maybe API6 |
| Can set NetSum/fee | Mass assign + revenue flow |
| Can buy unlimited on sale open | URC + API6 |

## NEXT
→ SSRF  
→ Re-read [05-bfla-broken-function-level-authz.md](./05-bfla-broken-function-level-authz.md) and [04-unrestricted-resource-consumption.md](./04-unrestricted-resource-consumption.md) for chains  

---

## WORKED EXAMPLE (lab only — not the runbook)

Inlanefreight academy. Full proof: `../notes/inlanefreight-business-flows/`.

| Flow | Access | Abuse narrative |
|------|--------|-----------------|
| **Pricing calendar** | p9 zero roles → `GET /api/v1/products/discounts` | Know 70% window for product `a923b706-…` (2023-03-15 → 2023-09-15); with unlimited purchase = scalp |
| **Customer location book** | p9 → `GET /api/v1/customers/billing-addresses` | Full address catalog; query customer `daa8c984-…` |

**Q1 answer (street):** see `notes/inlanefreight-business-flows/evidence/ANSWER-street.txt`
