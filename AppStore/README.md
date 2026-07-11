# App Store Assets

## Screenshots (`screenshots/`)

Captured on **iPhone 16 Pro Max** (iOS 26.4) — **1320 × 2868**, the 6.9" App Store size.
Reproduce with the `ScreenshotTests` UI test (drives the `-UITEST_DEMO` flow):

```sh
DEV=$(xcrun simctl create Kudos-Shots \
  com.apple.CoreSimulator.SimDeviceType.iPhone-16-Pro-Max \
  com.apple.CoreSimulator.SimRuntime.iOS-26-4)
xcrun simctl boot "$DEV"
xcodebuild test -project Kudos.xcodeproj -scheme Kudos \
  -destination "platform=iOS Simulator,id=$DEV" \
  -only-testing:KudosUITests/ScreenshotTests \
  -resultBundlePath /tmp/kudos_shots.xcresult
xcrun xcresulttool export attachments \
  --path /tmp/kudos_shots.xcresult --output-path /tmp/shots_export
```

Upload order and captions (App Store Connect → 6.9" Display):

| Order | File | Caption |
|-------|------|---------|
| 1 | `1-Home-feed.png` | Gratitude, front and centre |
| 2 | `2-Compose-sheet.png` | A kudo in three taps |
| 3 | `3-You-profile.png` | Share your code, get kudos instantly |
| 4 | `4-Kudo-detail.png` | The full story behind each thank-you |

> The 6.9" set also satisfies the 6.5" requirement (App Store Connect scales it), so no separate 6.5" capture is needed.

## Everything else

App name, subtitle, description, keywords, reviewer notes, and the pre-submission
checklist live in [`../Kudos/Support/ReviewChecklist.md`](../Kudos/Support/ReviewChecklist.md).
