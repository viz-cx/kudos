import Foundation

protocol AccountProviding: Sendable {
    func account(for username: String) async throws -> AccountSnapshot
}

struct LiveAccountService: AccountProviding {
    let node: NodeClient
    func account(for username: String) async throws -> AccountSnapshot {
        guard let acc = try await node.account(username) else {
            throw AppError.accountNotFound
        }
        return AccountSnapshot(
            username: acc.name,
            currentEnergyBasisPoints: acc.currentEnergy,
            effectiveVestingShares: acc.effectiveVestingShares
        )
    }
}
