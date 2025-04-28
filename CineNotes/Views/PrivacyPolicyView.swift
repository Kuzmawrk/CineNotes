import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.padding) {
                Group {
                    Text("Privacy Policy")
                        .font(.title.bold())
                        .padding(.bottom)
                    
                    Text("Last updated: February 2024")
                        .foregroundStyle(Theme.secondaryText)
                    
                    Text("Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your personal information when you use our app.")
                        .padding(.vertical)
                    
                    sectionTitle("Information We Collect")
                    Text("• Movie ratings and reviews you create\n• App preferences and settings\n• Usage statistics and crash reports")
                    
                    sectionTitle("How We Use Your Information")
                    Text("• To provide and improve our services\n• To personalize your experience\n• To analyze app performance and fix issues")
                    
                    sectionTitle("Data Storage")
                    Text("All your movie data is stored locally on your device. We do not collect or store your movie entries on our servers.")
                    
                    sectionTitle("Third-Party Services")
                    Text("We may use third-party services for analytics and crash reporting. These services may collect anonymous usage data.")
                    
                    sectionTitle("Contact Us")
                    Text("If you have any questions about this Privacy Policy, please contact us at support@example.com")
                }
                .foregroundStyle(Theme.text)
            }
            .padding()
        }
        .background(Theme.groupedBackground)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .padding(.vertical, 8)
    }
}

#Preview {
    NavigationStack {
        PrivacyPolicyView()
    }
}