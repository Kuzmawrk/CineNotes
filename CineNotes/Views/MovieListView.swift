import SwiftUI

struct MovieListView: View {
    @ObservedObject var viewModel: MovieViewModel
    @State private var selectedMovie: Movie?
    @State private var showingAddMovie = false
    
    @AppStorage("sortByRating") private var sortByRating = false
    @AppStorage("showStats") private var showStats = true
    
    var body: some View {
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
                        showingAddMovie = true
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
        .sheet(item: $selectedMovie) { movie in
            MovieDetailView(movie: movie, viewModel: viewModel)
        }
        .sheet(isPresented: $showingAddMovie) {
            AddMovieView(viewModel: viewModel)
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

struct MovieCard: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.padding / 2) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.title3.bold())
                        .foregroundStyle(Theme.text)
                    
                    Text(movie.genre)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                RatingView(rating: movie.rating)
            }
            
            if !movie.thoughts.isEmpty {
                Text(movie.thoughts)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .padding(.top, 4)
            }
            
            HStack {
                Label(DateFormatters.formatDate(movie.watchDate), systemImage: "calendar")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if !movie.quotes.isEmpty {
                    Label("\(movie.quotes.count)", systemImage: "quote.bubble")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                if !movie.favoriteScenes.isEmpty {
                    Label("\(movie.favoriteScenes.count)", systemImage: "film.stack")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Theme.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
        .shadow(radius: Theme.shadowRadius, y: Theme.shadowY)
        .contentShape(Rectangle())
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: Theme.padding / 2) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Theme.primary)
            
            Text(value)
                .font(.title2.bold())
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Theme.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
        .shadow(radius: Theme.shadowRadius, y: Theme.shadowY)
    }
}

struct RatingView: View {
    let rating: Int
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundStyle(index <= rating ? .yellow : .gray.opacity(0.3))
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    NavigationStack {
        MovieListView(viewModel: MovieViewModel())
            .navigationTitle("Notes")
    }
}