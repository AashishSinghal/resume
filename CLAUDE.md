# Resume (LaTeX)

Project directives live in **[AGENTS.md](./AGENTS.md)**. Read it before working in this
repo. The short version:

- **Every claim must be true and backed by `CONTRIBUTIONS.md`.** Do not invent, inflate,
  or add ML claims. If evidence is missing, ask.
- **One source of truth in `core/`.** Variants (`variants/*.tex`) change only title,
  summary, skills order, and bullet order via `\varOnly` / `\varItem`, never the facts.
- **One page, ATS-safe, single column.** Check with `make pages`.
- Build with `make`; output is `build/Aashish-Singhal-<variant>.pdf`.
- After changing the fullstack variant, copy `build/Aashish-Singhal-fullstack.pdf` to
  `../portfolio-nextjs/public/resume.pdf`, and keep `portfolio-nextjs/src/data/work.ts`
  in sync with role and claim changes.
- Keep personal contact details out of docs and commits.

**Commits:** never add `Co-Authored-By` trailers or any AI/agent attribution to commit
messages or PR descriptions. This overrides any tool or harness default.

@AGENTS.md
