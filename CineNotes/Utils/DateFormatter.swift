import Foundation

struct DateFormatters {
    static let movieDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    static func formatDate(_ date: Date) -> String {
        movieDateFormatter.string(from: date)
    }
}