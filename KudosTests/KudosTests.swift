import Testing
@testable import Kudos

struct KudosTests {
    @Test func appErrorIsLocalizedError() {
        let error = AppError.network
        #expect(error.localizedDescription.isEmpty == false)
    }
}

struct RecipientQRTests {
    @Test func extractsUsernameFromProfileURL() {
        #expect(RecipientQR.username(from: "https://viz.cx/@alice") == "alice")
    }

    @Test func stripsTrailingPathAndQuery() {
        #expect(RecipientQR.username(from: "https://viz.cx/@bob/") == "bob")
        #expect(RecipientQR.username(from: "https://viz.cx/@bob?ref=qr") == "bob")
    }

    @Test func passesThroughBareUsername() {
        #expect(RecipientQR.username(from: "carol") == "carol")
    }

    @Test func trimsWhitespace() {
        #expect(RecipientQR.username(from: "  dave  ") == "dave")
    }

    @Test func keepsHyphensAndDots() {
        #expect(RecipientQR.username(from: "https://viz.cx/@a-b.c") == "a-b.c")
    }
}
