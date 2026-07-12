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

    static let minQueryLength = 2
    static let searchDebounce: Duration = .milliseconds(250)

    private var searchTask: Task<Void, Never>?
    /// Set when a suggestion is tapped so the resulting text change doesn't
    /// immediately re-open the dropdown with the just-selected name.
    private var suppressNextQuery = false

    init(session: SessionStore, people: any PeopleSearching) {
        self.session = session
        self.people = people
        self.warmthFraction = session.budget.fraction
    }

    /// Called on every keystroke: debounces, enforces a minimum length, and
    /// clears stale suggestions before dispatching the actual search.
    func queryChanged(_ query: String) {
        searchTask?.cancel()
        if suppressNextQuery {
            suppressNextQuery = false
            return
        }
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard trimmed.count >= Self.minQueryLength else {
            suggestions = []
            return
        }
        searchTask = Task { [weak self] in
            try? await Task.sleep(for: Self.searchDebounce)
            guard !Task.isCancelled else { return }
            await self?.search(trimmed)
        }
    }

    /// Fills the recipient from a tapped suggestion and closes the dropdown.
    func selectSuggestion(_ person: Person) {
        searchTask?.cancel()
        suppressNextQuery = true
        recipient = person.username
        suggestions = []
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
