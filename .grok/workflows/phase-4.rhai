// phase-4 — logger, then diagnostician, then clerk.
//
// /workflow phase-4 {"slug":"aws_oidc_flow"}
//
// the logger writes nothing. the diagnostician writes the diagnosis.
// the clerk files the artifacts that are already on disk.

let meta = #{
    name: "phase-4",
    description: "Confirm the harness, diagnose from the earlier phases, then file the topic folder. Does not teach, quiz, or invent a missing page.",
    when_to_use: "When a phase 1 map exists and you want the shared root and the topic folder. The logger runs first.",
    phases: [
        #{ title: "Logger", detail: "read the harness and report which earlier files exist" },
        #{ title: "Diagnose", detail: "one shared root, one route" },
        #{ title: "File", detail: "harness_clerk symlinks the artifacts that exist" },
    ],
};

let gate_schema = #{
    "type": "object",
    "required": ["status", "summary"],
    "properties": #{
        "status": #{ "type": "string" },
        "summary": #{ "type": "string" },
        "session_dir": #{ "type": "string" },
        "page_present": #{ "type": "string" },
        "exam_present": #{ "type": "string" },
    },
};

let step_schema = #{
    "type": "object",
    "required": ["status", "summary"],
    "properties": #{
        "status": #{ "type": "string" },
        "summary": #{ "type": "string" },
    },
};

let slug = ();
if args != () {
    if args.slug != () { slug = args.slug; }
}
if slug == () {
    pause("verification", "Pass args.slug. Example: /workflow phase-4 {\"slug\":\"aws_oidc_flow\"}. phase_1/output/<slug>/MAP.md and logs/sessions/LATEST.md must exist.");
}

let slug_s = slug + "";
let map_path = "phase_1/output/" + slug_s + "/MAP.md";
let target_path = "phase_1/output/" + slug_s + "/TARGET.md";
let page = "phase_2/output/" + slug_s + "/PAGE.md";
let exam = "phase_3/output/" + slug_s;
let diagnosis = "study_os/topics/" + slug_s + "/phase_4/DIAGNOSIS.md";
let index_path = "study_os/topics/" + slug_s + "/INDEX.md";

log("phase-4 slug=" + slug_s);

phase("Logger");

let log_prompt = "";
log_prompt += "Read .grok/rules/study-os-handoff.md. You are the phase 4 logger. Write nothing.\n";
log_prompt += "Use read_file on logs/sessions/LATEST.md and on " + map_path + ".\n";
log_prompt += "If either read fails, or either file is empty, return status=blocked and name the missing path. Do not invent a session.\n";
log_prompt += "Also use read_file on " + target_path + ", " + page + ", " + exam + "/MARK.md, " + exam + "/VERDICT.md, and " + exam + "/SPAR.md.\n";
log_prompt += "A missing page or a missing exam file is not a reason to block. Set page_present to yes only if PAGE.md has content. Set exam_present to yes if any exam file has content. Name each path in summary as present or absent.\n";
log_prompt += "session_dir is the directory LATEST.md points at.\n";
log_prompt += "If the ledger and the map are both readable, return status=ok.\n";
log_prompt += "Do not create a phase file. Do not diagnose. Do not append to ACTIONS.md or DECISIONS.md.\n";

let ledger = agent(log_prompt, #{
    label: "study_logger",
    capability_mode: "read-only",
    output_schema: gate_schema,
});

let ledger_status = "";
let ledger_summary = "";
let session_dir = "";
let page_present = "no";
let exam_present = "no";
if ledger != () && ledger.success && ledger.output != () {
    if ledger.output.status != () { ledger_status = ledger.output.status + ""; }
    if ledger.output.summary != () { ledger_summary = ledger.output.summary + ""; }
    if ledger.output.session_dir != () { session_dir = ledger.output.session_dir + ""; }
    if ledger.output.page_present != () { page_present = ledger.output.page_present + ""; }
    if ledger.output.exam_present != () { exam_present = ledger.output.exam_present + ""; }
}
if ledger_status != "ok" {
    complete(#{ status: "blocked", slug: slug_s, summary: ledger_summary });
}

phase("Diagnose");

let diag_prompt = "";
diag_prompt += "You are the diagnostician. Read .grok/rules/study-os-handoff.md, phase_4/RULES.md, and phase_4/skills/diagnostician/SKILL.md. Follow them.\n";
diag_prompt += "Slug: " + slug_s + "\n";
diag_prompt += "Map: " + map_path + "\n";
diag_prompt += "Target: " + target_path + "\n";
diag_prompt += "Page: " + page + " present=" + page_present + "\n";
diag_prompt += "Exam dir: " + exam + " present=" + exam_present + "\n";
diag_prompt += "Harness session: " + session_dir + "\n";
diag_prompt += "Use read_file on the map, the target, the page, and the exam files. A failed read means that file is absent. Do not invent its contents. The logger report is the first pass, not a substitute for the read.\n";
diag_prompt += "If the page is absent, the route may be phase_2. If the exam is absent, do not send him to sit it again.\n";
diag_prompt += "Write " + diagnosis + " in the shape in phase_4/PATHS.md. One route.\n";
diag_prompt += "Do not file the rest of the topic folder. Do not rewrite PAGE.md. Do not write a quiz.\n";
diag_prompt += "Return status=ok only when DIAGNOSIS.md is written. Otherwise status=blocked.\n";

let diagnosed = agent(diag_prompt, #{
    label: "diagnostician",
    agent_type: "diagnostician",
    capability_mode: "read-write",
    output_schema: step_schema,
});

let diag_status = "";
let diag_summary = "";
if diagnosed != () && diagnosed.success && diagnosed.output != () {
    if diagnosed.output.status != () { diag_status = diagnosed.output.status + ""; }
    if diagnosed.output.summary != () { diag_summary = diagnosed.output.summary + ""; }
}
if diag_status != "ok" {
    complete(#{ status: "blocked", slug: slug_s, summary: diag_summary });
}

phase("File");

let file_prompt = "";
file_prompt += "You are the harness clerk. Read .grok/rules/study-os-handoff.md and phase_4/skills/harness_clerk/SKILL.md. Follow them.\n";
file_prompt += "Slug: " + slug_s + "\n";
file_prompt += "Diagnosis: " + diagnosis + "\n";
file_prompt += "Use read_file on the diagnosis. If it is missing, write nothing and return status=blocked.\n";
file_prompt += "Symlink the phase 1, phase 2, and phase 3 files that exist. A missing phase is none. Do not create those files.\n";
file_prompt += "Timestamps come from the harness session " + session_dir + ". If a line has no harness time, write no harness timestamp.\n";
file_prompt += "Write " + index_path + ".\n";
file_prompt += "Do not diagnose. Do not append to the hook log.\n";
file_prompt += "Return status=ok only when INDEX.md is written. Otherwise status=blocked.\n";

let filed = agent(file_prompt, #{
    label: "harness_clerk",
    agent_type: "harness_clerk",
    capability_mode: "all",
    output_schema: step_schema,
});

let file_status = "";
let file_summary = "";
if filed != () && filed.success && filed.output != () {
    if filed.output.status != () { file_status = filed.output.status + ""; }
    if filed.output.summary != () { file_summary = filed.output.summary + ""; }
}
if file_status != "ok" {
    complete(#{ status: "blocked", slug: slug_s, summary: file_summary });
}

complete(#{
    status: "ok",
    slug: slug_s,
    diagnosis: diagnosis,
    index_path: index_path,
    summary: file_summary,
});
