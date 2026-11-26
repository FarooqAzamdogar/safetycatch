# ActionGuard

**Open-source, on-device protection for the moments scams and data theft depend on.**

AI has made phishing, deepfake fraud and data theft cheaper and more convincing, but almost every attack still needs you (or your AI agent) to *do* something: paste a command, type a login code, scan a QR code, approve an app, share a photo, run a plugin. ActionGuard checks those actions privately on your own device and explains the risk in plain language.

> "ActionGuard" is a working name — it will be confirmed after a trademark search (see `docs/OPEN-SOURCE-PLAYBOOK.md`).

## The tools

| Project | What it protects | Form | Status |
|---|---|---|---|
| [actionguard-engine](actionguard-engine/) | Shared detection rules for links, commands, logins, QR codes, secrets, downloads and scam messages | TypeScript library + CLI | v0.1 built: 1,021 tests pass; about 270 rules; 7 extra languages (machine-translated, need native review) (26 Nov 2026) |
| [actionguard-browser](actionguard-browser/) — **flagship** | Fake "paste this command" pages (ClickFix), device-code and OAuth phishing, look-alike login pages, AI-chat data leaks, risky downloads | Browser extension (Chrome, Edge, Firefox) | in progress |
| [actionguard-mobile](actionguard-mobile/) | Links and messages shared from any app, safe QR scanning (link-device, wallet, payment and login-code QR traps) | Installable web app (Android and iPhone) | v0.1 built: 252 tests pass; 69/69 real-browser smoke checks pass (26 Nov 2026). Not yet tested on a real phone |
| [actionguard-desktop](actionguard-desktop/) | Dangerous commands on the clipboard; browsers relaunched to steal cookies | Background guard (Windows first) | in progress |
| [actionguard-agent](actionguard-agent/) | AI coding agents and MCP tools: config tampering, rug pulls, hidden instructions, misuse by malicious packages | Node CLI + Claude Code hook | v0.1 built: 736 tests pass; hook verified live on sample actions (26 Nov 2026). Not yet tested against live agents |
| [actionguard-photo](actionguard-photo/) | Hidden location and device data in photos; faces before sharing; Content Credentials | Web app + CLI | v0.1 built: 117 tests pass; 23/23 real-browser smoke checks pass (26 Nov 2026) |
| [actionguard-takedown](actionguard-takedown/) | Victims of leaked intimate images, sextortion or sexual deepfakes: evidence, local hashing, takedown notices, 48-hour tracking | Offline web app | v0.1 built: 135 tests pass; 17/17 real-browser smoke checks pass (26 Nov 2026). Legal templates need review by a lawyer before public use |
| [actionguard-phone](actionguard-phone/) | Stalkerware, spyware-like settings and banking-trojan signs on Android | Node CLI over USB (ADB) | v0.1 built: 188 tests pass on simulated phone snapshots (26 Nov 2026). Not yet tested on a real phone |

## Principles

1. **Guard the action, not only the domain.** Rules that watch the risky step keep working when attackers rotate domains.
2. **Private by default.** Everything runs on your device. No telemetry, no accounts, no uploads.
3. **Plain language.** Every warning says what happened, why it matters and what to do.
4. **Honest limits.** Each README lists what the tool does not catch.

## Build everything

Requires Node.js 22.18 or newer.

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\check-all.ps1 -Install
```

The script builds the engine first, then type-checks, tests and builds every other project.

## Repositories

Every tool is a **separate Git repository** in its own folder, so each one can have its own issues, releases, contributors and version number. This top folder is a small "suite" repository that holds only the shared documents and scripts; its `.gitignore` leaves the tool folders to their own repositories.

```
actionguard/                  suite repository: README, LICENSE, docs/, scripts/
├─ actionguard-engine/        own repository — shared detection library
├─ actionguard-browser/       own repository — browser extension (flagship)
├─ actionguard-mobile/        own repository — phone web app
├─ actionguard-desktop/       own repository — desktop guard
├─ actionguard-agent/         own repository — AI-agent guard
├─ actionguard-photo/         own repository — photo privacy tool
├─ actionguard-takedown/      own repository — image-abuse takedown kit
└─ actionguard-phone/         own repository — Android phone checker
```

Run one Git command in all of them at once:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\git-all.ps1                    # short status of every repository
powershell -ExecutionPolicy Bypass -File .\scripts\git-all.ps1 log --oneline -3   # last 3 commits of every repository
```

When publishing, create one GitHub repository per folder under a single GitHub organization (see the playbook).

## Documents

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — how the projects fit together and why TypeScript
- [docs/CONVENTIONS.md](docs/CONVENTIONS.md) — engineering rules every project follows
- [docs/OPEN-SOURCE-PLAYBOOK.md](docs/OPEN-SOURCE-PLAYBOOK.md) — how to launch, govern, secure and fund the project
- [docs/RESEARCH-REPORT.md](docs/RESEARCH-REPORT.md) — the research behind these choices

## License

Code: Apache-2.0. Detection rules and data we author: CC-BY-4.0. Third-party data keeps its own license (see each project's NOTICE).
