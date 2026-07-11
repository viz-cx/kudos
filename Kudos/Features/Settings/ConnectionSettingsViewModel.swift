import Foundation

@MainActor @Observable final class ConnectionSettingsViewModel {
    private let store: NodeSettingsStore
    private let prober: NodeProbing

    var customURLText: String = ""
    private(set) var validating: URL? = nil
    private(set) var errorText: String? = nil
    private(set) var blockHeights: [URL: UInt32] = [:]

    init(store: NodeSettingsStore, prober: NodeProbing = LiveNodeProbe()) {
        self.store = store
        self.prober = prober
    }

    var endpoints: [NodeEndpoint] { store.endpoints }
    var selectedURL: URL { store.selectedURL }

    func select(_ url: URL) async {
        errorText = nil
        validating = url
        do {
            let block = try await prober.probe(url)
            blockHeights[url] = block
            await store.apply(url)
        } catch {
            errorText = "Couldn't reach this node."
        }
        validating = nil
    }

    func connectCustom() async {
        let trimmed = customURLText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = Self.validate(trimmed) else {
            errorText = "Enter a valid https:// address."
            return
        }
        await select(url)
    }

    static func validate(_ text: String) -> URL? {
        guard !text.isEmpty,
              let url = URL(string: text),
              url.scheme == "https",
              let host = url.host, !host.isEmpty
        else { return nil }
        return url
    }
}
