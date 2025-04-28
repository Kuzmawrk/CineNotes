import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @ObservedObject var viewModel: MovieViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.padding) {
                header
                
                if !movie.thoughts.isEmpty {
                    detailSection(title: "Thoughts", content: movie.thoughts)
                }
                
                if !movie.favoriteScenes.isEmpty {
                    detailSection(title: "Favorite Scenes", content: movie.favoriteScenes.joined(separator: "\n\n"))
                }
                
                if !movie.quotes.isEmpty {
                    detailSection(title: "Memorable Quotes", content: movie.quotes.joined(separator: "\n\n"))
                }
                
                if !movie.emotionalResponse.isEmpty {
                    detailSection(title: "Emotional Response", content: movie.emotionalResponse)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive) {
                    showingDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                }
            }
        }
        .alert("Delete Movie", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteMovie()
            }
        } message: {
            Text("Are you sure you want to delete this movie? This action cannot be undone.")
        }
    }
    
    private var header: some View {
        VStack(spacing: Theme.padding) {
            Text(movie.title)
                .font(.title.bold())
                .multilineTextAlignment(.center)
            
            MovieRatingView(rating: movie.rating)
                .font(.title2)
            
            HStack {
                Label(movie.genre, systemImage: "film")
                Spacer()
                Label(DateFormatters.formatDate(movie.watchDate), systemImage: "calendar")
            }
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(Theme.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
    }
    
    private func detailSection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: Theme.padding / 2) {
            Text(title)
                .font(.headline)
            
            Text(content)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Theme.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
    }
    
    private func deleteMovie() {
        viewModel.deleteMovie(movie)
        dismiss()
    }
}

struct MovieRatingView: View {
    let rating: Int
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundStyle(index <= rating ? .yellow : .gray.opacity(0.3))
            }
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(
            movie: Movie(
                title: "Inception",
                genre: "Sci-Fi",
                rating: 5,
                thoughts: "Mind-bending masterpiece",
                favoriteScenes: ["The hotel scene"],
                quotes: ["Dreams feel real while we're in them"],
                emotionalResponse: "Blown away by the complexity"
            ),
            viewModel: MovieViewModel()
        )
    }
}