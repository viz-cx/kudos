#if DEBUG
struct PreviewAccountMock: AccountProviding {
    func account(for username: String) async throws -> AccountSnapshot {
        AccountSnapshot(username: username, currentEnergyBasisPoints: 7500, effectiveVestingShares: 1)
    }
}
struct PreviewOnboardMock: OnboardingProviding {
    func register(inviteSecret: String, username: String) async throws -> Credentials { .init(username: username, regularKeyWIF: "k") }
    func demoCredentials() async throws -> Credentials { .init(username: "demo", regularKeyWIF: "k") }
}
struct PreviewKudosMock: KudosSending {
    func send(from initiator: String, to receiver: String, warmth: Warmth, note: String, regularKeyWIF: String) async throws {}
}
#endif
