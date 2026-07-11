import Testing
import Foundation
@testable import Kudos

struct NodeEndpointTests {
    @Test func builtInHasFourExpectedHosts() {
        let hosts = NodeEndpoint.builtIn.map(\.displayName)
        #expect(hosts == ["api.viz.world", "mirror.viz.world", "node.viz.cx", "viz.lexai.top"])
    }

    @Test func displayNameIsHost() {
        let ep = NodeEndpoint(url: URL(string: "https://node.viz.cx")!)
        #expect(ep.displayName == "node.viz.cx")
    }

    @Test func defaultIsNodeVizCx() {
        #expect(NodeEndpoint.defaultURL.absoluteString == "https://node.viz.cx")
    }
}
