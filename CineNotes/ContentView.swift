import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MovieViewModel()
    
    var body: some View {
        TabView {
            NavigationStack {
                MovieListView(viewModel: viewModel)
                    .navigationTitle("Notes")
            }
            .tabItem {
                Label("Notes", systemImage: "book.fill")
            }
            
            NavigationStack {
                SettingsView()
                    .navigationTitle("Settings")
            }
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