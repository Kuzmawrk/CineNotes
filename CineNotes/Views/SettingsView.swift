import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showingShareSheet = false
    
    private let appId = "YOUR_APP_ID" // Replace with your actual App ID
    
    var body: some View {
        List {
            Section {
                Toggle(isOn: $isDarkMode) {
                    Label {
                        Text("Dark Mode")
                    } icon: {
                        Image(systemName: isDarkMode ? "moon.fill" : "moon")
                            .foregroundStyle(isDarkMode ? .yellow : Theme.primary)
                    }
                }
                .tint(Theme.success)
            } header: {
                Text("Appearance")
            } footer: {
                Text("Change the app's appearance")
            }
            
            Section {
                Button {
                    rateApp()
                } label: {
                    Label {
                        Text("Rate this App")
                            .foregroundStyle(Theme.text)
                    } icon: {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                    }
                }
                
                Button {
                    shareApp()
                } label: {
                    Label {
                        Text("Share this App")
                            .foregroundStyle(Theme.text)
                    } icon: {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(Theme.primary)
                    }
                }
            } header: {
                Text("Support Us")
            }
            
            Section {
                NavigationLink {
                    PrivacyPolicyView()
                } label: {
                    Label {
                        Text("Privacy Policy")
                    } icon: {
                        Image(systemName: "hand.raised.fill")
                            .foregroundStyle(Theme.secondary)
                    }
                }
                
                NavigationLink {
                    TermsOfUseView()
                } label: {
                    Label {
                        Text("Terms of Use")
                    } icon: {
                        Image(systemName: "doc.text.fill")
                            .foregroundStyle(Theme.accent)
                    }
                }
            } header: {
                Text("Legal")
            }
            
            Section {
                LabeledContent {
                    Text(Bundle.main.releaseVersionNumber ?? "1.0.0")
                        .foregroundStyle(Theme.secondaryText)
                } label: {
                    Label("Version", systemImage: "info.circle.fill")
                        .foregroundStyle(Theme.text)
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: [createShareText()])
        }
    }
    
    private func rateApp() {
        guard let appStoreURL = URL(string: "https://apps.apple.com/app/id\(appId)") else { return }
        UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
    }
    
    private func shareApp() {
        showingShareSheet = true
    }
    
    private func createShareText() -> String {
        """
        Check out CineNotes - Your Personal Movie Journal!
        
        Track your movie experiences, record your thoughts, and never forget those special cinema moments.
        
        Download now: https://apps.apple.com/app/id\(appId)
        """
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}