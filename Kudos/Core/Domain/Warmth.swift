struct Warmth: Equatable, Sendable {
    let fraction: Double
    init(fraction: Double) { self.fraction = min(max(fraction, 0), 1) }
    init(energyBasisPoints: UInt16) { self.init(fraction: Double(energyBasisPoints) / 10000) }
    var energyBasisPoints: UInt16 { UInt16((fraction * 10000).rounded()) }
}
