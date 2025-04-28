import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MovieViewModel()
    @State private var selectedTab = 0
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                MovieListView(viewModel: viewModel, selectedTab: $selectedTab)
                    .navigationTitle("Notes")
            }
            .tag(0)
            .tabItem {
                Label("Notes", systemImage: "book.fill")
            }
            
            NavigationStack {
                SettingsView()
                    .navigationTitle("Settings")
            }
            .tag(1)
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
        .tint(Theme.primary)
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .overlay {
            if viewModel.showSuccessMessage {
                VStack {
                    Spacer()
                    Text(viewModel.successMessage)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .clipShape(Capsule())
                        .padding(.bottom, 100)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .animation(.spring(response: 0.3), value: viewModel.showSuccessMessage)
            }
        }
    }
}

#Preview {
    ContentView()
}