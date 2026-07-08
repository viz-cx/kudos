import KeychainAccess

actor CredentialVault {
    private let keychain = Keychain(service: "cx.viz.kudos")
        .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: [.biometryAny])

    func load() -> Credentials? {
        guard let username = try? keychain.getString("username"),
              let key = try? keychain.getString("regularKey") else { return nil }
        return Credentials(username: username, regularKeyWIF: key)
    }

    func save(_ credentials: Credentials) {
        keychain["username"] = credentials.username
        keychain["regularKey"] = credentials.regularKeyWIF
    }

    func clear() {
        try? keychain.remove("username")
        try? keychain.remove("regularKey")
    }
}
