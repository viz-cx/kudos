import Foundation

@MainActor @Observable final class HomeViewModel {
    private(set) var greeting: String
    private(set) var feed: [KudoEvent] = []
    private(set) var isLoadingFeed = false
    private(set) var feedError: String?

    private let session: SessionStore
    private let feedProvider: any KudosFeedProviding

    init(session: SessionStore, feedProvider: any KudosFeedProviding) {
        self.session = session
        self.feedProvider = feedProvider
        self.greeting = Greeting.current()
    }

    var receivedCount: Int { feed.filter { $0.direction == .received }.count }

    var appreciatedSubtitle: String {
        let n = receivedCount
        if n == 0 { return String(localized: "home.appreciated.zero", defaultValue: "Send a little appreciation today") }
        let noun = n == 1 ? "person" : "people"
        return "\(n) \(noun) appreciated you"
    }

    func load() async {
        greeting = Greeting.current()
        await session.refresh()
        guard !session.username.isEmpty else { return }
        isLoadingFeed = true
        feedError = nil
        do {
            feed = try await feedProvider.feed(for: session.username, limit: 100)
        } catch {
            feedError = String(localized: "home.feed.error", defaultValue: "Couldn't load your kudos right now.")
        }
        isLoadingFeed = false
    }
}
