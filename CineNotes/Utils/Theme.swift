import SwiftUI

enum Theme {
    static let primary = Color("AccentColor")
    static let background = Color(uiColor: .systemBackground)
    static let secondaryBackground = Color(uiColor: .secondarySystemBackground)
    
    static let text = Color(uiColor: .label)
    static let secondaryText = Color(uiColor: .secondaryLabel)
    
    static let cornerRadius: CGFloat = 12
    static let padding: CGFloat = 16
    
    static let animation = Animation.spring(response: 0.3, dampingFraction: 0.7)
    
    static let shadowRadius: CGFloat = 5
    static let shadowY: CGFloat = 2
    static let shadowOpacity: CGFloat = 0.1
}