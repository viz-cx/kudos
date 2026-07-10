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
    var warmthLabel: String {
        switch warmth.fraction {
        case ..<0.34: return String(localized: "kudo.warmth.little", defaultValue: "A little warmth")
        case ..<0.67: return String(localized: "kudo.warmth.some", defaultValue: "A good deal of warmth")
        default: return String(localized: "kudo.warmth.lot", defaultValue: "A lot of warmth")
        }
    }
}
