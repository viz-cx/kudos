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
