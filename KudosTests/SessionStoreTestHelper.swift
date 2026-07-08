#if DEBUG
import Testing
@testable import Kudos

extension SessionStore {
    @MainActor
    static func makeActiveTestStore() async -> SessionStore {
        let store = SessionStore(
            account: PreviewAccountMock(),
            onboarding: PreviewOnboardMock(),
            kudos: PreviewKudosMock(),
            vault: CredentialVault()
        )
        await store.completeSignIn(Credentials(username: "testuser", regularKeyWIF: "k"))
        return store
    }
}
#endif
