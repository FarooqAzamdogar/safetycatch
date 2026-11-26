# Engine feedback from the tools that use it

Issues found in `actionguard-engine` v0.1.0 while building the other tools. Each tool currently works around the ones that affect it. They are queued for an engine v0.1.1 fix round, after which the workarounds can be removed.

## Reported by actionguard-mobile (26 Nov 2026)

| # | Issue | Effect | Workaround in mobile |
|---|---|---|---|
| 1 | The first two `analyzeMessage` calls take about 0.9 s each on a desktop PC (cold start); expect several seconds on cheap phones | Slow first check after opening the app | Engine runs in a background worker with a warm-up call |
| 2 | `analyzeQrPayload` rates `javascript:`, `data:`, `file:` and `search-ms:` payloads as low ("Opens an app") | Dangerous QR payloads under-rated | App raises these itself |
| 3 | `analyzeMessage` never runs the auth analyzer on links, so a device-code link inside a message comes back safe | Device-code phishing by SMS or chat under-rated | App runs `analyzeAuthFlow` on every link and raises the verdict |
| 4 | `extractUrls` ignores app links such as `tg://login` inside messages | Account-takeover links in messages missed | App extracts app links itself |
| 5 | Parameter trimming glues words together (for example "Example Store(amount…", "LOJA EXEMPLOin SAO PAULO") | Awkward wording in findings | None |
| 6 | QR advice says "this link" for payloads that are not links | Confusing advice text | None |

## Reported by actionguard-agent (26 Nov 2026)

| # | Issue | Effect | Workaround in agent |
|---|---|---|---|
| 7 | Importing the engine costs about 0.9 s: `rx()` in `core/text.ts` compiles Unicode-property regular expressions at load time (this is the root cause of issue 1) | Every command-line run and hook call pays the start-up cost | Engine is loaded lazily, only when a shell command or URL must be checked |
| 8 | `analyzeUrl('https://api.githubcopilot.com/mcp/')` returns medium `url.brand-in-domain` | False positive on an official GitHub address | Allow-listed locally |
| 9 | `scanSecrets` misses opaque `Authorization: Bearer …` values, and its redaction of JSON string values swallows the quotes | Some tokens not redacted; redacted JSON is malformed | Own redaction for config output |
| 10 | `analyzeCommand` rates a credential file piped to a network tool as `safe` | Data-theft commands under-rated | Agent-specific rules cover it |
| 11 | The README does not say that `extractUrls` returns objects | Documentation gap | None |

## Reported by actionguard-browser (26 Nov 2026)

| # | Issue | Effect | Workaround in browser |
|---|---|---|---|
| 12 | `analyzePageText` takes 1.5–2.5 s on its first call (same cold start as issues 1 and 7), under 10 ms after | Slow first page check | Skips page analysis when it cannot change the decision |
| 13 | Page analysis has no rules for "download and run this file" instructions | Trusted-platform lures with download instructions missed | Small English-only heuristic in the extension |
| 14 | `url.brand-impersonation` findings do not expose the brand's official domain | Warning cannot show the real address | Extension probes `<brand>.com` |
| 15 | `scanSecrets().redacted` is all-or-nothing: it also hides low findings such as email addresses | Over-redaction when pasting into AI chats | None |
| 16 | Plain http plus an unusual port reaches "high" with no high finding | Over-scored http login pages | Shows a banner instead of a full-page wall |
| 17 | `-WindowStyle Hidden -EncodedCommand` with a benign payload only scores medium | Hidden-window commands under-rated | None |
| 18 | Platform and endpoint tables are not exported | Consumers duplicate the lists as pre-filters | Tests compare the copies against the engine's tables |

## Reported by actionguard-desktop (26 Nov 2026)

| # | Issue | Effect | Workaround in desktop |
|---|---|---|---|
| 19 | `cmd.fake-verification-text` rates ordinary prose containing "I am not a robot" as high | False alarm when someone copies normal text | Guard requires a command-like pre-filter match first |
| 20 | `analyzeCommand` rates bare links high on `url.*` rules alone | Copying a suspicious link is treated like copying a command | Guard ignores verdicts that rest only on `url.*` rules |
| 21 | `translate()` silently drops unfilled placeholders | Missing words in translated messages | Guard fills all parameters itself |
