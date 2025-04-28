import Foundation
import SwiftUI

@MainActor
class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var selectedMovie: Movie?
    
    private let saveKey = "SavedMovies"
    
    init() {
        loadMovies()
    }
    
    func addMovie(_ movie: Movie) {
        movies.append(movie)
        saveMovies()
    }
    
    func updateMovie(_ movie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index] = movie
            saveMovies()
        }
    }
    
    func deleteMovie(_ movie: Movie) {
        movies.removeAll { $0.id == movie.id }
        saveMovies()
    }
    
    private func saveMovies() {
        if let encoded = try? JSONEncoder().encode(movies) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadMovies() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Movie].self, from: data) {
                movies = decoded
            }
        }
    }
    
    var sortedMovies: [Movie] {
        movies.sorted { $0.watchDate > $1.watchDate }
    }
    
    var averageRating: Double {
        guard !movies.isEmpty else { return 0 }
        let sum = movies.reduce(0) { $0 + $1.rating }
        return Double(sum) / Double(movies.count)
    }
}