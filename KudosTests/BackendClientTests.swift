import Testing
import Foundation
@testable import Kudos

struct BackendClientTests {
    @Test func decodesPeople() throws {
        let json = #"{"people":[{"username":"alice","display_name":"Alice"},{"username":"bob","display_name":null}]}"#
        let data = Data(json.utf8)
        let dto = try JSONDecoder().decode(BackendClient.PeopleResponse.self, from: data)
        let people = dto.people.map { Person(username: $0.username, displayName: $0.displayName) }
        #expect(people == [Person(username: "alice", displayName: "Alice"),
                          Person(username: "bob", displayName: nil)])
    }
}
