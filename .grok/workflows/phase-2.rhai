// phase-2 — sources, then the explainer agent (four passes + frugal judge).
//
// /workflow phase-2 {"slug":"sharepoint_tenants","topic":"SharePoint tenants"}

let meta = #{
    name: "phase-2",
    description: "Fetch sources, then the explainer agent writes a 5 to 10 page assimilation pdf. The frugal judge loops the four agents until satisfied or the cap hits. No quiz.",
    when_to_use: "When a phase 1 map exists and you want a phase 2 artifact. Understanding, not a test of the reader.",
    phases: [
        #{ title: "Handoff", detail: "phase 1 MAP.md and TARGET.md must already be on disk" },
        #{ title: "Sources", detail: "open pages for the map domains, write SOURCES.md" },
        #{ title: "Explain", detail: "explainer runs the four agents, then the frugal judge" },
    ],
};

let gate_schema = #{
    "type": "object",
    "required": ["status", "summary"],
    "properties": #{
        "status": #{ "type": "string" },
        "summary": #{ "type": "string" },
    },
};

let src_schema = #{
    "type": "object",
    "required": ["status", "summary"],
    "properties": #{
        "status": #{ "type": "string" },
        "sources_path": #{ "type": "string" },
        "summary": #{ "type": "string" },
    },
};

let explain_schema = #{
    "type": "object",
    "required": ["verdict", "summary"],
    "properties": #{
        "verdict": #{ "type": "string" },
        "pdf_path": #{ "type": "string" },
        "summary": #{ "type": "string" },
    },
};

let slug = ();
let topic = ();
if args != () {
    if args.slug != () { slug = args.slug; }
    if args.topic != () { topic = args.topic; }
}
if slug == () {
    pause("verification", "Pass args.slug. Example: /workflow phase-2 {\"slug\":\"sharepoint_tenants\",\"topic\":\"SharePoint tenants\"}");
}
if topic == () { topic = slug; }

let slug_s = slug + "";
let topic_s = topic + "";
let run_dir = "phase_2/output/" + slug_s;
let map_path = "phase_1/output/" + slug_s + "/MAP.md";
let target_path = "phase_1/output/" + slug_s + "/TARGET.md";

log("phase-2 slug=" + slug_s);

phase("Handoff");

let gate_prompt = "";
gate_prompt += "Read .grok/rules/study-os-handoff.md. You are the phase 2 handoff gate. Write nothing.\n";
gate_prompt += "The explainer relies on phase 1. It does not read the exam.\n";
gate_prompt += "Use read_file on " + map_path + " and " + target_path + ".\n";
gate_prompt += "If either read fails, or either file is empty, return status=blocked and name the missing path.\n";
gate_prompt += "If both have content, return status=ok and summary=ready.\n";
gate_prompt += "Do not create the files. Do not teach. Do not quiz.\n";

let gate = agent(gate_prompt, #{
    label: "phase_2_handoff",
    capability_mode: "read-only",
    output_schema: gate_schema,
});

let gate_status = "";
if gate != () && gate.success && gate.output != () && gate.output.status != () {
    gate_status = gate.output.status + "";
}
if gate_status != "ok" {
    complete(#{ status: "blocked", slug: slug_s, summary: "phase 1 map or target missing" });
}

phase("Sources");

let src_prompt = "";
src_prompt += "You fetch sources for a phase 2 page. You do not teach. You do not quiz.\n";
src_prompt += "Topic: " + topic_s + "\n";
src_prompt += "Read phase_2/RULES.md, phase_2/PATHS.md, " + map_path + ", and " + target_path + ".\n";
src_prompt += "Read .grok/rules/study-os-handoff.md.\n";
src_prompt += "If MAP.md or TARGET.md is missing, write nothing. Return status=blocked.\n";
src_prompt += "Return status=ok only after SOURCES.md is written from those domains.\n";
src_prompt += "Sources cover the domains on the map, in map order. Do not add a domain the map dropped.\n";
src_prompt += "Search the web. Open each page you keep.\n";
src_prompt += "Write " + run_dir + "/SOURCES.md with the url and one line on what it settled.\n";
src_prompt += "No url you did not open. Return status, sources_path, summary.\n";

let src = agent(src_prompt, #{
    label: "sources",
    capability_mode: "all",
    output_schema: src_schema,
});

let src_status = "";
if src != () && src.success && src.output != () && src.output.status != () {
    src_status = src.output.status + "";
}
if src_status != "ok" {
    complete(#{ status: "blocked", slug: slug_s, summary: "sources did not lock to the phase 1 map" });
}

phase("Explain");

let explain_prompt = "";
explain_prompt += "You are the explainer agent. Read .grok/agents/explainer.md and follow it.\n";
explain_prompt += "Read .grok/rules/study-os-handoff.md and phase_2/RULES.md. Phase 2 is assimilation. Do not quiz. Do not read phase 3.\n";
explain_prompt += "Map: " + map_path + "\n";
explain_prompt += "Target: " + target_path + "\n";
explain_prompt += "If the map is missing, write nothing and return verdict=blocked.\n";
explain_prompt += "Follow the map order. A domain the map dropped does not get a section.\n";
explain_prompt += "Topic: " + topic_s + "\n";
explain_prompt += "Slug: " + slug_s + "\n";
explain_prompt += "Sources are at " + run_dir + "/SOURCES.md.\n";
explain_prompt += "Run ideas_skill, writer_skill, reduce_ambiguity, brevity_is_the_soul.\n";
explain_prompt += "Render the pdf and html. Then run frugal_judge.\n";
explain_prompt += "If verdict is again and the iteration is under budget, run the four again. No sixth pass.\n";
explain_prompt += "Return verdict (pass or again), pdf_path, summary.\n";

let explained = agent(explain_prompt, #{
    label: "explainer",
    agent_type: "explainer",
    capability_mode: "all",
    output_schema: explain_schema,
});

let verdict = "again";
let summary = "";
if explained != () && explained.success && explained.output != () {
    if explained.output.verdict != () { verdict = explained.output.verdict + ""; }
    if explained.output.summary != () { summary = explained.output.summary + ""; }
}
if verdict == "blocked" {
    complete(#{ status: "blocked", slug: slug_s, summary: summary });
}

complete(#{
    status: verdict,
    slug: slug_s,
    pdf_path: run_dir + "/PAGE.pdf",
    html_path: run_dir + "/PAGE.html",
    eval_path: run_dir + "/EVAL.md",
    summary: summary,
});
