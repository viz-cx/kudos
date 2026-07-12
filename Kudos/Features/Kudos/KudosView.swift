import SwiftUI
import ConfettiSwiftUI

struct KudosView: View {
    @Environment(SessionStore.self) private var session
    @Environment(\.dismiss) private var dismiss
    private let people: any PeopleSearching
    private let onSent: () -> Void
    @State private var vm: KudosViewModel?

    init(people: any PeopleSearching, onSent: @escaping () -> Void = {}) {
        self.people = people
        self.onSent = onSent
    }

    var body: some View {
        ZStack {
            BrandColor.canvas.ignoresSafeArea()
            if let vm { mainContent(vm: vm) }
        }
        .navigationTitle("Send kudos")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
        }
        .onAppear { if vm == nil { vm = KudosViewModel(session: session, people: people) } }
    }

    @ViewBuilder
    private func mainContent(vm: KudosViewModel) -> some View {
        @Bindable var vm = vm
        ScrollView {
            VStack(spacing: 24) {
                Text(session.budget.isEmpty
                     ? "You've given all you can for now — come back later."
                     : "Who made your day?")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                RecipientField(
                    text: $vm.recipient,
                    suggestions: vm.suggestions,
                    onQuery: { vm.queryChanged($0) },
                    onSelect: { vm.selectSuggestion($0) }
                )

                WarmthPicker(fraction: $vm.warmthFraction, max: session.budget.fraction)

                TextField("Add a note (optional)", text: $vm.note, axis: .vertical)
                    .lineLimit(3...6)
                    .padding(12)
                    .background(BrandColor.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(BrandColor.coral.opacity(0.2)))

                Button {
                    Task {
                        await vm.send()
                        if !vm.showError {
                            try? await Task.sleep(for: .milliseconds(800))
                            onSent()
                        }
                    }
                } label: {
                    if vm.isSending { ProgressView().tint(.white) } else { Text("Send with love") }
                }
                .buttonStyle(.primary)
                .disabled(vm.isSending || session.budget.isEmpty)
            }
            .padding()
        }
        .confettiCannon(counter: $vm.confettiTrigger)
        .alert("Could not send", isPresented: $vm.showError) {
            Button("OK", role: .cancel) { vm.showError = false }
        } message: {
            Text(vm.errorText)
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        KudosView(people: PreviewPeopleMock())
            .environment(SessionStore.previewActive)
    }
}
#endif
