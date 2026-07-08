import Foundation

enum AppError: Error, LocalizedError, Equatable {
    case invalidInvite, usernameTaken, invalidRecoveryCode
    case accountNotFound, outOfAppreciation, network, signing, unknown

    var errorDescription: String? {
        switch self {
        case .invalidInvite:       String(localized: "This invite isn't valid or has already been used.")
        case .usernameTaken:       String(localized: "That name is taken. Try another.")
        case .invalidRecoveryCode: String(localized: "We couldn't verify that recovery code.")
        case .accountNotFound:     String(localized: "We couldn't find that person.")
        case .outOfAppreciation:   String(localized: "You're out of appreciation for now — it refills over time.")
        case .network:             String(localized: "Something went wrong. Check your connection and try again.")
        case .signing:             String(localized: "We couldn't send that. Please try again.")
        case .unknown:             String(localized: "Something went wrong. Please try again.")
        }
    }
}
