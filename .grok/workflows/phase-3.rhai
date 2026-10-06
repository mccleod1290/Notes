// phase-3 — three papers and a build brief. does not email. does not spar.
//
// /workflow phase-3 {"slug":"sharepoint_tenants"}
//
// the examiner skill sends the mail when he asks. this workflow only writes the files.

let meta = #{
    name: "phase-3",
    description: "Write the phase 3 MCQ, short, and long papers plus the build brief. Topics come from the phase 1 map and must be supported by the phase 2 page. Does not email and does not spar.",
    when_to_use: "When the phase 1 map and the phase 2 page exist and you want the exam files on disk. Mail is a separate step in the examiner skill.",
    phases: [
        #{ title: "Handoff", detail: "phase 1 map and target, plus the phase 2 page" },
        #{ title: "Papers", detail: "MCQ, short 180, long 500, key on disk" },
        #{ title: "Build", detail: "one weekend build brief from the map and the page" },
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

let paper_schema = #{
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
    pause("verification", "Pass args.slug of an existing phase 1 map and phase 2 page. Example: /workflow phase-3 {\"slug\":\"aws_oidc_flow\"}");
}

let slug_s = slug + "";
let page = "phase_2/output/" + slug_s + "/PAGE.md";
let map_path = "phase_1/output/" + slug_s + "/MAP.md";
let target_path = "phase_1/output/" + slug_s + "/TARGET.md";
let out = "phase_3/output/" + slug_s;

log("phase-3 slug=" + slug_s);

phase("Handoff");

let gate_prompt = "";
gate_prompt += "Read .grok/rules/study-os-handoff.md. You are the phase 3 handoff gate. Write nothing.\n";
gate_prompt += "The exam relies on phase 1 and phase 2. Use read_file on these three:\n";
gate_prompt += map_path + "\n";
gate_prompt += target_path + "\n";
gate_prompt += page + "\n";
gate_prompt += "If any read fails, or any file is empty, return status=blocked and name the missing path.\n";
gate_prompt += "If all three have content, return status=ok and summary=ready.\n";
gate_prompt += "Do not create the files. Do not write a question. Do not email.\n";

let gate = agent(gate_prompt, #{
    label: "phase_3_handoff",
    capability_mode: "read-only",
    output_schema: gate_schema,
});

let gate_status = "";
if gate != () && gate.success && gate.output != () && gate.output.status != () {
    gate_status = gate.output.status + "";
}
if gate_status != "ok" {
    complete(#{ status: "blocked", slug: slug_s, summary: "phase 1 map or phase 2 page missing" });
}

phase("Papers");

let paper_prompt = "";
paper_prompt += "Read .grok/rules/study-os-handoff.md, phase_3/skills/academic_paper/SKILL.md, and phase_3/RULES.md. Follow them.\n";
paper_prompt += "Map: " + map_path + "\n";
paper_prompt += "Page: " + page + "\n";
paper_prompt += "If the map or the page is missing, write nothing and return status=blocked.\n";
paper_prompt += "Every question is a domain on the map. A domain the map dropped is not a question. The page has to support it.\n";
paper_prompt += "Write " + out + "/MCQ.md, SHORT.md, LONG.md, and KEY.md.\n";
paper_prompt += "Render the three papers to pdf. Do not email. Do not put the key on the papers.\n";
paper_prompt += "Return status=ok only when the three papers and KEY.md are written. Otherwise status=blocked.\n";
paper_prompt += "Return status and summary.\n";

let papers = agent(paper_prompt, #{
    label: "academic_paper",
    agent_type: "academic_paper",
    capability_mode: "all",
    output_schema: paper_schema,
});

let paper_status = "";
if papers != () && papers.success && papers.output != () && papers.output.status != () {
    paper_status = papers.output.status + "";
}
if paper_status != "ok" {
    complete(#{ status: "blocked", slug: slug_s, summary: "papers did not lock to the map and the page" });
}

phase("Build");

let build_prompt = "";
build_prompt += "Read .grok/rules/study-os-handoff.md and phase_3/skills/practical_build/SKILL.md and follow them.\n";
build_prompt += "Map: " + map_path + "\n";
build_prompt += "Target: " + target_path + "\n";
build_prompt += "Page: " + page + "\n";
build_prompt += "If the map, the target, or the page is missing, write nothing and return status=blocked.\n";
build_prompt += "The brief is one work item from the map, aimed at the target.\n";
build_prompt += "Write the brief only: " + out + "/BUILD.md and BUILD.pdf.\n";
build_prompt += "Do not judge. Do not email. Do not build the thing.\n";
build_prompt += "Return status=ok only when BUILD.md and BUILD.pdf are written. Otherwise status=blocked.\n";
build_prompt += "Return status and summary.\n";

let built = agent(build_prompt, #{
    label: "practical_build",
    agent_type: "practical_build",
    capability_mode: "all",
    output_schema: paper_schema,
});

let summary = "";
let build_status = "";
if built != () && built.success && built.output != () {
    if built.output.summary != () { summary = built.output.summary + ""; }
    if built.output.status != () { build_status = built.output.status + ""; }
}
if build_status != "ok" {
    complete(#{ status: "blocked", slug: slug_s, summary: summary });
}

complete(#{
    status: "files",
    slug: slug_s,
    mcq: out + "/MCQ.pdf",
    short_paper: out + "/SHORT.pdf",
    long_paper: out + "/LONG.pdf",
    build: out + "/BUILD.pdf",
    key: out + "/KEY.md",
    summary: summary,
});
