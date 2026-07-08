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
                ToolbarItem(placement: .confirmationAction) {
                    Button("Join") {
                        Task { await vm.redeem() }
                    }
                    .disabled(vm.isWorking)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .overlay {
                if vm.isWorking { ProgressView() }
            }
        }
    }
}

#Preview {
    let session = SessionStore(account: PreviewAccountMock(), onboarding: PreviewOnboardMock(),
                               kudos: PreviewKudosMock(), vault: CredentialVault())
    InviteRedeemView(vm: OnboardingViewModel(session: session, onboarding: PreviewOnboardMock()))
}
