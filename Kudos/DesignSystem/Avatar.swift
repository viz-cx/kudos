import SwiftUI

enum Avatar {
    /// First alphanumeric character of a username, uppercased. "?" if none.
    static func initial(for username: String) -> String {
        guard let ch = username.first(where: { $0.isLetter || $0.isNumber }) else { return "?" }
        return String(ch).uppercased()
    }
}

struct AvatarView: View {
    let username: String
    var size: CGFloat = 44

    var body: some View {
        Circle()
            .fill(BrandGradient.full)
            .frame(width: size, height: size)
            .overlay(
                Text(Avatar.initial(for: username))
                    .font(.system(size: size * 0.42, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            )
    }
}

#Preview {
    HStack { AvatarView(username: "maya"); AvatarView(username: "@sam"); AvatarView(username: "") }
        .padding()
}
