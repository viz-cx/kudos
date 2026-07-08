import Observation

@MainActor @Observable final class KudosViewModel {
    var recipient: String = ""
    var note: String = ""
    var warmthFraction: Double
    private(set) var suggestions: [Person] = []
    private(set) var isSending: Bool = false
    var confettiTrigger: Int = 0
    var showError: Bool = false
    var errorText: String = ""

    private let session: SessionStore
    private let people: any PeopleSearching

    init(session: SessionStore, people: any PeopleSearching) {
        self.session = session
        self.people = people
        self.warmthFraction = session.budget.fraction
    }

    func search(_ query: String) async {
        do {
            suggestions = try await people.search(query)
        } catch {
            suggestions = []
        }
    }

    func send() async {
        guard !recipient.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorText = String(localized: "kudos.error.emptyRecipient", defaultValue: "Please enter a recipient.")
            showError = true
            return
        }
        guard warmthFraction > 0 else {
            errorText = String(localized: "kudos.error.zeroWarmth", defaultValue: "Please set an appreciation amount greater than zero.")
            showError = true
            return
        }
        guard !isSending else { return }
        isSending = true
        showError = false
        do {
            try await session.sendKudos(to: recipient, warmth: Warmth(fraction: warmthFraction), note: note)
            confettiTrigger += 1
            recipient = ""
            note = ""
            warmthFraction = session.budget.fraction
        } catch {
            errorText = error.localizedDescription
            showError = true
        }
        isSending = false
    }
}
