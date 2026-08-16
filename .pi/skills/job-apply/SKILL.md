---
name: job-apply
description: Fill out a job application form in the user's open Chrome tab using their stored profile data. Use when the user opens a job application page and asks to apply to it, or says "apply to this job".
---

# Job Apply

Apply to the job on the currently open browser page using the user's stored profile.

## Data (read both before touching the page)

Data files live in `job-applications/` at the project root (relative to this skill directory: `../../job-applications/`).

- `profile.md` — identity, work history, education, links, resume path
- `answers.md` — stock answers for common questions

If `profile.md` or `answers.md` is missing, stop and tell the user to copy the matching `*.example.md` over it and fill it in before continuing.

## Workflow

1. Read both data files.
2. `chrome-devtools_list_pages`, then `chrome-devtools_select_page` the tab containing the application form. If multiple tabs look relevant, ask the user which one.
3. `chrome-devtools_take_snapshot` to see all form fields and element refs.
4. Map each field to profile/answer data.
5. Fill fields with `chrome-devtools_fill` / `chrome-devtools_fill_form`. File uploads (resume, portfolio) with `chrome-devtools_upload_file` — paths come from profile.md.
6. Repeat snapshot → fill. For multi-step forms, click Next/Continue as needed and re-snapshot each step.
7. Review (mandatory — this is the single approval gate):
   - `chrome-devtools_take_snapshot` + `chrome-devtools_take_screenshot` for a final check
   - Present a table of every field → the value entered
   - For long free-form fields (cover letter, essays): show the full text, never a summary or truncation
   - For an uploaded cover letter PDF: open the PDF in a temporary Chrome tab and `chrome-devtools_take_screenshot` each page (verify it yourself), include the image(s) in the review if the user's terminal renders them, and always give the user the PDF path so they can open it locally, then close the tab
   - Flag anything guessed, invented, or possibly mismatched
   - **Wait for explicit user approval. Never click the submit button without it.**
   - If the user requests changes (e.g. rewrite the letter): apply them, update the form/upload, re-present the changed part, and get approval again before submitting.
8. After the user confirms and submit succeeds, note the confirmation (ref number, confirmation URL) in the log.

## Cover letter PDF

If the form requires a cover letter file (or the user asks for one):

1. Write an HTML file to `job-applications/cover-letters/<company>-<role>.html` based on `assets/cover-letter-template.html` (relative to this skill directory), filling in name/contact from profile.md and the approved text.
2. From the skill directory, run `./scripts/cover-letter-pdf.sh job-applications/cover-letters/<company>-<role>.html job-applications/cover-letters/<company>-<role>.pdf`.
3. Upload the resulting PDF with `chrome-devtools_upload_file`.

## Log

Append every application attempt to `job-applications/log.md` as a table row (create it from `log.example.md` first if it doesn't exist):

`| date | company | role | URL | status (submitted / draft / abandoned / blocked) | notes |`

## Rules

- Never invent data. If a field has no matching profile data, ask the user.
- Never handle logins, passwords, CAPTCHAs, or 2FA. If the page shows a login screen or CAPTCHA, tell the user to handle it first.
- Dropdowns/selects: pick the closest option and flag it in the review table.
- Essay/behavioral questions: draft from the profile + the job description shown on the page, fill it in, and let the user review the full text at the final review. Only submit what they approve verbatim or edited.
- Cover letters: same flow — no separate pre-approval round. Draft a fresh one per job from the profile + job description, following the "Cover letter notes" in profile.md (do not use a canned template). Fill it in / generate the PDF (see "Cover letter PDF") and present it in full at the final review.
- If the form is custom or unusually complex, snapshot it first and confirm the field mapping with the user before filling.
- On any error or dead end, stop and report what's blocking rather than guessing.
