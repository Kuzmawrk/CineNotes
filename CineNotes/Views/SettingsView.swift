import SwiftUI

struct SettingsView: View {
    @AppStorage("defaultGenre") private var defaultGenre = ""
    @AppStorage("sortByRating") private var sortByRating = false
    @AppStorage("showStats") private var showStats = true
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    
    @State private var showingResetAlert = false
    @State private var showingShareSheet = false
    
    var body: some View {
        List {
            Section {
                TextField("Default Genre", text: $defaultGenre)
                    .textContentType(.none)
                    .autocapitalization(.words)
                
                toggleRow(title: "Sort by Rating", 
                         icon: "arrow.up.arrow.down",
                         isOn: $sortByRating)
                
                toggleRow(title: "Show Statistics",
                         icon: "chart.bar.fill",
                         isOn: $showStats)
                
                toggleRow(title: "Enable Notifications",
                         icon: "bell.fill",
                         isOn: $notificationsEnabled)
            } header: {
                Text("Preferences")
            } footer: {
                Text("Configure your app experience")
            }
            
            Section {
                LabeledContent {
                    Text(Bundle.main.releaseVersionNumber ?? "1.0.0")
                        .foregroundStyle(.secondary)
                } label: {
                    Label("Version", systemImage: "number")
                }
                
                LabeledContent {
                    Text(Bundle.main.buildVersionNumber ?? "1")
                        .foregroundStyle(.secondary)
                } label: {
                    Label("Build", systemImage: "hammer.fill")
                }
            } header: {
                Text("App Info")
            }
            
            Section {
                Button {
                    showingShareSheet = true
                } label: {
                    HStack {
                        Label("Export Data", systemImage: "square.and.arrow.up")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                    }
                }
                .foregroundStyle(Theme.text)
                
                Button(role: .destructive) {
                    showingResetAlert = true
                } label: {
                    HStack {
                        Label("Reset All Data", systemImage: "exclamationmark.triangle")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Text("Data Management")
            } footer: {
                Text("Export or reset your movie data")
            }
            
            Section {
                Link(destination: URL(string: "https://www.example.com/privacy")!) {
                    HStack {
                        Label("Privacy Policy", systemImage: "hand.raised.fill")
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.caption.bold())
                    }
                }
                .foregroundStyle(Theme.text)
                
                Link(destination: URL(string: "https://www.example.com/terms")!) {
                    HStack {
                        Label("Terms of Use", systemImage: "doc.text.fill")
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.caption.bold())
                    }
                }
                .foregroundStyle(Theme.text)
                
                Link(destination: URL(string: "mailto:support@example.com")!) {
                    HStack {
                        Label("Contact Support", systemImage: "envelope.fill")
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.caption.bold())
                    }
                }
                .foregroundStyle(Theme.text)
            } header: {
                Text("About")
            } footer: {
                Text("CineNotes © 2024")
            }
        }
        .alert("Reset All Data", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                resetAllData()
            }
        } message: {
            Text("Are you sure you want to reset all data? This action cannot be undone.")
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: [exportData()])
        }
    }
    
    private func toggleRow(title: String, icon: String, isOn: Binding<Bool>) -> some View {
        Toggle(isOn: isOn) {
            Label(title, systemImage: icon)
        }
        .tint(Theme.success)
        .overlay {
            GeometryReader { geometry in
                Color.clear.preference(
                    key: ViewSizeKey.self,
                    value: geometry.size
                )
            }
        }
    }
    
    private func resetAllData() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        defaultGenre = ""
        sortByRating = false
        showStats = true
        notificationsEnabled = true
    }
    
    private func exportData() -> String {
        "CineNotes Export Data"
    }
}

struct ViewSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}