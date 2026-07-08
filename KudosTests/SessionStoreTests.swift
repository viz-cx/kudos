import Testing
@testable import Kudos

@MainActor
struct SessionStoreTests {
    struct AccountMock: AccountProviding {
        func account(for username: String) async throws -> AccountSnapshot {
            AccountSnapshot(username: username, currentEnergyBasisPoints: 5000, effectiveVestingShares: 1)
        }
    }
    struct OnboardMock: OnboardingProviding {
        func register(inviteSecret: String, username: String) async throws -> Credentials { .init(username: username, regularKeyWIF: "k") }
        func demoCredentials() async throws -> Credentials { .init(username: "demo", regularKeyWIF: "k") }
    }
    final class KudosSpy: KudosSending, @unchecked Sendable {
        var sent: (String, Warmth, String)?
        func send(from: String, to: String, warmth: Warmth, note: String, regularKeyWIF: String) async throws { sent = (to, warmth, note) }
    }

    static func makeTestStore() -> SessionStore {
        SessionStore(account: AccountMock(), onboarding: OnboardMock(), kudos: KudosSpy(), vault: CredentialVault())
    }

    static func makeActiveTestStore(username: String = "alice") async -> SessionStore {
        let store = Self.makeTestStore()
        await store.completeSignIn(Credentials(username: username, regularKeyWIF: "k"))
        return store
    }

    @Test func completeSignInBecomesActiveWithBudget() async {
        let store = Self.makeTestStore()
        await store.completeSignIn(Credentials(username: "alice", regularKeyWIF: "k"))
        #expect(store.phase == .active)
        #expect(store.username == "alice")
        #expect(store.budget.fraction == 0.5)
    }

    @Test func sendKudosForwardsWarmthAndNote() async throws {
        let spy = KudosSpy()
        let store = SessionStore(account: AccountMock(), onboarding: OnboardMock(), kudos: spy, vault: CredentialVault())
        await store.completeSignIn(Credentials(username: "alice", regularKeyWIF: "k"))
        try await store.sendKudos(to: "bob", warmth: Warmth(fraction: 0.4), note: "thanks")
        #expect(spy.sent?.0 == "bob")
        #expect(spy.sent?.2 == "thanks")
    }
}
