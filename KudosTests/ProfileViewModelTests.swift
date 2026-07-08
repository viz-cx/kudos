#if DEBUG
import Testing
@testable import Kudos

@MainActor
struct ProfileViewModelTests {
    @Test func profileURLUsesWebProfile() async {
        let session = await SessionStore.makeActiveTestStore()
        let vm = ProfileViewModel(session: session)
        #expect(vm.profileURLString == "https://viz.cx/@testuser")
    }

    @Test func usernameMatchesSession() async {
        let session = await SessionStore.makeActiveTestStore()
        let vm = ProfileViewModel(session: session)
        #expect(vm.username == session.username)
    }

    @Test func budgetMatchesSession() async {
        let session = await SessionStore.makeActiveTestStore()
        let vm = ProfileViewModel(session: session)
        #expect(vm.budget == session.budget)
    }
}
#endif
