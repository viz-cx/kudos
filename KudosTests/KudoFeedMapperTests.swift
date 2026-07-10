#if DEBUG
import Testing
import Foundation
import VIZ
@testable import Kudos

struct KudoFeedMapperTests {
    private func award(initiator: String, receiver: String, energy: UInt16, memo: String) -> VIZ.Operation.Award {
        VIZ.Operation.Award(
            initiator: initiator, receiver: receiver,
            energy: energy, customSequence: 0, memo: memo, beneficiaries: []
        )
    }

    @Test func receivedAwardMapsCounterpartyToInitiator() {
        let op = award(initiator: "alice", receiver: "me", energy: 5000, memo: "thanks")
        let event = KudoFeedMapper.event(from: op, id: "x", timestamp: .init(timeIntervalSince1970: 1), for: "me")
        #expect(event.direction == .received)
        #expect(event.counterparty == "alice")
        #expect(event.note == "thanks")
        #expect(event.warmth.fraction == 0.5)
    }

    @Test func sentAwardMapsCounterpartyToReceiver() {
        let op = award(initiator: "me", receiver: "bob", energy: 2500, memo: "great job")
        let event = KudoFeedMapper.event(from: op, id: "y", timestamp: .init(timeIntervalSince1970: 2), for: "me")
        #expect(event.direction == .sent)
        #expect(event.counterparty == "bob")
        #expect(event.warmth.fraction == 0.25)
    }

    @Test func warmthLabelIsQualitative() {
        let low = KudoEvent(id: "1", counterparty: "a", direction: .sent, warmth: Warmth(fraction: 0.1), note: "", timestamp: .init(timeIntervalSince1970: 0))
        let high = KudoEvent(id: "2", counterparty: "a", direction: .sent, warmth: Warmth(fraction: 0.95), note: "", timestamp: .init(timeIntervalSince1970: 0))
        #expect(low.warmthLabel != high.warmthLabel)
    }
}
#endif
