import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var authService: MockAuthService
    @State private var achievements = DemoData.achievements
    @State private var selectedCategory: AchievementCategory? = nil
    @State private var selectedAchievement: Achievement?
    @State private var appear = false

    var filteredAchievements: [Achievement] {
        if let cat = selectedCategory {
            return achievements.filter { $0.category == cat }
        }
        return achievements
    }

    var unlockedCount: Int { achievements.filter(\.isUnlocked).count }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.background.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: Theme.Spacing.xl) {
                        // Header
                        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                            Text("Achievements")
                                .font(Theme.Typography.largeTitle)
                                .foregroundStyle(Theme.Colors.textPrimary)
                            Text("\(unlockedCount) of \(achievements.count) unlocked")
                                .font(Theme.Typography.callout)
                                .foregroundStyle(Theme.Colors.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, Theme.Spacing.lg)
                        .padding(.top, Theme.Spacing.md)
                        .opacity(appear ? 1 : 0)

                        // Progress
                        VStack(spacing: Theme.Spacing.sm) {
                            HStack {
                                Text("Collection Progress")
                                    .font(Theme.Typography.callout)
                                    .foregroundStyle(Theme.Colors.textSecondary)
                                Spacer()
                                Text("\(Int((Double(unlockedCount) / Double(achievements.count)) * 100))%")
                                    .font(Theme.Typography.callout)
                                    .foregroundStyle(Theme.Colors.neonGreen)
                            }
                            XPProgressBar(current: unlockedCount, max: achievements.count)
                        }
                        .padding(Theme.Spacing.md)
                        .glassCard()
                        .padding(.horizontal, Theme.Spacing.lg)
                        .opacity(appear ? 1 : 0)

                        // Category Filter
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: Theme.Spacing.sm) {
                                FilterPill(title: "All", isSelected: selectedCategory == nil) {
                                    selectedCategory = nil
                                }
                                ForEach(AchievementCategory.allCases, id: \.self) { cat in
                                    FilterPill(title: cat.rawValue, isSelected: selectedCategory == cat) {
                                        selectedCategory = cat
                                    }
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.lg)
                        }
                        .opacity(appear ? 1 : 0)

                        // Achievements Grid
                        LazyVGrid(
                            columns: [GridItem(.adaptive(minimum: 100), spacing: Theme.Spacing.md)],
                            spacing: Theme.Spacing.lg
                        ) {
                            ForEach(filteredAchievements) { achievement in
                                AchievementBadgeView(
                                    achievement: achievement,
                                    size: 72,
                                    showTitle: true
                                )
                                .onTapGesture {
                                    selectedAchievement = achievement
                                    HapticManager.shared.selection()
                                }
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                        .opacity(appear ? 1 : 0)

                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $selectedAchievement) { achievement in
                AchievementDetailSheet(achievement: achievement)
            }
            .onAppear {
                withAnimation(.spring(response: 0.7, dampingFraction: 0.8)) {
                    appear = true
                }
            }
        }
    }
}

// MARK: - Filter Pill
struct FilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            HapticManager.shared.selection()
            action()
        }) {
            Text(title)
                .font(Theme.Typography.caption)
                .foregroundStyle(isSelected ? Theme.Colors.background : Theme.Colors.textSecondary)
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(isSelected ? Theme.Colors.neonGreen : Theme.Colors.surfaceElevated)
                )
        }
        .animation(.snappy, value: isSelected)
    }
}

// MARK: - Achievement Detail Sheet
struct AchievementDetailSheet: View {
    let achievement: Achievement
    @Environment(\.dismiss) private var dismiss
    @State private var appear = false

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            VStack(spacing: Theme.Spacing.xl) {
                // Handle
                RoundedRectangle(cornerRadius: 3)
                    .fill(Theme.Colors.border)
                    .frame(width: 40, height: 4)
                    .padding(.top, Theme.Spacing.md)

                // Badge
                AchievementBadgeView(achievement: achievement, size: 100, showTitle: false)
                    .scaleEffect(appear ? 1.0 : 0.7)
                    .opacity(appear ? 1 : 0)

                VStack(spacing: Theme.Spacing.sm) {
                    Text(achievement.title)
                        .font(Theme.Typography.title2)
                        .foregroundStyle(Theme.Colors.textPrimary)
                        .multilineTextAlignment(.center)

                    Text(achievement.description)
                        .font(Theme.Typography.body)
                        .foregroundStyle(Theme.Colors.textSecondary)
                        .multilineTextAlignment(.center)

                    // Rarity
                    Text(achievement.rarity.rawValue.uppercased())
                        .font(Theme.Typography.micro)
                        .foregroundStyle(Color(hex: achievement.rarity.color))
                        .padding(.horizontal, Theme.Spacing.sm)
                        .padding(.vertical, 4)
                        .background(Color(hex: achievement.rarity.color).opacity(0.15))
                        .clipShape(Capsule())
                }
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? 0 : 20)

                // Stats
                HStack(spacing: Theme.Spacing.lg) {
                    VStack(spacing: 4) {
                        Text("+\(achievement.xpReward)")
                            .font(Theme.Typography.title3)
                            .foregroundStyle(Theme.Colors.neonGreen)
                        Text("XP Reward")
                            .font(Theme.Typography.caption)
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }

                    Divider()
                        .frame(height: 40)
                        .background(Theme.Colors.border)

                    VStack(spacing: 4) {
                        Text(achievement.isUnlocked ? "✅" : "🔒")
                            .font(.system(size: 24))
                        Text(achievement.isUnlocked ? "Unlocked" : "Locked")
                            .font(Theme.Typography.caption)
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }

                    if let date = achievement.unlockedAt {
                        Divider()
                            .frame(height: 40)
                            .background(Theme.Colors.border)

                        VStack(spacing: 4) {
                            Text(date, style: .date)
                                .font(Theme.Typography.caption)
                                .foregroundStyle(Theme.Colors.textPrimary)
                            Text("Earned")
                                .font(Theme.Typography.caption)
                                .foregroundStyle(Theme.Colors.textSecondary)
                        }
                    }
                }
                .padding(Theme.Spacing.lg)
                .glassCard()
                .padding(.horizontal, Theme.Spacing.lg)
                .opacity(appear ? 1 : 0)

                if achievement.isUnlocked {
                    GradientButton(title: "Share Achievement 🎉") {
                        // Share action
                    }
                    .padding(.horizontal, Theme.Spacing.lg)
                    .opacity(appear ? 1 : 0)
                }

                Spacer()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                appear = true
            }
        }
    }
}
