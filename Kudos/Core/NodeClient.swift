import Foundation
import VIZ

protocol NodeConfiguring: Sendable {
    func reconfigure(address: URL) async
}

protocol NodeProbing: Sendable {
    func probe(_ address: URL) async throws -> UInt32
}

/// Prefix-search over existing account names. Backed by the node's
/// `database_api.lookup_accounts`; abstracted so callers can be tested
/// without a live node.
protocol AccountLookup: Sendable {
    func lookupAccounts(prefix: String, limit: UInt32) async throws -> [String]
}

/// `database_api.lookup_accounts(lower_bound_name, limit)` — returns account
/// names alphabetically from `lowerBound`, so results must be prefix-filtered
/// by the caller. The VIZ lib already routes this method to `database_api`.
struct LookupAccounts: VIZ.Request {
    typealias Response = [String]
    let method = "lookup_accounts"
    var params: RequestParams<AnyEncodable>? {
        RequestParams([AnyEncodable(lowerBound), AnyEncodable(limit)])
    }
    let lowerBound: String
    let limit: UInt32
}

actor NodeClient: NodeConfiguring, AccountLookup {
    private var client: VIZ.Client

    init(address: URL = NodeEndpoint.defaultURL) {
        client = VIZ.Client(address: address)
    }

    /// Hot-swaps the endpoint. Every service holds the same `NodeClient`
    /// reference, so their next request uses the new node.
    func reconfigure(address: URL) {
        client = VIZ.Client(address: address)
    }

    /// Validates a candidate node without disturbing the live client.
    static func probe(_ address: URL) async throws -> UInt32 {
        let probeClient = VIZ.Client(address: address)
        let props = try await probeClient.send(API.GetDynamicGlobalProperties())
        return UInt32(props.headBlockNumber)
    }

    func account(_ name: String) async throws -> API.ExtendedAccount? {
        try await client.send(API.GetAccount(account: name, customProtocolId: ""))
    }

    func accountHistory(_ name: String, from: Int = -1, limit: Int = 100) async throws -> [API.AccountHistoryObject] {
        try await client.send(API.GetAccountHistory(account: name, from: from, limit: limit))
    }

    func lookupAccounts(prefix: String, limit: UInt32 = 20) async throws -> [String] {
        try await client.send(LookupAccounts(lowerBound: prefix, limit: limit))
    }

    func broadcast(_ operation: any OperationType, signedWith key: PrivateKey) async throws {
        let props = try await client.send(API.GetDynamicGlobalProperties())
        let tx = Transaction(
            refBlockNum: UInt16(props.headBlockNumber & 0xFFFF),
            refBlockPrefix: props.headBlockId.prefix,
            expiration: props.time.addingTimeInterval(60),
            operations: [operation]
        )
        guard let stx = try? tx.sign(usingKey: key) else { throw AppError.signing }
        _ = try await client.send(API.BroadcastTransaction(transaction: stx))
    }
}

struct LiveNodeProbe: NodeProbing {
    func probe(_ address: URL) async throws -> UInt32 {
        try await NodeClient.probe(address)
    }
}
