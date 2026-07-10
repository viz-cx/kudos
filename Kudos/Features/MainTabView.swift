import SwiftUI

struct MainTabView: View {
    private let people: any PeopleSearching
    private let vault: CredentialVault
    private let backend: BackendClient
    private let feed: any KudosFeedProviding

    init(people: any PeopleSearching, vault: CredentialVault, backend: BackendClient, feed: any KudosFeedProviding) {
        self.people = people
        self.vault = vault
        self.backend = backend
        self.feed = feed
    }

    var body: some View {
        TabView {
            NavigationStack {
                KudosView(people: people)
            }
            .tabItem { Label("Kudos", systemImage: "heart.fill") }

            NavigationStack {
                ProfileView(feed: feed)
            }
            .tabItem { Label("You", systemImage: "person.fill") }

            SettingsView(vault: vault, backend: backend)
                .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
}
