# SafetyCatch

**Open-source, on-device protection for the moments scams and data theft depend on.**

AI has made phishing, deepfake fraud and data theft cheaper and more convincing, but almost every attack still needs you (or your AI agent) to *do* something: paste a command, type a login code, scan a QR code, approve an app, share a photo, run a plugin. SafetyCatch checks those actions privately on your own device and explains the risk in plain language.

> SafetyCatch was first developed under the working name "ActionGuard". See `docs/PUBLISHING.md` for the name check, licence and launch plan.

## The tools

| Project | What it protects | Form | Status |
|---|---|---|---|
| [safetycatch-engine](safetycatch-engine/) | Shared detection rules for links, commands, logins, QR codes, secrets, downloads and scam messages | TypeScript library + CLI | v0.1.1: 1,174 tests pass; about 280 rules; cold start about 0.3 s; 7 extra languages (machine-translated, need native review) (26 Nov 2026) |
| [safetycatch-browser-extension](safetycatch-browser-extension/) — **flagship** | Fake "paste this command" pages (ClickFix), device-code and OAuth phishing, look-alike login pages, AI-chat data leaks, risky downloads | Browser extension (Chrome, Edge, Firefox) | v0.1 built: 232 tests pass; 39/39 real-browser smoke checks pass in Chrome (26 Nov 2026). Firefox build never run |
| [safetycatch-scam-checker](safetycatch-scam-checker/) | Links and messages shared from any app, safe QR scanning (link-device, wallet, payment and login-code QR traps) | Installable web app (Android and iPhone) | v0.1 built: 252 tests pass; 69/69 real-browser smoke checks pass (26 Nov 2026). Not yet tested on a real phone |
| [safetycatch-clipboard-guard](safetycatch-clipboard-guard/) | Dangerous commands on the clipboard; browsers relaunched to steal cookies | Background guard (Windows first) | v0.1 built: 314 tests pass; a 32-check live smoke run passed once on Windows 11 (26 Nov 2026). Windows only |
| [safetycatch-mcp-guard](safetycatch-mcp-guard/) | AI coding agents and MCP tools: config tampering, rug pulls, hidden instructions, misuse by malicious packages | Node CLI + Claude Code hook | v0.1 built: 736 tests pass; hook verified live on sample actions (26 Nov 2026). Not yet tested against live agents |
| [safetycatch-photo-privacy](safetycatch-photo-privacy/) | Hidden location and device data in photos; faces before sharing; Content Credentials | Web app + CLI | v0.1 built: 117 tests pass; 23/23 real-browser smoke checks pass (26 Nov 2026) |
| [safetycatch-takedown-kit](safetycatch-takedown-kit/) | Victims of leaked intimate images, sextortion or sexual deepfakes: evidence, local hashing, takedown notices, 48-hour tracking | Offline web app | v0.1 built: 135 tests pass; 17/17 real-browser smoke checks pass (26 Nov 2026). Legal templates need review by a lawyer before public use |
| [safetycatch-stalkerware-check](safetycatch-stalkerware-check/) | Stalkerware, spyware-like settings and banking-trojan signs on Android | Node CLI over USB (ADB) | v0.1 built: 188 tests pass on simulated phone snapshots (26 Nov 2026). Not yet tested on a real phone |

## Principles

1. **Guard the action, not only the domain.** Rules that watch the risky step keep working when attackers rotate domains.
2. **Private by default.** Everything runs on your device. No telemetry, no accounts, no uploads.
3. **Plain language.** Every warning says what happened, why it matters and what to do.
4. **Honest limits.** Each README lists what the tool does not catch.

## Build everything

Requires Node.js 22.18 or newer and pnpm 11 (`npm install -g pnpm@11.29.0`). pnpm stores one shared copy of each package, so all eight projects together use about 89 MB of disk for dependencies.

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\check-all.ps1 -Install
```

The script builds the engine first, then type-checks, tests and builds every other project.

## Repositories

Every tool is a **separate Git repository** in its own folder, so each one can have its own issues, releases, contributors and version number. This top folder is a small "suite" repository that holds only the shared documents and scripts; its `.gitignore` leaves the tool folders to their own repositories.

```
safetycatch/                  suite repository: README, LICENSE, docs/, scripts/
├─ safetycatch-engine/        own repository — shared detection library
├─ safetycatch-browser-extension/       own repository — browser extension (flagship)
├─ safetycatch-scam-checker/        own repository — phone web app
├─ safetycatch-clipboard-guard/       own repository — desktop guard
├─ safetycatch-mcp-guard/         own repository — AI-agent guard
├─ safetycatch-photo-privacy/         own repository — photo privacy tool
├─ safetycatch-takedown-kit/      own repository — image-abuse takedown kit
└─ safetycatch-stalkerware-check/         own repository — Android phone checker
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
- [docs/PUBLISHING.md](docs/PUBLISHING.md) — proposed name, licence, GitHub descriptions and topics, and public/private plan for every repository (`scripts/publish-github.ps1` applies it)
- [docs/RESEARCH-REPORT.md](docs/RESEARCH-REPORT.md) — the research behind these choices

## License

Code: Apache-2.0. Detection rules and data we author: CC-BY-4.0. Third-party data keeps its own license (see each project's NOTICE).
