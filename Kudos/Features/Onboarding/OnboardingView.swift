import SwiftUI

struct OnboardingView: View {
    @Environment(SessionStore.self) private var session
    @State private var vm: OnboardingViewModel
    @State private var showInviteSheet = false

    init(session: SessionStore, onboarding: any OnboardingProviding) {
        _vm = State(initialValue: OnboardingViewModel(session: session, onboarding: onboarding))
    }

    var body: some View {
        ZStack {
            BrandGradient.full.ignoresSafeArea()
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: "heart.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(.white)
                    .padding(28)
                    .background(.white.opacity(0.18), in: Circle())
                Text("Kudos")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Text("Send a little gratitude to the people who make your day.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(.horizontal, 24)
                Spacer()
                VStack(spacing: 14) {
                    Button("I have an invite") { showInviteSheet = true }
                        .font(.headline)
                        .foregroundStyle(BrandColor.magenta)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(.white, in: Capsule())
                    Button("Look around first →") {
                        Task { await vm.continueAsGuest() }
                    }
                    .foregroundStyle(.white)
                    .font(.subheadline.weight(.semibold))
                }
            }
            .padding()
        }
        .sheet(isPresented: $showInviteSheet) {
            InviteRedeemView(vm: vm)
        }
        .alert("Something went wrong", isPresented: $vm.showError) {
            Button("OK", role: .cancel) { vm.showError = false }
        } message: {
            Text(vm.errorText)
        }
        .overlay {
            if vm.isWorking { ProgressView().tint(.white) }
        }
    }
}

#Preview {
    let session = SessionStore(account: PreviewAccountMock(), onboarding: PreviewOnboardMock(),
                               kudos: PreviewKudosMock(), vault: CredentialVault())
    OnboardingView(session: session, onboarding: PreviewOnboardMock())
        .environment(session)
}
