import SwiftUI

enum AppTheme {
    enum Colors {
        static let surfaceBase        = Color(hex: "0F1014")
        static let surfaceElevated    = Color(hex: "1B1D25")
        static let surfaceElevatedAlt = Color(hex: "1A1C23")

        static let textPrimary   = Color(hex: "FFFFFF")
        static let textSecondary = Color(hex: "C9CED8")
        static let textTertiary  = Color(hex: "8E94A3")

        static let accentPrimary       = Color(hex: "FF8000")
        static let accentSecondary     = Color(hex: "F4C542")
        static let gradientStart       = Color(hex: "BE662A")
        static let gradientEnd         = Color(hex: "4B1600")

        static let success = Color(hex: "34C759")
        static let danger  = Color(hex: "FF453A")
        static let delete  = Color(hex: "FF8A00")

        static let progressTrack = Color(hex: "2A2F42")
        static let tabBarBg      = Color(hex: "1A1D2A")
        static let chipUnselectedBg = Color(hex: "1B1D25")

        static let backgroundGradient = LinearGradient(
            colors: [gradientStart, gradientEnd],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    enum Spacing {
        static let screenHorizontal: CGFloat = 16
        static let cardGap: CGFloat          = 16
        static let sectionGap: CGFloat       = 22
        static let fieldGap: CGFloat         = 16
        static let labelToField: CGFloat     = 8
        static let itemGap: CGFloat          = 8
        static let listItemGap: CGFloat      = 14
    }

    enum Radius {
        static let input:  CGFloat = 12
        static let card:   CGFloat = 16
        static let button: CGFloat = 16
        static let chip:   CGFloat = 999
    }

    enum Size {
        static let primaryButtonHeight: CGFloat  = 56
        static let inputHeight: CGFloat          = 48
        static let textAreaHeight: CGFloat       = 112
        static let photoDropzoneHeight: CGFloat  = 148
        static let chipHeight: CGFloat           = 40
        static let tabBarHeight: CGFloat         = 49
        static let progressBarHeight: CGFloat    = 9
        static let checklistRowHeight: CGFloat   = 56
        static let topBarHeight: CGFloat         = 56
        static let iconSmall: CGFloat            = 20
        static let touchTargetMin: CGFloat       = 44
        static let rankBadgeSize: CGFloat        = 34
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}
