import Testing
@testable import Kudos

struct WarmthTests {
    @Test func fractionClampsToUnitInterval() {
        #expect(Warmth(fraction: -0.5).fraction == 0)
        #expect(Warmth(fraction: 1.5).fraction == 1)
    }
    @Test func fractionMapsToBasisPoints() {
        #expect(Warmth(fraction: 0).energyBasisPoints == 0)
        #expect(Warmth(fraction: 1).energyBasisPoints == 10000)
        #expect(Warmth(fraction: 0.5).energyBasisPoints == 5000)
    }
    @Test func basisPointsRoundTrip() {
        #expect(Warmth(energyBasisPoints: 2500).fraction == 0.25)
    }
}
