import SwiftUI

struct MainTabView: View {
    private let people: any PeopleSearching
    private let vault: CredentialVault
    private let backend: BackendClient
    private let feed: any KudosFeedProviding

    @State private var showCompose = false

    init(people: any PeopleSearching, vault: CredentialVault, backend: BackendClient, feed: any KudosFeedProviding) {
        self.people = people
        self.vault = vault
        self.backend = backend
        self.feed = feed
    }

    var body: some View {
        TabView {
            NavigationStack {
                HomeView(feed: feed, onCompose: { showCompose = true })
            }
            .tabItem { Label("Home", systemImage: "house.fill") }

            NavigationStack {
                ProfileView()
            }
            .tabItem { Label("You", systemImage: "person.fill") }

            SettingsView(vault: vault, backend: backend)
                .tabItem { Label("Settings", systemImage: "gear") }
        }
        .tint(BrandColor.magenta)
        .sheet(isPresented: $showCompose) {
            NavigationStack {
                KudosView(people: people, onSent: { showCompose = false })
            }
        }
    }
}
