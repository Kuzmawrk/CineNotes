import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MovieViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                MovieListView(viewModel: viewModel)
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
    }
}

#Preview {
    ContentView()
}