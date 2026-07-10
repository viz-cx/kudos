import SwiftUI

struct SettingsView: View {
    @Environment(SessionStore.self) private var session
    @State private var vm: SettingsViewModel?
    private let vault: CredentialVault
    private let backend: BackendClient

    init(vault: CredentialVault, backend: BackendClient) {
        self.vault = vault
        self.backend = backend
    }

    var body: some View {
        NavigationStack {
            Group {
                if let vm {
                    content(vm: vm)
                } else {
                    ProgressView()
                }
            }
            .onAppear {
                if vm == nil {
                    vm = SettingsViewModel(session: session, vault: vault, backend: backend)
                }
            }
        }
    }

    @ViewBuilder
    private func content(vm: SettingsViewModel) -> some View {
        Form {
            Section("Account") {
                Button("Show recovery code") {
                    Task { await vm.revealRecoveryCode() }
                }
                Button("Invite a friend") {
                    Task { await vm.inviteFriend() }
                }
            }
            Section("Advanced") {
                NavigationLink("Connection settings") {
                    Text("Connection configuration coming soon.")
                        .foregroundStyle(.secondary)
                        .padding()
                        .navigationTitle("Connection settings")
                }
            }
            Section {
                Button("Sign out", role: .destructive) {
                    Task { await vm.signOut() }
                }
            }
            Section("About") {
                Link("Privacy Policy", destination: URL(string: "https://viz-cx.github.io/kudos/privacy/")!)
                Link("Support", destination: URL(string: "https://viz-cx.github.io/kudos/support/")!)
            }
        }
        .navigationTitle("Settings")
        .alert("Recovery code", isPresented: Bindable(vm).showRecoveryCodeAlert) {
            Button("Copy") {
                if let code = vm.recoveryCodeText {
                    UIPasteboard.general.string = code
                }
            }
            Button("OK", role: .cancel) {
                vm.recoveryCodeText = nil
            }
        } message: {
            Text(vm.recoveryCodeText ?? "Not available")
        }
        .alert("Invite link ready", isPresented: Bindable(vm).showInviteAlert) {
            Button("Copy link") {
                vm.copyInviteLink()
            }
            Button("OK", role: .cancel) {}
        } message: {
            Text(vm.inviteLink ?? "")
        }
        .alert("Something went wrong", isPresented: Bindable(vm).showError) {
            Button("OK", role: .cancel) { vm.showError = false }
        } message: {
            Text(vm.errorText)
        }
    }
}

#Preview {
    SettingsView(vault: CredentialVault(), backend: BackendClient())
        .environment(SessionStore.previewActive)
}
