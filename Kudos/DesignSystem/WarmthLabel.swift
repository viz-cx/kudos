import Foundation

/// Qualitative warmth copy shared by compose and the feed — keeps the app's
/// amount-free tone (no raw percentages surfaced to users).
enum WarmthLabel {
    static func text(for fraction: Double) -> String {
        switch fraction {
        case ..<0.34: return String(localized: "kudo.warmth.little", defaultValue: "A little warmth")
        case ..<0.67: return String(localized: "kudo.warmth.some", defaultValue: "A good deal of warmth")
        default: return String(localized: "kudo.warmth.lot", defaultValue: "A lot of warmth")
        }
    }
}
