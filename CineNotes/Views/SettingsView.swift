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
            Section("Preferences") {
                TextField("Default Genre", text: $defaultGenre)
                    .textContentType(.none)
                    .autocapitalization(.words)
                
                Toggle("Sort by Rating", isOn: $sortByRating)
                Toggle("Show Statistics", isOn: $showStats)
                Toggle("Enable Notifications", isOn: $notificationsEnabled)
            }
            
            Section("App Info") {
                LabeledContent("Version", value: Bundle.main.releaseVersionNumber ?? "1.0.0")
                LabeledContent("Build", value: Bundle.main.buildVersionNumber ?? "1")
            }
            
            Section("Data Management") {
                Button {
                    showingShareSheet = true
                } label: {
                    Label("Export Data", systemImage: "square.and.arrow.up")
                }
                
                Button(role: .destructive) {
                    showingResetAlert = true
                } label: {
                    Label("Reset All Data", systemImage: "exclamationmark.triangle")
                }
            }
            
            Section("About") {
                Link(destination: URL(string: "https://www.example.com/privacy")!) {
                    Label("Privacy Policy", systemImage: "hand.raised.fill")
                }
                
                Link(destination: URL(string: "https://www.example.com/terms")!) {
                    Label("Terms of Use", systemImage: "doc.text.fill")
                }
                
                Link(destination: URL(string: "mailto:support@example.com")!) {
                    Label("Contact Support", systemImage: "envelope.fill")
                }
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
    
    private func resetAllData() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        defaultGenre = ""
        sortByRating = false
        showStats = true
        notificationsEnabled = true
    }
    
    private func exportData() -> String {
        // In a real app, this would export actual user data in a structured format
        return "CineNotes Export Data"
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