protocol PeopleSearching: Sendable {
    func search(_ query: String) async throws -> [Person]
}

/// Autocompletes recipients from real on-chain accounts via the node's
/// `lookup_accounts`. That call returns names alphabetically from the query,
/// so results are prefix-filtered to keep only genuine matches.
struct NodePeopleSearchService: PeopleSearching {
    let lookup: any AccountLookup
    var suggestionLimit = 8

    func search(_ query: String) async throws -> [Person] {
        let prefix = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !prefix.isEmpty else { return [] }
        let names = try await lookup.lookupAccounts(prefix: prefix, limit: 20)
        return names
            .filter { $0.hasPrefix(prefix) }
            .prefix(suggestionLimit)
            .map { Person(username: $0, displayName: nil) }
    }
}
