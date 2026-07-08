import Observation

@MainActor @Observable final class SessionStore {
    enum Phase: Equatable {
        case loading, onboarding, active
    }

    private(set) var phase: Phase = .loading
    private(set) var username: String = ""
    private(set) var budget: AppreciationBudget = AppreciationBudget(currentEnergyBasisPoints: 0)

    private var _regularKey: String = ""

    private let account: any AccountProviding
    private let onboarding: any OnboardingProviding
    private let kudos: any KudosSending
    private let vault: CredentialVault

    init(account: any AccountProviding, onboarding: any OnboardingProviding, kudos: any KudosSending, vault: CredentialVault) {
        self.account = account
        self.onboarding = onboarding
        self.kudos = kudos
        self.vault = vault
    }

    func restore() async {
        let credentials = await vault.load()
        if let credentials {
            await completeSignIn(credentials)
        } else {
            phase = .onboarding
        }
    }

    func completeSignIn(_ credentials: Credentials) async {
        await vault.save(credentials)
        _regularKey = credentials.regularKeyWIF
        username = credentials.username
        await refresh()
        phase = .active
    }

    func sendKudos(to receiver: String, warmth: Warmth, note: String) async throws {
        guard !_regularKey.isEmpty else { throw AppError.signing }
        try await kudos.send(from: username, to: receiver, warmth: warmth, note: note, regularKeyWIF: _regularKey)
        await refresh()
    }

    func refresh() async {
        guard !username.isEmpty else { return }
        if let snapshot = try? await account.account(for: username) {
            budget = AppreciationBudget(currentEnergyBasisPoints: snapshot.currentEnergyBasisPoints)
        }
    }

    func signOut() async {
        await vault.clear()
        username = ""
        _regularKey = ""
        phase = .onboarding
    }
}
