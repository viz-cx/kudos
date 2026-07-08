import SwiftUI
import CodeScanner

struct RecipientField: View {
    @Binding var text: String
    let suggestions: [Person]
    let onQuery: (String) -> Void
    let onScan: () -> Void

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
                    text = scan.string
                    onQuery(scan.string)
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
    RecipientField(text: $text, suggestions: people, onQuery: { _ in }, onScan: {})
        .padding()
}
