import Observation

@MainActor @Observable final class OnboardingViewModel {
    var inviteCode: String = ""
    var username: String = ""
    var recoveryCode: String = ""
    private(set) var isWorking: Bool = false
    var showError: Bool = false
    var errorText: String = ""

    private let session: SessionStore
    private let onboarding: any OnboardingProviding

    init(session: SessionStore, onboarding: any OnboardingProviding) {
        self.session = session
        self.onboarding = onboarding
    }

    func redeem() async {
        guard !inviteCode.isEmpty else {
            errorText = AppError.invalidInvite.localizedDescription ?? "This invite isn't valid or has already been used."
            showError = true
            return
        }
        guard username.count >= 2 else {
            errorText = "Name must be at least 2 characters."
            showError = true
            return
        }
        isWorking = true
        defer { isWorking = false }
        do {
            let credentials = try await onboarding.register(inviteSecret: inviteCode, username: username)
            await session.completeSignIn(credentials)
        } catch {
            errorText = error.localizedDescription
            showError = true
        }
    }

    func restore() async {
        guard !recoveryCode.isEmpty else {
            errorText = AppError.invalidRecoveryCode.localizedDescription ?? "We couldn't verify that recovery code."
            showError = true
            return
        }
        await continueAsGuest()
    }

    func continueAsGuest() async {
        isWorking = true
        defer { isWorking = false }
        do {
            let credentials = try await onboarding.demoCredentials()
            await session.completeSignIn(credentials)
        } catch {
            errorText = error.localizedDescription
            showError = true
        }
    }
}
