import XCTest

final class GuestFlowUITests: XCTestCase {
    func testGuestReachesMainTabs() {
        let app = XCUIApplication()
        app.launchArguments += ["-UITEST_DEMO", "1"]
        app.launch()

        let lookAroundButton = app.buttons.matching(
            NSPredicate(format: "label BEGINSWITH 'Look around'")
        ).firstMatch
        XCTAssertTrue(lookAroundButton.waitForExistence(timeout: 30))
        lookAroundButton.tap()

        XCTAssertTrue(app.tabBars.buttons["Home"].waitForExistence(timeout: 15))
        XCTAssertTrue(app.tabBars.buttons["You"].exists)
        XCTAssertTrue(app.tabBars.buttons["Settings"].exists)
    }

    func testHomeShowsSendKudosAndComposeSheet() {
        let app = XCUIApplication()
        app.launchArguments += ["-UITEST_DEMO", "1"]
        app.launch()

        let lookAroundButton = app.buttons.matching(
            NSPredicate(format: "label BEGINSWITH 'Look around'")
        ).firstMatch
        XCTAssertTrue(lookAroundButton.waitForExistence(timeout: 30))
        lookAroundButton.tap()

        // Lands on the Home feed with "Send kudos" button
        XCTAssertTrue(app.buttons["Send kudos"].waitForExistence(timeout: 15))

        let homeShot = XCTAttachment(screenshot: app.screenshot())
        homeShot.name = "Home-feed"
        homeShot.lifetime = .keepAlways
        add(homeShot)

        // Opening compose presents the sheet with recipient field
        app.buttons["Send kudos"].tap()
        XCTAssertTrue(app.textFields["Find someone"].waitForExistence(timeout: 10))

        let composeShot = XCTAttachment(screenshot: app.screenshot())
        composeShot.name = "Compose-sheet"
        composeShot.lifetime = .keepAlways
        add(composeShot)
    }

    func testYouTabIsIdentityOnly() {
        let app = XCUIApplication()
        app.launchArguments += ["-UITEST_DEMO", "1"]
        app.launch()

        let lookAroundButton = app.buttons.matching(
            NSPredicate(format: "label BEGINSWITH 'Look around'")
        ).firstMatch
        XCTAssertTrue(lookAroundButton.waitForExistence(timeout: 30))
        lookAroundButton.tap()

        let youTab = app.tabBars.buttons["You"]
        XCTAssertTrue(youTab.waitForExistence(timeout: 15))
        youTab.tap()

        // "You" tab no longer hosts the kudos feed
        XCTAssertFalse(app.staticTexts["Your kudos"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["From @alice"].exists)

        let shot = XCTAttachment(screenshot: app.screenshot())
        shot.name = "You-tab-identity"
        shot.lifetime = .keepAlways
        add(shot)
    }
}
