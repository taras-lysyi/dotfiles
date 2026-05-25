---
description: Review current Go/Encore PR without loading Go/Encore skills globally
---
Review current branch PR changes. Do not edit files.

Review target:
- If no base is provided, auto-detect base using upstream branch, `origin/staging`, or `origin/main` via `git merge-base`.
- Treat `${@:1}` as extra reviewer focus notes for slash-template usage.

Skill/docs policy:
- For Encore guidance, fetch direct raw GitHub links only when relevant. Do not fetch whole repo. If link fails, continue review and mention failure in checks/resources used.
  - `https://raw.githubusercontent.com/encoredev/skills/main/encore/go-code-review/SKILL.md` always for Encore code review
  - `https://raw.githubusercontent.com/encoredev/skills/main/encore/go-api/SKILL.md` if API endpoints changed
  - `https://raw.githubusercontent.com/encoredev/skills/main/encore/go-auth/SKILL.md` if auth changed
  - `https://raw.githubusercontent.com/encoredev/skills/main/encore/go-database/SKILL.md` if DB queries/migrations changed
  - `https://raw.githubusercontent.com/encoredev/skills/main/encore/go-infrastructure/SKILL.md` if infra resources changed
  - `https://raw.githubusercontent.com/encoredev/skills/main/encore/go-service/SKILL.md` if service structure changed
  - `https://raw.githubusercontent.com/encoredev/skills/main/encore/go-testing/SKILL.md` if tests changed or tests needed
- For Go guidance
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-benchmark/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-cli/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-code-style/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-concurrency/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-context/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-continuous-integration/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-data-structures/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-database/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-dependency-injection/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-dependency-management/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-design-patterns/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-documentation/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-error-handling/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-grpc/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-lint/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-modernize/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-naming/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-observability/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-performance/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-popular-libraries/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-project-layout/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-safety/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-samber-do/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-samber-hot/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-samber-lo/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-samber-mo/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-samber-oops/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-samber-ro/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-samber-slog/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-security/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-stay-updated/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-stretchr-testify/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-structs-interfaces/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-testing/SKILL.md`
  - `https://raw.githubusercontent.com/samber/cc-skills-golang/main/skills/golang-troubleshooting/SKILL.md`


Output rules:
- Optimize for human decision-making, not exhaustive commentary.
- Start with verdict: `[BLOCK|CHANGES REQUESTED|COMMENT|LGTM]` + one-line reason.
- Use finding IDs (`F1`, `F2`) for easy PR discussion.
- Keep high signal: fewer high-confidence findings beats many speculative ones.
- Group nits/cleanup; do not let them compete visually with blockers.
- Separate proven findings from assumptions; put assumptions in `Needs human eyes`.

Severity rubric:
- blocking: likely prod break, data loss/corruption, security/privacy issue, irreversible migration issue, or build/test failure.
- major: likely bug, scalability, or reliability issue, but scoped/recoverable.
- minor: maintainability, observability, consistency, or missing edge-case test.
- nit: style/noise only; include sparingly or grouped.

Output format:
- Verdict: `<verdict>` — `<one-line reason>`
- Base reviewed: `<base>`
- Scope: files/lines changed, commits, main change
- Checks run: commands/resources used, plus skipped checks
- Risk map: 2-5 bullets for data/migrations, runtime, security/privacy, tests
- Must fix before merge: short checklist, or `None`
- Findings index: table with ID, severity, area, file:line, title
- Findings details, ordered by severity:
  - `### F1 — [blocking|major|minor|nit] <title>`
  - `path:line`
  - `Problem:` what is wrong
  - `Evidence:` exact code/behavior proving it
  - `Impact:` what breaks
  - `Fix:` concrete change
  - `Verify:` test/command/manual check
  - `Confidence:` high/medium/low
- What looked good: 2-4 concrete positives, no fluff
- Needs human eyes: decisions/checks requiring env/product context
- Author next actions: numbered checklist
- Not reviewed / skipped: transparent scope gaps
- If no actionable findings, say `LGTM` and include residual risks if any.
