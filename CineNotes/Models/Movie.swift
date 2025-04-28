import Foundation

struct Movie: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var genre: String
    var watchDate: Date
    var rating: Int // 1-5 stars
    var thoughts: String
    var favoriteScenes: [String]
    var quotes: [String]
    var emotionalResponse: String
    
    init(id: UUID = UUID(), 
         title: String = "",
         genre: String = "",
         watchDate: Date = Date(),
         rating: Int = 0,
         thoughts: String = "",
         favoriteScenes: [String] = [],
         quotes: [String] = [],
         emotionalResponse: String = "") {
        self.id = id
        self.title = title
        self.genre = genre
        self.watchDate = watchDate
        self.rating = rating
        self.thoughts = thoughts
        self.favoriteScenes = favoriteScenes
        self.quotes = quotes
        self.emotionalResponse = emotionalResponse
    }
}