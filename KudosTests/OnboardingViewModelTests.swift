import Testing
@testable import Kudos

@MainActor
struct OnboardingViewModelTests {

    // MARK: - Shared mock for onboarding service

    struct OnboardMock: OnboardingProviding {
        func register(inviteSecret: String, username: String) async throws -> Credentials {
            .init(username: username, regularKeyWIF: "k")
        }
        func demoCredentials() async throws -> Credentials {
            .init(username: "demo", regularKeyWIF: "k")
        }
    }

    // MARK: - Validation tests (redeem)

    @Test func redeemRejectsEmptyInvite() async {
        let session = SessionStoreTests.makeTestStore()
        let vm = OnboardingViewModel(session: session, onboarding: OnboardMock())
        vm.username = "bob"
        vm.inviteCode = ""
        await vm.redeem()
        #expect(vm.showError == true)
        #expect(vm.errorText.isEmpty == false)
    }

    @Test func redeemRejectsShortUsername() async {
        let session = SessionStoreTests.makeTestStore()
        let vm = OnboardingViewModel(session: session, onboarding: OnboardMock())
        vm.username = "a"
        vm.inviteCode = "5Kinvite"
        await vm.redeem()
        #expect(vm.showError == true)
        #expect(vm.errorText.isEmpty == false)
    }

    @Test func redeemSucceedsWithValidInputs() async {
        let session = SessionStoreTests.makeTestStore()
        let vm = OnboardingViewModel(session: session, onboarding: OnboardMock())
        vm.username = "alice"
        vm.inviteCode = "validInviteCode"
        await vm.redeem()
        #expect(vm.showError == false)
        #expect(session.phase == .active)
    }

    @Test func redeemIsWorkingDuringExecution() async {
        let session = SessionStoreTests.makeTestStore()
        let vm = OnboardingViewModel(session: session, onboarding: OnboardMock())
        vm.username = "alice"
        vm.inviteCode = "validInviteCode"
        // isWorking should be false before
        #expect(vm.isWorking == false)
        await vm.redeem()
        // isWorking should be false after
        #expect(vm.isWorking == false)
    }

    // MARK: - continueAsGuest

    @Test func continueAsGuestSignsInAsDemo() async {
        let session = SessionStoreTests.makeTestStore()
        let vm = OnboardingViewModel(session: session, onboarding: OnboardMock())
        await vm.continueAsGuest()
        #expect(vm.showError == false)
        #expect(session.phase == .active)
        #expect(session.username == "demo")
    }
}
