# writeup-writer

Canonical contract: `.agents/writeup-writer.yaml`  
Grok spawn body: `.grok/agents/writeup-writer.md`

**lab-writeup** skill + **simple-english** 1× pragmatic.  
**No** frugal-eval. **No** content_eval.

## Quick invoke

```text
spawn writeup-writer
topic: <box> — <bug class>
path: web-app-testing/writeups/<slug>.md
mode: blog
land: notes
```

Or: “write a lab writeup with writeup-writer (no eval)”.

## Deliverable shape

Pre-req → core concept one-liner → meta → intro → root cause →  
Step N (why / command / first principles / expect / screenshot) →  
impact → mitigation → Beyond Root → conclusion → disclaimer
