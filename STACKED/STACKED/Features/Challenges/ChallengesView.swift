import SwiftUI

struct ChallengesView: View {
    @ObservedObject var viewModel: ChallengeViewModel
    @State private var selectedChallenge: Challenge?
    @State private var showChallengeSheet = false

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
                            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                                Text("Daily Challenges")
                                    .font(Theme.Typography.largeTitle)
                                    .foregroundStyle(Theme.Colors.textPrimary)
                                Text("Train your money brain. Build wealth habits.")
                                    .font(Theme.Typography.callout)
                                    .foregroundStyle(Theme.Colors.textSecondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, Theme.Spacing.lg)
                            .padding(.top, Theme.Spacing.md)

                            // Progress Bar
                            DailyProgressView(
                                completed: viewModel.completedIds.count,
                                total: viewModel.challenges.count,
                                progress: viewModel.progress
                            )
                            .padding(.horizontal, Theme.Spacing.lg)

                            // Category Filter
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: Theme.Spacing.sm) {
                                    // All button
                                    Button {
                                        viewModel.selectedCategory = nil
                                        HapticManager.shared.selection()
                                    } label: {
                                        HStack(spacing: 4) {
                                            Text("All")
                                                .font(Theme.Typography.caption)
                                                .foregroundStyle(viewModel.selectedCategory == nil ? Theme.Colors.background : Theme.Colors.textSecondary)
                                        }
                                        .padding(.horizontal, Theme.Spacing.sm)
                                        .padding(.vertical, 6)
                                        .background(
                                            Capsule()
                                                .fill(viewModel.selectedCategory == nil ? Theme.Colors.neonGreen : Theme.Colors.surfaceElevated)
                                        )
                                    }

                                    ForEach(ChallengeCategory.allCases) { cat in
                                        CategoryChip(category: cat, isSelected: viewModel.selectedCategory == cat) {
                                            viewModel.selectedCategory = cat
                                        }
                                    }
                                }
                                .padding(.horizontal, Theme.Spacing.lg)
                            }

                            // Challenge List
                            LazyVStack(spacing: Theme.Spacing.sm) {
                                ForEach(viewModel.filteredChallenges) { challenge in
                                    ChallengeCardView(
                                        challenge: challenge,
                                        isCompleted: viewModel.isCompleted(challenge)
                                    ) {
                                        selectedChallenge = challenge
                                        viewModel.startChallenge(challenge)
                                        showChallengeSheet = true
                                    }
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.lg)

                            Spacer(minLength: 100)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .task { await viewModel.loadChallenges() }
            .sheet(isPresented: $showChallengeSheet) {
                if let challenge = selectedChallenge {
                    ChallengeDetailView(
                        challenge: challenge,
                        viewModel: viewModel
                    )
                }
            }
        }
    }
}

// MARK: - Daily Progress View
struct DailyProgressView: View {
    let completed: Int
    let total: Int
    let progress: Double

    var body: some View {
        VStack(spacing: Theme.Spacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Today's Progress")
                        .font(Theme.Typography.headline)
                        .foregroundStyle(Theme.Colors.textPrimary)
                    Text("\(completed) of \(total) challenges done")
                        .font(Theme.Typography.caption)
                        .foregroundStyle(Theme.Colors.textSecondary)
                }
                Spacer()

                // Streak bonus indicator
                if completed > 0 {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("+\(completed * 75) XP")
                            .font(Theme.Typography.callout)
                            .foregroundStyle(Theme.Colors.neonGreen)
                        Text("earned today")
                            .font(Theme.Typography.micro)
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }
                }
            }

            XPProgressBar(current: completed, max: max(total, 1), animated: true)
                .frame(height: 10)
        }
        .padding(Theme.Spacing.md)
        .glassCard()
    }
}

// MARK: - Challenge Card
struct ChallengeCardView: View {
    let challenge: Challenge
    let isCompleted: Bool
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            guard !isCompleted else { return }
            HapticManager.shared.medium()
            action()
        }) {
            HStack(spacing: Theme.Spacing.md) {
                // Category Icon
                ZStack {
                    RoundedRectangle(cornerRadius: Theme.Radius.sm)
                        .fill(Color(hex: challenge.category.color).opacity(0.15))
                        .frame(width: 52, height: 52)
                    Text(challenge.category.emoji)
                        .font(.system(size: 26))
                }

                // Content
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    HStack {
                        Text(challenge.category.rawValue)
                            .font(Theme.Typography.micro)
                            .foregroundStyle(Color(hex: challenge.category.color))
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

                    HStack(spacing: Theme.Spacing.xs) {
                        DifficultyBadge(difficulty: challenge.difficulty)
                        Text("·")
                            .foregroundStyle(Theme.Colors.textTertiary)
                        Text("~\(challenge.estimatedSeconds)s")
                            .font(Theme.Typography.micro)
                            .foregroundStyle(Theme.Colors.textTertiary)
                        Spacer()
                    }
                }

                // Arrow
                if !isCompleted {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Theme.Colors.textTertiary)
                }
            }
            .padding(Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.lg)
                    .fill(isCompleted ? Theme.Colors.surfaceElevated : Theme.Colors.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.lg)
                            .strokeBorder(
                                isCompleted ? Theme.Colors.neonGreen.opacity(0.2) : Theme.Colors.border,
                                lineWidth: 1
                            )
                    )
            )
        }
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.snappy, value: isPressed)
        .disabled(isCompleted)
        .opacity(isCompleted ? 0.7 : 1.0)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

struct DifficultyBadge: View {
    let difficulty: ChallengeDifficulty

    var body: some View {
        Text(difficulty.rawValue)
            .font(Theme.Typography.micro)
            .foregroundStyle(Color(hex: difficulty.color))
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(Color(hex: difficulty.color).opacity(0.15))
            .clipShape(Capsule())
    }
}
