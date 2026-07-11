import SwiftUI

@main
struct KudosApp: App {
    @State private var session: SessionStore
    private let onboarding: any OnboardingProviding
    private let people: any PeopleSearching
    private let vault: CredentialVault
    private let backend: BackendClient
    private let feed: any KudosFeedProviding
    private let nodeSettings: NodeSettingsStore

    init() {
        let vault = CredentialVault()

        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("-UITEST_DEMO") {
            CredentialVault.resetForTesting()
            let onboarding = PreviewOnboardMock()
            let session = SessionStore(
                account: PreviewAccountMock(),
                onboarding: onboarding,
                kudos: PreviewKudosMock(),
                vault: vault
            )
            self._session = State(initialValue: session)
            self.onboarding = onboarding
            self.people = PreviewPeopleMock()
            self.vault = vault
            self.backend = BackendClient()
            self.feed = PreviewFeedMock()
            self.nodeSettings = NodeSettingsStore(configuring: PreviewNodeConfiguring())
            return
        }
        #endif

        let node = NodeClient(address: NodeSettingsStore.savedURL())
        let backend = BackendClient()
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
        self.feed = LiveKudosFeedService(node: node)
        self.nodeSettings = NodeSettingsStore(configuring: node)
    }

    var body: some Scene {
        WindowGroup {
            RootView(onboarding: onboarding, people: people, vault: vault, backend: backend, feed: feed)
                .environment(session)
                .environment(nodeSettings)
        }
    }
}
