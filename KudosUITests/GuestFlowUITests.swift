import XCTest

final class GuestFlowUITests: XCTestCase {
    func testGuestReachesMainTabs() {
        let app = XCUIApplication()
        app.launchArguments += ["-UITEST_DEMO", "1"]
        app.launch()

        let lookAroundButton = app.buttons["Look around first"]
        XCTAssertTrue(lookAroundButton.waitForExistence(timeout: 30))
        lookAroundButton.tap()

        XCTAssertTrue(app.tabBars.buttons["Kudos"].waitForExistence(timeout: 15))
        XCTAssertTrue(app.tabBars.buttons["You"].exists)
        XCTAssertTrue(app.tabBars.buttons["Settings"].exists)
    }

    func testProfileShowsKudosFeed() {
        let app = XCUIApplication()
        app.launchArguments += ["-UITEST_DEMO", "1"]
        app.launch()

        let lookAroundButton = app.buttons["Look around first"]
        XCTAssertTrue(lookAroundButton.waitForExistence(timeout: 30))
        lookAroundButton.tap()

        let youTab = app.tabBars.buttons["You"]
        XCTAssertTrue(youTab.waitForExistence(timeout: 15))
        youTab.tap()

        // Feed section header + a mock event from PreviewFeedMock.
        XCTAssertTrue(app.staticTexts["Your kudos"].waitForExistence(timeout: 15))
        XCTAssertTrue(app.staticTexts["From @alice"].waitForExistence(timeout: 5))

        let shot = XCTAttachment(screenshot: app.screenshot())
        shot.name = "Profile-with-kudos-feed"
        shot.lifetime = .keepAlways
        add(shot)

        // Tap through to the detail view.
        app.staticTexts["From @alice"].tap()
        XCTAssertTrue(app.navigationBars["Kudo"].waitForExistence(timeout: 10))

        let detailShot = XCTAttachment(screenshot: app.screenshot())
        detailShot.name = "Kudo-detail"
        detailShot.lifetime = .keepAlways
        add(detailShot)
    }
}
