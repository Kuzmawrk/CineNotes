import SwiftUI

enum Theme {
    // Primary Colors
    static let primary = Color.blue
    static let secondary = Color.purple
    static let accent = Color.orange
    static let success = Color.green
    
    // Background Colors
    static var background: Color {
        adaptiveColor(
            light: .white,
            dark: Color(hex: "1C1C1E")
        )
    }
    
    static var secondaryBackground: Color {
        adaptiveColor(
            light: Color(hex: "F2F2F7"),
            dark: Color(hex: "2C2C2E")
        )
    }
    
    static var groupedBackground: Color {
        adaptiveColor(
            light: Color(hex: "F2F2F7"),
            dark: Color(hex: "000000")
        )
    }
    
    static var cardBackground: Color {
        adaptiveColor(
            light: .white,
            dark: Color(hex: "2C2C2E")
        )
    }
    
    // Text Colors
    static var text: Color {
        adaptiveColor(
            light: Color(hex: "000000"),
            dark: .white
        )
    }
    
    static var secondaryText: Color {
        adaptiveColor(
            light: Color(hex: "6C6C70"),
            dark: Color(hex: "EBEBF5").opacity(0.6)
        )
    }
    
    // UI Elements
    static var divider: Color {
        adaptiveColor(
            light: Color(hex: "C6C6C8"),
            dark: Color(hex: "38383A")
        )
    }
    
    static var buttonBackground: Color {
        adaptiveColor(
            light: Color(hex: "F2F2F7"),
            dark: Color(hex: "3A3A3C")
        )
    }
    
    // Elevation
    static func elevation(_ level: Int) -> Color {
        adaptiveColor(
            light: .black.opacity(Double(level) * 0.05),
            dark: .white.opacity(Double(level) * 0.05)
        )
    }
    
    // Dimensions
    static let cornerRadius: CGFloat = 12
    static let smallCornerRadius: CGFloat = 8
    static let padding: CGFloat = 16
    static let smallPadding: CGFloat = 8
    
    // Animations
    static let animation = Animation.spring(response: 0.3, dampingFraction: 0.7)
    
    // Shadows
    static let shadowRadius: CGFloat = 10
    static let shadowY: CGFloat = 4
    static let shadowOpacity: CGFloat = 0.1
    
    static func shadowColor(opacity: Double = 0.15) -> Color {
        adaptiveColor(
            light: .black.opacity(opacity),
            dark: .white.opacity(opacity * 0.5)
        )
    }
    
    // Utility Functions
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

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}