import Testing
@testable import Kudos

struct AppErrorTests {
    @Test func messagesAreUserFriendlyAndReviewSafe() {
        let banned = ["key", "crypto", "token", "blockchain", "wallet", "energy"]
        for e in [AppError.invalidInvite, .usernameTaken, .invalidRecoveryCode,
                  .accountNotFound, .outOfAppreciation, .network, .signing, .unknown] {
            let msg = e.errorDescription ?? ""
            #expect(!msg.isEmpty)
            for word in banned { #expect(!msg.lowercased().contains(word)) }
        }
    }
}
