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
        let session = SessionStore(
            account: LiveAccountService(node: node),
            onboarding: LiveOnboardingService(backend: backend),
            kudos: LiveKudosService(node: node),
            vault: vault
        )
        self._session = State(initialValue: session)
        self.onboarding = LiveOnboardingService(backend: backend)
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
