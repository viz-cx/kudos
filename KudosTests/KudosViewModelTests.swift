import Testing
@testable import Kudos

@MainActor
struct KudosViewModelTests {
    @Test func sendRejectsEmptyRecipient() async {
        let vm = KudosViewModel(session: await .makeActiveTestStore(), people: PeopleMock())
        vm.recipient = ""; vm.warmthFraction = 0.5
        await vm.send()
        #expect(vm.showError)
    }

    @Test func successfulSendTriggersConfettiAndClears() async {
        let vm = KudosViewModel(session: await .makeActiveTestStore(), people: PeopleMock())
        vm.recipient = "bob"; vm.note = "thanks"; vm.warmthFraction = 0.5
        await vm.send()
        #expect(!vm.showError)
        #expect(vm.confettiTrigger == 1)
        #expect(vm.recipient.isEmpty)
    }

    struct PeopleMock: PeopleSearching {
        func search(_ query: String) async throws -> [Person] { [Person(username: "bob", displayName: nil)] }
    }
}
