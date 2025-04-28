import SwiftUI

struct EditMovieView: View {
    @ObservedObject var viewModel: MovieViewModel
    let movie: Movie
    
    @Environment(\.dismiss) private var dismiss
    @State private var showingDiscardAlert = false
    
    @State private var title: String
    @State private var genre: String
    @State private var watchDate: Date
    @State private var rating: Int
    @State private var thoughts: String
    @State private var favoriteScene: String
    @State private var quote: String
    @State private var emotionalResponse: String
    
    init(viewModel: MovieViewModel, movie: Movie) {
        self.viewModel = viewModel
        self.movie = movie
        
        // Initialize state with movie data
        _title = State(initialValue: movie.title)
        _genre = State(initialValue: movie.genre)
        _watchDate = State(initialValue: movie.watchDate)
        _rating = State(initialValue: movie.rating)
        _thoughts = State(initialValue: movie.thoughts)
        _favoriteScene = State(initialValue: movie.favoriteScenes.first ?? "")
        _quote = State(initialValue: movie.quotes.first ?? "")
        _emotionalResponse = State(initialValue: movie.emotionalResponse)
    }
    
    var hasChanges: Bool {
        title != movie.title ||
        genre != movie.genre ||
        watchDate != movie.watchDate ||
        rating != movie.rating ||
        thoughts != movie.thoughts ||
        favoriteScene != (movie.favoriteScenes.first ?? "") ||
        quote != (movie.quotes.first ?? "") ||
        emotionalResponse != movie.emotionalResponse
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Movie Details") {
                    TextField("Title", text: $title)
                        .textContentType(.none)
                    
                    TextField("Genre", text: $genre)
                        .textContentType(.none)
                    
                    DatePicker("Watch Date", selection: $watchDate, displayedComponents: .date)
                }
                
                Section("Rating") {
                    RatingSelector(rating: $rating)
                }
                
                Section("Your Thoughts") {
                    TextEditor(text: $thoughts)
                        .frame(height: 100)
                }
                
                Section("Favorite Scene") {
                    TextEditor(text: $favoriteScene)
                        .frame(height: 80)
                }
                
                Section("Memorable Quote") {
                    TextEditor(text: $quote)
                        .frame(height: 80)
                }
                
                Section("Emotional Response") {
                    TextEditor(text: $emotionalResponse)
                        .frame(height: 100)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Edit Movie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        if hasChanges {
                            showingDiscardAlert = true
                        } else {
                            dismiss()
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .bold()
                    .disabled(!hasChanges || title.isEmpty)
                }
            }
            .alert("Discard Changes?", isPresented: $showingDiscardAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Discard", role: .destructive) {
                    dismiss()
                }
            } message: {
                Text("You have unsaved changes. Are you sure you want to discard them?")
            }
        }
        .interactiveDismissDisabled(hasChanges)
    }
    
    private func saveChanges() {
        let updatedMovie = Movie(
            id: movie.id, // Keep the same ID
            title: title,
            genre: genre,
            watchDate: watchDate,
            rating: rating,
            thoughts: thoughts,
            favoriteScenes: favoriteScene.isEmpty ? [] : [favoriteScene],
            quotes: quote.isEmpty ? [] : [quote],
            emotionalResponse: emotionalResponse
        )
        
        viewModel.updateMovie(updatedMovie)
        dismiss()
    }
}

#Preview {
    EditMovieView(
        viewModel: MovieViewModel(),
        movie: Movie(
            title: "Inception",
            genre: "Sci-Fi",
            rating: 5,
            thoughts: "Amazing movie",
            favoriteScenes: ["The hotel scene"],
            quotes: ["Dreams feel real"],
            emotionalResponse: "Mind-blown"
        )
    )
}