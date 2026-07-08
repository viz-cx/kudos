import Foundation
import UIKit

@MainActor @Observable final class SettingsViewModel {
    private let session: SessionStore
    private let vault: CredentialVault
    private let backend: BackendClient

    var showRecoveryCodeAlert = false
    var recoveryCodeText: String? = nil

    var inviteLink: String? = nil
    var showInviteAlert = false

    var showError = false
    var errorText = ""

    init(session: SessionStore, vault: CredentialVault, backend: BackendClient) {
        self.session = session
        self.vault = vault
        self.backend = backend
    }

    func revealRecoveryCode() async {
        let credentials = await vault.load()
        recoveryCodeText = credentials?.regularKeyWIF
        showRecoveryCodeAlert = true
    }

    func inviteFriend() async {
        do {
            let secret = try await backend.requestInvite(member: session.username)
            inviteLink = "https://viz.cx/join?code=\(secret)"
            showInviteAlert = true
        } catch {
            errorText = "Could not create invite. Please try again."
            showError = true
        }
    }

    func copyInviteLink() {
        guard let link = inviteLink else { return }
        UIPasteboard.general.string = link
    }

    func signOut() async {
        await session.signOut()
    }
}
