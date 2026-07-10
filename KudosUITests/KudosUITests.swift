import XCTest

final class KudosUITests: XCTestCase {
    func testLaunch() {
        let app = XCUIApplication()
        app.launchArguments += ["-UITEST_DEMO", "1"]
        app.launch()

        // After guest bypass, Home tab should be the landing tab
        let lookAroundButton = app.buttons.matching(
            NSPredicate(format: "label BEGINSWITH 'Look around'")
        ).firstMatch
        XCTAssertTrue(lookAroundButton.waitForExistence(timeout: 30))
        lookAroundButton.tap()

        XCTAssertTrue(app.tabBars.buttons["Home"].waitForExistence(timeout: 15))
    }

    func testComposeSheetOpensFromHome() {
        let app = XCUIApplication()
        app.launchArguments += ["-UITEST_DEMO", "1"]
        app.launch()

        let lookAroundButton = app.buttons.matching(
            NSPredicate(format: "label BEGINSWITH 'Look around'")
        ).firstMatch
        XCTAssertTrue(lookAroundButton.waitForExistence(timeout: 30))
        lookAroundButton.tap()

        // Tap "Send kudos" on the Home tab to open the compose sheet
        XCTAssertTrue(app.buttons["Send kudos"].waitForExistence(timeout: 15))
        app.buttons["Send kudos"].tap()

        // Compose sheet must expose the recipient field and the send button
        XCTAssertTrue(app.textFields["Find someone"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.buttons["Send with love"].waitForExistence(timeout: 5))

        let shot = XCTAttachment(screenshot: app.screenshot())
        shot.name = "Compose-sheet-home"
        shot.lifetime = .keepAlways
        add(shot)
    }
}
