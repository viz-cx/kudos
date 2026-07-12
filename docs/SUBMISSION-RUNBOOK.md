# Kudos — App Store Submission Runbook

A click-by-click for pushing Kudos to the App Store. All copy/assets referenced
here already live in the repo (`AppStore/`, `Kudos/Support/ReviewChecklist.md`).

**App facts:** Bundle ID `cx.viz.kudos` · Version `1.0` · Build `1` · Category Social Networking.
Export compliance is pre-answered in `Info.plist` via `ITSAppUsesNonExemptEncryption = NO`,
so App Store Connect will not prompt for it.

---

## Phase A — Xcode: archive & upload (~15 min)

1. Xcode → device selector → **Any iOS Device (arm64)** (not a simulator).
2. Target **Kudos** → **Signing & Capabilities** → Team set, "Automatically manage signing" on.
3. **Product → Archive** → wait for the Organizer window.
4. Organizer → select archive → **Distribute App → App Store Connect → Upload** → defaults → **Upload**.
5. Wait ~5–15 min for processing. Build turns green in the **TestFlight** tab (email confirms).

## Phase B — App Store Connect: the app record

6. [appstoreconnect.apple.com](https://appstoreconnect.apple.com) → **My Apps**.
   If **Kudos** doesn't exist: **＋ → New App** → iOS, name **Kudos**, English,
   bundle ID `cx.viz.kudos`, SKU `cx-viz-kudos`.

## Phase C — Version page (copy-paste)

7. **Category** → Primary: **Social Networking**.
8. **Subtitle**: `Send gratitude to the people you appreciate`
9. **Description**: paste the "Kudos is a gratitude app…" block from `Kudos/Support/ReviewChecklist.md`.
10. **Keywords**: `gratitude, appreciation, recognition, compliments, thank you, social, positive vibes, shoutout, celebrate, kind`
11. **Support URL**: `https://viz-cx.github.io/kudos/support/`
12. **Privacy Policy URL**: `https://viz-cx.github.io/kudos/privacy/`
13. **Screenshots** → 6.9" Display → drag in order:
    `1-Home-feed` → `2-Compose-sheet` → `3-You-profile` → `4-Kudo-detail`
    (from `AppStore/screenshots/`; 6.9" set auto-satisfies 6.5").
14. **Build** → **＋ Select a build** → the processed build.
15. **What's New**: `Initial release.`

## Phase D — Compliance answers

16. **Age Rating** → all "None" → result **4+**.
17. **Export Compliance** → not prompted (pre-set in Info.plist). If ever asked: uses only standard HTTPS → exempt.
18. **Content Rights** → "Does not contain third-party content" → confirm.
19. **App Privacy** → no data collected for tracking; Keychain-only credentials;
    camera for QR only; no analytics/ad SDKs (matches the privacy policy).

## Phase E — Reviewer notes & submit

20. **App Review Information → Notes** → paste the "App Store Review Notes / Demo access"
    block from `Kudos/Support/ReviewChecklist.md`.
21. Sign-in **not required**: leave demo username/password blank; note
    "No sign-in required — tap 'Look around first' on the welcome screen."
22. **Add for Review → Submit**.

---

## Reproduce screenshots (only if the UI changes)

See `AppStore/README.md` — drives `KudosUITests/ScreenshotTests` via the `-UITEST_DEMO` flow.
