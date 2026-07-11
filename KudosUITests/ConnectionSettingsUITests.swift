import XCTest

final class ConnectionSettingsUITests: XCTestCase {
    func testConnectionListRendersWithDefault() {
        let app = XCUIApplication()
        app.launchArguments += ["-UITEST_DEMO", "1"]
        app.launch()

        let lookAround = app.buttons.matching(
            NSPredicate(format: "label BEGINSWITH 'Look around'")
        ).firstMatch
        XCTAssertTrue(lookAround.waitForExistence(timeout: 30))
        lookAround.tap()

        XCTAssertTrue(app.tabBars.buttons["Settings"].waitForExistence(timeout: 15))
        app.tabBars.buttons["Settings"].tap()
        app.buttons["Connection"].tap()

        XCTAssertTrue(app.staticTexts["node.viz.cx"].waitForExistence(timeout: 5))
        // Verify another node is present (buttons or static texts — Form exposes them either way)
        let apiWorld = app.buttons["api.viz.world"].exists || app.staticTexts["api.viz.world"].exists
        XCTAssertTrue(apiWorld)
    }
}
