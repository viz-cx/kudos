import Foundation
import VIZ

actor NodeClient {
    private let client: VIZ.Client

    init(address: URL = URL(string: "https://node.viz.cx")!) {
        client = VIZ.Client(address: address)
    }

    func account(_ name: String) async throws -> API.ExtendedAccount? {
        try await client.send(API.GetAccount(account: name, customProtocolId: ""))
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
