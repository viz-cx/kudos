import Foundation

@MainActor @Observable final class ProfileViewModel {
    private(set) var username: String
    var profileURLString: String { "https://viz.cx/@\(username)" }

    private let session: SessionStore

    init(session: SessionStore) {
        self.session = session
        self.username = session.username
    }

    func refresh() async {
        await session.refresh()
        username = session.username
    }
}
