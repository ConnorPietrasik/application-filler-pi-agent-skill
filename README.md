# job-apply

A [Pi](https://pi.dev) skill that fills out job application forms in your browser for you.
You open the application page, log in, and say "apply to this job" — the agent reads your
stored profile, snapshots the form, fills in the fields (including file uploads), shows you a
review of everything, and only submits when you explicitly approve.

Built for Pi, but the skill follows the [Agent Skills standard](https://agentskills.io), so it
can also be pointed at from Claude Code or Codex via their `skills` setting.

## How it works

1. You open the job application page in Chrome and log in yourself.
2. You tell the agent to apply (or run `/skill:job-apply`).
3. The agent reads `job-applications/profile.md` and `job-applications/answers.md`.
4. Using the `chrome-devtools` MCP server, it takes a snapshot of the page, maps each form
   field to your profile data, fills inputs, selects dropdowns, and uploads your resume.
5. It presents the full review: every field → value (long text like the cover letter shown in full, uploaded PDFs rendered as images), flagging anything guessed, plus a screenshot.
6. You approve edits, then it submits. That review is the single approval gate — nothing is submitted before you see exactly what will be sent. Every attempt is logged to `job-applications/log.md`.

### Safety rules (baked into the skill)

- **Never clicks submit without explicit user approval.**
- Never touches logins, passwords, CAPTCHAs, or 2FA.
- Never invents data — unknown fields trigger a question to you.
- Essays, cover letters, and everything else are filled in first and shown to you in full at the final review before anything is submitted.

## Requirements

- [Pi](https://pi.dev) coding agent
- Chrome, with the `chrome-devtools` MCP server (already configured in `.mcp.json` — it runs
  `npx chrome-devtools-mcp`, so just need Node.js)

## Setup

```bash
mv job-applications/profile.example.md job-applications/profile.md
mv job-applications/answers.example.md job-applications/answers.md
```

Then fill in:

- **`profile.md`** — the important one: contact info, resume PDF path, work history bullets,
  education, salary/visa/notice-period defaults, and a cover-letter template.
- **`answers.md`** — stock answers for the questions every ATS asks ("why this company",
  "why leaving", sponsorship, etc.).

## Usage

**If you use this (or anything that involves giving an LLM internet) outside of a VM, you are insane**

Open an application page in Chrome, make sure it's the active tab, then:

```
apply to this job
```

or force the skill:

```
/skill:job-apply
```

## Repo layout

```
.pi/skills/job-apply/
├── SKILL.md                     # the skill (workflow + rules)
├── scripts/cover-letter-pdf.sh  # HTML → PDF via headless Chrome
└── assets/cover-letter-template.html
job-applications/                # your data (real files gitignored, examples committed)
├── profile.example.md           # ← copy to profile.md and fill in
├── answers.example.md           # ← copy to answers.md and fill in
└── log.example.md
.mcp.json                        # chrome-devtools MCP server config
.gitignore                       # keeps personal data out of git
LICENSE                          # GPLv3
```

## License

GPLv3 — see [LICENSE](LICENSE).
