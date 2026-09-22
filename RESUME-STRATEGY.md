# Resume Strategy — Positioning, Variants, Layout
*Compiled 2026-09-22. Research sources listed at the end.*

---

## 0. The one thing that matters most

**Go back to one page.** Every serious 2026 source says the same thing: one page is the standard up to ~8–10 years of experience; two pages are for staff/principal ICs and EMs with multi-team scope. You're at 5.5 years. A two-page resume at your level reads as "couldn't prioritize," not "has more to say."

Recruiters spend **6–8 seconds** on the first scan, and **78% of large tech firms** now run an AI pre-filter before a human sees it. The first 2–3 bullets of your most recent role are doing almost all the work.

Everything in §3 is about buying back the space to make that happen.

---

## 1. Positioning: pick the AI-platform lane

Right now the resume reads as "full-stack engineer who also does AI." Your actual evidence says something much more valuable and much rarer.

### Why this lane

The market split in 2026 is stark: AI/ML engineering has a **63% talent shortage with 500K+ open roles**, while entry-level generalist SWE postings are **down 25% from their 2023 peak**. Generic full-stack is the crowded side of that split.

And specifically — **LLM evaluation is described as "the most underrated skill in 2026 hiring."** You have the thing most applicants are fabricating:

- You replaced rule-based detection with LLM transcript analysis and then *hardened the prompts and schemas over 10+ iterations* — that's eval discipline, not prompt tinkering.
- You ran **20-iteration consistency experiments** to measure prompt stability before shipping. Almost nobody does this. Almost everybody claims it.
- You built a **Langfuse dataset bridge** so reviewers feed production calls back into eval sets. That's a closed evaluation loop — an actual MLOps artifact.
- You built a **human-in-the-loop review workflow that recomputes scores from reviewer answers.** That is the RLHF-shaped feedback loop hiring managers are looking for.

Paired with the Empirical work (multi-model LLM infra across Claude/GPT/Gemini, Cloudflare Durable Objects agent worker, Whisper transcription), you have **two consecutive roles of production AI systems**. That's a narrative, not a skill list.

### What to change

| Where | Now | Change to |
|---|---|---|
| Header title | "Software Engineer" | **"Senior Software Engineer · AI Platform"** — *not* "AI/ML Engineer"; you have AI-engineering experience, not ML (no training/fine-tuning). Claiming ML invites a screen you'd fail. |
| Summary opener | "Software Engineer with 5+ years..." | Lead with AI systems + scale, name the eval work |
| Bullet order (100ms) | AI eval → pipelines → jobs → product → analytics | Keep AI eval first. It's your differentiator and it's in the 6-second window. |
| Skills block | Languages first | Lead with **AI/ML** category, then Languages |

### Gaps against what's hot right now

You genuinely have: LLM integration, evals, observability (Langfuse), Kubernetes, IaC-adjacent work, TypeScript, Python, Go, MLOps-shaped pipelines.

You're missing, and should close if you can: **RAG pipelines**, **vector databases**, **agentic frameworks** (you have agent *infrastructure* at Empirical — surface that wording), and above all **cost optimization**. One source puts it bluntly: *"engineers who can cut a $50k/month LLM bill to $20k without quality loss are worth a senior salary by themselves."* If you have any LLM cost or token-efficiency numbers from the backfills, that single bullet may be worth more than any other line on the page.

---

## 2. MNC-specific calibration

For Google/Microsoft/Amazon/Atlassian/Uber-class employers:

1. **Scale numbers in the first two bullets.** You have them — 106K recordings, 92K evaluations, 400K-record migration, 50,950 workflows triaged. Get at least two into the top two bullets of the 100ms role.
2. **Show architectural judgment, not just delivery.** 2026 resumes that convert "lead with system design and show architectural judgment on every bullet." Your pod-sizing derivation (memory scales with file *count*, not size → 512MB for a 500GB month) and your concurrency-sweet-spot finding are exactly this. One of them belongs on the page.
3. **Ownership language.** "Designed and operated," "owned end-to-end," "from zero" — you have the receipts, use the verbs.
4. **Exact keyword spellings.** ATS matching is literal: "Node.js" not "NodeJS," "Kubernetes" not "K8s," and spell out acronyms once — "Google Kubernetes Engine (GKE)."
5. **Don't repeat keywords to game it.** ML-based screeners now penalize stuffing and cross-reference your LinkedIn and title progression. Make sure LinkedIn says Senior Software Engineer at 100ms from Mar 2026.
6. **Amazon specifically**: rewrite your top bullets against the Leadership Principles (Ownership, Dive Deep, Deliver Results). Your reconciliation work — 749 error items, every one accounted for — is a textbook Dive Deep story.

---

## 3. Layout: how to buy back a full page

Your template (Jake's) is already ATS-safe — single column, standard headers, real text, no graphics. Don't switch templates. Don't add a two-column skills sidebar; those scramble in parsers. The savings come from content and spacing.

### Mechanical (no content loss) — approx. 12–15 lines

| Change | Saves | Risk |
|---|---|---|
| `11pt` → `10pt` document class | ~8–10 lines | None. Still above the 10pt floor. |
| Margins `-0.7in` → `-0.85in` side, textwidth `+1.7in` | ~3–4 lines | None at 10pt. |
| `\resumeItemListStart` → add `itemsep=-2pt, topsep=0pt` | ~4 lines | None. |
| Drop the italic company-description line (4 roles × 1 line) | 4 lines | Low — fold the descriptor into the company field: *100ms — AI call-quality platform*. |
| Education to a single line | 1 line | None. |

### Editorial (content decisions) — approx. 20+ lines

| Change | Saves | My take |
|---|---|---|
| **Cut the "AI Detect" project** | 4 lines | Do it. Feb 2024, a TensorFlow.js camera demo. It's actively *diluting* — it's the weakest thing on a page that otherwise says "production AI at scale." |
| **Summary 75 → under 50 words** | 2–3 lines | Do it. The rule is under 50 words, and yours currently buries the lede. |
| **Empirical: 5 bullets → 3** | 4 lines | Do it. It's no longer your current role. Merge "Infrastructure & Observability" into "Distributed Systems" — they overlap heavily already. |
| **Nutanix: 4 bullets → 2** | 4 lines | Do it. It ended 8 months ago and it's pre-AI work. Keep the 40% deployment-failure bullet and the feature-flag portal. |
| **Celebal intern: 1 bullet → title line only** | 2 lines | Optional. At 5.5 years a 2021 internship barely earns its space. |
| **Skills: 5 rows → 4** | 1–2 lines | Do it. Guidance is 8–12 *strongest* skills, not everything. Drop Java, Spring, TensorFlow.js, Express.js, TOTP, FFmpeg unless the JD names them. |

That's roughly 35 lines against a ~40-line overflow. One page is comfortably reachable without losing a single strong claim.

### What NOT to do
- No two-column layouts, no sidebars, no icons, no graphics, no header/footer content — all parse badly.
- Don't go below 10pt or below 0.4in effective margins; it reads as desperate and some ATS OCR paths choke.
- Don't delete the Summary entirely. It's one of the highest-weighted ATS zones.

---

## 4. Variants: build 3, not 10

The handbook advice is to tailor **per role type, not per posting** — collect 3–5 similar JDs, pull the common vocabulary, build one variant for that cluster. Three variants covers your realistic market:

| Variant | Target | Header title | Lead bullets | Skills order |
|---|---|---|---|---|
| **`ai-platform`** *(primary)* | AI infra, LLM platform, ML engineering | Senior SWE · AI Platform | LLM evals → pipelines → agent infra | AI/ML → Languages → Infra |
| **`backend-infra`** | Distributed systems, platform, SRE-adjacent | Senior SWE · Backend & Infrastructure | K8s jobs/migrations → Go services/gRPC → scale + reliability | Languages → Infra → AI/ML |
| **`fullstack`** | Product engineering, startups | Senior Full-Stack Engineer | QC platform from zero → analytics workspace → React/TS depth | Languages → Frameworks → AI/ML |

Same facts in all three — only emphasis, ordering, and the summary change. Never invent per variant.

### Proposed file architecture

```
resume/
├── core/
│   ├── preamble.tex        # document class, packages, macros  (variant sets \fontsize)
│   ├── heading.tex         # name, contacts — takes \resumeTitle
│   ├── exp-100ms.tex       # ALL bullets, each wrapped in \variantonly{...}
│   ├── exp-empirical.tex
│   ├── exp-nutanix.tex
│   ├── projects.tex
│   └── education.tex
├── variants/
│   ├── ai-platform.tex     # \def\variant{ai} + summary + skills order, then \input core
│   ├── backend-infra.tex
│   └── fullstack.tex
└── Makefile                # `make all` → build/aashish-singhal-{variant}.pdf
```

The mechanism is a single conditional macro — bullets tagged with which variants they appear in, so there's **one source of truth** and no drift between copies:

```latex
\newcommand{\variantonly}[2]{\ifnum\pdfstrcmp{\variant}{#1}=0 #2\fi}
```

Output filenames matter more than people think: **`Aashish-Singhal-Senior-SWE.pdf`**, never `main.pdf` or `resume_final_v3.pdf` — the filename is visible to the recruiter.

**Status: built.** See `README.md` for the mechanism. `make` produces all three; `make pages` enforces the one-page rule.

---

## 5. Suggested order of work

1. Cut to one page (§3) — biggest single win, needs no new information from you.
2. Reposition the header/summary/bullet order toward AI platform (§1).
3. Split into the variant system (§4).
4. Backfill any cost/latency/token numbers you can dig up (§1, last paragraph).

---

## Sources

- [Practical guide to writing FAANG-ready software engineer resumes — Tech Interview Handbook](https://www.techinterviewhandbook.org/resume/)
- [Software Engineer Resume Examples 2026: Junior, Senior & FAANG Samples — Resume Optimizer Pro](https://resumeoptimizerpro.com/blog/software-engineer-resume-2026)
- [ATS Resume Best Practices 2026: 20 Tips + What Now Backfires — Resume Optimizer Pro](https://resumeoptimizerpro.com/blog/ats-friendly-resume-tips)
- [Best FAANG Resume Template for Software Engineers in 2026 — Interview Kickstart](https://interviewkickstart.com/blogs/articles/faang-resume-template-for-software-engineers)
- [FAANG Resume Guide (2026): Google, Meta & Amazon Examples — SWE Resume](https://www.sweresume.app/articles/faang-resume-guide/)
- [Software Engineering Job Market 2026: Data, Trends and Outlook — Final Round AI](https://www.finalroundai.com/blog/software-engineering-job-market-2026)
- [15 AI Engineer Skills Every Hire Should Have in 2026 — AyAutomate](https://www.ayautomate.com/blog/ai-engineer-skills-2026)
- [The 5 Most In-Demand Software Engineering Roles Right Now — Primis](https://primis-talent.com/blog/2026/06/the-5-most-in-demand-software-engineering-roles-right-now)
- [ATS-Friendly Resume Format for IT Engineers in 2026 — SoundCV](https://www.soundcv.com/blog/ats-friendly-resume-format-for-it-engineers-2026)
