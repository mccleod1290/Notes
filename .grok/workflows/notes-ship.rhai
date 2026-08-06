// notes-ship — Notes vault document create + ship
// Run:
//   /notes-ship
//   /workflow notes-ship {"topic":"...","path":"AI","slug":"my-topic"}
//   /workflow notes-ship {"topic":"...","path":"api","slug":"bola","create_only":true}
//
// Process: writer (simple-english 1x) → frugal-eval (simple-english 3x hardcore)
//          → optional PDF + git + mail
// content_eval is NOT in this workflow.

let meta = #{
    name: "notes-ship",
    description: "Notes create+ship: writer STE 1x, frugal-eval STE 3x hardcore, two-doc, git, mail",
    when_to_use: "When creating or shipping learning notes in the Notes vault with the hardcoded writer then frugal-eval simple-english pipeline",
    phases: [
        #{ title: "Resolve", detail: "paths, two-doc vs single, ship flags" },
        #{ title: "Research", detail: "optional facts for references doc" },
        #{ title: "Writer", detail: "draft + simple-english 1x pragmatic" },
        #{ title: "FrugalEval", detail: "simple-english 3x hardcore per file" },
        #{ title: "Ship", detail: "PDF, git push, mail (unless create_only)" },
    ],
};

let resolve_schema = #{
    "type": "object",
    "required": ["topic", "folder", "slug", "two_doc", "create_only", "principles_path", "references_path", "skip_research", "skip_git", "skip_mail"],
    "properties": #{
        "topic": #{ "type": "string" },
        "folder": #{ "type": "string" },
        "slug": #{ "type": "string" },
        "two_doc": #{ "type": "boolean" },
        "create_only": #{ "type": "boolean" },
        "principles_path": #{ "type": "string" },
        "references_path": #{ "type": "string" },
        "skip_research": #{ "type": "boolean" },
        "skip_git": #{ "type": "boolean" },
        "skip_mail": #{ "type": "boolean" },
        "notes": #{ "type": "string" },
    },
};

let writer_schema = #{
    "type": "object",
    "required": ["ok", "principles_path", "references_path", "two_doc", "ste_self_check", "one_line"],
    "properties": #{
        "ok": #{ "type": "boolean" },
        "principles_path": #{ "type": "string" },
        "references_path": #{ "type": "string" },
        "two_doc": #{ "type": "boolean" },
        "ste_self_check": #{ "type": "string" },
        "one_line": #{ "type": "string" },
        "error": #{ "type": "string" },
    },
};

let frugal_schema = #{
    "type": "object",
    "required": ["path", "overall", "ok"],
    "properties": #{
        "path": #{ "type": "string" },
        "overall": #{ "type": "string" },
        "ok": #{ "type": "boolean" },
        "one_line_verdict": #{ "type": "string" },
        "error": #{ "type": "string" },
    },
};

let ship_schema = #{
    "type": "object",
    "required": ["ok", "git", "mail", "pdfs", "one_line"],
    "properties": #{
        "ok": #{ "type": "boolean" },
        "git": #{ "type": "string" },
        "mail": #{ "type": "string" },
        "pdfs": #{ "type": "array", "items": #{ "type": "string" }, "maxItems": 8 },
        "one_line": #{ "type": "string" },
        "error": #{ "type": "string" },
    },
};

fn bstr(b) {
    if b { "true" } else { "false" }
}

// ---- args -------------------------------------------------------------------
let topic = ();
let folder = ();
let slug = ();
let create_only = false;
let single_doc = false;
let skip_research = false;
let skip_git = false;
let skip_mail = false;

if args != () {
    if args.topic != () { topic = args.topic; }
    if args.path != () { folder = args.path; }
    if args.folder != () { folder = args.folder; }
    if args.slug != () { slug = args.slug; }
    if args.create_only == true { create_only = true; }
    if args.single_doc == true { single_doc = true; }
    if args.skip_research == true { skip_research = true; }
    if args.skip_git == true { skip_git = true; }
    if args.skip_mail == true { skip_mail = true; }
}

if topic == () {
    pause("verification", "Pass args.topic. Optional: path/folder, slug, create_only, single_doc, skip_research, skip_git, skip_mail. Example: /workflow notes-ship {\"topic\":\"Module 2 prompting\",\"path\":\"claude/prepcourses/foundations/module2\",\"slug\":\"prompting-task-execution\"}");
}

let topic_s = topic + "";
let folder_s = "";
if folder != () { folder_s = folder + ""; }
let slug_s = "";
if slug != () { slug_s = slug + ""; }

log("notes-ship topic=" + topic_s);

// ---- Phase Resolve ----------------------------------------------------------
phase("Resolve");

let resolve_prompt = "";
resolve_prompt += "You resolve paths for the Notes vault notes-ship pipeline.\n";
resolve_prompt += "Use tools (list_dir, read_file). Workspace is the Notes vault root.\n\n";
resolve_prompt += "Input topic: " + topic_s + "\n";
resolve_prompt += "Input folder hint: " + folder_s + "\n";
resolve_prompt += "Input slug hint: " + slug_s + "\n";
resolve_prompt += "create_only flag: " + bstr(create_only) + "\n";
resolve_prompt += "single_doc flag: " + bstr(single_doc) + "\n";
resolve_prompt += "skip_research flag: " + bstr(skip_research) + "\n";
resolve_prompt += "skip_git flag: " + bstr(skip_git) + "\n";
resolve_prompt += "skip_mail flag: " + bstr(skip_mail) + "\n\n";
resolve_prompt += "Rules:\n";
resolve_prompt += "1) folder = relative path under vault (e.g. AI, api, claude/prepcourses/foundations/module2). If empty, pick a sensible core folder from AGENTS.md.\n";
resolve_prompt += "2) slug = kebab-case basename without -principles/-references. If empty, derive from topic.\n";
resolve_prompt += "3) two_doc = true unless single_doc is true. Learning topics prefer two_doc.\n";
resolve_prompt += "4) principles_path = folder/slug-principles.md if two_doc else folder/slug.md\n";
resolve_prompt += "5) references_path = folder/slug-references.md if two_doc else empty string\n";
resolve_prompt += "6) Echo create_only, skip_research, skip_git, skip_mail from flags.\n";
resolve_prompt += "7) Create parent directories if missing (mkdir -p via shell is ok).\n";
resolve_prompt += "Return structured fields only.\n";

let res = agent(resolve_prompt, #{
    label: "resolve-paths",
    capability_mode: "execute",
    output_schema: resolve_schema,
});

if res == () || !res.success || res.output == () {
    pause("infra", "Resolve agent failed. Fix workspace and resume.");
}

let p_path = res.output.principles_path + "";
let r_path = res.output.references_path + "";
let two_doc = res.output.two_doc == true;
let co = res.output.create_only == true;
let skip_r = res.output.skip_research == true;
let skip_g = res.output.skip_git == true;
let skip_m = res.output.skip_mail == true;
let topic_final = res.output.topic + "";
let folder_final = res.output.folder + "";
let slug_final = res.output.slug + "";

log("paths principles=" + p_path + " references=" + r_path + " two_doc=" + bstr(two_doc));

// ---- Phase Research ---------------------------------------------------------
phase("Research");

if !skip_r {
    let research_prompt = "";
    research_prompt += "You gather study sources for Notes vault learning content.\n";
    research_prompt += "Topic: " + topic_final + "\n";
    research_prompt += "Write notes ONLY into a scratch buffer you will hand to the writer in chat output — do not write final principles yet.\n";
    research_prompt += "Fetch official docs + gold-mine first-principles sources. Use web_search/open_page when useful.\n";
    research_prompt += "Never invent plan caps or product limits.\n";
    research_prompt += "Output a markdown block titled RESEARCH PACK with tables:\n";
    research_prompt += "- Official docs: link | what it teaches | operator so-what\n";
    research_prompt += "- Gold-mine: link | why gold | extra tip\n";
    research_prompt += "If nothing found, mark gap rows.\n";
    research_prompt += "Keep frugal. This feeds Doc 2 (references) only.\n";
    let research = agent(research_prompt, #{
        label: "research",
        capability_mode: "all",
    });
    if research == () || !research.success {
        log("research agent failed or empty — writer must mark gaps");
    }
} else {
    log("skip_research=true");
}

// ---- Phase Writer -----------------------------------------------------------
phase("Writer");

let writer_prompt = "";
writer_prompt += "You are the Notes vault **writer** agent for notes-ship.\n";
writer_prompt += "Canonical contract: .agents/writer.yaml and rules/writer-mandatory.md\n";
writer_prompt += "Root map: AGENTS.md. Pipeline: rules/ship-pipeline-mandatory.md\n";
writer_prompt += "Two-doc: rules/two-doc-ship-mandatory.md\n\n";
writer_prompt += "MUST load skill simple-english: .agents/skills/simple-english/SKILL.md\n";
writer_prompt += "Mode pragmatic. Passes: 1 per file written. Skill is mandatory.\n\n";
writer_prompt += "Topic: " + topic_final + "\n";
writer_prompt += "Folder: " + folder_final + "\n";
writer_prompt += "Slug: " + slug_final + "\n";
writer_prompt += "Write principles to: " + p_path + "\n";
writer_prompt += "Write references to: " + r_path + " (empty means single-doc only)\n";
writer_prompt += "two_doc: " + bstr(two_doc) + "\n\n";
writer_prompt += "Use Templates/topic-principles.md and Templates/topic-references.md as shape when two_doc.\n";
writer_prompt += "Doc1: definition, why, mechanism, map, critical misses (3-7), gotchas (3-7), critical tips for bug bounty/audit/AI operator/architect (3-7), IF/THEN, do this.\n";
writer_prompt += "Almost zero external URLs in Doc1.\n";
writer_prompt += "Doc2: how to use, official table, gold-mine table, cross-stack, read order, gaps. All URLs here.\n";
writer_prompt += "If research pack appears above in this conversation or workspace, use it for Doc2.\n";
writer_prompt += "Do NOT invent domain facts — mark gap.\n";
writer_prompt += "Do NOT run frugal-eval 3x loop yourself.\n";
writer_prompt += "Do NOT run content_eval.\n";
writer_prompt += "After drafts exist, apply simple-english pragmatic once per file, then report.\n";
writer_prompt += "Return structured: ok, paths, two_doc, ste_self_check PASS|FAIL, one_line.\n";

let wr = agent(writer_prompt, #{
    label: "writer",
    agent_type: "writer",
    capability_mode: "all",
    output_schema: writer_schema,
});

if wr == () || !wr.success || wr.output == () {
    pause("infra", "Writer agent failed. Inspect logs and resume or re-run.");
}
if wr.output.ok != true {
    pause("verification", "Writer reported ok=false: " + (wr.output.error + ""));
}

let principles_written = wr.output.principles_path + "";
let references_written = wr.output.references_path + "";
if principles_written == "" { principles_written = p_path; }

log("writer done ste=" + (wr.output.ste_self_check + ""));

// ---- Phase FrugalEval -------------------------------------------------------
phase("FrugalEval");

let frugal_base = "";
frugal_base += "You are the Notes vault **frugal-eval** agent for notes-ship.\n";
frugal_base += "Canonical: .agents/frugal-eval.yaml · rules/frugal-eval-mandatory.md\n";
frugal_base += "MUST load simple-english hardcore 3 sequential passes.\n";
frugal_base += "Skill: .agents/skills/simple-english/SKILL.md\n";
frugal_base += "Checklist: .agents/skills/simple-english/references/checklist.md\n";
frugal_base += "Mode hardcore only (not pragmatic). Fail closed.\n";
frugal_base += "Read the file with tools. Never eval from memory.\n";
frugal_base += "Rewrite on FAIL max 2 per pass. Write cleaned file on SHIP.\n";
frugal_base += "Do NOT run content_eval. Create ends after your SHIP.\n";
frugal_base += "Return structured overall SHIP|REVISE|BLOCKED, ok=true only if SHIP.\n";

let frugal1_prompt = frugal_base + "Target path: " + principles_written + "\n";
let f1 = agent(frugal1_prompt, #{
    label: "frugal-principles",
    agent_type: "frugal-eval",
    capability_mode: "all",
    output_schema: frugal_schema,
});

if f1 == () || !f1.success || f1.output == () {
    pause("infra", "Frugal-eval on principles failed.");
}
if f1.output.ok != true {
    pause("verification", "Principles frugal-eval not SHIP: " + (f1.output.overall + "") + " — " + (f1.output.one_line_verdict + ""));
}

log("frugal principles=" + (f1.output.overall + ""));

if two_doc && references_written != "" {
    let frugal2_prompt = frugal_base + "Target path: " + references_written + "\n";
    let f2 = agent(frugal2_prompt, #{
        label: "frugal-references",
        agent_type: "frugal-eval",
        capability_mode: "all",
        output_schema: frugal_schema,
    });
    if f2 == () || !f2.success || f2.output == () {
        pause("infra", "Frugal-eval on references failed.");
    }
    if f2.output.ok != true {
        pause("verification", "References frugal-eval not SHIP: " + (f2.output.overall + ""));
    }
    log("frugal references=" + (f2.output.overall + ""));
}

// ---- Phase Ship -------------------------------------------------------------
phase("Ship");

if co {
    log("create_only — skipping PDF/git/mail");
    complete(#{
        summary: "create done (create_only)",
        topic: topic_final,
        principles_path: principles_written,
        references_path: references_written,
        two_doc: two_doc,
        create: "done",
        git: "skipped",
        mail: "skipped",
    });
}

let ship_prompt = "";
ship_prompt += "You finish full ship for Notes vault notes-ship.\n";
ship_prompt += "Workspace = Notes vault root. Use shell tools.\n\n";
ship_prompt += "Files:\n";
ship_prompt += "- principles: " + principles_written + "\n";
ship_prompt += "- references: " + references_written + "\n";
ship_prompt += "two_doc: " + bstr(two_doc) + "\n";
ship_prompt += "skip_git: " + bstr(skip_g) + "\n";
ship_prompt += "skip_mail: " + bstr(skip_m) + "\n\n";
ship_prompt += "Steps:\n";
ship_prompt += "1) For each .md path that exists, run: python3 scripts/md_to_pdf.py PATH.md -o PATH.pdf\n";
ship_prompt += "2) If skip_git is false: git add the md+pdf files, commit with a clear message, push origin HEAD. Never force-add logs/. Never commit secrets.\n";
ship_prompt += "3) If skip_mail is false: python3 scripts/send_notes_email.py --subject \"[Notes] " + topic_final + " — principles + references\" --body \"Doc1 principles/critical tips. Doc2 official + gold-mine refs.\" then attach each pdf and md that exists.\n";
ship_prompt += "4) On mail failure set mail=failed but still return git hash if push worked.\n";
ship_prompt += "Return ok, git (hash or skipped), mail (sent|failed|skipped), pdfs list, one_line.\n";

let sh = agent(ship_prompt, #{
    label: "ship",
    capability_mode: "all",
    output_schema: ship_schema,
});

if sh == () || !sh.success || sh.output == () {
    pause("infra", "Ship agent failed after create succeeded. Files are on disk — ship manually.");
}

complete(#{
    summary: sh.output.one_line + "",
    topic: topic_final,
    principles_path: principles_written,
    references_path: references_written,
    two_doc: two_doc,
    create: "done",
    git: sh.output.git + "",
    mail: sh.output.mail + "",
    pdfs: sh.output.pdfs,
    ok: sh.output.ok == true,
});
