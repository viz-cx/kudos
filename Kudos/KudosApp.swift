import SwiftUI

@main
struct KudosApp: App {
    @State private var session: SessionStore
    private let onboarding: any OnboardingProviding
    private let people: any PeopleSearching
    private let vault: CredentialVault
    private let backend: BackendClient

    init() {
        let node = NodeClient()
        let backend = BackendClient()
        let vault = CredentialVault()
        let onboarding = LiveOnboardingService(backend: backend)
        let session = SessionStore(
            account: LiveAccountService(node: node),
            onboarding: onboarding,
            kudos: LiveKudosService(node: node),
            vault: vault
        )
        self._session = State(initialValue: session)
        self.onboarding = onboarding
        self.people = LivePeopleSearchService(backend: backend)
        self.vault = vault
        self.backend = backend
    }

    var body: some Scene {
        WindowGroup {
            RootView(onboarding: onboarding, people: people, vault: vault, backend: backend)
                .environment(session)
        }
    }
}
