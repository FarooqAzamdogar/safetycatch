# ActionGuard engineering conventions

These rules apply to every project in the ActionGuard suite. They exist so that eight separate repositories still feel like one product, and so that a security tool is itself built securely.

"ActionGuard" is a working name. Keep the name in one place per project (package name, manifest name, README title) so a rename is a search-and-replace.

## 1. Product principles

1. **Guard the action, not only the domain.** The fastest-growing attacks (ClickFix paste-and-run, device-code phishing, QR "link device" takeovers, lures on trusted platforms, malicious agent skills) end at a step the person or their AI agent must take. Detect that step. Blocklists and ML models are extra layers, never the only layer.
2. **On-device and private by default.** No telemetry, no analytics, no remote code, no uploading user content. Any network call must be opt-in, triggered by the user, and listed under "Network use" in the README.
3. **Plain language.** Every warning says what happened, why it is risky, and what to do next, at roughly a 12-year-old's reading level. No fear-mongering, no jargon without explanation.
4. **Escape hatch with friction.** Users can proceed or allow a site, but only after a deliberate step (for example typing or holding a button), never a single reflexive click.
5. **Honest limits.** README "Limitations" sections state what the tool does not catch.

## 2. Repository layout (every project)

```
<project>/
  README.md            what it is, who it is for, install, usage, privacy, network use, limitations, dependencies
  LICENSE              full Apache-2.0 text (https://www.apache.org/licenses/LICENSE-2.0.txt)
  NOTICE               copyright line plus third-party attributions (data and code)
  SECURITY.md          how to report vulnerabilities privately (GitHub private vulnerability reporting), supported versions
  CONTRIBUTING.md      dev setup, scripts, how to add a rule or language, review rules
  CODE_OF_CONDUCT.md   adopt Contributor Covenant 2.1 by reference with a link and a contact placeholder
  CHANGELOG.md         Keep a Changelog format, start at 0.1.0
  ROADMAP.md           next milestones, new ideas, known gaps
  THREAT_MODEL.md      assets, attackers, trust boundaries, what is in and out of scope
  docs/                extra docs (architecture, rule writing, screenshots later)
  src/                 source
  test/                tests and fixtures
  .github/workflows/ci.yml
  .gitignore  .editorconfig  package.json  pnpm-lock.yaml  pnpm-workspace.yaml  tsconfig.json
```

## 3. Toolchain (this dev machine)

- Windows 11 with **Smart App Control ON**. Newly compiled, unsigned native executables and DLLs are blocked (Rust build scripts, Go binaries, unsigned npm native addons). Therefore:
  - All projects are **TypeScript on Node.js**. No native addons. Runtime dependencies must be pure JS or WASM.
  - Package manager: **pnpm 11.29.0** (pinned with `"packageManager": "pnpm@11.29.0"`). pnpm 11 is plain JavaScript; pnpm 12 ships an unsigned native executable that Smart App Control would block. pnpm keeps one shared copy of each package and hard-links it into every project (the eight projects use about 89 MB of real disk instead of 389 MB with npm). Install it once with `npm install -g pnpm@11.29.0`.
  - Signed tools work: `node` 24.14, `npm` 11.9, `git`, `powershell.exe` 5.1 (FullLanguage mode), `esbuild` (works), TypeScript 7 `tsc` (works).
  - Rust 1.100 is installed (`$HOME/.cargo/bin`) but native builds fail here; do not use it.
- Node engines field: `">=22.18"`. ESM only (`"type": "module"`).
- TypeScript: `strict`, `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes` (optional), `verbatimModuleSyntax`, **`erasableSyntaxOnly`** (no `enum`, `namespace`, or constructor parameter properties) so Node can run `.ts` files directly with type stripping.
- Tests: Node's built-in runner, run directly on TypeScript: `node --test "test/**/*.test.ts"`. Use `node:assert/strict`.
- Bundling (extensions, PWAs, CLIs that need it): `esbuild`.
- Required npm scripts in every project:
  - `typecheck` = `tsc --noEmit`
  - `test` = node test runner
  - `build` = produce distributable output (dist/ or a packaged extension/PWA)
  - `check` = `node --run typecheck && node --run test && node --run build`. **Must pass before you report done.**
  - Timing tests (wall-clock budgets) do not belong in `test`; put them in a separate `perf` script and run them on an idle machine.
  - Each repository has a `pnpm-workspace.yaml` with `allowBuilds:` so dependency install scripts never run unless a package is explicitly allowed.

## 4. Dependencies

- Prefer zero runtime dependencies. Each runtime dependency must be pure JS/WASM, permissively licensed (MIT, BSD, ISC, Apache-2.0, CC0), maintained (release or commits in the last 12 months), and justified in the README "Dependencies" section.
- Pin exact versions (`pnpm add --save-exact`), commit `pnpm-lock.yaml`, and run `pnpm audit --prod` (report results).
- Dev dependencies are limited to what is needed: `typescript`, `@types/node`, `esbuild`, and small pure-JS helpers when truly needed (for example a DOM shim for tests).
- The shared engine is consumed as `"actionguard-engine": "link:../actionguard-engine"` (a live link, so engine changes are picked up without reinstalling) and imported from `"actionguard-engine"`. Build the engine (`pnpm run build` in its folder) before using it.

## 5. Security rules for our own code

- Treat every input as hostile: page text, URLs, clipboard, QR payloads, files, ADB output, config files.
- Never use `eval`, `new Function`, `innerHTML`/`outerHTML`/`insertAdjacentHTML` with untrusted data, or `document.write`. Build DOM with `createElement` and `textContent`.
- Extensions and PWAs ship a strict Content Security Policy. No remote scripts. No CDNs.
- Regular expressions must be ReDoS-safe: no nested unbounded quantifiers on overlapping classes, and cap input length before matching (truncate very long inputs and record that truncation happened).
- Never log secrets or user content in plain text. Redact in logs.
- Least privilege: request the narrowest permissions; explain each one in the README.
- Fail safe: if analysis errors, show a neutral "could not check" state, never a false "safe".

## 6. Test data safety

- Use defanged domains only: `example.com`, `example.org`, `*.example`, `*.test`, `*.invalid`. Never include live malicious URLs.
- **Microsoft Defender may quarantine source or test files that contain realistic attack strings** (for example a full ClickFix PowerShell download-and-execute line). Build such samples at runtime from fragments, or store them base64-encoded and decode in the test. If a file disappears or a write fails with a virus error, this is why.
- The same protection **refuses to start a process whose command line contains a realistic attack string** ("Permission denied" when launching `node` with a ClickFix-style argument). Never pass such strings as command-line arguments; assemble them in memory inside the script or test, or feed them through stdin from a file built at runtime. Do not try to bypass or disable the protection.
- Synthetic fixtures only. No real people's photos, no copyrighted images, no real victims' data. Generate images programmatically where needed.

## 7. UX, accessibility, languages

- All user-facing strings live in one message catalog per project. English is the source language. Extra languages are welcome but must be marked "machine translation, needs native review" until a native speaker reviews them.
- Keyboard navigable, visible focus, ARIA labels, contrast at least WCAG AA, never color-only signals.
- Warnings use a consistent severity scale: `safe`, `low`, `medium`, `high`, `critical`.

## 8. Licensing

- Code: Apache-2.0. Copyright line: `Copyright 2026 The ActionGuard Authors`.
- Rules and data we author: CC-BY-4.0 (say so in the rules folder README).
- Third-party data keeps its license; record source, license, and attribution in NOTICE (for example Echap stalkerware-indicators, CC-BY-4.0).
- Never bundle non-commercial data or models (CC BY-NC, research-only weights).

## 9. CI (GitHub Actions)

- `.github/workflows/ci.yml`: on push and pull_request; top-level `permissions: contents: read`; matrix Node 22 and 24 on ubuntu-latest and windows-latest; steps: checkout, `pnpm/action-setup`, setup-node with `cache: pnpm`, `pnpm install --frozen-lockfile`, `pnpm run check`, `pnpm audit --prod`.
- Pin every action to a full commit SHA with the version in a comment, for example `uses: actions/checkout@<40-char-sha> # v5.0.0`. Look SHAs up with `git ls-remote https://github.com/actions/checkout "refs/tags/v5*"`.
- Projects that depend on the engine check it out and build it first (document the assumption that both repos sit side by side, or use a relative checkout path).

## 10. Git and publishing

- Each project is its own repository: run `git init` in the project folder. **Do not commit, push, publish to npm, or upload to any store.** The owner decides when.
- Do not touch other projects' folders, except reading `actionguard-engine`.

## 11. Definition of done

1. `pnpm run check` passes (typecheck, tests, build), and you report the actual test counts.
2. README is complete and honest, including Limitations and Network use.
3. All files in section 2 exist.
4. ROADMAP.md lists the next milestones and new ideas found during prior-art checks.
5. No secrets, no live malicious URLs, no real personal data in the repo.
