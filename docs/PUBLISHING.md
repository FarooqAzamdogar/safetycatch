# Publishing plan: names, licences, descriptions, visibility

Proposed brand: **SafetyCatch** (checked 26 Nov 2026: GitHub organisation name free, 0 repositories named `safetycatch`, npm package name free; `safetycatch.dev`, `.org`, `.app` and `.io` showed no DNS registration; `safetycatch.com` is registered by someone else). "ActionGuard" is only a working name: the `actionguard` GitHub account is taken and at least six repositories use the name, three of them AI-agent safety tools. Run a free trademark search (WIPO Global Brand Database and your national trademark office) before launch.

The descriptions below do not contain the brand, so they work with any final name. `scripts/publish-github.ps1 -Brand <name>` builds the repository names from the brand.

## Licence

| What | Licence | Why |
|---|---|---|
| All code in all nine repositories | **Apache-2.0** (already in every `LICENSE` file) | Permissive, so people and companies can use it freely and adoption is highest; an explicit patent grant that protects contributors and users; accepted by the Chrome, Edge and Firefox stores, F-Droid and every funder in the research (OTF, NLnet, FLOSS/fund, GitHub's fund); it does not grant use of the name, so forks cannot call themselves SafetyCatch. |
| Detection rules and data we write | **CC-BY-4.0** (already declared in the engine) | Other tools may reuse the rules with credit, which grows the community. |
| Third-party data and libraries | Their own licences, listed in each `NOTICE` | For example Echap stalkerware indicators (CC-BY-4.0), Public Suffix List data in tldts (MPL-2.0). |

Alternatives considered: **MIT** (simpler but no patent grant), **MPL-2.0** (changed files must stay open — a middle ground if closed copies of the engine become a worry), **GPL-3.0 / AGPL-3.0** (forces all copies to stay open, but the FSF says it conflicts with Apple's App Store terms and it puts off companies). Keep Apache-2.0.

## Visibility: public, after a short private pre-launch

All nine repositories should be **public** at launch. A security tool has to be auditable to be trusted; public repositories get unlimited free GitHub Actions minutes and free secret scanning, push protection, Dependabot, CodeQL and private vulnerability reporting; only public repositories appear in search engines; and the grants above require public open source.

Create them **private first** for one to two weeks, then switch all of them to public together on launch day:

1. Finish the rename to the final brand and the current clean-up.
2. Trademark search; register the domain.
3. Decide which email address the commits show. The local commits record the author email chosen on 26 Nov 2026; once public, anyone can read it. Before the first push, the history can be rewritten to your GitHub no-reply address (Settings → Emails on GitHub).
4. Turn on the organisation security settings in `OPEN-SOURCE-PLAYBOOK.md` (two-factor for members, branch rules, private vulnerability reporting, secret scanning, Dependabot).

**Exception: the takedown kit stays private until a lawyer has reviewed its legal templates** (TAKE IT DOWN Act, DMCA and DSA notices). A wrong template could hurt the people it is meant to help. Free help may be available from a law-school clinic or a digital-rights organisation.

## Repositories

| Folder today | Repository | Visibility at launch |
|---|---|---|
| `actionguard` (suite) | `safetycatch` | public |
| `actionguard-engine` | `safetycatch-engine` | public |
| `actionguard-browser` | `safetycatch-browser-extension` | public |
| `actionguard-mobile` | `safetycatch-scam-checker` | public |
| `actionguard-desktop` | `safetycatch-clipboard-guard` | public |
| `actionguard-agent` | `safetycatch-mcp-guard` | public |
| `actionguard-photo` | `safetycatch-photo-privacy` | public |
| `actionguard-takedown` | `safetycatch-takedown-kit` | private until legal review |
| `actionguard-phone` | `safetycatch-stalkerware-check` | public |

### GitHub "About" descriptions and topics

GitHub shows the description under the repository name and uses it, the topics and the README in search. Website for all: `https://safetycatch.dev` once the domain is registered.

**safetycatch** (home)
> Free, open-source protection against AI-era scams and data theft: phishing, fake-CAPTCHA paste attacks, QR traps, deepfake abuse, stalkerware and risky AI agents. Runs on your device. No tracking.

Topics: `security` `privacy` `anti-phishing` `scam-detection` `phishing-protection` `clickfix` `ai-security` `deepfake` `stalkerware` `mcp-security` `on-device` `online-safety` `fraud-prevention` `cybersecurity` `open-source` `typescript`

**safetycatch-engine**
> On-device detection engine for phishing links, ClickFix paste-and-run commands, QR-code traps, device-code and OAuth phishing, scam messages and leaked secrets. TypeScript, explainable rules, no network.

Topics: `phishing-detection` `scam-detection` `clickfix` `qr-code` `device-code-phishing` `oauth` `secret-detection` `dlp` `url-analysis` `homoglyph` `on-device` `library` `typescript` `security`

**safetycatch-browser-extension**
> Browser extension for Chrome, Edge and Firefox that stops fake-CAPTCHA paste attacks, look-alike login pages, device-code phishing and secrets pasted into AI chats. 100% on-device, no data collected.

Topics: `browser-extension` `chrome-extension` `firefox-addon` `edge-extension` `manifest-v3` `anti-phishing` `phishing-protection` `clickfix` `fake-captcha` `scam-protection` `ai-chat` `dlp` `privacy` `security`

**safetycatch-scam-checker**
> Free scam checker for phones: share or paste a link or message to check it, and scan QR codes safely to see what a code does before it opens. Works offline, in 8 languages, with no tracking.

Topics: `scam-checker` `scam-detection` `qr-code-scanner` `quishing` `smishing` `phishing-detection` `pwa` `offline-first` `android` `iphone` `multilingual` `privacy` `security`

**safetycatch-clipboard-guard**
> Windows guard against ClickFix and FileFix paste-and-run attacks: warns about and clears dangerous commands on the clipboard, and flags browsers started in the remote-control mode used to steal cookies.

Topics: `clickfix` `filefix` `clipboard` `windows` `infostealer` `cookie-theft` `malware-protection` `endpoint-security` `powershell` `typescript` `security`

**safetycatch-mcp-guard**
> Security guard for AI coding agents and MCP servers: finds risky configs, hidden prompt-injection text and tool rug pulls, seals and verifies settings, and blocks dangerous actions with a Claude Code hook.

Topics: `mcp` `mcp-security` `model-context-protocol` `ai-agents` `agent-security` `ai-security` `llm-security` `prompt-injection` `claude-code` `cursor` `supply-chain-security` `sarif` `cli` `security`

**safetycatch-photo-privacy**
> Share photos safely: see and remove hidden location and device data (EXIF), blur faces on your device, and check Content Credentials (C2PA). Offline web app and command-line tool, nothing uploaded.

Topics: `exif` `exif-remover` `metadata-removal` `photo-privacy` `image-privacy` `face-blur` `gps` `c2pa` `content-credentials` `pwa` `offline-first` `privacy`

**safetycatch-takedown-kit**
> Private, offline help for people targeted by leaked intimate images, sextortion or sexual deepfakes: encrypted evidence log, on-device image hashing, TAKE IT DOWN Act and DMCA notices, and a 48-hour tracker.

Topics: `ncii` `sextortion` `deepfake` `take-it-down-act` `dmca` `image-abuse` `victim-support` `digital-evidence` `pdq-hash` `pwa` `offline-first` `privacy`

**safetycatch-stalkerware-check**
> Check an Android phone for stalkerware, spyware-like settings and banking-trojan signs over USB (ADB). Read-only and offline, with safety-first guidance for survivors of tech abuse.

Topics: `stalkerware` `spyware-detection` `android` `android-security` `adb` `tech-abuse` `domestic-violence` `malware-detection` `privacy` `cli` `security`

## Search-friendliness checklist (per repository)

- The first line of the README repeats the description in plain words; add a screenshot or short GIF at the top.
- A social preview image (Settings → Social preview, 1280 × 640 px).
- Store listings use keywords in the title, for example "SafetyCatch: Anti-Phishing & Scam Guard".
- A small website (GitHub Pages with the custom domain) with one page per tool, so search engines index plain-language pages.
- Submit to curated "awesome" lists for privacy, security, browser extensions and MCP servers.
- The same name everywhere: GitHub organisation, npm, extension stores, domain and social accounts.
