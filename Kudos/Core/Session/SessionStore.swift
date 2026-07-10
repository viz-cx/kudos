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
        // Only the (non-secret) username is read here, so a returning user lands
        // in the app without a Face ID prompt. The signing key is loaded lazily on
        // the first send, which is the natural moment to authenticate.
        if let username = await vault.loadUsername() {
            self.username = username
            await refresh()
            phase = .active
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
        let key = try await signingKey()
        try await kudos.send(from: username, to: receiver, warmth: warmth, note: note, regularKeyWIF: key)
        await refresh()
    }

    /// Returns the in-memory signing key, loading it from the vault (with a
    /// biometric prompt) on first use within a restored session.
    private func signingKey() async throws -> String {
        if _regularKey.isEmpty {
            guard let key = await vault.loadKey() else { throw AppError.signing }
            _regularKey = key
        }
        return _regularKey
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
