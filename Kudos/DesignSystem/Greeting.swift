import Foundation

enum Greeting {
    static func text(for hour: Int) -> String {
        switch hour {
        case 5..<12: return String(localized: "greeting.morning", defaultValue: "Good morning ✨")
        case 12..<18: return String(localized: "greeting.afternoon", defaultValue: "Good afternoon ✨")
        default: return String(localized: "greeting.evening", defaultValue: "Good evening ✨")
        }
    }

    /// Convenience for the current time using the user's calendar.
    static func current(now: Date = Date(), calendar: Calendar = .current) -> String {
        text(for: calendar.component(.hour, from: now))
    }
}
