# Kudos — App Store Submission Checklist

## App Store Metadata

### Category
**Primary:** Social Networking

### App Name
Kudos

### Subtitle
Send gratitude to the people you appreciate

### Description (100–150 words)

Kudos is a gratitude app that makes it easy to celebrate the people around you. Send a heartfelt acknowledgement to a colleague, friend, or family member with just a few taps — no account required to receive.

Look back over the kudos you've received and sent in your personal history, and keep every kind word close. Each kudo carries your name and a short message of thanks so the recipient always knows who cares.

To send kudos you'll need a Kudos account (free to create). Scan a friend's personal QR code or share your own — meeting up in person has never been a better reason to say thank you.

Spread the good. Recognise effort. Make someone's day.

### Keywords (100-character limit; comma-separated)
gratitude, appreciation, recognition, compliments, thank you, social, positive vibes, shoutout, celebrate, kind

### Support URL
https://kudos.app/support

### Privacy Policy URL
https://kudos.app/privacy

---

## App Store Review Notes

Demo access (no invite required):
1. Launch the app
2. On the welcome screen, tap "Look around first"
3. You will be signed in with a demo account
4. You'll see three tabs: Kudos (home), You (profile), Settings
5. In Kudos tab: search for a recipient, adjust appreciation level, add a note, tap "Send kudos"
6. In You tab: view your profile QR code and your personal list of received/sent kudos (tap one for detail)
7. In Settings: sign out, view connection settings

Camera permission: Used only for scanning QR codes in the recipient search field (CodeScanner button). Not required for the main demo flow.

---

## Screenshot Suggestions (6.7-inch / iPhone 16 Pro Max)

| # | Screen | Caption |
|---|--------|---------|
| 1 | Kudos tab (compose) | "A kudo in three taps" |
| 2 | Profile with your kudos list | "Every compliment, saved forever" |
| 3 | QR Share screen | "Share your code, get kudos instantly" |
| 4 | Kudo detail view | "The full story behind each thank-you" |

---

## Pre-Submission Checklist

### Copy & Metadata
- [ ] All screenshots use gratitude-only captions (no technical jargon)
- [ ] App description reviewed — no prohibited terms
- [ ] Keywords reviewed — no prohibited terms
- [ ] Support URL resolves and shows a contact form
- [ ] Privacy Policy URL resolves and is current

### Permissions
- [ ] `NSCameraUsageDescription` set ("Scan a friend's code to send them kudos.")
- [ ] No other sensitive permissions requested unnecessarily

### Build
- [x] Runs without crashes on iPhone (latest iOS) — build + unit + UI tests pass clean
- [ ] Runs without crashes on iPad (if universal)
- [x] No placeholder UI or lorem-ipsum text in the binary
- [x] App icon set — single 1024×1024, no alpha channel (placeholder; replace with final artwork before release)
- [x] Launch screen visible and branded (LaunchBackground color)

### App Store Connect
- [ ] Age rating completed (expected: 4+)
- [ ] Export compliance answered (no encryption beyond standard HTTPS)
- [ ] Content rights confirmed
- [ ] Version notes written for "What's New" (first release: "Initial release.")

### Final QA before submit
- [ ] Reviewer notes entered in App Store Connect "Notes for reviewer" field (copy the Demo Path section above)
- [ ] Demo account credentials entered if a sign-in is required (or "no sign-in required" confirmed)
- [ ] Build uploaded and processed (green checkmark in TestFlight)
