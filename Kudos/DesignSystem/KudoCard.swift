import SwiftUI

struct KudoCard: View {
    let event: KudoEvent

    private var isReceived: Bool { event.direction == .received }
    private var tint: Color { isReceived ? BrandColor.receivedTint : BrandColor.sentTint }
    private var accent: Color { isReceived ? BrandColor.receivedAccent : BrandColor.sentAccent }

    var body: some View {
        HStack(spacing: 12) {
            AvatarView(username: event.counterparty, size: 40)

            VStack(alignment: .leading, spacing: 3) {
                Text(isReceived ? "From @\(event.counterparty)" : "To @\(event.counterparty)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(BrandColor.textPrimary)
                if !event.note.isEmpty {
                    Text(event.note)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 4) {
                Image(systemName: isReceived ? "heart.fill" : "paperplane.fill")
                    .font(.caption)
                    .foregroundStyle(accent)
                Text(event.timestamp, format: .relative(presentation: .named))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(14)
        .background(tint, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(accent.opacity(0.15), lineWidth: 1)
        )
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 12) {
        KudoCard(event: KudoEvent(id: "1", counterparty: "maya", direction: .received,
            warmth: Warmth(fraction: 0.7), note: "Thanks for covering my shift!",
            timestamp: Date(timeIntervalSince1970: 1_700_100_000)))
        KudoCard(event: KudoEvent(id: "2", counterparty: "sam", direction: .sent,
            warmth: Warmth(fraction: 0.4), note: "Great presentation today.",
            timestamp: Date(timeIntervalSince1970: 1_700_000_000)))
    }
    .padding()
    .background(BrandColor.canvas)
}
#endif
