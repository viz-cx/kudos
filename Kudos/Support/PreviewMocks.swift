#if DEBUG
import Foundation

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
struct PreviewFeedMock: KudosFeedProviding {
    func feed(for username: String, limit: Int) async throws -> [KudoEvent] {
        [
            KudoEvent(id: "1", counterparty: "alice", direction: .received,
                      warmth: Warmth(fraction: 0.7), note: "Thanks for the help on the launch!",
                      timestamp: Date(timeIntervalSince1970: 1_700_100_000)),
            KudoEvent(id: "2", counterparty: "bob", direction: .sent,
                      warmth: Warmth(fraction: 0.4), note: "Great presentation today.",
                      timestamp: Date(timeIntervalSince1970: 1_700_000_000)),
            KudoEvent(id: "3", counterparty: "carol", direction: .received,
                      warmth: Warmth(fraction: 0.9), note: "",
                      timestamp: Date(timeIntervalSince1970: 1_699_900_000))
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
