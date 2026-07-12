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

    @Test func searchPopulatesSuggestions() async {
        let vm = KudosViewModel(session: await .makeActiveTestStore(), people: PeopleMock())
        await vm.search("bo")
        #expect(vm.suggestions.map(\.username) == ["bob"])
    }

    @Test func queryBelowMinLengthClearsSuggestions() async {
        let vm = KudosViewModel(session: await .makeActiveTestStore(), people: PeopleMock())
        await vm.search("bo")
        #expect(!vm.suggestions.isEmpty)
        vm.queryChanged("b")
        #expect(vm.suggestions.isEmpty)
    }

    @Test func selectSuggestionFillsRecipientAndClears() async {
        let vm = KudosViewModel(session: await .makeActiveTestStore(), people: PeopleMock())
        await vm.search("bo")
        vm.selectSuggestion(Person(username: "bob", displayName: nil))
        #expect(vm.recipient == "bob")
        #expect(vm.suggestions.isEmpty)
    }

    struct PeopleMock: PeopleSearching {
        func search(_ query: String) async throws -> [Person] { [Person(username: "bob", displayName: nil)] }
    }
}
