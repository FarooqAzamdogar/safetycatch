# SafetyCatch suite architecture

## The idea in one sentence

Modern scams and data theft succeed at a **moment of action** — pasting a command, typing a login code, scanning a QR code, approving an app, sharing a photo, letting an AI agent run a skill. SafetyCatch puts a small, private, explainable check in front of each of those moments.

## How the projects fit together

```
                         ┌──────────────────────────────┐
                         │      safetycatch-engine      │  TypeScript library + CLI
                         │  rules · scoring · i18n      │  runs in browser, PWA, Node
                         │  url · command · page · auth │
                         │  qr · secrets · download ·   │
                         │  message analyzers           │
                         └──────────────┬───────────────┘
              imports (file:../safetycatch-engine, bundled with esbuild)
        ┌───────────────┬───────────────┼────────────────┬─────────────────┐
        ▼               ▼               ▼                ▼                 │
 safetycatch-browser-extension  safetycatch-   safetycatch-     safetycatch-         │
 MV3 extension        mobile (PWA)   desktop (Node +  agent (Node CLI)     │
 Chrome/Edge/Firefox  share-to-check PowerShell)      AI-agent config      │
 paste guard, device- safe QR scan,  clipboard paste  seal, rug-pull       │
 code/OAuth warnings, message check  guard, cookie-   alerts, hidden-text  │
 look-alike logins,                  theft launch     scan, Claude Code    │
 AI-chat leak guard,                 watcher          hook, MCP checks     │
 risky downloads                                                           │
                                                                           │
 Standalone (no engine dependency):                                        │
 safetycatch-photo-privacy     PWA + CLI: inspect/strip metadata, blur faces, C2PA │
 safetycatch-takedown-kit  offline PWA: NCII/deepfake evidence, PDQ hashing,   │
                       TAKE IT DOWN / DMCA / DSA notices, 48-hour tracker  │
 safetycatch-stalkerware-check     Node CLI over ADB: stalkerware and banking-trojan   │
                       signs, survivor-safe report                         ┘
```

## Layers of defence (same order everywhere)

1. **Action rules** (deterministic, explainable): "this page wrote a PowerShell command to your clipboard", "this QR code links a new device to your account". Hardest for attackers to avoid, because the action is the whole point of the attack.
2. **Context**: referrer, page title vs domain, trusted-platform hosting, brand impersonation.
3. **Reputation** (optional): local lists only; any online lookup is opt-in and privacy-preserving.
4. **Models** (later, optional): tiny on-device models add judgement; never the only control.

## Shared contracts

- **Verdict** (from the engine): `{ analyzer, level: safe|low|medium|high|critical, score 0–100, findings[], advice[] }`. Every product renders the same severity scale and the same plain-language findings, so a user learns one vocabulary.
- **Rules as data** (CC-BY-4.0): each rule has an id, severity, explanation, references and tests, so contributors can add detection without touching core code.
- **i18n catalog**: English source; other languages flagged until a native speaker reviews them.

## Trust boundaries

| Boundary | Rule |
|---|---|
| Web page → extension | Page content is hostile. Analysis runs in the extension's isolated world or service worker; UI is built with DOM APIs, never `innerHTML`. |
| User content → network | Never crosses. No telemetry. Optional online features are user-triggered and documented. |
| Phone → computer (ADB) | Read-only commands; no private user data collected; nothing written to the phone. |
| Victim evidence → disk | Encrypted at rest (AES-GCM, passphrase-derived key); quick-exit locks the vault. |
| AI agent → tools | The agent CLI treats agent configs, skills and MCP tool descriptions as untrusted; it pins hashes and alerts on change. |

## Why TypeScript (and where Rust fits later)

- The flagship surfaces — browser extensions and installable web apps — run JavaScript natively, so a TypeScript engine needs no WebAssembly bridge and is easy for contributors to audit.
- The development machine runs Windows **Smart App Control**, which blocks unsigned native binaries, including Rust build tools. TypeScript runs on the signed Node.js runtime.
- **Rust is the planned v2 path** for native pieces that need operating-system APIs (a browser-secrets file-access monitor using ETW / Endpoint Security / fanotify), shipped as code-signed binaries (SignPath Foundation) built in CI.
