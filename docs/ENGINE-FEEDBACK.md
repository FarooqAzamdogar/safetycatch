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
