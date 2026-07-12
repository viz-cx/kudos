import Testing
@testable import Kudos

struct PeopleSearchServiceTests {
    struct LookupMock: AccountLookup {
        let names: [String]
        func lookupAccounts(prefix: String, limit: UInt32) async throws -> [String] { names }
    }

    @Test func filtersOutNamesThatDontMatchPrefix() async throws {
        // lookup_accounts returns names alphabetically from the query, so it can
        // include names past the prefix — those must be dropped.
        let service = NodePeopleSearchService(lookup: LookupMock(names: ["alice", "alparslan", "amanda"]))
        let people = try await service.search("al")
        #expect(people.map(\.username) == ["alice", "alparslan"])
    }

    @Test func emptyQueryReturnsNothing() async throws {
        let service = NodePeopleSearchService(lookup: LookupMock(names: ["alice"]))
        #expect(try await service.search("   ").isEmpty)
    }

    @Test func lowercasesAndTrimsQuery() async throws {
        let service = NodePeopleSearchService(lookup: LookupMock(names: ["bob", "bobby"]))
        let people = try await service.search("  BO ")
        #expect(people.map(\.username) == ["bob", "bobby"])
    }

    @Test func capsSuggestionCount() async throws {
        let many = (0..<20).map { "viz\($0)" }
        let service = NodePeopleSearchService(lookup: LookupMock(names: many))
        let people = try await service.search("viz")
        #expect(people.count == 8)
    }
}
