import SwiftUI

struct RootView: View {
    @Environment(SessionStore.self) private var session
    private let onboarding: any OnboardingProviding
    private let people: any PeopleSearching
    private let vault: CredentialVault
    private let backend: BackendClient
    private let feed: any KudosFeedProviding

    init(
        onboarding: any OnboardingProviding,
        people: any PeopleSearching,
        vault: CredentialVault,
        backend: BackendClient,
        feed: any KudosFeedProviding
    ) {
        self.onboarding = onboarding
        self.people = people
        self.vault = vault
        self.backend = backend
        self.feed = feed
    }

    var body: some View {
        switch session.phase {
        case .loading:
            ProgressView()
                .task { await session.restore() }
        case .onboarding:
            OnboardingView(session: session, onboarding: onboarding)
        case .active:
            MainTabView(people: people, vault: vault, backend: backend, feed: feed)
        }
    }
}
