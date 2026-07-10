import Foundation

@MainActor @Observable final class ProfileViewModel {
    private(set) var username: String
    private(set) var feed: [KudoEvent] = []
    private(set) var isLoadingFeed = false
    private(set) var feedError: String?
    var profileURLString: String { "https://viz.cx/@\(username)" }

    private let session: SessionStore
    private let feedProvider: any KudosFeedProviding

    init(session: SessionStore, feedProvider: any KudosFeedProviding) {
        self.session = session
        self.feedProvider = feedProvider
        self.username = session.username
    }

    func refresh() async {
        await session.refresh()
        username = session.username
    }

    func loadFeed() async {
        guard !username.isEmpty else { return }
        isLoadingFeed = true
        feedError = nil
        do {
            feed = try await feedProvider.feed(for: username, limit: 100)
        } catch {
            feedError = String(localized: "profile.feed.error",
                               defaultValue: "Couldn't load your kudos right now.")
        }
        isLoadingFeed = false
    }
}
