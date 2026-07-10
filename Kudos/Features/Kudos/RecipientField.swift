import SwiftUI
import CodeScanner

/// Extracts a VIZ username from a scanned QR payload. Profile QRs encode a full
/// URL like "https://viz.cx/@alice"; this returns the bare username ("alice"),
/// while a plain scanned username passes through unchanged.
enum RecipientQR {
    static func username(from payload: String) -> String {
        let trimmed = payload.trimmingCharacters(in: .whitespacesAndNewlines)
        if let atRange = trimmed.range(of: "@", options: .backwards) {
            let token = trimmed[atRange.upperBound...]
                .prefix { $0.isLetter || $0.isNumber || $0 == "." || $0 == "-" }
            if !token.isEmpty { return String(token) }
        }
        return trimmed
    }
}

struct RecipientField: View {
    @Binding var text: String
    let suggestions: [Person]
    let onQuery: (String) -> Void

    @State private var showScanner = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                TextField("Find someone", text: $text)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .onChange(of: text) { _, newValue in
                        onQuery(newValue)
                    }
                Button(action: { showScanner = true }) {
                    Image(systemName: "qrcode.viewfinder")
                        .foregroundStyle(.secondary)
                }
            }
            .padding(12)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            if !suggestions.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(suggestions) { person in
                        Button {
                            text = person.username
                            onQuery("")
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(person.displayName ?? person.username)
                                    .foregroundStyle(.primary)
                                if person.displayName != nil {
                                    Text("@\(person.username)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                        }
                        Divider()
                    }
                }
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.top, 4)
            }
        }
        .sheet(isPresented: $showScanner) {
            CodeScannerView(codeTypes: [.qr]) { result in
                showScanner = false
                if case .success(let scan) = result {
                    let username = RecipientQR.username(from: scan.string)
                    text = username
                    onQuery(username)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var text = ""
    let people = [
        Person(username: "alice", displayName: "Alice"),
        Person(username: "bob", displayName: nil)
    ]
    RecipientField(text: $text, suggestions: people, onQuery: { _ in })
        .padding()
}
