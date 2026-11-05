# Résumé — Aashish Singhal

LaTeX résumé with **one source of truth** and one PDF per targeted variant (every file in `variants/`). Every bullet is written once
in `core/` and tagged with which variants it appears in, so the versions can never drift apart.

## Build

```bash
make            # build every variant in variants/ into build/
make list       # markdown list of variants (used for the release notes)
make pages      # build and report page counts (warns if a variant exceeds two pages)
make open       # build and open the AI-platform variant
make clean      # remove build/
```

Requires `pdflatex` (TeX Live / MacTeX).

Output: one `build/Aashish-Singhal-<variant>.pdf` per file in `variants/`.

Filenames are what a recruiter sees — they are intentionally not `main.pdf`.

## Editing without a laptop

The repository is the editor. Nothing needs LaTeX installed.

**Press `.` on the GitHub repo page.** That opens github.dev — VS Code in the
browser, with the whole repo. Edit any file in `core/`, commit from the sidebar,
and GitHub Actions rebuilds every variant. Works on an iPad. The GitHub
mobile app handles a one-line fix from a phone.

Then grab the PDF from **Releases → Latest**, which is replaced on every push to
`main`.

CI enforces the two-page limit, so an edit made on a train that pushes a variant
onto a second page fails the build rather than quietly producing a two-page
résumé.

## Versions

| | |
|---|---|
| Latest from `main` | Releases → **Latest**, replaced on every push |
| A version that will not move | `make release VERSION=v1.2` |
| Any past build | Actions → the run → **resume-pdfs** artifact (90 days) |

Tag a release before sending the résumé somewhere that matters, so "the one I
sent in March" stays downloadable after the source has moved on.

## Variants

Every file in `variants/` is a variant. Adding `variants/<name>.tex` is enough: the Makefile discovers it,
CI builds it on every push, pull request and release, and the release notes list it (from the file's
`% VARIANT:` header comment).

| Variant | Target roles | Header title |
|---|---|---|
| `ai-platform` *(primary)* | AI infrastructure, LLM platform, AI engineering | Senior Software Engineer · AI Platform |
| `ai-agents` | LLM agents + evals, full-stack leaning (ElevenLabs Creative Agents JD) | Senior Software Engineer · AI Agents & Evaluation |
| `ai-safety` | LLM output validation / guardrails, backend leaning (ElevenLabs Safety JD) | Senior Software Engineer · LLM Validation & Backend |
| `backend-infra` | Distributed systems, backend, platform | Senior Software Engineer · Backend & Infrastructure |
| `platform-engineer` | Platform / AI tooling infrastructure (Supabase JD) | Senior Software Engineer · Platform & Backend |
| `java-backend` | Java backend developer | Senior Software Engineer · Backend (Java, Go) |
| `nodejs-backend` | Node.js backend developer | Backend Developer |
| `fullstack` | Product engineering, full-stack | Senior Full-Stack Engineer |
| `frontend` | Frontend, React/TypeScript, UI engineering | Senior Frontend Engineer |

Same facts in all variants — only emphasis, ordering, and the summary change. Never invent per variant.

## Layout

```
core/
  preamble.tex      document class, margins, macros, variant machinery
  body.tex          section order; \input by every variant
  heading.tex       name + contact links (reads \resumeTitle)
  summary.tex       reads \resumeSummary
  skills.tex        skill rows defined once; order set per variant via \skillsOrder
  exp-*.tex         one file per role; bullets defined as macros, ordered per variant
  projects.tex
  education.tex
variants/
  <name>.tex        sets \variant, \resumeTitle, \resumeSummary, \skillsOrder → \input core/body
  (one file per variant; see the table above)
archive/            previous single-file version, kept for reference
```

## How the variant mechanism works

A variant file sets four things, then pulls in the shared body:

```latex
\input{core/preamble}
\def\variant{ai}
\def\resumeTitle{Senior Software Engineer $\cdot$ AI Platform}
\def\resumeSummary{...}
\def\skillsOrder{\skillAI \skillLang \skillInfra \skillFrameworks}
\input{core/body}
```

Two macros do the selection:

```latex
\varItem{ai,backend}{bullet text}   % renders the bullet only for those variants
\varOnly{fullstack}{ ...any block... }
```

Role files define each bullet once as a named macro, then order them per variant:

```latex
\varOnly{ai}{\hmsAIEval \hmsPipelines \hmsJobs \hmsProduct}
\varOnly{backend}{\hmsJobs \hmsPipelines \hmsAIEval \hmsAnalytics}
```

To add a variant: add `variants/<name>.tex`, pick a `\variant` tag, add that tag to the
`\varOnly` lines you want it to include, and add the name to `VARIANTS` in the `Makefile`.

## Constraints worth keeping

- **Two pages max.** `make pages` enforces it.
- **ATS-safe.** Single column, standard section headers, real selectable text, no graphics,
  no header/footer content, `\pdfgentounicode=1`. Don't add a two-column skills sidebar.
- **Spell tools exactly as job posts do** — "Node.js", "Kubernetes", "Google Kubernetes Engine (GKE)".

## Related docs

- `CONTRIBUTIONS.md` — sanitized audit of work history, the evidence behind every bullet.
- `RESUME-STRATEGY.md` — positioning, variant strategy, layout research with sources.
