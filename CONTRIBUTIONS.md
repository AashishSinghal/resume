# Aashish Singhal — Contribution Audit (100ms / `100mslive`)
**Period covered:** 2026-03-12 → 2026-08-31 (~5.5 months)
**Sources:** GitHub API (`gh`), local git history, local runbooks/manifests, Claude Code session history (2,228 session summaries, 6,515 observations, 4,302 prompts)
**Status:** GitHub + local + chat history complete. GCP API pending re-auth (see Gaps).

---

## 1. Headline numbers

| Metric | Value |
|---|---|
| PRs opened (org-wide) | **197** |
| PRs merged | **148+** (119 compass, 29 ethos) |
| PRs reviewed for others | **209** |
| PRs commented on | **227** |
| Commits authored | **~870** (687 compass, 178 ethos) |
| Lines changed | **+113,000 / −45,500** |
| Files touched | **1,261** |
| Repos contributed to | compass, ethos, hercules, ai-devops |
| Production records processed (backfills) | **~150,000+** calls/evals |

Contribution split: ~80% compass (platform + dashboard), ~15% ethos (AI/LLM evaluation service), ~5% ops/infra tooling that never landed in a repo.

---

## 2. GitHub contributions

### 2.1 `compass` — QC platform, dashboard, analytics (119 merged PRs, +74k/−35k)

**A. QC review product (built from zero, Mar–Apr)**
- QC evaluations list UI with role-gated access (`qc-reviewer`) — #2118
- Evaluation counts API with server-side filtering + sorting — #2152
- Org-scoped QC detail page: transcript viewer, summary, scorecard — #2154 (+2,527)
- Scorecard normalization, score bands, section scroll-to, tooltips — #2280, #2286, #2296
- Evaluation agents endpoint + UI integration — #2405, #2406

**B. Human-in-the-loop review workflow (AD-1975 / AD-2176)**
- `needs_review` + `reviews` schema for accept/reject workflow — #2632 (+2,865/−1,070)
- Confirm/Dismiss UI for evaluation flag reviews — #2639
- QC feedback + reviews rail, multi-note popovers — #2833, #2834
- **Human answer re-evaluation** — score recompute from reviewer answers — #2952 (+3,654/−1,342)
- Needs Review tab, review alerts persistence, confirmation dialogs — #2635, #2697, #2943

**C. Analytics workspace (May–Jul, the largest single initiative)**
- Analytics workspace with org + agent tabs — #3131 (+13,094/−13,706)
- Agent analytics deep-link from eval summary — #3441 (+10,984/−3,286)
- Trend bucketing (smart + explicit buckets), timezone-stable date handling — #3315, #3442, #3488
- Call Volume time-series chart, compliance chart gap-bridging — #3883, #3614
- Org/program filtering, date-filter sync across screens, KPI no-change display — #2858, #3314, #3216
- Analytics RBAC: QC manager analytics permissions + migration — #3453, #3447
- Anchored analytics on `call_start_time` vs `created_at` — #3882 (and a disciplined revert, #3902)

**D. Exports & reporting**
- Evaluation PDF export — #3433 · Org analytics PDF export — #3435
- Section scores in QC export — #3003 · Program breakdown in Pass & Miss export — #3893
- Reviewed-findings CSV export

**E. Backend / core platform**
- `GetCallsByProgram` core RPC — #2699 (+3,632/−2,550)
- `user_id` exposed on core proto Call message — #2403
- Call start/end time + transfer flag carried onto evaluations — #3788 (+1,288/−909)
- Admin API to backfill scorecard `valid_metadata_keys` — #3799
- Inactive provisioning in `CoreUserService.CreateUser`

**F. AI tooling integration**
- **Langfuse dataset bridge + "Add to dataset" flow** — #3636 (+4,026/−390), with per-env routing and fail-loud behavior — #3713

**G. Performance & reliability**
- Fixed `_id`-sort timeout on evaluations list (default sort → `created_at`) — #3635
- Scoped `GetEvaluationAgents` to page date bounds to kill agent-API timeouts — #3879
- Dropped 100-row page size causing slow queries — #3892
- Grafana QC review-quality dashboard: NaN fixes, `increase()` for pod-restart resilience — #2782, #2785, #2793
- CI: pnpm 9.14.4 → 10.31.0 across workflows — #3134

### 2.2 `ethos` — AI/LLM call-QC evaluation service (29 merged PRs, +8.2k/−1.6k)

- **Replaced rule-based compliance/escalation detection with LLM transcript analysis** — #90
- Escalation triggers driven from workflow `data.input` (parameterized, per-program) — #389 (+1,157)
- Structured evidence snippets with transcript-timestamp spans — #145, #182, #218
- Iterative prompt + schema hardening for complete, in-bounds evidence — #160, #181, #253, #255 (+1,169)
- Activation metadata reasons + display-only `why_not_others` in eval prompt — #256, #290
- Score recompute from reviewer answers (ethos side of AD-2176) — #194
- Langfuse observability: parent-span evidence shape, LLM finding reasons in traces, input/output on re-eval spans — #175, #228, #275
- Batch processing via `GetCallsByProgram` — #161/#173
- Removed QC Google-Sheets integration (−698 lines) — #231
- Per-question call eval script + reviewed-findings CSV export tooling — #276, #308

### 2.3 Collaboration
- **209 PRs reviewed** and **227 PRs commented on** across the org — roughly 1.4 reviews per PR authored. This is a large, under-documented part of the contribution.

---

## 3. Off-GitHub contributions (infrastructure, jobs, clusters, ops)

This is work that produced no PR but ran in production. Evidence: local runbooks, K8s manifests, run reports, and session logs.

### 3.1 Customer transcript backfill — design → build → run (Jul 2026)
A one-off production pipeline to push a customer's historical call recordings through the full QC stack (stitch → transcribe → AI-evaluate → deliver over SFTP).

**Built:**
- **Job 1 (`job1_stitch.py`)** — normalizes/stitches multi-part call recordings on SFTP; concatenates transfer-call parts in call-start order, backs up originals, streams via ffmpeg (`-c copy`, no re-encode). Structured JSON logs shipped to VictoriaLogs.
- **Job 2 (`job2_ingest.py`)** — ingest + QC evaluation, with a concurrent **sweep job** for convergence, checkpoint resume, idempotent re-runs, and a targeted retry path (`--only-contacts`).
- ~34 supporting scripts: agent provisioning, call-direction and campaign/team resolution, eligibility scans, reconciliation, no-speech metadata generation, duplicate-eval verification, monthly reporting.

**Ran (production GKE cluster, us-east1):**

| Run | Scale | Outcome |
|---|---|---|
| Feb pass (~10h, single pass) | **49,165** rows processed | **42,258 delivered**; 98.1% of all with-audio calls evaluated + delivered |
| Jan pass | **57,384** conversations | **50,121** evaluations created and delivered; 50,710 SFTP uploads |
| Retry pass | 195 transient failures | 154 recovered in 5m38s (96%) |
| Error reconciliation | 749 error items | 747 delivered, 100% accounted for, zero unexplained loss |

**Engineering practice demonstrated:**
- Staged rollout everywhere: local SFTP emulator → QA → prod dry-run → 1-row → 10-sample → full.
- Disk snapshot taken before the destructive stitch step for independent rollback.
- Secrets via imperative K8s Secrets + **Workload Identity** — no tokens in version control, deliberately kept out of ArgoCD.
- Images built `--platform linux/amd64`, timestamp-tagged, pushed to GCP Artifact Registry.
- Wrote runbooks, an internal run report, and migration docs for handoff.

**Performance engineering (`PERFORMANCE.md`):**
- Benchmarked Job 1 against a containerized SFTP emulator across concurrency 1/2/4/8 → identified it as **I/O-bound, not CPU-bound**, with a throughput sweet spot at concurrency 4 and degradation at 8 (server connection contention).
- Derived a pod-sizing model from first principles: memory scales with *file count* not *file size* (~0.3 KB/file) → **512 MB–1 GB pod sufficient for a 100–500 GB month**.
- Modeled the real prod bottleneck as `wall_time ≈ 3 × transfer_bytes / SFTP_throughput`.

### 3.2 Eval call-data migration (Jul 2026)
Backfilled every existing QC evaluation with call-sourced fields so analytics could move from `created_at` to `call_start_time`.
- ClickHouse DDL: added `call_start_time` / `call_end_time` / `is_transfer_call` to two tables + recreated the materialized view (ReplacingMergeTree).
- In-cluster K8s Job: idempotent, resumable, `--qps`-throttled, `--dry-run`-first; campaign/team resolution per contact via the contact-center platform API; Workload Identity, no static tokens.
- **Sharded execution** — 6 parallel month-shard Jobs (`prod-shards.yaml`); at peak: full job 122k records, month-back 102k, May shard 85k, **zero errors across all jobs**.
- Authored a 4-phase PR breakdown plan with verified code anchors and a non-blocking migration strategy for ~400k evaluations.

### 3.3 Production incident triage & reliability
- Classified **50,950 Temporal workflows**: 41,176 healthy, 9,129 OpenAI 429s, 645 stuck awaiting assets — produced actionable retry lists and temporal-distribution analysis.
- Recurring prod log triage for 429s / 5xx across ethos and compass; `retry_429_workflows.py`.
- Investigated duration mismatches, agent-attribution gaps, asset re-download loops, SSO behavior.

### 3.4 LLM evaluation & prompt engineering experiments
- Ran **20-iteration consistency experiments** on prompt variants (e.g. `call-reason-2`) via Langfuse datasets, with per-item logging, to measure model output stability rather than eyeballing single runs.
- Validated `rx_order` prompt changes against production metadata-extraction results.
- Designed a program-specific keyword system for transcription + AI evaluation.

### 3.5 Other operational tooling
- Operational scripts: bulk case cancellation (50-way concurrency), transcript+metadata SFTP delivery.
- `qc_exports` / `qc_audits`: reviewed-findings exports, audit pulls.
- Local repos touched without commits (read/ops): `arcus`, `hermes`, `pqcagent`, `cred-manager`, `internal-automations`, `python-libs`.

---

## 4. Resume-ready bullets (anonymized — no customer/infra identifiers)

Pick 4–6. Each is backed by evidence above.

**Scale / data engineering**
- Designed and ran a production backfill pipeline (stitch → transcribe → LLM evaluation → SFTP delivery) that processed **106K+ historical call recordings** across two monthly runs, delivering **92K+ AI evaluations at 98% completion** with full reconciliation of every failed row.
- Built idempotent, resumable Kubernetes Jobs on GKE with checkpoint resume, concurrent sweep convergence, and targeted retry — recovered 96% of transient failures in under 6 minutes.
- Sharded a **400K-record** database migration into 6 parallel Kubernetes Jobs with QPS throttling and dry-run staging; processed 300K+ records with **zero errors**.

**Performance**
- Benchmarked a containerized ingestion job across concurrency levels to prove it I/O-bound, identified the throughput sweet spot, and derived a first-principles pod-sizing model that cut memory allocation to **512 MB for 500 GB workloads**.
- Eliminated production API timeouts on a high-traffic evaluations list by re-scoping aggregation queries to page date bounds and correcting index-hostile default sorts.

**AI / LLM**
- Replaced rule-based compliance and escalation detection with **LLM transcript analysis**, then hardened prompts and output schemas over 10+ iterations to guarantee in-bounds, timestamp-anchored evidence.
- Built a **Langfuse dataset bridge** letting reviewers push production calls into eval datasets in one click, and ran **20-iteration consistency experiments** to measure prompt stability before shipping changes.
- Instrumented the LLM evaluation service with Langfuse tracing (parent spans, finding reasons, re-eval input/output) for production observability.

**Product / full-stack**
- Shipped a QC review platform from zero: role-gated evaluation list, transcript viewer with search + timestamp navigation, scorecard UI, and a human-in-the-loop accept/reject workflow that recomputes scores from reviewer answers.
- Built an analytics workspace (org + agent views, trend bucketing, CSV/PDF export, RBAC) across **~24K lines** of frontend and backend changes.

---

## 5. Notes

1. **Sanitized** — this document carries no customer names, org/program/contact IDs, host addresses, credentials, secret names, GCP project or cluster identifiers, service-account emails, or registry paths. Internal repo names, PR numbers, and ticket IDs are kept so you can trace any claim back to its source. The source runbooks under `~/work/` are *not* sanitized — don't share those.
2. **Applied to `main.tex`** — 100ms added as *Senior Software Engineer, Mar 2026 – Present* with 5 bullets drawn from §4; Empirical corrected to *Apr 2025 – Jan 2026*; summary and skills refreshed. **Unverified: office location, set to Bangalore, India — correct it if wrong.** Backup of the original at `main.tex.bak`.
3. **Sharpen if you have it** — cost savings, SLA/turnaround improvement, or headcount-hours saved by the backfill automation. None of that is recorded in the sources; only you know it.

---

## Frontend stack detail (owner-supplied)
- **100ms:** extended the existing Redux Toolkit store, which held dashboard state, to carry RBAC (owner statement; PR numbers not yet mapped).
- **Empirical.run:** test-run dashboard and the agent split into monorepo packages (Vite, Turborepo); the dashboard was built from separate micro frontends; Zustand held most dashboard state and user preferences; most UI components were tested with Jest, run in CI.
- **Nutanix:** large, old, heavily customised dashboard built from micro frontends; Redux held a very large amount of application state and user auth details; Webpack used heavily with custom rules and plugins. UI library: migrated to it only (suggested component changes; the library team maintained it). Led hackathons and took part in technical designs.
- **Celebal:** mentored interns (React, Redux, TypeScript).
- **Empirical.run, also:** took part in technical discussions and designs.
- **Empirical.run (confirmed):** reworked the sessions list and sessions page (large data from many sources) into SSR and client components: faster rendering, far fewer reloads, very few crashes or unstable state changes. Improved accessibility so the product's own agent could navigate the dashboard. The dashboard talks to many parts of the distributed system; TOTP auth secures it. No metrics recorded.
