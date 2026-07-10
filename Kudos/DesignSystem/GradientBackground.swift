import SwiftUI

extension View {
    /// Fills the entire background (ignoring safe area) with the brand gradient.
    func brandGradientBackground() -> some View {
        background(BrandGradient.full.ignoresSafeArea())
    }
}
