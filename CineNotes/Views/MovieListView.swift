import SwiftUI

struct MovieListView: View {
    @ObservedObject var viewModel: MovieViewModel
    @State private var selectedMovie: Movie?
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.padding) {
                if !viewModel.movies.isEmpty {
                    statsView
                }
                
                LazyVStack(spacing: Theme.padding) {
                    ForEach(viewModel.sortedMovies) { movie in
                        MovieCard(movie: movie)
                            .onTapGesture {
                                selectedMovie = movie
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(item: $selectedMovie) { movie in
            MovieDetailView(movie: movie, viewModel: viewModel)
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }
    
    private var statsView: some View {
        VStack(spacing: Theme.padding / 2) {
            Text("Movie Stats")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
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
            }
        }
        .padding(.horizontal)
    }
}

struct MovieCard: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.padding / 2) {
            HStack {
                Text(movie.title)
                    .font(.title3.bold())
                Spacer()
                RatingView(rating: movie.rating)
            }
            
            Text(movie.genre)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text(DateFormatters.formatDate(movie.watchDate))
                .font(.caption)
                .foregroundStyle(.secondary)
            
            if !movie.thoughts.isEmpty {
                Text(movie.thoughts)
                    .font(.subheadline)
                    .lineLimit(2)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(Theme.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
        .shadow(radius: Theme.shadowRadius, y: Theme.shadowY)
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
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Theme.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
    }
}

struct RatingView: View {
    let rating: Int
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundStyle(index <= rating ? .yellow : .gray)
            }
        }
    }
}

#Preview {
    MovieListView(viewModel: MovieViewModel())
}