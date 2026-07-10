import Foundation
import VIZ

protocol KudosFeedProviding: Sendable {
    func feed(for username: String, limit: Int) async throws -> [KudoEvent]
}

/// Pure mapping from a blockchain award operation to a `KudoEvent` relative to
/// the signed-in user. Kept separate from the live service so it is unit-testable
/// without a node connection.
enum KudoFeedMapper {
    static func event(from award: VIZ.Operation.Award, id: String, timestamp: Date, for username: String) -> KudoEvent {
        let direction: KudoEvent.Direction = award.receiver == username ? .received : .sent
        let counterparty = direction == .received ? award.initiator : award.receiver
        return KudoEvent(
            id: id,
            counterparty: counterparty,
            direction: direction,
            warmth: Warmth(energyBasisPoints: award.energy),
            note: award.memo,
            timestamp: timestamp
        )
    }
}

struct LiveKudosFeedService: KudosFeedProviding {
    let node: NodeClient

    func feed(for username: String, limit: Int) async throws -> [KudoEvent] {
        let history = try await node.accountHistory(username, limit: limit)
        let events = history.compactMap { object -> KudoEvent? in
            let op = object.value
            guard let award = op.operation as? VIZ.Operation.Award else { return nil }
            let id = "\(op.block)-\(op.trxInBlock)-\(op.opInTrx)"
            return KudoFeedMapper.event(from: award, id: id, timestamp: op.timestamp, for: username)
        }
        return events.sorted { $0.timestamp > $1.timestamp }
    }
}
