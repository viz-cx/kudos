struct AccountSnapshot: Sendable {
    let username: String
    let currentEnergyBasisPoints: Int
    let effectiveVestingShares: Double
}
