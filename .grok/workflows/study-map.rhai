// study-map — clerk, then map maker. the interviewer already wrote interview.md.
//
// /workflow study-map {"slug":"aws_oidc_flow"}
//
// does not teach. does not quiz. does not decide that a topic is known.

let meta = #{
    name: "study-map",
    description: "Format the interview into a context packet, then map domains, prerequisites, and acquired skills. Does not teach.",
    when_to_use: "After interview.md exists. The interviewer writes that file. This hook runs the clerk, then the map maker.",
    phases: [
        #{ title: "Context", detail: "study_clerk writes CONTEXT.md and adds nothing" },
        #{ title: "Map", detail: "map_maker writes MAP.md from the packet plus sourced research" },
    ],
};

let clerk_schema = #{
    "type": "object",
    "required": ["status", "summary"],
    "properties": #{
        "status": #{ "type": "string" },
        "context_path": #{ "type": "string" },
        "summary": #{ "type": "string" },
    },
};

let map_schema = #{
    "type": "object",
    "required": ["status", "summary"],
    "properties": #{
        "status": #{ "type": "string" },
        "map_path": #{ "type": "string" },
        "ungrounded_count": #{ "type": "number" },
        "summary": #{ "type": "string" },
    },
};

let slug = ();
if args != () {
    if args.slug != () { slug = args.slug; }
}
if slug == () {
    pause("verification", "Pass args.slug. Example: /workflow study-map {\"slug\":\"aws_oidc_flow\"}. interview.md must already exist at phase_1/output/<slug>/interview.md.");
}

let slug_s = slug + "";
let run_dir = "phase_1/output/" + slug_s;
let interview_path = run_dir + "/interview.md";
let context_path = run_dir + "/CONTEXT.md";
let map_path = run_dir + "/MAP.md";

log("study-map slug=" + slug_s);

// ---- Phase 1: context packet ------------------------------------------------
phase("Context");

let clerk_prompt = "";
clerk_prompt += "You are the study clerk. You do not interview, quiz, search, map, or teach.\n";
clerk_prompt += "Read phase_1/skills/study_clerk/SKILL.md and phase_1/PACKET.md with read_file before you write.\n";
clerk_prompt += "Interview file: " + interview_path + "\n";
clerk_prompt += "If that file is missing, write nothing. Return status=blocked and summary explaining the missing path.\n";
clerk_prompt += "If it exists, write " + context_path + " in the PACKET.md shape.\n";
clerk_prompt += "Add nothing that he did not say and nothing that is not in a file he named.\n";
clerk_prompt += "Put interviewer inferences under dropped. Keep a missing target path as the word missing. Exposure stays exposure. Do not promote it.\n";
clerk_prompt += "Return status (ok or blocked), context_path, and summary.\n";

let clerk = agent(clerk_prompt, #{
    label: "study_clerk",
    agent_type: "study_clerk",
    capability_mode: "read-write",
    output_schema: clerk_schema,
});

let clerk_status = "";
let clerk_summary = "";
if clerk != () && clerk.success && clerk.output != () {
    if clerk.output.status != () { clerk_status = clerk.output.status + ""; }
    if clerk.output.context_path != () { context_path = clerk.output.context_path + ""; }
    if clerk.output.summary != () { clerk_summary = clerk.output.summary + ""; }
    log("clerk status=" + clerk_status + " path=" + context_path);
} else {
    clerk_status = "failed";
    log("clerk failed");
}

if clerk_status == "blocked" || clerk_status == "failed" {
    complete(#{
        status: clerk_status,
        slug: slug_s,
        context_path: context_path,
        map_path: "",
        summary: clerk_summary,
    });
}

// ---- Phase 2: map -----------------------------------------------------------
phase("Map");

let map_prompt = "";
map_prompt += "You are the map maker. You do not quiz, teach, or start the explainer.\n";
map_prompt += "Read phase_1/skills/map_maker/SKILL.md, phase_1/PACKET.md, and " + run_dir + "/TARGET.md with read_file before you write.\n";
map_prompt += "Context packet: " + context_path + "\n";
map_prompt += "Write " + map_path + " in the PACKET.md shape.\n";
map_prompt += "acquired comes only from a skill he produced in known mode, or from a file he supplied. Exposure never counts. Mode zero stays empty unless a file shows the skill.\n";
map_prompt += "For a prerequisite or domain outside the packet, open a web page before you call it grounded.\n";
map_prompt += "A claim with no opened url goes under ungrounded, not under sources.\n";
map_prompt += "Set handoff to: explainer not run.\n";
map_prompt += "Return status, map_path, ungrounded_count, and summary.\n";

let mapped = agent(map_prompt, #{
    label: "map_maker",
    agent_type: "map_maker",
    capability_mode: "all",
    output_schema: map_schema,
});

let map_status = "";
let map_summary = "";
let ungrounded_n = 0;
if mapped != () && mapped.success && mapped.output != () {
    if mapped.output.status != () { map_status = mapped.output.status + ""; }
    if mapped.output.map_path != () { map_path = mapped.output.map_path + ""; }
    if mapped.output.summary != () { map_summary = mapped.output.summary + ""; }
    if mapped.output.ungrounded_count != () { ungrounded_n = mapped.output.ungrounded_count; }
    log("map status=" + map_status + " path=" + map_path);
} else {
    map_status = "failed";
    log("map maker failed");
}

complete(#{
    status: map_status,
    slug: slug_s,
    context_path: context_path,
    map_path: map_path,
    ungrounded_count: ungrounded_n,
    summary: map_summary,
});
