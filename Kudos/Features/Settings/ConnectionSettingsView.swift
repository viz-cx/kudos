import SwiftUI

struct ConnectionSettingsView: View {
    @Environment(NodeSettingsStore.self) private var store
    @State private var vm: ConnectionSettingsViewModel?

    var body: some View {
        Group {
            if let vm {
                content(vm: vm)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if vm == nil { vm = ConnectionSettingsViewModel(store: store) }
        }
        .navigationTitle("Connection")
    }

    @ViewBuilder
    private func content(vm: ConnectionSettingsViewModel) -> some View {
        @Bindable var vm = vm
        Form {
            Section("Nodes") {
                ForEach(vm.endpoints) { endpoint in
                    Button {
                        Task { await vm.select(endpoint.url) }
                    } label: {
                        row(vm: vm, endpoint: endpoint)
                    }
                    .buttonStyle(.plain)
                    .disabled(vm.validating != nil)
                }
            }
            Section("Custom node") {
                TextField("https://your-node.example", text: $vm.customURLText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.URL)
                Button("Connect") {
                    Task { await vm.connectCustom() }
                }
                .disabled(vm.validating != nil || vm.customURLText.isEmpty)
            }
            if let error = vm.errorText {
                Section {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(BrandColor.canvas.ignoresSafeArea())
        .tint(BrandColor.magenta)
    }

    @ViewBuilder
    private func row(vm: ConnectionSettingsViewModel, endpoint: NodeEndpoint) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(endpoint.displayName)
                    .foregroundStyle(.primary)
                if let block = vm.blockHeights[endpoint.url] {
                    Text("block #\(block)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            if vm.validating == endpoint.url {
                ProgressView()
            } else if vm.selectedURL == endpoint.url {
                Image(systemName: "checkmark")
                    .foregroundStyle(BrandColor.magenta)
            }
        }
        .contentShape(Rectangle())
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        ConnectionSettingsView()
            .environment(NodeSettingsStore(configuring: PreviewNodeConfiguring()))
    }
}
#endif
