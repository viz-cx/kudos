import Testing
@testable import Kudos

struct KudosTests {
    @Test func appErrorIsLocalizedError() {
        let error = AppError.network("timeout")
        #expect(error.localizedDescription.isEmpty == false)
    }
}
