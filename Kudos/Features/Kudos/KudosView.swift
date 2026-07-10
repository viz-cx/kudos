import SwiftUI
import ConfettiSwiftUI

struct KudosView: View {
    @Environment(SessionStore.self) private var session
    private let people: any PeopleSearching
    @State private var vm: KudosViewModel?

    init(people: any PeopleSearching) {
        self.people = people
    }

    var body: some View {
        ZStack {
            if let vm {
                mainContent(vm: vm)
            }
        }
        .onAppear {
            if vm == nil {
                vm = KudosViewModel(session: session, people: people)
            }
        }
    }

    @ViewBuilder
    private func mainContent(vm: KudosViewModel) -> some View {
        @Bindable var vm = vm
        ScrollView {
            VStack(spacing: 24) {
                Text(session.budget.isEmpty
                     ? "You've given all you can for now — come back later."
                     : "You have plenty of appreciation to give.")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                RecipientField(
                    text: $vm.recipient,
                    suggestions: vm.suggestions,
                    onQuery: { q in Task { await vm.search(q) } }
                )

                WarmthSlider(fraction: $vm.warmthFraction, max: session.budget.fraction)

                TextField("Add a note (optional)", text: $vm.note, axis: .vertical)
                    .lineLimit(3...6)
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Button {
                    Task { await vm.send() }
                } label: {
                    Group {
                        if vm.isSending {
                            ProgressView()
                        } else {
                            Text("Send kudos")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(vm.isSending || session.budget.isEmpty)
            }
            .padding()
        }
        .navigationTitle("Kudos")
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
