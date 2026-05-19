import SwiftUI

// MARK: - Level Badge
struct LevelBadge: View {
    let level: Int
    let title: String
    var size: BadgeSize = .medium

    enum BadgeSize {
        case small, medium, large
        var iconSize: CGFloat {
            switch self { case .small: return 24; case .medium: return 36; case .large: return 52 }
        }
        var fontSize: Font {
            switch self { case .small: return Theme.Typography.micro; case .medium: return Theme.Typography.caption; case .large: return Theme.Typography.callout }
        }
    }

    var body: some View {
        HStack(spacing: Theme.Spacing.xs) {
            ZStack {
                Circle()
                    .fill(levelGradient)
                    .frame(width: size.iconSize, height: size.iconSize)
                Text("\(level)")
                    .font(.system(size: size.iconSize * 0.4, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
            }
            .shadow(color: levelColor.opacity(0.4), radius: 6)

            if size != .small {
                Text(title)
                    .font(size.fontSize)
                    .foregroundStyle(Theme.Colors.textSecondary)
            }
        }
    }

    private var levelColor: Color {
        switch level {
        case 1: return Color(hex: "#8B8BA7")
        case 2: return Color(hex: "#4A90E2")
        case 3: return Color(hex: "#00C851")
        case 4: return Color(hex: "#00FF88")
        case 5: return Color(hex: "#FFD700")
        case 6: return Color(hex: "#FF8C00")
        case 7: return Color(hex: "#FF4757")
        case 8: return Color(hex: "#A855F7")
        case 9: return Color(hex: "#FF69B4")
        default: return Color(hex: "#FFD700")
        }
    }

    private var levelGradient: LinearGradient {
        LinearGradient(
            colors: [levelColor.opacity(0.8), levelColor],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Achievement Badge View
struct AchievementBadgeView: View {
    let achievement: Achievement
    var size: CGFloat = 72
    var showTitle: Bool = true

    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? rarityGradient : AnyShapeStyle(Theme.Colors.surfaceElevated))
                    .frame(width: size, height: size)

                if achievement.isUnlocked {
                    Circle()
                        .strokeBorder(rarityColor.opacity(0.4), lineWidth: 2)
                        .frame(width: size, height: size)
                        .scaleEffect(isAnimating ? 1.15 : 1.0)
                        .opacity(isAnimating ? 0 : 0.6)
                }

                Text(achievement.isUnlocked ? achievement.emoji : "🔒")
                    .font(.system(size: size * 0.45))
                    .grayscale(achievement.isUnlocked ? 0 : 0.8)
                    .opacity(achievement.isUnlocked ? 1 : 0.5)
            }
            .shadow(color: achievement.isUnlocked ? rarityColor.opacity(0.3) : .clear, radius: 8)

            if showTitle {
                Text(achievement.title)
                    .font(Theme.Typography.micro)
                    .foregroundStyle(achievement.isUnlocked ? Theme.Colors.textPrimary : Theme.Colors.textTertiary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: size + 10)
            }
        }
        .onAppear {
            if achievement.isUnlocked {
                withAnimation(.easeOut(duration: 1.5).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
        }
    }

    private var rarityColor: Color {
        Color(hex: achievement.rarity.color)
    }

    private var rarityGradient: AnyShapeStyle {
        AnyShapeStyle(LinearGradient(
            colors: [rarityColor.opacity(0.3), rarityColor.opacity(0.15)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
    }
}

// MARK: - Category Chip
struct CategoryChip: View {
    let category: ChallengeCategory
    var isSelected: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: {
            HapticManager.shared.selection()
            action()
        }) {
            HStack(spacing: 4) {
                Text(category.emoji)
                    .font(.system(size: 12))
                Text(category.rawValue)
                    .font(Theme.Typography.caption)
                    .foregroundStyle(isSelected ? Theme.Colors.background : Theme.Colors.textSecondary)
            }
            .padding(.horizontal, Theme.Spacing.sm)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(isSelected ? Color(hex: category.color) : Theme.Colors.surfaceElevated)
                    .overlay(
                        Capsule()
                            .strokeBorder(isSelected ? .clear : Theme.Colors.border, lineWidth: 1)
                    )
            )
        }
    }
}
