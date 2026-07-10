import Testing
import SwiftUI
@testable import Kudos

struct ColorHexTests {
    @Test func hexProducesExpectedComponents() {
        let c = Color(hex: 0xFF7A59)
        let resolved = c.resolve(in: EnvironmentValues())
        #expect(abs(resolved.red - 1.0) < 0.01)
        #expect(abs(resolved.green - 0.478) < 0.01)
        #expect(abs(resolved.blue - 0.349) < 0.01)
    }
}

struct AvatarInitialTests {
    @Test func usesFirstCharacterUppercased() {
        #expect(Avatar.initial(for: "maya") == "M")
    }
    @Test func skipsLeadingAtSign() {
        #expect(Avatar.initial(for: "@sam") == "S")
    }
    @Test func fallsBackToQuestionMark() {
        #expect(Avatar.initial(for: "") == "?")
    }
}

struct WarmthLabelTests {
    @Test func lowFractionIsLittle() {
        #expect(WarmthLabel.text(for: 0.1) == "A little warmth")
    }
    @Test func midFractionIsGoodDeal() {
        #expect(WarmthLabel.text(for: 0.5) == "A good deal of warmth")
    }
    @Test func highFractionIsLot() {
        #expect(WarmthLabel.text(for: 0.9) == "A lot of warmth")
    }
}

struct GreetingTests {
    @Test func morning() { #expect(Greeting.text(for: 8) == "Good morning ✨") }
    @Test func afternoon() { #expect(Greeting.text(for: 14) == "Good afternoon ✨") }
    @Test func evening() { #expect(Greeting.text(for: 21) == "Good evening ✨") }
    @Test func lateNightIsEvening() { #expect(Greeting.text(for: 2) == "Good evening ✨") }
}
