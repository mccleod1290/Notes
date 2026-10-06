# Phase 1

**The target, then the map.** Two skills. The clerk between them only freezes his words.

```text
book, course, or work material
        |
        v
interviewer
  zero:  no quiz. computer literacy only. copy-paste is not skill
  known: drill, then only what he could produce
        |
        v
study_clerk  ->  CONTEXT.md     adds nothing
        |
        v
map_maker    ->  MAP.md         parts, dependencies, stuck points
        |
        v
phase 2 explainer reads MAP.md and TARGET.md
phase 3 exam reads that same map and the phase 2 page
phase 4 logger, then diagnostician, then clerk, reads the phases before it
```

| Path | Job |
| --- | --- |
| `RULES.md` | Saraev's interviewer and map maker, plus the two modes |
| `PACKET.md` | The only field list |
| `skills/interviewer/` | The two modes |
| `skills/study_clerk/` | Freeze. Not a third phase |
| `skills/map_maker/` | The map |

```text
/interviewer
/workflow study-map {"slug":"aws_oidc_flow"}
```
