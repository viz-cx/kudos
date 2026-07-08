import Testing
@testable import Kudos

struct SecureRandomTests {
    @Test func seedIs64HexCharsAndUnique() {
        let a = SecureRandom.seed(), b = SecureRandom.seed()
        #expect(a.count == 64)
        #expect(a.allSatisfy { "0123456789abcdef".contains($0) })
        #expect(a != b)
    }
}
