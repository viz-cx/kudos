import Foundation

struct BackendClient: Sendable {
    private let baseURL: URL
    private let session: URLSession

    init(baseURL: URL = URL(string: "https://viz.cx/api")!, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    // MARK: - Public API

    func register(inviteSecret: String, username: String, publicKey: String) async throws {
        let body = RegisterRequest(
            inviteSecret: inviteSecret,
            newAccountName: username,
            newAccountPublicKey: publicKey
        )
        var request = URLRequest(url: baseURL.appendingPathComponent("register"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        try await sendVoid(request)
    }

    func demoSession() async throws -> (username: String, regularKeyWIF: String) {
        var request = URLRequest(url: baseURL.appendingPathComponent("demo"))
        request.httpMethod = "POST"
        let response: DemoResponse = try await send(request)
        return (username: response.username, regularKeyWIF: response.regularKeyWIF)
    }

    func search(_ query: String) async throws -> [Person] {
        var components = URLComponents(url: baseURL.appendingPathComponent("people"), resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "q", value: query)]
        let request = URLRequest(url: components.url!)
        let response: PeopleResponse = try await send(request)
        return response.people.map { Person(username: $0.username, displayName: $0.displayName) }
    }

    func requestInvite(member: String) async throws -> String {
        var components = URLComponents(url: baseURL.appendingPathComponent("invite"), resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "member", value: member)]
        let request = URLRequest(url: components.url!)
        let response: InviteResponse = try await send(request)
        return response.claimSecret
    }

    // MARK: - Nested DTOs

    struct PeopleResponse: Decodable {
        let people: [PersonDTO]

        struct PersonDTO: Decodable {
            let username: String
            let displayName: String?

            enum CodingKeys: String, CodingKey {
                case username
                case displayName = "display_name"
            }
        }
    }

    struct DemoResponse: Decodable {
        let username: String
        let regularKeyWIF: String

        enum CodingKeys: String, CodingKey {
            case username
            case regularKeyWIF = "regular_key_wif"
        }
    }

    struct RegisterRequest: Encodable {
        let inviteSecret: String
        let newAccountName: String
        let newAccountPublicKey: String

        enum CodingKeys: String, CodingKey {
            case inviteSecret = "invite_secret"
            case newAccountName = "new_account_name"
            case newAccountPublicKey = "new_account_public_key"
        }
    }

    struct InviteResponse: Decodable {
        let claimSecret: String

        enum CodingKeys: String, CodingKey {
            case claimSecret = "claim_secret"
        }
    }

    // MARK: - Private helpers

    private func send<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw AppError.network }
        switch http.statusCode {
        case 200..<300: break
        case 409: throw AppError.usernameTaken
        case 400: throw AppError.invalidInvite
        case 429: throw AppError.outOfAppreciation
        default: throw AppError.network
        }
        return try JSONDecoder().decode(T.self, from: data)
    }

    private func sendVoid(_ request: URLRequest) async throws {
        let (_, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw AppError.network }
        switch http.statusCode {
        case 200..<300: break
        case 409: throw AppError.usernameTaken
        case 400: throw AppError.invalidInvite
        case 429: throw AppError.outOfAppreciation
        default: throw AppError.network
        }
    }
}
