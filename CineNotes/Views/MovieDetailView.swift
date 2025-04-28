import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @ObservedObject var viewModel: MovieViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingDeleteAlert = false
    @State private var showingEditSheet = false
    @State private var showingShareSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.padding) {
                header
                
                actionButtons
                
                if !movie.thoughts.isEmpty {
                    detailSection(
                        title: "Thoughts",
                        icon: "thought.bubble",
                        color: Theme.primary,
                        content: movie.thoughts
                    )
                }
                
                if !movie.favoriteScenes.isEmpty {
                    detailSection(
                        title: "Favorite Scenes",
                        icon: "film.stack",
                        color: Theme.secondary,
                        content: movie.favoriteScenes.joined(separator: "\n\n")
                    )
                }
                
                if !movie.quotes.isEmpty {
                    detailSection(
                        title: "Memorable Quotes",
                        icon: "quote.bubble",
                        color: Theme.accent,
                        content: movie.quotes.joined(separator: "\n\n")
                    )
                }
                
                if !movie.emotionalResponse.isEmpty {
                    detailSection(
                        title: "Emotional Response",
                        icon: "heart",
                        color: .red,
                        content: movie.emotionalResponse
                    )
                }
            }
            .padding()
        }
        .background(Theme.groupedBackground)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title3)
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
        .sheet(isPresented: $showingEditSheet) {
            EditMovieView(viewModel: viewModel, movie: movie)
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: [createShareText()])
        }
    }
    
    private var header: some View {
        VStack(spacing: Theme.padding) {
            Text(movie.title)
                .font(.title.bold())
                .multilineTextAlignment(.center)
                .foregroundStyle(Theme.text)
            
            MovieRatingView(rating: movie.rating)
                .font(.title2)
            
            HStack(spacing: Theme.padding * 2) {
                Label {
                    Text(movie.genre)
                        .lineLimit(1)
                } icon: {
                    Image(systemName: "film")
                        .foregroundStyle(Theme.primary)
                }
                
                Label {
                    Text(DateFormatters.formatDate(movie.watchDate))
                        .lineLimit(1)
                } icon: {
                    Image(systemName: "calendar")
                        .foregroundStyle(Theme.accent)
                }
            }
            .font(.subheadline)
            .foregroundStyle(Theme.secondaryText)
        }
        .padding(Theme.padding)
        .frame(maxWidth: .infinity)
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
        .shadow(color: Theme.elevation(2), radius: Theme.shadowRadius, y: Theme.shadowY)
    }
    
    private var actionButtons: some View {
        HStack(spacing: Theme.padding) {
            Button {
                showingEditSheet = true
            } label: {
                Label("Edit", systemImage: "pencil")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Theme.primary)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
            }
            
            Button {
                showingShareSheet = true
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Theme.accent)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
            }
        }
    }
    
    private func detailSection(title: String, icon: String, color: Color, content: String) -> some View {
        VStack(alignment: .leading, spacing: Theme.padding) {
            HStack {
                Label {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(Theme.text)
                } icon: {
                    Image(systemName: icon)
                        .foregroundStyle(color)
                }
                
                Spacer()
            }
            .padding(.horizontal, Theme.smallPadding)
            .padding(.vertical, Theme.smallPadding / 2)
            .background(color.opacity(0.1))
            .clipShape(Capsule())
            
            Text(content)
                .font(.body)
                .foregroundStyle(Theme.secondaryText)
        }
        .padding(Theme.padding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
        .shadow(color: Theme.elevation(1), radius: Theme.shadowRadius / 2, y: Theme.shadowY / 2)
    }
    
    private func deleteMovie() {
        withAnimation {
            viewModel.deleteMovie(movie)
            dismiss()
        }
    }
    
    private func createShareText() -> String {
        """
        Movie: \(movie.title)
        Genre: \(movie.genre)
        Rating: \(String(repeating: "⭐️", count: movie.rating))
        
        \(movie.thoughts)
        
        Shared from CineNotes
        """
    }
}

struct MovieRatingView: View {
    let rating: Int
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundStyle(index <= rating ? .yellow : Theme.secondaryText.opacity(0.3))
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
                thoughts: "A mind-bending masterpiece that challenges our perception of reality. The intricate plot and stunning visuals create an unforgettable experience.",
                favoriteScenes: ["The hotel corridor fight scene", "The folding city of Paris"],
                quotes: ["Dreams feel real while we're in them", "You're waiting for a train..."],
                emotionalResponse: "Left me questioning reality and amazed by the possibilities of human consciousness."
            ),
            viewModel: MovieViewModel()
        )
    }
}