#if DEBUG
import Testing
import Foundation
@testable import Kudos

private struct StubProbe: NodeProbing {
    var block: UInt32 = 42
    var shouldThrow = false
    func probe(_ address: URL) async throws -> UInt32 {
        if shouldThrow { throw AppError.network }
        return block
    }
}

private actor NoopConfiguring: NodeConfiguring {
    func reconfigure(address: URL) async {}
}

@MainActor
struct ConnectionSettingsViewModelTests {
    private func makeStore() -> NodeSettingsStore {
        let name = "test.node.\(UUID().uuidString)"
        let d = UserDefaults(suiteName: name)!
        d.removePersistentDomain(forName: name)
        return NodeSettingsStore(configuring: NoopConfiguring(), defaults: d)
    }

    @Test func successfulProbeAppliesAndRecordsBlock() async {
        let store = makeStore()
        let vm = ConnectionSettingsViewModel(store: store, prober: StubProbe(block: 100))
        let target = URL(string: "https://api.viz.world")!
        await vm.select(target)
        #expect(store.selectedURL == target)
        #expect(vm.blockHeights[target] == 100)
        #expect(vm.validating == nil)
        #expect(vm.errorText == nil)
    }

    @Test func failingProbeDoesNotApply() async {
        let store = makeStore()
        let original = store.selectedURL
        let vm = ConnectionSettingsViewModel(store: store, prober: StubProbe(shouldThrow: true))
        await vm.select(URL(string: "https://api.viz.world")!)
        #expect(store.selectedURL == original)
        #expect(vm.errorText != nil)
        #expect(vm.validating == nil)
    }

    @Test func rejectsNonHttpsCustomURL() async {
        let store = makeStore()
        let original = store.selectedURL
        let vm = ConnectionSettingsViewModel(store: store, prober: StubProbe())
        vm.customURLText = "http://insecure.example"
        await vm.connectCustom()
        #expect(vm.errorText != nil)
        #expect(store.selectedURL == original)
    }

    @Test func validateRejectsBadAndAcceptsHttps() {
        #expect(ConnectionSettingsViewModel.validate("") == nil)
        #expect(ConnectionSettingsViewModel.validate("not a url") == nil)
        #expect(ConnectionSettingsViewModel.validate("ftp://x.y") == nil)
        #expect(ConnectionSettingsViewModel.validate("https://node.viz.cx")?.absoluteString == "https://node.viz.cx")
    }
}
#endif
