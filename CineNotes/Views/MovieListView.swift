import SwiftUI

struct MovieListView: View {
    @ObservedObject var viewModel: MovieViewModel
    @State private var selectedMovie: Movie?
    @State private var showingAddMovie = false
    
    @AppStorage("sortByRating") private var sortByRating = false
    @AppStorage("showStats") private var showStats = true
    
    var body: some View {
        ZStack {
            Theme.groupedBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Theme.padding) {
                    if !viewModel.movies.isEmpty && showStats {
                        statsView
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    if !viewModel.movies.isEmpty {
                        HStack {
                            Text("Your Movies")
                                .font(.title2.bold())
                                .foregroundStyle(Theme.text)
                            
                            Spacer()
                            
                            Menu {
                                Button {
                                    withAnimation {
                                        sortByRating.toggle()
                                    }
                                } label: {
                                    Label(
                                        sortByRating ? "Sort by Date" : "Sort by Rating",
                                        systemImage: sortByRating ? "calendar" : "star.fill"
                                    )
                                }
                            } label: {
                                HStack(spacing: Theme.smallPadding) {
                                    Text(sortByRating ? "Rating" : "Date")
                                        .font(.subheadline.bold())
                                    Image(systemName: "arrow.up.arrow.down")
                                }
                                .foregroundStyle(Theme.primary)
                                .padding(.horizontal, Theme.padding)
                                .padding(.vertical, Theme.smallPadding)
                                .background(Theme.buttonBackground)
                                .clipShape(Capsule())
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    LazyVStack(spacing: Theme.padding) {
                        ForEach(sortedMovies) { movie in
                            MovieCardView(movie: movie)
                                .onTapGesture {
                                    selectedMovie = movie
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 100) // Space for FAB
            }
            
            if viewModel.movies.isEmpty {
                ContentUnavailableView {
                    Label("Welcome to CineNotes", systemImage: "film")
                } description: {
                    Text("Start your movie journal by adding your first movie")
                } actions: {
                    Button {
                        showingAddMovie = true
                    } label: {
                        Text("Add Movie")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Theme.primary)
                            .clipShape(Capsule())
                    }
                }
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
                            .frame(width: 64, height: 64)
                            .background {
                                Circle()
                                    .fill(Theme.primary)
                                    .shadow(
                                        color: Theme.primary.opacity(0.4),
                                        radius: 8,
                                        x: 0,
                                        y: 4
                                    )
                            }
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
                    .foregroundStyle(Theme.text)
                Spacer()
                
                Button {
                    withAnimation {
                        showStats.toggle()
                    }
                } label: {
                    HStack {
                        Text(showStats ? "Hide" : "Show")
                            .font(.subheadline.bold())
                        Image(systemName: "chevron.up")
                            .rotationEffect(.degrees(showStats ? 180 : 0))
                    }
                    .foregroundStyle(Theme.primary)
                    .padding(.horizontal, Theme.padding)
                    .padding(.vertical, Theme.smallPadding)
                    .background(Theme.buttonBackground)
                    .clipShape(Capsule())
                }
            }
            .padding(.horizontal)
            
            HStack(spacing: Theme.padding) {
                MovieStatCard(
                    title: "Movies Watched",
                    value: "\(viewModel.movies.count)",
                    icon: "film",
                    color: Theme.primary
                )
                
                MovieStatCard(
                    title: "Average Rating",
                    value: String(format: "%.1f", viewModel.averageRating),
                    icon: "star.fill",
                    color: Theme.accent
                )
                
                if let topGenre = getTopGenre() {
                    MovieStatCard(
                        title: "Top Genre",
                        value: topGenre,
                        icon: "ticket.fill",
                        color: Theme.secondary
                    )
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, Theme.padding)
    }
    
    private func getTopGenre() -> String? {
        let genreCounts = Dictionary(grouping: viewModel.movies, by: { $0.genre })
            .mapValues { $0.count }
        return genreCounts.max(by: { $0.value < $1.value })?.key
    }
}

struct MovieCardView: View {
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
                        .foregroundStyle(Theme.secondaryText)
                }
                
                Spacer()
                
                MovieRatingView(rating: movie.rating)
                    .font(.callout)
            }
            
            if !movie.thoughts.isEmpty {
                Text(movie.thoughts)
                    .font(.subheadline)
                    .foregroundStyle(Theme.secondaryText)
                    .lineLimit(2)
                    .padding(.top, 4)
            }
            
            HStack(spacing: Theme.padding) {
                Label {
                    Text(DateFormatters.formatDate(movie.watchDate))
                        .font(.caption)
                } icon: {
                    Image(systemName: "calendar")
                        .foregroundStyle(Theme.primary)
                }
                .foregroundStyle(Theme.secondaryText)
                
                Spacer()
                
                if !movie.quotes.isEmpty {
                    Label {
                        Text("\(movie.quotes.count)")
                            .font(.caption)
                    } icon: {
                        Image(systemName: "quote.bubble")
                            .foregroundStyle(Theme.accent)
                    }
                    .foregroundStyle(Theme.secondaryText)
                }
                
                if !movie.favoriteScenes.isEmpty {
                    Label {
                        Text("\(movie.favoriteScenes.count)")
                            .font(.caption)
                    } icon: {
                        Image(systemName: "film.stack")
                            .foregroundStyle(Theme.secondary)
                    }
                    .foregroundStyle(Theme.secondaryText)
                }
            }
        }
        .padding(Theme.padding)
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
        .shadow(color: Theme.elevation(2), radius: Theme.shadowRadius, y: Theme.shadowY)
    }
}

struct MovieStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Theme.padding / 2) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .padding(Theme.smallPadding)
                .background(color.opacity(0.2))
                .clipShape(Circle())
            
            Text(value)
                .font(.title2.bold())
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .foregroundStyle(Theme.text)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(Theme.secondaryText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(Theme.padding)
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
        .shadow(color: Theme.elevation(1), radius: Theme.shadowRadius / 2, y: Theme.shadowY / 2)
    }
}

#Preview {
    NavigationStack {
        MovieListView(viewModel: MovieViewModel())
            .navigationTitle("Notes")
    }
}