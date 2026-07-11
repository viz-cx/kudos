import Foundation

struct NodeEndpoint: Identifiable, Equatable {
    let url: URL
    var id: URL { url }
    var displayName: String { url.host ?? url.absoluteString }

    static let defaultURL = URL(string: "https://node.viz.cx")!

    static let builtIn: [NodeEndpoint] = [
        "https://api.viz.world",
        "https://mirror.viz.world",
        "https://node.viz.cx",
        "https://viz.lexai.top",
    ].compactMap { URL(string: $0) }.map { NodeEndpoint(url: $0) }
}
