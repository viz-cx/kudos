import Testing
@testable import Kudos

struct KudosTests {
    @Test func appErrorIsLocalizedError() {
        let error = AppError.network
        #expect(error.localizedDescription.isEmpty == false)
    }
}
