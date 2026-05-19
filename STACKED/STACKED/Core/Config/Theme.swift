import SwiftUI

// MARK: - Design System
enum Theme {
    // MARK: Colors
    enum Colors {
        static let background = Color(hex: "#0A0A0F")
        static let surface = Color(hex: "#13131A")
        static let surfaceElevated = Color(hex: "#1C1C27")
        static let border = Color(hex: "#2A2A3A")

        static let neonGreen = Color(hex: "#00FF88")
        static let neonGreenDim = Color(hex: "#00FF8830")
        static let neonGreenGlow = Color(hex: "#00FF8815")

        static let accent = Color(hex: "#7B5EA7")
        static let accentBlue = Color(hex: "#4A90E2")
        static let accentGold = Color(hex: "#FFD700")
        static let accentOrange = Color(hex: "#FF6B35")
        static let accentRed = Color(hex: "#FF4757")
        static let accentPurple = Color(hex: "#A855F7")

        static let textPrimary = Color.white
        static let textSecondary = Color(hex: "#8B8BA7")
        static let textTertiary = Color(hex: "#4A4A6A")

        static let successGreen = Color(hex: "#00C851")
        static let warningYellow = Color(hex: "#FFD700")
        static let errorRed = Color(hex: "#FF4444")

        // Gradients
        static let primaryGradient = LinearGradient(
            colors: [Color(hex: "#00FF88"), Color(hex: "#00C851")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let goldGradient = LinearGradient(
            colors: [Color(hex: "#FFD700"), Color(hex: "#FF8C00")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let purpleGradient = LinearGradient(
            colors: [Color(hex: "#A855F7"), Color(hex: "#7B5EA7")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let blueGradient = LinearGradient(
            colors: [Color(hex: "#4A90E2"), Color(hex: "#357ABD")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let darkGradient = LinearGradient(
            colors: [Color(hex: "#0A0A0F"), Color(hex: "#13131A")],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: Typography
    enum Typography {
        static let largeTitle = Font.system(size: 34, weight: .black, design: .rounded)
        static let title1 = Font.system(size: 28, weight: .bold, design: .rounded)
        static let title2 = Font.system(size: 22, weight: .bold, design: .rounded)
        static let title3 = Font.system(size: 20, weight: .semibold, design: .rounded)
        static let headline = Font.system(size: 17, weight: .semibold, design: .rounded)
        static let body = Font.system(size: 16, weight: .regular, design: .rounded)
        static let callout = Font.system(size: 14, weight: .medium, design: .rounded)
        static let caption = Font.system(size: 12, weight: .medium, design: .rounded)
        static let micro = Font.system(size: 10, weight: .semibold, design: .rounded)

        static let xpNumber = Font.system(size: 48, weight: .black, design: .rounded)
        static let moneyIQ = Font.system(size: 64, weight: .black, design: .rounded)
    }

    // MARK: Spacing
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let xxxl: CGFloat = 64
    }

    // MARK: Radius
    enum Radius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let full: CGFloat = 100
    }

    // MARK: Shadows
    enum Shadows {
        static let neonGlow = Shadow(color: Color(hex: "#00FF8840"), radius: 20, x: 0, y: 0)
        static let card = Shadow(color: Color.black.opacity(0.4), radius: 16, x: 0, y: 8)
    }
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Color Hex Extension
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
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - View Modifiers
struct GlassCardModifier: ViewModifier {
    var cornerRadius: CGFloat = Theme.Radius.lg

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Theme.Colors.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .strokeBorder(Theme.Colors.border, lineWidth: 1)
                    )
            )
    }
}

struct NeonGlowModifier: ViewModifier {
    var color: Color = Theme.Colors.neonGreen
    var radius: CGFloat = 8

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.6), radius: radius)
            .shadow(color: color.opacity(0.3), radius: radius * 2)
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = Theme.Radius.lg) -> some View {
        modifier(GlassCardModifier(cornerRadius: cornerRadius))
    }

    func neonGlow(color: Color = Theme.Colors.neonGreen, radius: CGFloat = 8) -> some View {
        modifier(NeonGlowModifier(color: color, radius: radius))
    }
}
