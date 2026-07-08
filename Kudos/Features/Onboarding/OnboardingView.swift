import SwiftUI

struct OnboardingView: View {
    @Environment(SessionStore.self) private var session
    @State private var vm: OnboardingViewModel
    @State private var showInviteSheet = false

    init(session: SessionStore, onboarding: any OnboardingProviding) {
        _vm = State(initialValue: OnboardingViewModel(session: session, onboarding: onboarding))
    }

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text("Kudos")
                .font(.largeTitle.bold())
            Text("Share your appreciation with the people who matter.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Spacer()
            VStack(spacing: 16) {
                Button("I have an invite") { showInviteSheet = true }
                    .buttonStyle(.borderedProminent)
                Button("Look around first") {
                    Task { await vm.continueAsGuest() }
                }
                .foregroundStyle(.secondary)
                .font(.footnote)
            }
        }
        .padding()
        .sheet(isPresented: $showInviteSheet) {
            InviteRedeemView(vm: vm)
        }
        .alert("Something went wrong", isPresented: $vm.showError) {
            Button("OK", role: .cancel) { vm.showError = false }
        } message: {
            Text(vm.errorText)
        }
        .overlay {
            if vm.isWorking { ProgressView() }
        }
    }
}

#Preview {
    let session = SessionStore(account: PreviewAccountMock(), onboarding: PreviewOnboardMock(),
                               kudos: PreviewKudosMock(), vault: CredentialVault())
    OnboardingView(session: session, onboarding: PreviewOnboardMock())
        .environment(session)
}
