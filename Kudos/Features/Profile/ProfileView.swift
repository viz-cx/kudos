import SwiftUI

struct ProfileView: View {
    @Environment(SessionStore.self) private var session
    @State private var vm: ProfileViewModel?

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let vm {
                    AvatarView(username: vm.username, size: 72)
                    Text("@\(vm.username)")
                        .font(.title2.bold())
                        .foregroundStyle(BrandColor.textPrimary)

                    ProfileQRView(text: vm.profileURLString)
                        .frame(width: 220, height: 220)
                        .padding(16)
                        .background(BrandColor.surface, in: RoundedRectangle(cornerRadius: 24))

                    Text("Let people scan this to say thanks")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    Text(session.budget.isEmpty
                         ? "You've shared all your appreciation for now."
                         : "You're ready to share more appreciation.")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                } else {
                    ProgressView()
                }
            }
            .padding()
        }
        .background(BrandColor.canvas.ignoresSafeArea())
        .navigationTitle("You")
        .onAppear { if vm == nil { vm = ProfileViewModel(session: session) } }
        .task { await vm?.refresh() }
        .refreshable { await vm?.refresh() }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        ProfileView().environment(SessionStore.previewActive)
    }
}
#endif
