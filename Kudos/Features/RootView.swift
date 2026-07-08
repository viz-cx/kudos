import SwiftUI

struct RootView: View {
    @Environment(SessionStore.self) private var session
    private let onboarding: any OnboardingProviding
    private let people: any PeopleSearching
    private let vault: CredentialVault
    private let backend: BackendClient

    init(
        onboarding: any OnboardingProviding,
        people: any PeopleSearching,
        vault: CredentialVault,
        backend: BackendClient
    ) {
        self.onboarding = onboarding
        self.people = people
        self.vault = vault
        self.backend = backend
    }

    var body: some View {
        switch session.phase {
        case .loading:
            ProgressView()
                .task { await session.restore() }
        case .onboarding:
            OnboardingView(session: session, onboarding: onboarding)
        case .active:
            MainTabView(people: people, vault: vault, backend: backend)
        }
    }
}
