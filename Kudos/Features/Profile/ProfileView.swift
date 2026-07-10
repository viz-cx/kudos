import SwiftUI

struct ProfileView: View {
    @Environment(SessionStore.self) private var session
    private let feed: any KudosFeedProviding
    @State private var vm: ProfileViewModel?

    init(feed: any KudosFeedProviding) {
        self.feed = feed
    }

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

                    feedSection(vm: vm)
                } else {
                    ProgressView()
                }
            }
            .padding()
        }
        .navigationTitle("Profile")
        .onAppear {
            if vm == nil {
                vm = ProfileViewModel(session: session, feedProvider: feed)
            }
        }
        .task {
            await vm?.refresh()
            await vm?.loadFeed()
        }
        .refreshable {
            await vm?.refresh()
            await vm?.loadFeed()
        }
    }

    @ViewBuilder
    private func feedSection(vm: ProfileViewModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your kudos")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            if vm.isLoadingFeed && vm.feed.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
            } else if let error = vm.feedError, vm.feed.isEmpty {
                Text(error)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
            } else if vm.feed.isEmpty {
                Text("No kudos yet. Send some appreciation to get started.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
            } else {
                ForEach(vm.feed) { event in
                    NavigationLink {
                        KudoDetailView(event: event)
                    } label: {
                        KudoEventRow(event: event)
                    }
                    .buttonStyle(.plain)
                    Divider()
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        ProfileView(feed: PreviewFeedMock())
            .environment(SessionStore.previewActive)
    }
}
#endif
