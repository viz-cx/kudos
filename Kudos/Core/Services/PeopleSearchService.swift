protocol PeopleSearching: Sendable {
    func search(_ query: String) async throws -> [Person]
}

struct LivePeopleSearchService: PeopleSearching {
    let backend: BackendClient
    func search(_ query: String) async throws -> [Person] {
        try await backend.search(query)
    }
}
