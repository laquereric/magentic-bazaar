# User Persona: The Ideal OpenCode User

**Name:** Alex Miller

**Role:** Senior Software Engineer at a mid-sized tech startup.

**Background:** Alex has been a professional developer for about 8 years, primarily working on backend services using Python and Go. They are highly proficient in the command line, live in their code editor (VS Code with Vim keybindings), and are deeply familiar with Git and GitHub workflows. Alex is pragmatic, values efficiency, and is always looking for tools that can speed up their work without getting in the way.

**A Day in the Life:**
Alex's day is a mix of coding new features, fixing bugs, and reviewing pull requests from junior developers. A typical morning starts by looking at the team's GitHub issue tracker. They might be assigned a bug report like, "API endpoint `/v2/users/{id}/profile` is throwing a 500 error when the profile is empty."

**Pain Points & Goals:**
*   **Context Switching:** Jumping between reading the bug report, finding the relevant code, running tests, and writing the fix is time-consuming.
*   **Repetitive Work:** Alex spends a lot of time writing boilerplate code, documentation, and unit tests. It's necessary but not creatively fulfilling.
*   **Codebase Archeology:** When tackling a bug in an unfamiliar part of the codebase, it can take an hour just to understand the logic and data flow.
*   **Privacy Concerns:** Alex is forbidden by company policy from pasting proprietary code into public AI chat interfaces for security reasons.
*   **Goal:** Alex wants to spend more time on complex architectural problems and less time on routine coding and bug-fixing. They want an assistant that works *with* them in their existing environment.

**Why OpenCode is the Perfect Tool for Alex:**
OpenCode is designed for someone exactly like Alex. It integrates seamlessly into their workflow:

1.  **Triage the Bug:** From their terminal, Alex can run `opencode --issue <github_issue_url>`. OpenCode's `Plan` agent will read the issue, analyze the referenced code, and propose a step-by-step plan to fix it.
2.  **Human-in-the-Loop:** Alex reviews the plan directly in their terminal. It looks good, so they approve it.
3.  **Generate the Fix:** The `Build` agent then writes the necessary code changes, including a new unit test to cover the edge case.
4.  **Review and Save:** The changes are presented as a diff. Alex, the expert, gives the final approval. They might even make a small tweak directly before applying the changes. The agent never commits code without their explicit consent.
5.  **Create the PR:** Alex can then instruct OpenCode to create a pull request with a summary of the changes, linking back to the original issue.

For Alex, OpenCode isn't a magic box; it's a powerful, privacy-respecting "pair programmer" that handles the tedious parts of their job, allowing them to focus on what matters most.
