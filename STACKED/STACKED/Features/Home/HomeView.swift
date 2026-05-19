import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var authService: MockAuthService
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.background.ignoresSafeArea()

                if viewModel.isLoading {
                    LoadingView()
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: Theme.Spacing.lg) {
                            // Header
                            HomeHeaderView(
                                greeting: viewModel.greeting,
                                user: viewModel.user
                            )

                            // Money IQ + Streak Row
                            HStack(spacing: Theme.Spacing.sm) {
                                if let user = viewModel.user {
                                    MoneyIQCard(
                                        score: user.moneyIQ,
                                        level: user.level,
                                        levelTitle: user.levelTitle
                                    )
                                    .frame(maxWidth: .infinity)

                                    StreakCard(
                                        currentStreak: user.currentStreak,
                                        longestStreak: user.longestStreak
                                    )
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.lg)

                            // XP Progress
                            if let user = viewModel.user {
                                XPProgressSection(user: user)
                                    .padding(.horizontal, Theme.Spacing.lg)
                            }

                            // Today's Challenges
                            DailyChallengesSection(
                                challenges: viewModel.dailyChallenges,
                                completedIds: viewModel.completedChallengeIds,
                                progress: viewModel.challengeProgress
                            )

                            // Recent Achievements
                            if !viewModel.recentAchievements.isEmpty {
                                RecentAchievementsSection(achievements: viewModel.recentAchievements)
                            }

                            // Quick Actions
                            QuickActionsSection(showPaywall: $showPaywall)

                            // Leaderboard Preview
                            LeaderboardPreviewSection(entries: viewModel.leaderboardPreview)

                            Spacer(minLength: 100)
                        }
                    }
                    .refreshable { await viewModel.refresh() }
                }

                // XP Gain Animation
                if viewModel.showXPAnimation {
                    VStack {
                        XPGainOverlay(amount: viewModel.lastXPGained)
                        Spacer()
                    }
                    .padding(.top, 60)
                    .transition(.opacity)
                }
            }
            .navigationBarHidden(true)
            .task { await viewModel.load() }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }
}

// MARK: - Header
struct HomeHeaderView: View {
    let greeting: String
    let user: UserProfile?

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(greeting + "!")
                    .font(Theme.Typography.callout)
                    .foregroundStyle(Theme.Colors.textSecondary)
                Text(user?.username ?? "Stacker")
                    .font(Theme.Typography.title2)
                    .foregroundStyle(Theme.Colors.textPrimary)
            }

            Spacer()

            // Avatar / Level badge
            ZStack {
                Circle()
                    .fill(Theme.Colors.neonGreen.opacity(0.15))
                    .frame(width: 44, height: 44)
                Text("💰")
                    .font(.system(size: 22))
            }
            .overlay(
                Text("\(user?.level ?? 1)")
                    .font(Theme.Typography.micro)
                    .foregroundStyle(Theme.Colors.background)
                    .frame(width: 16, height: 16)
                    .background(Circle().fill(Theme.Colors.neonGreen))
                    .offset(x: 14, y: -14)
            )
        }
        .padding(.horizontal, Theme.Spacing.lg)
        .padding(.top, Theme.Spacing.md)
    }
}

// MARK: - XP Progress Section
struct XPProgressSection: View {
    let user: UserProfile

    var body: some View {
        VStack(spacing: Theme.Spacing.sm) {
            HStack {
                LevelBadge(level: user.level, title: user.levelTitle, size: .medium)
                Spacer()
                Text("Next: Level \(user.level + 1)")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.Colors.textSecondary)
            }

            XPProgressBar(current: user.xp, max: user.xpToNextLevel)
        }
        .padding(Theme.Spacing.md)
        .glassCard()
    }
}

// MARK: - Daily Challenges Section
struct DailyChallengesSection: View {
    let challenges: [Challenge]
    let completedIds: Set<String>
    let progress: Double

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            SectionHeader(
                title: "Today's Challenges",
                subtitle: "\(completedIds.count)/\(challenges.count) complete",
                emoji: "⚡"
            )

            // Progress summary
            HStack(spacing: Theme.Spacing.sm) {
                CircularProgressView(progress: progress, size: 52)
                    .padding(4)

                VStack(alignment: .leading, spacing: 2) {
                    Text(progress >= 1.0 ? "All done! 🎉" : "Keep going!")
                        .font(Theme.Typography.headline)
                        .foregroundStyle(Theme.Colors.textPrimary)
                    Text(progress >= 1.0 ? "Come back tomorrow for more XP" : "\(challenges.count - completedIds.count) challenges remaining")
                        .font(Theme.Typography.caption)
                        .foregroundStyle(Theme.Colors.textSecondary)
                }
                Spacer()

                if progress >= 1.0 {
                    Text("🔥 +\(completedIds.count * 75) XP")
                        .font(Theme.Typography.callout)
                        .foregroundStyle(Theme.Colors.neonGreen)
                }
            }
            .padding(Theme.Spacing.md)
            .glassCard()
            .padding(.horizontal, Theme.Spacing.lg)

            // Challenge cards scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.Spacing.sm) {
                    ForEach(challenges) { challenge in
                        NavigationLink {
                            ChallengeDetailView(challenge: challenge)
                        } label: {
                            HomeChallengeCard(
                                challenge: challenge,
                                isCompleted: completedIds.contains(challenge.id)
                            )
                        }
                    }
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.vertical, 4)
            }
        }
    }
}

struct HomeChallengeCard: View {
    let challenge: Challenge
    let isCompleted: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                Text(challenge.category.emoji)
                    .font(.system(size: 20))
                Spacer()
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Theme.Colors.neonGreen)
                } else {
                    Text("+\(challenge.xpReward) XP")
                        .font(Theme.Typography.micro)
                        .foregroundStyle(Theme.Colors.neonGreen)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Theme.Colors.neonGreen.opacity(0.15))
                        .clipShape(Capsule())
                }
            }

            Text(challenge.title)
                .font(Theme.Typography.headline)
                .foregroundStyle(isCompleted ? Theme.Colors.textSecondary : Theme.Colors.textPrimary)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 4) {
                Text(challenge.difficulty.rawValue)
                    .font(Theme.Typography.micro)
                    .foregroundStyle(Color(hex: challenge.difficulty.color))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color(hex: challenge.difficulty.color).opacity(0.15))
                    .clipShape(Capsule())

                Text("~\(challenge.estimatedSeconds)s")
                    .font(Theme.Typography.micro)
                    .foregroundStyle(Theme.Colors.textTertiary)
            }
        }
        .padding(Theme.Spacing.md)
        .frame(width: 180)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg)
                .fill(isCompleted ? Theme.Colors.surfaceElevated : Theme.Colors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.lg)
                        .strokeBorder(
                            isCompleted ? Theme.Colors.neonGreen.opacity(0.3) : Theme.Colors.border,
                            lineWidth: 1
                        )
                )
        )
        .opacity(isCompleted ? 0.7 : 1.0)
    }
}

// MARK: - Recent Achievements
struct RecentAchievementsSection: View {
    let achievements: [Achievement]

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            SectionHeader(title: "Recent Achievements", emoji: "🏆")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.Spacing.lg) {
                    ForEach(achievements) { achievement in
                        AchievementBadgeView(achievement: achievement, size: 68)
                    }
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.vertical, 4)
            }
        }
    }
}

// MARK: - Quick Actions
struct QuickActionsSection: View {
    @Binding var showPaywall: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            SectionHeader(title: "Quick Actions", emoji: "⚡")

            HStack(spacing: Theme.Spacing.sm) {
                NavigationLink {
                    SimulatorView(viewModel: SimulatorViewModel(
                        aiService: MockAIService(),
                        authService: MockAuthService()
                    ))
                } label: {
                    QuickActionCard(
                        emoji: "🤖",
                        title: "AI Simulator",
                        subtitle: "See your future wealth",
                        color: Theme.Colors.accentPurple
                    )
                }

                NavigationLink {
                    CoachView(viewModel: CoachViewModel(aiService: MockAIService()))
                } label: {
                    QuickActionCard(
                        emoji: "💬",
                        title: "Money Coach",
                        subtitle: "Ask anything",
                        color: Theme.Colors.accentBlue
                    )
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
        }
    }
}

struct QuickActionCard: View {
    let emoji: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text(emoji)
                .font(.system(size: 28))
                .padding(Theme.Spacing.xs)
                .background(color.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))

            Text(title)
                .font(Theme.Typography.headline)
                .foregroundStyle(Theme.Colors.textPrimary)
            Text(subtitle)
                .font(Theme.Typography.caption)
                .foregroundStyle(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg)
                .fill(Theme.Colors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.lg)
                        .strokeBorder(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Leaderboard Preview
struct LeaderboardPreviewSection: View {
    let entries: [LeaderboardEntry]

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            SectionHeader(title: "Leaderboard", subtitle: "Top 3 this week", emoji: "🏅")

            VStack(spacing: Theme.Spacing.xs) {
                ForEach(entries) { entry in
                    LeaderboardRowCompact(entry: entry)
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
        }
    }
}

struct LeaderboardRowCompact: View {
    let entry: LeaderboardEntry

    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            Text(entry.rankDisplay)
                .font(entry.rank <= 3 ? .system(size: 20) : Theme.Typography.headline)
                .frame(width: 28)

            ZStack {
                Circle()
                    .fill(Theme.Colors.neonGreen.opacity(0.1))
                    .frame(width: 36, height: 36)
                Text(String(entry.username.prefix(1)))
                    .font(Theme.Typography.headline)
                    .foregroundStyle(Theme.Colors.neonGreen)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.username)
                    .font(Theme.Typography.callout)
                    .foregroundStyle(Theme.Colors.textPrimary)
                Text("Lvl \(entry.level) · \(entry.currentStreak)🔥")
                    .font(Theme.Typography.micro)
                    .foregroundStyle(Theme.Colors.textSecondary)
            }

            Spacer()

            Text("\(entry.moneyIQ) IQ")
                .font(Theme.Typography.callout)
                .foregroundStyle(Theme.Colors.neonGreen)
        }
        .padding(Theme.Spacing.sm)
        .glassCard(cornerRadius: Theme.Radius.md)
    }
}

// MARK: - Helpers
struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var emoji: String? = nil

    var body: some View {
        HStack {
            HStack(spacing: Theme.Spacing.xs) {
                if let emoji = emoji {
                    Text(emoji)
                }
                Text(title)
                    .font(Theme.Typography.title3)
                    .foregroundStyle(Theme.Colors.textPrimary)
            }
            Spacer()
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.Colors.textSecondary)
            }
        }
        .padding(.horizontal, Theme.Spacing.lg)
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            ProgressView()
                .tint(Theme.Colors.neonGreen)
                .scaleEffect(1.3)
            Text("Loading your stats...")
                .font(Theme.Typography.callout)
                .foregroundStyle(Theme.Colors.textSecondary)
        }
    }
}
