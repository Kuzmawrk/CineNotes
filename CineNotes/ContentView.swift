import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MovieViewModel()
    @State private var showingAddMovie = false
    
    var body: some View {
        NavigationStack {
            MovieListView(viewModel: viewModel)
                .navigationTitle("CineNotes")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddMovie = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                        }
                    }
                }
                .sheet(isPresented: $showingAddMovie) {
                    AddMovieView(viewModel: viewModel)
                }
        }
    }
}

#Preview {
    ContentView()
}