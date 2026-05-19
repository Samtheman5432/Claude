import SwiftUI

struct LeaderboardView: View {
    @State private var selectedType: LeaderboardType = .global
    @State private var entries = DemoData.leaderboard
    @State private var appear = false

    var currentUserEntry: LeaderboardEntry? {
        entries.first { $0.isCurrentUser }
    }

    var topEntries: [LeaderboardEntry] {
        entries.filter { !$0.isCurrentUser }.prefix(10).map { $0 }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.background.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: Theme.Spacing.lg) {
                        // Header
                        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                            Text("Leaderboard")
                                .font(Theme.Typography.largeTitle)
                                .foregroundStyle(Theme.Colors.textPrimary)
                            Text("Who's the most stacked this week?")
                                .font(Theme.Typography.callout)
                                .foregroundStyle(Theme.Colors.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, Theme.Spacing.lg)
                        .padding(.top, Theme.Spacing.md)
                        .opacity(appear ? 1 : 0)

                        // Type Selector
                        HStack(spacing: Theme.Spacing.sm) {
                            ForEach(LeaderboardType.allCases) { type in
                                LeaderboardTypeButton(
                                    type: type,
                                    isSelected: selectedType == type
                                ) {
                                    withAnimation(.smooth) {
                                        selectedType = type
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                        .opacity(appear ? 1 : 0)

                        // Top 3 Podium
                        if topEntries.count >= 3 {
                            PodiumView(entries: Array(topEntries.prefix(3)))
                                .opacity(appear ? 1 : 0)
                                .offset(y: appear ? 0 : 30)
                        }

                        // Rankings
                        VStack(spacing: Theme.Spacing.xs) {
                            ForEach(Array(topEntries.dropFirst(3).enumerated()), id: \.element.id) { index, entry in
                                LeaderboardRow(entry: entry, rank: entry.rank)
                                    .opacity(appear ? 1 : 0)
                                    .offset(y: appear ? 0 : 10)
                                    .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(Double(index) * 0.04), value: appear)
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.lg)

                        // Your rank (pinned)
                        if let userEntry = currentUserEntry {
                            VStack(spacing: 0) {
                                Divider().background(Theme.Colors.border)
                                LeaderboardRow(entry: userEntry, rank: userEntry.rank, isHighlighted: true)
                                    .padding(.horizontal, Theme.Spacing.lg)
                            }
                        }

                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                    appear = true
                }
            }
        }
    }
}

// MARK: - Type Button
struct LeaderboardTypeButton: View {
    let type: LeaderboardType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(type.emoji)
                Text(type.rawValue)
                    .font(Theme.Typography.caption)
                    .foregroundStyle(isSelected ? Theme.Colors.background : Theme.Colors.textSecondary)
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Theme.Colors.neonGreen : Theme.Colors.surfaceElevated)
            )
        }
        .animation(.snappy, value: isSelected)
    }
}

// MARK: - Podium View
struct PodiumView: View {
    let entries: [LeaderboardEntry]
    @State private var appear = false

    var body: some View {
        HStack(alignment: .bottom, spacing: Theme.Spacing.sm) {
            // 2nd place
            if entries.count > 1 {
                PodiumItem(entry: entries[1], height: 90, medal: "🥈")
                    .scaleEffect(appear ? 1.0 : 0.8)
                    .opacity(appear ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: appear)
            }

            // 1st place
            PodiumItem(entry: entries[0], height: 120, medal: "🥇", isChampion: true)
                .scaleEffect(appear ? 1.0 : 0.8)
                .opacity(appear ? 1 : 0)
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: appear)

            // 3rd place
            if entries.count > 2 {
                PodiumItem(entry: entries[2], height: 70, medal: "🥉")
                    .scaleEffect(appear ? 1.0 : 0.8)
                    .opacity(appear ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: appear)
            }
        }
        .padding(.horizontal, Theme.Spacing.lg)
        .onAppear { appear = true }
    }
}

struct PodiumItem: View {
    let entry: LeaderboardEntry
    let height: CGFloat
    let medal: String
    var isChampion: Bool = false

    var body: some View {
        VStack(spacing: Theme.Spacing.sm) {
            // Medal
            Text(medal)
                .font(.system(size: isChampion ? 32 : 24))

            // Avatar
            ZStack {
                Circle()
                    .fill(
                        isChampion
                        ? Theme.Colors.goldGradient
                        : AnyShapeStyle(Theme.Colors.surfaceElevated)
                    )
                    .frame(width: isChampion ? 56 : 44, height: isChampion ? 56 : 44)

                Text(String(entry.username.prefix(1)))
                    .font(isChampion ? Theme.Typography.title3 : Theme.Typography.headline)
                    .foregroundStyle(isChampion ? Theme.Colors.background : Theme.Colors.textPrimary)
            }
            .shadow(color: isChampion ? Theme.Colors.accentGold.opacity(0.4) : .clear, radius: 8)

            VStack(spacing: 2) {
                Text(entry.username)
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .lineLimit(1)
                Text("\(entry.moneyIQ) IQ")
                    .font(Theme.Typography.micro)
                    .foregroundStyle(Theme.Colors.neonGreen)
            }

            // Podium block
            RoundedRectangle(cornerRadius: Theme.Radius.sm)
                .fill(
                    isChampion
                    ? AnyShapeStyle(Theme.Colors.goldGradient)
                    : AnyShapeStyle(Theme.Colors.surfaceElevated)
                )
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .overlay(
                    VStack {
                        Text("\(entry.rank)")
                            .font(Theme.Typography.title3)
                            .foregroundStyle(isChampion ? Theme.Colors.background : Theme.Colors.textSecondary)
                    }
                )
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Leaderboard Row
struct LeaderboardRow: View {
    let entry: LeaderboardEntry
    let rank: Int
    var isHighlighted: Bool = false

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            // Rank
            Group {
                if rank <= 3 {
                    Text(entry.rankDisplay)
                        .font(.system(size: 20))
                } else {
                    Text("#\(rank)")
                        .font(Theme.Typography.callout)
                        .foregroundStyle(Theme.Colors.textSecondary)
                }
            }
            .frame(width: 32, alignment: .center)

            // Avatar
            ZStack {
                Circle()
                    .fill(isHighlighted ? Theme.Colors.neonGreen.opacity(0.2) : Theme.Colors.surfaceElevated)
                    .frame(width: 40, height: 40)
                Text(String(entry.username.prefix(1)))
                    .font(Theme.Typography.headline)
                    .foregroundStyle(isHighlighted ? Theme.Colors.neonGreen : Theme.Colors.textPrimary)
            }

            // Info
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text(entry.username)
                        .font(Theme.Typography.callout)
                        .foregroundStyle(isHighlighted ? Theme.Colors.neonGreen : Theme.Colors.textPrimary)
                    if isHighlighted {
                        Text("(You)")
                            .font(Theme.Typography.micro)
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }
                }
                Text("Lvl \(entry.level) · \(entry.currentStreak)🔥 streak")
                    .font(Theme.Typography.micro)
                    .foregroundStyle(Theme.Colors.textSecondary)
            }

            Spacer()

            // Stats
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(entry.moneyIQ)")
                    .font(Theme.Typography.callout)
                    .foregroundStyle(Theme.Colors.textPrimary)
                Text("IQ")
                    .font(Theme.Typography.micro)
                    .foregroundStyle(Theme.Colors.textSecondary)
            }

            // Change indicator
            if entry.changeInRank != 0 {
                HStack(spacing: 2) {
                    Image(systemName: entry.changeInRank > 0 ? "arrow.up" : "arrow.down")
                        .font(.system(size: 10, weight: .bold))
                    Text("\(abs(entry.changeInRank))")
                        .font(Theme.Typography.micro)
                }
                .foregroundStyle(entry.changeInRank > 0 ? Theme.Colors.neonGreen : Theme.Colors.errorRed)
                .frame(width: 28)
            }
        }
        .padding(Theme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg)
                .fill(isHighlighted ? Theme.Colors.neonGreen.opacity(0.08) : Theme.Colors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.lg)
                        .strokeBorder(
                            isHighlighted ? Theme.Colors.neonGreen.opacity(0.3) : Theme.Colors.border,
                            lineWidth: 1
                        )
                )
        )
    }
}
