import SwiftUI

struct KudoEventRow: View {
    let event: KudoEvent

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: event.direction == .received ? "heart.fill" : "paperplane.fill")
                .foregroundStyle(event.direction == .received ? .pink : .orange)
                .font(.title3)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(event.direction == .received
                     ? "From @\(event.counterparty)"
                     : "To @\(event.counterparty)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                if !event.note.isEmpty {
                    Text(event.note)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Text(event.timestamp, format: .relative(presentation: .named))
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

#if DEBUG
#Preview {
    KudoEventRow(event: KudoEvent(
        id: "1", counterparty: "alice", direction: .received,
        warmth: Warmth(fraction: 0.6), note: "Thanks for the help!",
        timestamp: Date(timeIntervalSince1970: 1_700_000_000)
    ))
    .padding()
}
#endif
