import Testing
import Foundation
@testable import Kudos

struct NodeClientConformanceTests {
    @Test func nodeClientIsConfiguring() {
        let _: NodeConfiguring = NodeClient()
    }

    @Test func liveProbeIsProbing() {
        let _: NodeProbing = LiveNodeProbe()
    }
}
