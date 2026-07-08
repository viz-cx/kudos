import SwiftUI

struct MainTabView: View {
    private let people: any PeopleSearching
    private let vault: CredentialVault
    private let backend: BackendClient

    init(people: any PeopleSearching, vault: CredentialVault, backend: BackendClient) {
        self.people = people
        self.vault = vault
        self.backend = backend
    }

    var body: some View {
        TabView {
            NavigationStack {
                KudosView(people: people)
            }
            .tabItem { Label("Kudos", systemImage: "heart.fill") }

            NavigationStack {
                ProfileView()
            }
            .tabItem { Label("You", systemImage: "person.fill") }

            SettingsView(vault: vault, backend: backend)
                .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
}
