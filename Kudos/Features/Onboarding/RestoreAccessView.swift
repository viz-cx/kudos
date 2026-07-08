import SwiftUI

struct RestoreAccessView: View {
    @Bindable var vm: OnboardingViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    SecureField("Recovery code", text: $vm.recoveryCode)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                } footer: {
                    Text("Enter the recovery code you saved when you first joined.")
                }
            }
            .navigationTitle("Restore access")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Restore") {
                        Task { await vm.restore() }
                    }
                    .disabled(vm.isWorking)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    let session = SessionStore(account: PreviewAccountMock(), onboarding: PreviewOnboardMock(),
                               kudos: PreviewKudosMock(), vault: CredentialVault())
    RestoreAccessView(vm: OnboardingViewModel(session: session, onboarding: PreviewOnboardMock()))
}
