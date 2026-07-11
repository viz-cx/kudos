import Foundation
import Observation

@MainActor @Observable final class NodeSettingsStore {
    static let defaultsKey = "node.address"

    private(set) var selectedURL: URL
    let endpoints: [NodeEndpoint] = NodeEndpoint.builtIn

    private let configuring: NodeConfiguring
    private let defaults: UserDefaults

    init(configuring: NodeConfiguring, defaults: UserDefaults = .standard) {
        self.configuring = configuring
        self.defaults = defaults
        self.selectedURL = Self.savedURL(defaults)
    }

    /// The persisted node URL, or the default when none is saved. Safe to call
    /// before any store exists (used by `KudosApp` at launch).
    static func savedURL(_ defaults: UserDefaults = .standard) -> URL {
        if let saved = defaults.string(forKey: defaultsKey), let url = URL(string: saved) {
            return url
        }
        return NodeEndpoint.defaultURL
    }

    func apply(_ url: URL) async {
        defaults.set(url.absoluteString, forKey: Self.defaultsKey)
        await configuring.reconfigure(address: url)
        selectedURL = url
    }
}
