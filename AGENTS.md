# Job Apply

The user's job-application workspace. Application workflow: `.pi/skills/job-apply/SKILL.md`.

## Data

- `job-applications/profile.md` is the single source of truth for all personal details (identity, work history, projects, standard answers, form defaults). Read it before writing any personal content; never invent data.
- `job-applications/answers.md` holds stock answers for common form/essay questions (some entries are agent notes, not verbatim form text).
- Profile.md lists a resume PDF path; verify it exists before referencing it.

## Browser (Chrome)

- Prefer web search/fetch tools for general research; use the browser for what needs a logged-in session (LinkedIn), a real browser context (forms), or the user's open pages.
- Chrome is launched from the desktop icon, which uses the `~/.config/google-chrome-mcp` profile. Never launch Chrome with the default profile; `~/.config/google-chrome` is just an old backup.
- The user never opens a page here without wanting me to act on it: if they refer to "my open page/tab", attach and look. If chrome-devtools shows no pages, check `curl -s http://127.0.0.1:9222/json/version` (retry once right after a session restart); if the port is down, ask the user to launch Chrome from the desktop icon.
