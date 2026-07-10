import SwiftUI

enum BrandColor {
    static let coral = Color(hex: 0xFF7A59)
    static let pink = Color(hex: 0xFF4D8D)
    static let magenta = Color(hex: 0xC724B1)

    static let canvas = Color(hex: 0xFFF3EC)
    static let surface = Color(hex: 0xFFF8F4)
    static let textPrimary = Color(hex: 0x1A1414)

    static let receivedAccent = pink
    static let sentAccent = coral
    static let receivedTint = Color(hex: 0xFFEEF4)
    static let sentTint = Color(hex: 0xFFEFE6)
}

enum BrandGradient {
    static let full = LinearGradient(
        colors: [BrandColor.coral, BrandColor.pink, BrandColor.magenta],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
