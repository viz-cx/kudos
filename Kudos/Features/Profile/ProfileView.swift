import SwiftUI

struct ProfileView: View {
    @Environment(SessionStore.self) private var session
    @State private var vm: ProfileViewModel?

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                if let vm {
                    Text("@\(vm.username)")
                        .font(.title2.bold())

                    ProfileQRView(text: vm.profileURLString)
                        .frame(width: 220, height: 220)

                    Text("Let people find you to say thanks")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    // Qualitative appreciation status — no amounts
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
        .navigationTitle("Profile")
        .onAppear {
            if vm == nil {
                vm = ProfileViewModel(session: session)
            }
        }
        .task {
            await vm?.refresh()
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environment(SessionStore.previewActive)
    }
}
