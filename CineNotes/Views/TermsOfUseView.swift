import SwiftUI

struct TermsOfUseView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.padding) {
                Group {
                    Text("Terms of Use")
                        .font(.title.bold())
                        .padding(.bottom)
                    
                    Text("Last updated: February 2024")
                        .foregroundStyle(Theme.secondaryText)
                    
                    Text("By using CineNotes, you agree to these terms. Please read them carefully.")
                        .padding(.vertical)
                    
                    sectionTitle("1. Acceptance of Terms")
                    Text("By accessing or using CineNotes, you agree to be bound by these Terms of Use.")
                    
                    sectionTitle("2. User Content")
                    Text("You retain all rights to the content you create in CineNotes. You are solely responsible for the content you create, including movie reviews and ratings.")
                    
                    sectionTitle("3. Prohibited Uses")
                    Text("You agree not to:\n• Use the app for any illegal purpose\n• Attempt to gain unauthorized access\n• Interfere with the app's functionality")
                    
                    sectionTitle("4. Changes to Terms")
                    Text("We reserve the right to modify these terms at any time. Continued use of the app constitutes acceptance of modified terms.")
                    
                    sectionTitle("5. Disclaimer")
                    Text("The app is provided 'as is' without warranties of any kind, either express or implied.")
                    
                    sectionTitle("Contact")
                    Text("For any questions about these Terms, please contact us at support@example.com")
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
        TermsOfUseView()
    }
}