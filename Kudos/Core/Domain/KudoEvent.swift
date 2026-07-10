import Foundation

/// A single kudo the signed-in user has received or sent, derived from the
/// blockchain award history.
struct KudoEvent: Identifiable, Equatable, Sendable {
    enum Direction: String, Equatable, Sendable {
        case received
        case sent
    }

    let id: String
    /// The other party — sender for a received kudo, recipient for a sent one.
    let counterparty: String
    let direction: Direction
    let warmth: Warmth
    let note: String
    let timestamp: Date

    /// Qualitative warmth label, keeping with the app's amount-free tone.
    var warmthLabel: String { WarmthLabel.text(for: warmth.fraction) }
}
