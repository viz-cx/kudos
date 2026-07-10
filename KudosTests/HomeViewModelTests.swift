#if DEBUG
import Testing
import Foundation
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
struct HomeViewModelTests {
    private func events() -> [KudoEvent] {
        [
            KudoEvent(id: "1", counterparty: "maya", direction: .received,
                      warmth: Warmth(fraction: 0.7), note: "Thanks", timestamp: .init(timeIntervalSince1970: 2)),
            KudoEvent(id: "2", counterparty: "sam", direction: .sent,
                      warmth: Warmth(fraction: 0.4), note: "", timestamp: .init(timeIntervalSince1970: 1)),
            KudoEvent(id: "3", counterparty: "amir", direction: .received,
                      warmth: Warmth(fraction: 0.9), note: "", timestamp: .init(timeIntervalSince1970: 3)),
        ]
    }

    @Test func loadPopulatesFeed() async {
        let session = await SessionStore.makeActiveTestStore()
        let vm = HomeViewModel(session: session, feedProvider: StubFeed(events: events()))
        await vm.load()
        #expect(vm.feed.count == 3)
        #expect(vm.feedError == nil)
        #expect(vm.isLoadingFeed == false)
    }

    @Test func receivedCountCountsReceivedOnly() async {
        let session = await SessionStore.makeActiveTestStore()
        let vm = HomeViewModel(session: session, feedProvider: StubFeed(events: events()))
        await vm.load()
        #expect(vm.receivedCount == 2)
        #expect(vm.appreciatedSubtitle == "2 people appreciated you")
    }

    @Test func subtitleIsSingularForOne() async {
        let session = await SessionStore.makeActiveTestStore()
        let single = [KudoEvent(id: "1", counterparty: "maya", direction: .received,
                                warmth: Warmth(fraction: 0.7), note: "", timestamp: .init(timeIntervalSince1970: 1))]
        let vm = HomeViewModel(session: session, feedProvider: StubFeed(events: single))
        await vm.load()
        #expect(vm.appreciatedSubtitle == "1 person appreciated you")
    }

    @Test func loadSurfacesError() async {
        let session = await SessionStore.makeActiveTestStore()
        let vm = HomeViewModel(session: session, feedProvider: StubFeed(shouldThrow: true))
        await vm.load()
        #expect(vm.feed.isEmpty)
        #expect(vm.feedError != nil)
    }
}
#endif
