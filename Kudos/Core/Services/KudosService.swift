import VIZ

protocol KudosSending: Sendable {
    func send(from initiator: String, to receiver: String, warmth: Warmth, note: String, regularKeyWIF: String) async throws
}

struct LiveKudosService: KudosSending {
    let node: NodeClient
    func send(from initiator: String, to receiver: String, warmth: Warmth,
              note: String, regularKeyWIF: String) async throws {
        guard let key = PrivateKey(regularKeyWIF) else { throw AppError.signing }
        let award = VIZ.Operation.Award(
            initiator: initiator, receiver: receiver,
            energy: warmth.energyBasisPoints, customSequence: 0,
            memo: note, beneficiaries: []
        )
        try await node.broadcast(award, signedWith: key)
    }
}
