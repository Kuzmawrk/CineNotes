import SwiftUI

struct MovieListView: View {
    @ObservedObject var viewModel: MovieViewModel
    @Binding var selectedTab: Int
    @State private var selectedMovie: Movie?
    @State private var showingAddMovie = false
    @State private var movieToDelete: Movie?
    @State private var showingDeleteAlert = false
    
    @AppStorage("sortByRating") private var sortByRating = false
    @State private var sortOrder: SortOrder = .date
    
    enum SortOrder {
        case date
        case rating
        
        var icon: String {
            switch self {
            case .date: return "calendar"
            case .rating: return "star.fill"
            }
        }
        
        var title: String {
            switch self {
            case .date: return "Date"
            case .rating: return "Rating"
            }
        }
    }
    
    var body: some View {
        ZStack {
            if !viewModel.movies.isEmpty {
                List {
                    if !viewModel.movies.isEmpty {
                        statsView
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                    }
                    
                    HStack {
                        Text("Your Movies")
                            .font(.title2.bold())
                            .foregroundStyle(Theme.text)
                        
                        Spacer()
                        
                        Menu {
                            Button {
                                withAnimation {
                                    sortOrder = .date
                                    sortByRating = false
                                }
                            } label: {
                                Label("Sort by Date", systemImage: "calendar")
                            }
                            .disabled(sortOrder == .date)
                            
                            Button {
                                withAnimation {
                                    sortOrder = .rating
                                    sortByRating = true
                                }
                            } label: {
                                Label("Sort by Rating", systemImage: "star.fill")
                            }
                            .disabled(sortOrder == .rating)
                            
                            Divider()
                            
                            Button(role: .destructive) {
                                withAnimation {
                                    sortOrder = .date
                                    sortByRating = false
                                }
                            } label: {
                                Label("Reset Sort", systemImage: "arrow.counterclockwise")
                            }
                            .disabled(sortOrder == .date)
                        } label: {
                            HStack(spacing: Theme.smallPadding) {
                                Label(sortOrder.title, systemImage: sortOrder.icon)
                                    .font(.subheadline.bold())
                                    .foregroundStyle(Theme.primary)
                                    .padding(.horizontal, Theme.padding)
                                    .padding(.vertical, Theme.smallPadding)
                                    .background(Theme.buttonBackground)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    
                    ForEach(sortedMovies) { movie in
                        MovieCardView(movie: movie)
                            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                            .listRowBackground(Color.clear)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedMovie = movie
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    movieToDelete = movie
                                    showingDeleteAlert = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                
                                Button {
                                    selectedMovie = movie
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(Theme.primary)
                            }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Theme.groupedBackground)
            } else {
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
                .onDisappear {
                    if viewModel.showSuccessMessage {
                        selectedTab = 0
                    }
                }
        }
        .alert("Delete Movie", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {
                movieToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let movie = movieToDelete {
                    withAnimation {
                        viewModel.deleteMovie(movie)
                    }
                }
                movieToDelete = nil
            }
        } message: {
            if let movie = movieToDelete {
                Text("Are you sure you want to delete \"\(movie.title)\"? This action cannot be undone.")
            }
        }
    }
    
    private var sortedMovies: [Movie] {
        switch sortOrder {
        case .date:
            return viewModel.sortedMovies
        case .rating:
            return viewModel.movies.sorted { $0.rating > $1.rating }
        }
    }
    
    private var statsView: some View {
        VStack(spacing: Theme.padding) {
            Text("Movie Stats")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Theme.text)
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

// MARK: - Supporting Views

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
        MovieListView(viewModel: MovieViewModel(), selectedTab: .constant(0))
            .navigationTitle("Notes")
    }
}