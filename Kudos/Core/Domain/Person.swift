struct Person: Identifiable, Equatable, Sendable {
    var username: String
    var displayName: String?
    var id: String { username }
}
