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
struct PreviewPeopleMock: PeopleSearching {
    func search(_ query: String) async throws -> [Person] {
        [
            Person(username: "alice", displayName: "Alice"),
            Person(username: "bob", displayName: nil)
        ]
    }
}
final class PreviewSessionStore: @unchecked Sendable {
    /// Returns a SessionStore populated with preview state via Task to call async setup.
    @MainActor static func makeActive() -> SessionStore {
        let store = SessionStore(
            account: PreviewAccountMock(),
            onboarding: PreviewOnboardMock(),
            kudos: PreviewKudosMock(),
            vault: CredentialVault()
        )
        Task { @MainActor in
            await store.completeSignIn(Credentials(username: "preview", regularKeyWIF: "k"))
        }
        return store
    }
}

extension SessionStore {
    /// A pre-configured active session for use in SwiftUI previews.
    @MainActor static var previewActive: SessionStore {
        PreviewSessionStore.makeActive()
    }
}
#endif
