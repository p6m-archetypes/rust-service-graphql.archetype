let context = #{};

// Use the same switches, defaults, etc passed to this archetype, and pass them to calls to
// render other archetypes
let render_settings = archetect::archetype::settings();

context += render(Archetype("org-prompts"), ANSWERS, render_settings);

// Override to ensure these are always domain gateways
context += set("project-suffix", "Domain Gateway", #{
    cases: CasedIdentityCasedValue(PROGRAMMING_CASES),
});

// Turn off persistence
context += set("persistence", "None");

if switch_enabled("debug-context") {
    log(Info, `${archetect::archetype::description()} (${context["project-name"]}) Context:`);
    display(as_yaml(context));
}

// Let the upstream Archetype ask the rest of the questions
context += render(Archetype("upstream"), ANSWERS + context, render_settings);

// Render additional p6m-specific configuration
render(Directory("contents"), context, #{
    if_exists: Overwrite,
});
