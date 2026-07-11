import XCTest

/// Drives the demo flow (-UITEST_DEMO) and captures the four App Store screenshots
/// as keep-always attachments. Run on a 6.9" device (iPhone 16 Pro Max) for a
/// valid App Store resolution, then extract the PNGs from the .xcresult bundle.
final class ScreenshotTests: XCTestCase {
    func testCaptureAppStoreScreenshots() {
        let app = XCUIApplication()
        app.launchArguments += ["-UITEST_DEMO", "1"]
        app.launch()

        // Onboarding → guest bypass
        let lookAround = app.buttons.matching(
            NSPredicate(format: "label BEGINSWITH 'Look around'")
        ).firstMatch
        XCTAssertTrue(lookAround.waitForExistence(timeout: 30))
        lookAround.tap()

        // 1) Home feed
        XCTAssertTrue(app.tabBars.buttons["Home"].waitForExistence(timeout: 15))
        // let the populated feed render
        XCTAssertTrue(app.buttons["Send kudos"].waitForExistence(timeout: 10))
        Thread.sleep(forTimeInterval: 1.0)
        capture(app, name: "1-Home-feed")

        // 2) Kudo detail — tap the first feed card
        let firstCard = app.buttons.matching(
            NSPredicate(format: "label CONTAINS[c] 'alice'")
        ).firstMatch
        if firstCard.waitForExistence(timeout: 5) {
            firstCard.tap()
            Thread.sleep(forTimeInterval: 1.0)
            capture(app, name: "4-Kudo-detail")
            // back to Home
            let back = app.navigationBars.buttons.element(boundBy: 0)
            if back.exists { back.tap() }
        }

        // 3) You tab — avatar + QR
        app.tabBars.buttons["You"].tap()
        Thread.sleep(forTimeInterval: 1.2)
        capture(app, name: "3-You-profile")

        // 4) Compose sheet with a filled recipient + warmth
        app.tabBars.buttons["Home"].tap()
        let sendKudos = app.buttons["Send kudos"]
        XCTAssertTrue(sendKudos.waitForExistence(timeout: 10))
        sendKudos.tap()

        // Wait for the sheet, then set warmth via the slider only — no typing, so
        // the keyboard never appears and the whole sheet (recipient field, the
        // signature WarmthPicker heart, note, "Send with love") stays visible.
        XCTAssertTrue(app.textFields["Find someone"].waitForExistence(timeout: 10))
        let slider = app.sliders.firstMatch
        if slider.waitForExistence(timeout: 5) {
            slider.adjust(toNormalizedSliderPosition: 0.72)
        }
        Thread.sleep(forTimeInterval: 0.8)
        capture(app, name: "2-Compose-sheet")
    }

    private func capture(_ app: XCUIApplication, name: String) {
        let shot = XCTAttachment(screenshot: app.screenshot())
        shot.name = name
        shot.lifetime = .keepAlways
        add(shot)
    }
}
