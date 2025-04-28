import SwiftUI

enum Theme {
    static let primary = Color("AccentColor")
    static let success = Color.green
    
    static var background: Color {
        Color(uiColor: .systemBackground)
    }
    
    static var secondaryBackground: Color {
        Color(uiColor: .secondarySystemBackground)
    }
    
    static var groupedBackground: Color {
        Color(uiColor: .systemGroupedBackground)
    }
    
    static var text: Color {
        Color(uiColor: .label)
    }
    
    static var secondaryText: Color {
        Color(uiColor: .secondaryLabel)
    }
    
    static var divider: Color {
        Color(uiColor: .separator)
    }
    
    static let cornerRadius: CGFloat = 12
    static let padding: CGFloat = 16
    
    static let animation = Animation.spring(response: 0.3, dampingFraction: 0.7)
    
    static let shadowRadius: CGFloat = 5
    static let shadowY: CGFloat = 2
    static let shadowOpacity: CGFloat = 0.1
    
    static func adaptiveColor(light: Color, dark: Color) -> Color {
        Color(uiColor: UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
    }
}