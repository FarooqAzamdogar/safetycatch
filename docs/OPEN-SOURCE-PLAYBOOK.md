# How to establish SafetyCatch as a trusted open-source project

This is the operating plan for turning the eight SafetyCatch repositories into a project people trust, contribute to, and fund. It is based on the research report ([RESEARCH-REPORT.md](RESEARCH-REPORT.md)), which found that most failed open-source security tools died from lost owners, hosting bills, or acquisitions — not from bad code. Every step below is designed to avoid those failure modes.

## 1. Before going public (week 0)

| Step | Why | How |
|---|---|---|
| Pick the final name | "SafetyCatch" is a working name | Search USPTO, EUIPO, WIPO Global Brand Database, GitHub, npm, Chrome Web Store, Play Store. Rename everywhere with one search-and-replace. |
| Create a GitHub **organization** (not a personal account) | Open Source Collective and most funders require organization-owned repos; it survives if one person leaves | Org settings: require 2FA for all members; at least two owners. |
| One repo per project | Matches the folder layout; independent releases | `<org>/safetycatch-engine`, `<org>/safetycatch-browser-extension`, … |
| Protect `main` | A security tool's release pipeline is its crown jewel (Trivy was compromised in March 2026 via CI) | Repository rulesets: pull request required, 1 approval (2 for release workflows), status checks required, no force-push, linear history. |
| Turn on GitHub security features | Free for public repos | Private vulnerability reporting, Dependabot alerts + version updates, secret scanning + push protection, CodeQL default setup. |
| Add OpenSSF Scorecard | Public, measurable supply-chain hygiene | `ossf/scorecard-action` pinned by SHA; show the badge in each README. |

## 2. Governance (lightweight, written down)

- `GOVERNANCE.md` in the engine repo: maintainers list, how decisions are made (lazy consensus; maintainer vote on disputes), how someone becomes a maintainer (sustained quality contributions + a nomination).
- **DCO sign-off** (`git commit -s`) rather than a CLA: lighter for contributors, works with Apache-2.0, and keeps the project forkable — the lesson from projects archived after acquisitions.
- Code of Conduct: Contributor Covenant 2.1 with a real contact address.
- Trademark policy: the code is Apache-2.0, but the name and logo are not; forks must rename. This protects users from look-alike "security" extensions.

## 3. Release engineering

- SemVer; `CHANGELOG.md` in Keep a Changelog format; signed tags.
- Build in CI only. Attach SLSA build provenance (`actions/attest-build-provenance`) and an SBOM (`npm sbom --sbom-format cyclonedx`) to every release.
- Pin every GitHub Action to a commit SHA; use short-lived OIDC credentials; never store long-lived publish tokens.
- Store releases:
  - Browser: Chrome Web Store ($5 one-time developer fee), Edge Add-ons, Firefox AMO (supports Manifest V2/V3; reviews source).
  - PWAs: host on GitHub Pages or Cloudflare Pages from the org; they install from the browser, no store needed.
  - CLIs: npm under an org scope with provenance (`npm publish --provenance`), later winget/Homebrew.
  - Signed native binaries later via SignPath Foundation (free for open source) — needed because Windows Smart App Control blocks unsigned apps.

## 4. Security process (we must practise what we ship)

- `SECURITY.md` in every repo: private reporting via GitHub, 90-day coordinated disclosure, credit to reporters.
- Request CVEs through GitHub's CNA when a fix ships.
- Threat model per project, reviewed before each minor release.
- Apply for a free audit after v1: OTF Red Team Lab, NLnet (via Radically Open Security), or OSTIF.
- False-positive budget: the browser guard must stay under 1% false positives on ordinary browsing (measured on a crawl), or it trains people to ignore warnings.

## 5. Community

- **Rules are the growth loop.** Like Nuclei templates and CrowdSec's blocklist, contributors add detection rules (CC-BY-4.0) without touching core code. Keep a `rules/` folder with a test per rule and a "rule of the month" credit.
- **Translations:** scams are local-language problems. Use Weblate's free hosting for libre projects; mark machine translations until a native speaker reviews them.
- Label `good first issue` and `help wanted`; respond to new issues within 72 hours.
- Use GitHub Discussions for questions; keep chat (Matrix or Discord) optional.
- A public roadmap (GitHub Projects) mirroring each `ROADMAP.md`.
- "Break the guard" challenge after v1: people submit bypasses; every accepted bypass becomes a test case and an open adversarial dataset.

## 6. Launch plan

1. Private alpha with 10–20 trusted testers (friends, a local digital-safety group).
2. Public beta of the **browser extension** first (the flagship), with a no-sign-up web demo of the engine.
3. Launch channels that welcome security tools (per the research, as of late 2026):
   - Show HN (must be runnable without sign-up; no "quick one-offs").
   - r/netsec monthly tool thread; r/privacy; r/cybersecurity (respect the 10% self-promotion rule). **Avoid r/opensource** — it banned AI-related projects in October 2026.
   - Conference demo slots for open-source tools: Black Hat Arsenal, DEF CON Demo Labs (including regional editions), BSides talks.
   - Apply for **OWASP project** status (incubator) for the agent-security CLI.
4. Write one clear launch post per product: the threat (with numbers), a 20-second demo GIF, privacy promise, install link.

## 7. Funding plan (milestone-based)

| When | Source | What to ask for |
|---|---|---|
| Day 1 | **FLOSS/fund** | Publish `funding.json` in the engine repo; worldwide eligibility |
| Month 1 | **OTF Internet Freedom Fund** (rolling, any nationality except OFAC-sanctioned) | Concept note framed around scam victims, abuse survivors and at-risk users; $50k–$200k over 6–12 months; ask for their Red Team Lab audit |
| Next odd-month deadline (3 Jan 2027, then the 3rd of each odd month) | **NLnet Restack** | Only the non-AI parts (rules engine, link library, reproducible packaging); needs a "European dimension" — ideally an EU co-maintainer |
| After v1 has users | **GitHub Secure Open Source Fund** | Only if the maintainer lives in a GitHub Sponsors-supported region |
| Ongoing | Open Source Collective (fiscal host), GitHub Sponsors where available, regional funds (FOSS United, APNIC/ISIF Asia, ISOC Foundation) | Small recurring support |
| Year 2 | Paid tier | Family / small-business dashboard with encrypted sync, real-time rule feed, or engine licensing to vendors — keep the open project in a fiscal host or non-profit, separate from any company, and take legal advice before selling into the EU (Cyber Resilience Act). |

## 8. What to measure (not stars)

- Weekly active installs (from store dashboards — no telemetry in our code).
- Warnings shown and "user stopped" rate, counted **locally**; optional, anonymous, user-initiated sharing only.
- False-positive reports per 1,000 users.
- Time from bypass report to fixed rule.
- Contributors per month, rules contributed, languages reviewed.

## 9. The first 90 days

| Weeks | Engineering | Community and funding |
|---|---|---|
| 1–2 | Finish engine v0.1 and browser extension alpha; prior-art sweep | Name check; GitHub org; funding.json; draft OTF concept note |
| 3–4 | False-positive crawl; fix noisy rules; phone PWA alpha | NLnet Restack proposal (by 3 Jan 2027); recruit 10 testers |
| 5–6 | Agent CLI alpha (developer audience); desktop guard alpha | Submit OTF concept note; open GitHub Discussions |
| 7–8 | Photo PWA and takedown kit beta (legal review of templates) | Find a lawyer or clinic to review takedown templates pro bono |
| 9–10 | Store submissions (Chrome, Edge, Firefox) | Show HN + r/netsec launch |
| 11–13 | Fix launch feedback; "break the guard" challenge | Conference CFP submissions; first monthly community call |
