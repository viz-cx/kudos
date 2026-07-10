import SwiftUI

struct KudoDetailView: View {
    let event: KudoEvent

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: event.direction == .received ? "heart.fill" : "paperplane.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(event.direction == .received ? BrandColor.receivedAccent : BrandColor.sentAccent)
                    .padding(.top, 24)

                Text(event.direction == .received
                     ? "From @\(event.counterparty)"
                     : "To @\(event.counterparty)")
                    .font(.title2.bold())

                Text(event.timestamp, format: .dateTime.weekday(.wide).day().month().year().hour().minute())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if !event.note.isEmpty {
                    Text(event.note)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(event.direction == .received ? BrandColor.receivedTint : BrandColor.sentTint)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Label(event.warmthLabel, systemImage: "flame.fill")
                    .font(.subheadline)
                    .foregroundStyle(BrandColor.coral)
            }
            .padding()
        }
        .background(BrandColor.canvas.ignoresSafeArea())
        .navigationTitle("Kudo")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        KudoDetailView(event: KudoEvent(
            id: "1", counterparty: "alice", direction: .received,
            warmth: Warmth(fraction: 0.8), note: "Thank you so much for covering my shift — you saved the day!",
            timestamp: Date(timeIntervalSince1970: 1_700_000_000)
        ))
    }
}
#endif
