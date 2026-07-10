import KeychainAccess

actor CredentialVault {
    private static let usernameKey = "username"
    private static let regularKeyKey = "regularKey"

    /// Non-secret account identifier. Stored without biometric protection so the
    /// app can tell on launch whether a session exists without prompting Face ID.
    private let store = Keychain(service: "cx.viz.kudos")
        .accessibility(.whenUnlockedThisDeviceOnly)

    /// The signing key. Gated behind device biometrics — read only when the user
    /// actually needs it (sending kudos or revealing their recovery code).
    private let secureStore = Keychain(service: "cx.viz.kudos")
        .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: [.biometryAny])

    /// Returns the stored username, if any. Does not prompt for biometrics.
    func loadUsername() -> String? {
        try? store.getString(Self.usernameKey)
    }

    /// Returns the signing key. Triggers a biometric prompt.
    func loadKey() -> String? {
        try? secureStore.getString(Self.regularKeyKey)
    }

    /// Returns full credentials. Triggers a biometric prompt (reads the key).
    func load() -> Credentials? {
        guard let username = loadUsername(), let key = loadKey() else { return nil }
        return Credentials(username: username, regularKeyWIF: key)
    }

    func save(_ credentials: Credentials) {
        store[Self.usernameKey] = credentials.username
        secureStore[Self.regularKeyKey] = credentials.regularKeyWIF
    }

    func clear() {
        try? store.remove(Self.usernameKey)
        try? secureStore.remove(Self.regularKeyKey)
    }

    #if DEBUG
    /// Synchronously wipes stored credentials. Used only to give UI tests a clean slate on launch.
    static func resetForTesting() {
        let keychain = Keychain(service: "cx.viz.kudos")
        try? keychain.remove(usernameKey)
        try? keychain.remove(regularKeyKey)
    }
    #endif
}
