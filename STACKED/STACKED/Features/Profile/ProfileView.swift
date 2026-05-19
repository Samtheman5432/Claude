import SwiftUI

struct ProfileView: View {
    @ObservedObject var authService: MockAuthService
    @State private var showSettings = false
    @State private var showPaywall = false
    @State private var showAchievements = false
    @State private var showLeaderboard = false
    @State private var appear = false

    var user: UserProfile { authService.currentUser ?? .guest }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.background.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: Theme.Spacing.xl) {

                        // Profile Header
                        ProfileHeaderView(user: user)
                            .opacity(appear ? 1 : 0)
                            .offset(y: appear ? 0 : -20)

                        // Money IQ Big Card
                        MoneyIQCard(score: user.moneyIQ, level: user.level, levelTitle: user.levelTitle)
                            .padding(.horizontal, Theme.Spacing.lg)
                            .opacity(appear ? 1 : 0)

                        // Stats Row
                        HStack(spacing: Theme.Spacing.sm) {
                            StatCard(
                                title: "Streak",
                                value: "\(user.currentStreak)",
                                subtitle: "days",
                                icon: "flame",
                                iconColor: Theme.Colors.accentOrange
                            )
                            StatCard(
                                title: "Challenges",
                                value: "\(user.totalChallengesCompleted)",
                                subtitle: "completed",
                                icon: "bolt",
                                iconColor: Theme.Colors.neonGreen
                            )
                            StatCard(
                                title: "Simulations",
                                value: "\(user.totalSimulationsRun)",
                                subtitle: "run",
                                icon: "chart.line.uptrend.xyaxis",
                                iconColor: Theme.Colors.accentPurple
                            )
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                        .opacity(appear ? 1 : 0)

                        // Financial Archetype
                        ArchetypeCard(archetype: user.financialArchetype)
                            .padding(.horizontal, Theme.Spacing.lg)
                            .opacity(appear ? 1 : 0)

                        // Quick Navigation
                        VStack(spacing: Theme.Spacing.sm) {
                            ProfileNavRow(
                                icon: "trophy",
                                title: "Achievements",
                                subtitle: "\(DemoData.achievements.filter(\.isUnlocked).count) unlocked",
                                iconColor: Theme.Colors.accentGold
                            ) {
                                showAchievements = true
                            }

                            ProfileNavRow(
                                icon: "chart.bar",
                                title: "Leaderboard",
                                subtitle: "Rank #24 globally",
                                iconColor: Theme.Colors.accentPurple
                            ) {
                                showLeaderboard = true
                            }

                            if !user.subscriptionTier.isPremium {
                                ProfileNavRow(
                                    icon: "star.fill",
                                    title: "Upgrade to Pro",
                                    subtitle: "Unlock unlimited features",
                                    iconColor: Theme.Colors.accentGold,
                                    showBadge: true
                                ) {
                                    showPaywall = true
                                }
                            }

                            ProfileNavRow(
                                icon: "gearshape",
                                title: "Settings",
                                subtitle: nil,
                                iconColor: Theme.Colors.textSecondary
                            ) {
                                showSettings = true
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                        .opacity(appear ? 1 : 0)

                        // Subscription Status
                        if user.subscriptionTier.isPremium {
                            HStack(spacing: Theme.Spacing.sm) {
                                Text("⭐")
                                Text("\(user.subscriptionTier.displayName) Active")
                                    .font(Theme.Typography.callout)
                                    .foregroundStyle(Theme.Colors.accentGold)
                                Spacer()
                                Text("Active")
                                    .font(Theme.Typography.caption)
                                    .foregroundStyle(Theme.Colors.neonGreen)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Theme.Colors.neonGreen.opacity(0.15))
                                    .clipShape(Capsule())
                            }
                            .padding(Theme.Spacing.md)
                            .glassCard()
                            .padding(.horizontal, Theme.Spacing.lg)
                        }

                        // Sign Out
                        Button {
                            Task { try? await authService.signOut() }
                        } label: {
                            Text("Sign Out")
                                .font(Theme.Typography.callout)
                                .foregroundStyle(Theme.Colors.errorRed)
                        }
                        .padding(.bottom, Theme.Spacing.sm)

                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showSettings) { SettingsView(authService: authService) }
            .sheet(isPresented: $showPaywall) { PaywallView() }
            .navigationDestination(isPresented: $showAchievements) { AchievementsView() }
            .navigationDestination(isPresented: $showLeaderboard) { LeaderboardView() }
            .onAppear {
                withAnimation(.spring(response: 0.7, dampingFraction: 0.8)) {
                    appear = true
                }
            }
        }
    }
}

// MARK: - Profile Header
struct ProfileHeaderView: View {
    let user: UserProfile

    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            // Avatar
            ZStack {
                Circle()
                    .fill(Theme.Colors.primaryGradient)
                    .frame(width: 88, height: 88)

                Text(String(user.username.prefix(1)).uppercased())
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundStyle(Theme.Colors.background)
            }
            .shadow(color: Theme.Colors.neonGreen.opacity(0.3), radius: 12)
            .overlay(
                LevelBadge(level: user.level, title: "", size: .small)
                    .offset(x: 28, y: 28)
            )

            VStack(spacing: Theme.Spacing.xs) {
                Text(user.username)
                    .font(Theme.Typography.title2)
                    .foregroundStyle(Theme.Colors.textPrimary)

                Text(user.levelTitle)
                    .font(Theme.Typography.callout)
                    .foregroundStyle(Theme.Colors.neonGreen)
                    .padding(.horizontal, Theme.Spacing.md)
                    .padding(.vertical, 4)
                    .background(Theme.Colors.neonGreen.opacity(0.1))
                    .clipShape(Capsule())

                Text("Member since \(user.joinedAt.formatted(.dateTime.month(.wide).year()))")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.Colors.textTertiary)
            }
        }
        .padding(.top, Theme.Spacing.xl)
    }
}

// MARK: - Archetype Card
struct ArchetypeCard: View {
    let archetype: FinancialArchetype

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                Text("Your Archetype")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.Colors.textSecondary)
                Spacer()
                Text("🔄 Retake Quiz")
                    .font(Theme.Typography.micro)
                    .foregroundStyle(Theme.Colors.accentBlue)
            }

            HStack(spacing: Theme.Spacing.md) {
                Text(archetype.emoji)
                    .font(.system(size: 40))

                VStack(alignment: .leading, spacing: 4) {
                    Text(archetype.rawValue)
                        .font(Theme.Typography.headline)
                        .foregroundStyle(Theme.Colors.textPrimary)
                    Text(archetype.description)
                        .font(Theme.Typography.caption)
                        .foregroundStyle(Theme.Colors.textSecondary)
                        .lineSpacing(3)
                }
            }
        }
        .padding(Theme.Spacing.md)
        .glassCard()
    }
}

// MARK: - Profile Nav Row
struct ProfileNavRow: View {
    let icon: String
    let title: String
    let subtitle: String?
    let iconColor: Color
    var showBadge: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: {
            HapticManager.shared.light()
            action()
        }) {
            HStack(spacing: Theme.Spacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 40, height: 40)
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(iconColor)
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: Theme.Spacing.xs) {
                        Text(title)
                            .font(Theme.Typography.callout)
                            .foregroundStyle(Theme.Colors.textPrimary)
                        if showBadge {
                            Text("PRO")
                                .font(Theme.Typography.micro)
                                .foregroundStyle(Theme.Colors.background)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Theme.Colors.accentGold)
                                .clipShape(Capsule())
                        }
                    }
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(Theme.Typography.caption)
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Theme.Colors.textTertiary)
            }
            .padding(Theme.Spacing.md)
            .glassCard()
        }
    }
}
