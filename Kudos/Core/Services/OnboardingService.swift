import VIZ

protocol OnboardingProviding: Sendable {
    func register(inviteSecret: String, username: String) async throws -> Credentials
    func demoCredentials() async throws -> Credentials
}

struct LiveOnboardingService: OnboardingProviding {
    let backend: BackendClient
    func register(inviteSecret: String, username: String) async throws -> Credentials {
        guard let key = PrivateKey(seed: SecureRandom.seed()) else { throw AppError.unknown }
        let publicKey = String(describing: key.createPublic())
        try await backend.register(inviteSecret: inviteSecret, username: username, publicKey: publicKey)
        return Credentials(username: username, regularKeyWIF: key.wif)
    }
    func demoCredentials() async throws -> Credentials {
        let d = try await backend.demoSession()
        return Credentials(username: d.username, regularKeyWIF: d.regularKeyWIF)
    }
}
