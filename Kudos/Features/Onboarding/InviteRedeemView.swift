import SwiftUI

struct InviteRedeemView: View {
    @Bindable var vm: OnboardingViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Your invite") {
                    TextField("Invite code", text: $vm.inviteCode)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                Section("Choose your name") {
                    TextField("Name (2+ characters)", text: $vm.username)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
            }
            .navigationTitle("Join Kudos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    Task { await vm.redeem() }
                } label: {
                    if vm.isWorking { ProgressView().tint(.white) } else { Text("Join Kudos") }
                }
                .buttonStyle(.primary)
                .disabled(vm.isWorking)
                .padding()
            }
        }
    }
}

#Preview {
    let session = SessionStore(account: PreviewAccountMock(), onboarding: PreviewOnboardMock(),
                               kudos: PreviewKudosMock(), vault: CredentialVault())
    InviteRedeemView(vm: OnboardingViewModel(session: session, onboarding: PreviewOnboardMock()))
}
