import XCTest

final class GuestFlowUITests: XCTestCase {
    func testGuestReachesMainTabs() {
        let app = XCUIApplication()
        app.launchArguments += ["-UITEST_DEMO", "1"]
        app.launch()

        let lookAroundButton = app.buttons["Look around first"]
        XCTAssertTrue(lookAroundButton.waitForExistence(timeout: 5))
        lookAroundButton.tap()

        XCTAssertTrue(app.tabBars.buttons["Kudos"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.tabBars.buttons["You"].exists)
        XCTAssertTrue(app.tabBars.buttons["Settings"].exists)
    }
}
