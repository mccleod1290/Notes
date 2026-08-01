# Q3 — Unique threat model?

#### Why this matters

Default focus is PII and account takeover. Many apps hold other **crown jewels**: stream keys, API tokens, payroll, health data, payouts, integration secrets, doxing-grade app data.

If you only ask “can I read email?”, you miss what actually matters on *this* product.

**Example:** a streaming settings page where the valuable object is not the password — it is the **primary stream key**.

#### Checklist

- [ ] What ruins a customer or the business if stolen or changed?
- [ ] Data beyond PII: API keys, OAuth tokens, webhook secrets, signing keys, media, messages, …
- [ ] High-value **actions**: payout, reset others’ passwords, domain verify, deploy, ban, …
- [ ] Realistic adversary: other tenant, random internet, insider, partner integration?
- [ ] Compliance shape that implies extra surfaces (PCI, HIPAA, …)?

#### If you learn X → test Y

| Learn | Test |
|-------|------|
| Stream / API keys in UI | AuthZ on key endpoints; leaks in logs/referrers |
| Exports / reports | Access control; over-wide data |
| Third-party integrations | Token storage; redirect_uri; webhook SSRF |
| User media | Stored XSS; open object storage |
| Impersonate / “login as” | Re-auth gaps; session issues |

#### Prompt — threat model

```text
Build a target-specific threat model for authorized app testing (not a generic STRIDE dump).

Product: [one line]
Users/roles: [brief]
Sensitive features already seen: [list]
Standard PII: [yes/no + types]

1. Crown jewels (data + actions), ranked by impact for this product.
2. For each: likely location (settings, API, export, integration).
3. Jewel → bug classes that would unlock it.
4. Easy-to-forget assets beyond login/PII.
5. Hunting priority for the next 2–4 hours of manual work.

More recon:
[PASTE]

Keep it product-shaped and concrete.
```

---

---

*Part of Understanding App — Big Questions for directed web app testing.*
