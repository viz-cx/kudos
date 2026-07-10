#if DEBUG
import Testing
@testable import Kudos

private struct StubFeed: KudosFeedProviding {
    var events: [KudoEvent] = []
    var shouldThrow = false
    func feed(for username: String, limit: Int) async throws -> [KudoEvent] {
        if shouldThrow { throw AppError.network }
        return events
    }
}

@MainActor
struct ProfileViewModelTests {
    @Test func profileURLUsesWebProfile() async {
        let session = await SessionStore.makeActiveTestStore()
        let vm = ProfileViewModel(session: session, feedProvider: StubFeed())
        #expect(vm.profileURLString == "https://viz.cx/@testuser")
    }

    @Test func usernameMatchesSession() async {
        let session = await SessionStore.makeActiveTestStore()
        let vm = ProfileViewModel(session: session, feedProvider: StubFeed())
        #expect(vm.username == session.username)
    }

    @Test func loadFeedPopulatesEvents() async {
        let session = await SessionStore.makeActiveTestStore()
        let events = [
            KudoEvent(id: "1", counterparty: "alice", direction: .received,
                      warmth: Warmth(fraction: 0.5), note: "Thanks",
                      timestamp: .init(timeIntervalSince1970: 1))
        ]
        let vm = ProfileViewModel(session: session, feedProvider: StubFeed(events: events))
        await vm.loadFeed()
        #expect(vm.feed.count == 1)
        #expect(vm.feed.first?.counterparty == "alice")
        #expect(vm.feedError == nil)
        #expect(vm.isLoadingFeed == false)
    }

    @Test func loadFeedSurfacesError() async {
        let session = await SessionStore.makeActiveTestStore()
        let vm = ProfileViewModel(session: session, feedProvider: StubFeed(shouldThrow: true))
        await vm.loadFeed()
        #expect(vm.feed.isEmpty)
        #expect(vm.feedError != nil)
    }
}
#endif
