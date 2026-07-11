#if DEBUG
import Testing
import Foundation
@testable import Kudos

private actor SpyConfiguring: NodeConfiguring {
    private(set) var addresses: [URL] = []
    func reconfigure(address: URL) async { addresses.append(address) }
}

@MainActor
struct NodeSettingsStoreTests {
    private func freshDefaults() -> UserDefaults {
        let name = "test.node.\(UUID().uuidString)"
        let d = UserDefaults(suiteName: name)!
        d.removePersistentDomain(forName: name)
        return d
    }

    @Test func fallsBackToDefaultWhenEmpty() {
        let store = NodeSettingsStore(configuring: SpyConfiguring(), defaults: freshDefaults())
        #expect(store.selectedURL == NodeEndpoint.defaultURL)
    }

    @Test func loadsPersistedURL() {
        let d = freshDefaults()
        d.set("https://mirror.viz.world", forKey: NodeSettingsStore.defaultsKey)
        let store = NodeSettingsStore(configuring: SpyConfiguring(), defaults: d)
        #expect(store.selectedURL.absoluteString == "https://mirror.viz.world")
    }

    @Test func applyPersistsAndReconfigures() async {
        let spy = SpyConfiguring()
        let d = freshDefaults()
        let store = NodeSettingsStore(configuring: spy, defaults: d)
        let target = URL(string: "https://api.viz.world")!
        await store.apply(target)
        #expect(store.selectedURL == target)
        #expect(d.string(forKey: NodeSettingsStore.defaultsKey) == "https://api.viz.world")
        let recorded = await spy.addresses
        #expect(recorded == [target])
    }
}
#endif
