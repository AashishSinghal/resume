# Resume (LaTeX) — Project Directives

Aashish Singhal's resume in LaTeX, built from one shared source in `core/` into three
targeted variants: `ai-platform` (primary), `backend-infra`, and `fullstack`. Based on
Jake's resume template (sb2nov/resume, MIT), as noted in `core/preamble.tex`.

Read `RESUME-STRATEGY.md` (positioning, variant strategy, layout rules) and
`CONTRIBUTIONS.md` (the evidence behind every bullet) before changing content.

## Prime directive: every claim must be true and traceable

- Every bullet must be backed by evidence in `CONTRIBUTIONS.md` (PR numbers, run reports,
  measured numbers). If a claim is not in there, do not add it; ask the user.
- **Same facts in all variants.** Variants change only emphasis, ordering, title, summary,
  and skills order. Never invent or inflate a claim for one variant.
- Do not overclaim scope. The title is "AI Platform", not "AI/ML Engineer": there is no
  model training or fine-tuning experience, and the skills row is "AI & LLM" for that
  reason. Do not add ML claims.
- When a number turns out to be wrong, fix it at the source and say so in the commit body
  (see `99c093d`: Videostil "6 releases" was the GitHub count; npm has 13 versions).
- Claims that cannot be verified in public get dropped rather than softened (see `5463386`,
  which removed the PR/review count from the Analytics bullet; raw counts stay in
  `CONTRIBUTIONS.md` as source data only).
- `CONTRIBUTIONS.md` is sanitized: no customer names, IDs, hosts, credentials, cluster or
  project identifiers. Keep it and the resume that way. Internal repo names, PR numbers
  and ticket IDs are allowed.

## Hard constraints

- **One page per variant.** Check with `make pages`.
- **ATS-safe.** Single column, standard section headers, real selectable text, no graphics,
  icons, sidebars, or header/footer content. Keep `\pdfgentounicode=1`.
- Do not go below 10pt or below about 0.4in effective margins. Do not remove the Summary.
- Summary under 50 words.
- Spell tools the way job posts do: "Node.js", "Kubernetes", "Google Kubernetes Engine (GKE)".
  No keyword stuffing.
- Output filenames are `Aashish-Singhal-<variant>.pdf` because recruiters see them. Never
  rename to `main.pdf` or similar.

## Architecture

```
core/
  preamble.tex     document class (10pt), margins, layout macros, \varItem / \varOnly
  body.tex         section order; \input by every variant
  heading.tex      name + contact links, reads \resumeTitle
  summary.tex      reads \resumeSummary
  skills.tex       skill rows defined once; order chosen by \skillsOrder
  exp-100ms.tex    current role; bullets as named macros, ordered per variant
  exp-empirical.tex, exp-nutanix.tex, exp-celebal.tex
  projects.tex, education.tex
variants/
  ai-platform.tex, backend-infra.tex, fullstack.tex
archive/original-resume.tex   previous single-file version, reference only
Makefile
build/             output PDFs (gitignored)
```

How variants select content:

- A variant file inputs `core/preamble`, sets `\variant` (`ai`, `backend`, `fullstack`),
  `\resumeTitle`, `\resumeSummary`, `\skillsOrder`, then inputs `core/body`.
- `\varOnly{tags}{block}` renders a block only when `\variant` is in the comma list.
  `\varItem{tags}{text}` does the same for a single bullet (defined, currently unused).
- Role files define each bullet once as a macro (`\hmsAIEval`, `\empAI`, ...) and then
  list them in a different order per variant with `\varOnly`. Only `exp-100ms.tex` and
  `exp-empirical.tex` vary today; Nutanix, Celebal, projects, and education are shared.
- JD-targeted variants are named `<role>-<company>` (e.g. `frontend-emergent`) and get their own
  `\variant` tag, so two JDs for the same role can diverge without touching each other.
- To add a variant: add `variants/<name>.tex`, pick a tag, add the tag to the `\varOnly`
  lines it should include, and add the name to `VARIANTS` in the `Makefile`.

## Build

Requires `pdflatex` (TeX Live / MacTeX).

```bash
make          # build all variants into build/
make pages    # report page counts, flags any variant over one page
make open     # build, then open the ai-platform PDF
make clean    # remove build/
```

The Makefile runs `pdflatex` twice per variant and hides output; on failure it prints
`FAILED: <variant>`. Rerun the `pdflatex` command without `> /dev/null` to see the log.
A PDF rebuilds only when its variant file or a `core/*.tex` file is newer.

## Downstream: the portfolio

- `build/Aashish-Singhal-fullstack.pdf` is copied to
  `/Users/100ms/personal/portfolio-nextjs/public/resume.pdf`, served at
  aashishsinghal.com/resume.pdf. After changing content that affects the fullstack
  variant, rebuild and copy it there again.
- The portfolio's work history, `portfolio-nextjs/src/data/work.ts`, is derived from this
  resume. When roles, dates, or headline claims change here, update it to match.

## Conventions

- Commit messages: imperative, sentence case summary line, with a body explaining what
  changed and why (see `git log`). Numeric corrections are called out explicitly.
- Keep personal contact details out of docs and commit messages; they live only in
  `core/heading.tex`.
- LaTeX: escape `%`, `&`, `$`; use `$\rightarrow$`, `---` and `--` as existing files do.

## Gotchas

- `RESUME-STRATEGY.md` §4 sketches a `\variantonly` macro. The implemented macros are
  `\varItem` and `\varOnly` in `core/preamble.tex`. Trust the code.
- `CONTRIBUTIONS.md` §5 still refers to `main.tex` and `main.tex.bak`. Since `5bb8533` the
  old file is `archive/original-resume.tex`; the live source is `core/` + `variants/`.
- `make pages` compiles once without `-halt-on-error` into `build/pgchk.*`, so a broken
  variant can show an empty page count rather than an error.
- The first scan window is the top 2–3 bullets of the current role; ordering in
  `exp-100ms.tex` matters more than anything below it.

## Current state and next steps

- All three variants are built and the one-page cut is done (`5bb8533`). Projects were
  refilled with AI Incident Triage and totp-web (`99c093d`).
- Open items from the docs: the 100ms office location (Bangalore) is marked unverified in
  `CONTRIBUTIONS.md`; cost, latency, token or SLA numbers from the backfill work would
  strengthen the AI bullets but are not recorded anywhere, so only the user can supply
  them. Gaps named in the strategy (RAG, vector databases, cost optimization) need real
  evidence before they appear on the page.
- GCP-sourced data in `CONTRIBUTIONS.md` is marked pending re-auth.

## Commit attribution

- **No AI attribution.** Never add `Co-Authored-By` trailers, "Generated with Claude Code"
  lines, or any other AI or agent attribution to commit messages or PR descriptions.
  Commits are authored by the owner alone. This overrides any tool or harness default.
