import SwiftUI

struct MovieListView: View {
    @ObservedObject var viewModel: MovieViewModel
    @State private var selectedMovie: Movie?
    @State private var showingAddMovie = false
    @State private var navigationPath = NavigationPath()
    
    @AppStorage("sortByRating") private var sortByRating = false
    @AppStorage("showStats") private var showStats = true
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                ScrollView {
                    VStack(spacing: Theme.padding) {
                        if !viewModel.movies.isEmpty && showStats {
                            statsView
                        }
                        
                        if !viewModel.movies.isEmpty {
                            HStack {
                                Text("Your Movies")
                                    .font(.title2.bold())
                                
                                Spacer()
                                
                                Menu {
                                    Button {
                                        sortByRating.toggle()
                                    } label: {
                                        Label(
                                            sortByRating ? "Sort by Date" : "Sort by Rating",
                                            systemImage: sortByRating ? "calendar" : "star.fill"
                                        )
                                    }
                                } label: {
                                    Image(systemName: "arrow.up.arrow.down.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(Theme.primary)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        LazyVStack(spacing: Theme.padding) {
                            ForEach(sortedMovies) { movie in
                                MovieCard(movie: movie)
                                    .onTapGesture {
                                        selectedMovie = movie
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 100) // Space for FAB
                }
                .background(Color(uiColor: .systemGroupedBackground))
                
                if viewModel.movies.isEmpty {
                    ContentUnavailableView(
                        "Welcome to CineNotes",
                        systemImage: "film",
                        description: Text("Start your movie journal by adding your first movie")
                    )
                }
                
                // Floating Action Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            navigationPath.append("addMovie")
                        } label: {
                            Image(systemName: "plus")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Theme.primary)
                                .clipShape(Circle())
                                .shadow(radius: 4, x: 0, y: 2)
                        }
                        .padding()
                        .padding(.bottom, 8)
                    }
                }
            }
            .navigationTitle("Notes")
            .navigationDestination(for: String.self) { route in
                if route == "addMovie" {
                    AddMovieView(viewModel: viewModel, navigationPath: $navigationPath)
                }
            }
            .sheet(item: $selectedMovie) { movie in
                MovieDetailView(movie: movie, viewModel: viewModel)
            }
        }
    }
    
    private var sortedMovies: [Movie] {
        if sortByRating {
            return viewModel.movies.sorted { $0.rating > $1.rating }
        } else {
            return viewModel.sortedMovies
        }
    }
    
    private var statsView: some View {
        VStack(spacing: Theme.padding) {
            HStack {
                Text("Movie Stats")
                    .font(.title2.bold())
                Spacer()
                
                Button {
                    withAnimation {
                        showStats.toggle()
                    }
                } label: {
                    Image(systemName: "chevron.up.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Theme.primary)
                        .rotationEffect(.degrees(showStats ? 180 : 0))
                }
            }
            .padding(.horizontal)
            
            HStack(spacing: Theme.padding) {
                StatCard(
                    title: "Movies Watched",
                    value: "\(viewModel.movies.count)",
                    icon: "film"
                )
                
                StatCard(
                    title: "Average Rating",
                    value: String(format: "%.1f", viewModel.averageRating),
                    icon: "star.fill"
                )
                
                if let topGenre = getTopGenre() {
                    StatCard(
                        title: "Top Genre",
                        value: topGenre,
                        icon: "ticket.fill"
                    )
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .background(Theme.background.opacity(0.5))
    }
    
    private func getTopGenre() -> String? {
        let genreCounts = Dictionary(grouping: viewModel.movies, by: { $0.genre })
            .mapValues { $0.count }
        return genreCounts.max(by: { $0.value < $1.value })?.key
    }
}

// Rest of the view components remain the same...