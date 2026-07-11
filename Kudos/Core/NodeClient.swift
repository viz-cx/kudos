import Foundation
import VIZ

protocol NodeConfiguring: Sendable {
    func reconfigure(address: URL) async
}

protocol NodeProbing: Sendable {
    func probe(_ address: URL) async throws -> UInt32
}

actor NodeClient: NodeConfiguring {
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
