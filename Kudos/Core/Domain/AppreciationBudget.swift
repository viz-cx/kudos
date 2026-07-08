struct AppreciationBudget: Equatable, Sendable {
    let fraction: Double
    init(currentEnergyBasisPoints: Int) {
        fraction = min(max(Double(currentEnergyBasisPoints) / 10000, 0), 1)
    }
    var isEmpty: Bool { fraction <= 0.0001 }
    var percentText: String { "\(Int((fraction * 100).rounded()))%" }
}
