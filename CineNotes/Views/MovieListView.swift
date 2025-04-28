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

// Rest of the code remains the same...