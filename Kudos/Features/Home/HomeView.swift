import SwiftUI

struct HomeView: View {
    @Environment(SessionStore.self) private var session
    private let feed: any KudosFeedProviding
    private let onCompose: () -> Void
    @State private var vm: HomeViewModel?

    init(feed: any KudosFeedProviding, onCompose: @escaping () -> Void) {
        self.feed = feed
        self.onCompose = onCompose
    }

    var body: some View {
        ScrollView {
            if let vm {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(vm.greeting)
                            .font(.largeTitle.bold())
                            .foregroundStyle(BrandColor.magenta)
                        Text(vm.appreciatedSubtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Button(action: onCompose) {
                        Label("Send kudos", systemImage: "plus")
                    }
                    .buttonStyle(.primary)

                    feedSection(vm: vm)
                }
                .padding()
            } else {
                ProgressView().padding(.top, 60)
            }
        }
        .background(BrandColor.canvas.ignoresSafeArea())
        .navigationTitle("Kudos")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if vm == nil { vm = HomeViewModel(session: session, feedProvider: feed) }
            await vm?.load()
        }
        .refreshable { await vm?.load() }
    }

    @ViewBuilder
    private func feedSection(vm: HomeViewModel) -> some View {
        if vm.isLoadingFeed && vm.feed.isEmpty {
            ProgressView().frame(maxWidth: .infinity).padding(.vertical, 24)
        } else if let error = vm.feedError, vm.feed.isEmpty {
            EmptyState(systemImage: "wifi.slash", title: error)
        } else if vm.feed.isEmpty {
            EmptyState(systemImage: "heart.text.square",
                       title: "No kudos yet. Send some appreciation to get started.")
        } else {
            VStack(spacing: 10) {
                ForEach(vm.feed) { event in
                    NavigationLink { KudoDetailView(event: event) } label: { KudoCard(event: event) }
                        .buttonStyle(.plain)
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        HomeView(feed: PreviewFeedMock(), onCompose: {})
            .environment(SessionStore.previewActive)
    }
}
#endif
