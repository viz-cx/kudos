import SwiftUI

struct WarmthSlider: View {
    @Binding var fraction: Double
    let max: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Slider(value: $fraction, in: 0...max)
                .tint(.orange)
            HStack {
                Text("a little").foregroundStyle(.secondary)
                Spacer()
                Text("a lot").foregroundStyle(.secondary)
            }
            .font(.caption)
        }
    }
}

#Preview {
    @Previewable @State var fraction = 0.5
    WarmthSlider(fraction: $fraction, max: 0.8)
        .padding()
}
