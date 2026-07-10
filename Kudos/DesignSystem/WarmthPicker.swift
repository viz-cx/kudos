import SwiftUI

/// A slider with a reactive heart that grows and a live qualitative label.
/// `fraction` is 0…`max`; `max` is the sender's remaining appreciation budget.
struct WarmthPicker: View {
    @Binding var fraction: Double
    let max: Double

    private var heartScale: CGFloat { 0.7 + CGFloat(min(fraction, 1)) * 0.6 }

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "heart.fill")
                .font(.system(size: 34))
                .foregroundStyle(BrandGradient.full)
                .scaleEffect(heartScale)
                .animation(.spring(response: 0.3, dampingFraction: 0.55), value: fraction)

            Text(WarmthLabel.text(for: fraction))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(BrandColor.magenta)

            Slider(value: $fraction, in: 0...Swift.max(max, 0.0001))
                .tint(BrandColor.pink)

            HStack {
                Text("a little").foregroundStyle(.secondary)
                Spacer()
                Text("all my heart").foregroundStyle(.secondary)
            }
            .font(.caption)
        }
    }
}

#Preview {
    @Previewable @State var f = 0.5
    WarmthPicker(fraction: $f, max: 0.9).padding()
}
