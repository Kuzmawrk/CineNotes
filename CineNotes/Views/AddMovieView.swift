import SwiftUI

struct AddMovieView: View {
    @ObservedObject var viewModel: MovieViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var genre = ""
    @State private var watchDate = Date()
    @State private var rating = 0
    @State private var thoughts = ""
    @State private var favoriteScene = ""
    @State private var quote = ""
    @State private var emotionalResponse = ""
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case title, genre, thoughts, favoriteScene, quote, emotionalResponse
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Movie Details") {
                    TextField("Title", text: $title)
                        .focused($focusedField, equals: .title)
                        .textContentType(.none)
                        .submitLabel(.next)
                    
                    TextField("Genre", text: $genre)
                        .focused($focusedField, equals: .genre)
                        .textContentType(.none)
                        .submitLabel(.next)
                    
                    DatePicker("Watch Date", selection: $watchDate, displayedComponents: .date)
                }
                
                Section("Rating") {
                    RatingSelector(rating: $rating)
                }
                
                Section("Your Thoughts") {
                    TextEditor(text: $thoughts)
                        .focused($focusedField, equals: .thoughts)
                        .frame(height: 100)
                }
                
                Section("Favorite Scene") {
                    TextEditor(text: $favoriteScene)
                        .focused($focusedField, equals: .favoriteScene)
                        .frame(height: 80)
                }
                
                Section("Memorable Quote") {
                    TextEditor(text: $quote)
                        .focused($focusedField, equals: .quote)
                        .frame(height: 80)
                }
                
                Section("Emotional Response") {
                    TextEditor(text: $emotionalResponse)
                        .focused($focusedField, equals: .emotionalResponse)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Add Movie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveMovie()
                    }
                    .bold()
                    .disabled(title.isEmpty)
                }
                
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            focusedField = nil
                        }
                    }
                }
            }
            .onSubmit {
                switch focusedField {
                case .title:
                    focusedField = .genre
                case .genre:
                    focusedField = .thoughts
                case .thoughts:
                    focusedField = .favoriteScene
                case .favoriteScene:
                    focusedField = .quote
                case .quote:
                    focusedField = .emotionalResponse
                default:
                    focusedField = nil
                }
            }
        }
        .interactiveDismissDisabled()
    }
    
    private func saveMovie() {
        let movie = Movie(
            title: title,
            genre: genre,
            watchDate: watchDate,
            rating: rating,
            thoughts: thoughts,
            favoriteScenes: favoriteScene.isEmpty ? [] : [favoriteScene],
            quotes: quote.isEmpty ? [] : [quote],
            emotionalResponse: emotionalResponse
        )
        viewModel.addMovie(movie)
        dismiss()
    }
}

struct RatingSelector: View {
    @Binding var rating: Int
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundStyle(index <= rating ? .yellow : .gray)
                    .font(.title2)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                            rating = index
                        }
                    }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    AddMovieView(viewModel: MovieViewModel())
}