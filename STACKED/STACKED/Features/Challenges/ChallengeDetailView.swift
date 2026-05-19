import SwiftUI

struct ChallengeDetailView: View {
    let challenge: Challenge
    var viewModel: ChallengeViewModel? = nil

    @StateObject private var localVM: ChallengeViewModel
    @Environment(\.dismiss) private var dismiss

    init(challenge: Challenge, viewModel: ChallengeViewModel? = nil) {
        self.challenge = challenge
        self.viewModel = viewModel
        // Create local viewmodel if none provided (for standalone navigation)
        self._localVM = StateObject(wrappedValue: viewModel ?? ChallengeViewModel(
            challengeService: MockChallengeService(),
            authService: MockAuthService()
        ))
    }

    private var vm: ChallengeViewModel { viewModel ?? localVM }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Top bar
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Theme.Colors.textSecondary)
                                .frame(width: 36, height: 36)
                                .background(Circle().fill(Theme.Colors.surfaceElevated))
                        }

                        Spacer()

                        HStack(spacing: Theme.Spacing.xs) {
                            Text(challenge.category.emoji)
                            Text(challenge.category.rawValue)
                                .font(Theme.Typography.callout)
                                .foregroundStyle(Theme.Colors.textSecondary)
                        }

                        Spacer()

                        // XP reward
                        Text("+\(challenge.xpReward) XP")
                            .font(Theme.Typography.callout)
                            .foregroundStyle(Theme.Colors.neonGreen)
                            .padding(.horizontal, Theme.Spacing.sm)
                            .padding(.vertical, 6)
                            .background(Theme.Colors.neonGreen.opacity(0.15))
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal, Theme.Spacing.lg)
                    .padding(.top, Theme.Spacing.md)
                    .padding(.bottom, Theme.Spacing.sm)

                    ScrollView(showsIndicators: false) {
                        if vm.showResult {
                            ChallengeResultView(
                                challenge: challenge,
                                isCorrect: vm.isCorrect,
                                selectedIndex: vm.selectedOption ?? -1,
                                xpEarned: vm.xpGained
                            ) {
                                dismiss()
                            }
                        } else {
                            ChallengeQuestionView(
                                challenge: challenge,
                                selectedOption: $localVM.selectedOption,
                                hasSubmitted: vm.hasSubmitted,
                                isLoading: vm.isLoading
                            )
                            .onChange(of: vm.selectedOption) { newVal in
                                if viewModel != nil {
                                    // sync with parent vm
                                }
                            }
                        }
                    }

                    if !vm.showResult {
                        // Submit button
                        VStack(spacing: Theme.Spacing.sm) {
                            GradientButton(
                                title: vm.hasSubmitted ? "Checking..." : "Submit Answer",
                                isLoading: vm.isLoading,
                                isDisabled: vm.selectedOption == nil
                            ) {
                                Task { await submitWithLocalVM() }
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                        .padding(.bottom, Theme.Spacing.xl)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                if viewModel == nil {
                    localVM.startChallenge(challenge)
                }
            }
        }
    }

    private func submitWithLocalVM() async {
        if let vm = viewModel {
            await vm.submitAnswer()
        } else {
            localVM.selectedOption = localVM.selectedOption
            await localVM.submitAnswer()
        }
    }
}

// MARK: - Question View
struct ChallengeQuestionView: View {
    let challenge: Challenge
    @Binding var selectedOption: Int?
    let hasSubmitted: Bool
    let isLoading: Bool
    @State private var appear = false

    var body: some View {
        VStack(spacing: Theme.Spacing.xl) {
            // Question
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                // Difficulty
                HStack {
                    DifficultyBadge(difficulty: challenge.difficulty)
                    Text("~\(challenge.estimatedSeconds) seconds")
                        .font(Theme.Typography.caption)
                        .foregroundStyle(Theme.Colors.textSecondary)
                    Spacer()
                }

                Text(challenge.title)
                    .font(Theme.Typography.title2)
                    .foregroundStyle(Theme.Colors.textPrimary)

                Text(challenge.scenario)
                    .font(Theme.Typography.body)
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .lineSpacing(4)
            }
            .padding(Theme.Spacing.md)
            .glassCard()
            .opacity(appear ? 1 : 0)
            .offset(y: appear ? 0 : 20)

            // Options
            VStack(spacing: Theme.Spacing.sm) {
                Text("Choose the best answer:")
                    .font(Theme.Typography.callout)
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ForEach(Array(challenge.options.enumerated()), id: \.element.id) { index, option in
                    OptionButton(
                        option: option,
                        index: index,
                        isSelected: selectedOption == index,
                        hasSubmitted: hasSubmitted
                    ) {
                        if !hasSubmitted {
                            selectedOption = index
                            HapticManager.shared.selection()
                        }
                    }
                    .opacity(appear ? 1 : 0)
                    .offset(y: appear ? 0 : 20)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(Double(index) * 0.08), value: appear)
                }
            }

            Spacer(minLength: 40)
        }
        .padding(.horizontal, Theme.Spacing.lg)
        .padding(.top, Theme.Spacing.md)
        .onAppear {
            withAnimation {
                appear = true
            }
        }
    }
}

// MARK: - Option Button
struct OptionButton: View {
    let option: ChallengeOption
    let index: Int
    let isSelected: Bool
    let hasSubmitted: Bool
    let action: () -> Void

    let letters = ["A", "B", "C", "D"]

    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.sm) {
                // Letter
                ZStack {
                    Circle()
                        .fill(isSelected ? Theme.Colors.neonGreen : Theme.Colors.surfaceElevated)
                        .frame(width: 28, height: 28)
                    Text(letters[min(index, 3)])
                        .font(Theme.Typography.caption)
                        .foregroundStyle(isSelected ? Theme.Colors.background : Theme.Colors.textSecondary)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(option.text)
                        .font(Theme.Typography.body)
                        .foregroundStyle(Theme.Colors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if let detail = option.detail {
                        Text(detail)
                            .font(Theme.Typography.caption)
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }
                }

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Theme.Colors.neonGreen)
                }
            }
            .padding(Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.lg)
                    .fill(isSelected ? Theme.Colors.neonGreen.opacity(0.1) : Theme.Colors.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.lg)
                            .strokeBorder(
                                isSelected ? Theme.Colors.neonGreen : Theme.Colors.border,
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
            .shadow(color: isSelected ? Theme.Colors.neonGreen.opacity(0.2) : .clear, radius: 8)
        }
        .scaleEffect(isSelected ? 1.01 : 1.0)
        .animation(.snappy, value: isSelected)
    }
}

// MARK: - Result View
struct ChallengeResultView: View {
    let challenge: Challenge
    let isCorrect: Bool
    let selectedIndex: Int
    let xpEarned: Int
    let onDismiss: () -> Void

    @State private var appear = false
    @State private var confettiTrigger = 0

    var body: some View {
        VStack(spacing: Theme.Spacing.xl) {
            // Result Header
            VStack(spacing: Theme.Spacing.md) {
                ZStack {
                    Circle()
                        .fill((isCorrect ? Theme.Colors.neonGreen : Theme.Colors.errorRed).opacity(0.15))
                        .frame(width: 100, height: 100)
                    Text(isCorrect ? "🎯" : "💡")
                        .font(.system(size: 48))
                }
                .scaleEffect(appear ? 1.0 : 0.5)
                .opacity(appear ? 1 : 0)

                VStack(spacing: Theme.Spacing.xs) {
                    Text(isCorrect ? "Correct! 🔥" : "Not quite...")
                        .font(Theme.Typography.title1)
                        .foregroundStyle(isCorrect ? Theme.Colors.neonGreen : Theme.Colors.errorRed)

                    Text(isCorrect ? "You nailed it!" : "But you're learning — that's what matters.")
                        .font(Theme.Typography.callout)
                        .foregroundStyle(Theme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .opacity(appear ? 1 : 0)

                // XP gained
                HStack(spacing: Theme.Spacing.sm) {
                    Text("⚡")
                    Text("+\(xpEarned) XP earned")
                        .font(Theme.Typography.headline)
                        .foregroundStyle(Theme.Colors.neonGreen)
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.vertical, Theme.Spacing.sm)
                .background(
                    Capsule()
                        .fill(Theme.Colors.neonGreen.opacity(0.1))
                        .overlay(Capsule().strokeBorder(Theme.Colors.neonGreen.opacity(0.3), lineWidth: 1))
                )
                .opacity(appear ? 1 : 0)
                .neonGlow(radius: 4)
            }

            // Correct answer breakdown
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                if !isCorrect {
                    VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                        Text("Correct Answer:")
                            .font(Theme.Typography.caption)
                            .foregroundStyle(Theme.Colors.textSecondary)
                        Text(challenge.correctOption.text)
                            .font(Theme.Typography.headline)
                            .foregroundStyle(Theme.Colors.neonGreen)
                    }
                    .padding(Theme.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.Radius.md)
                            .fill(Theme.Colors.neonGreen.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.Radius.md)
                                    .strokeBorder(Theme.Colors.neonGreen.opacity(0.3), lineWidth: 1)
                            )
                    )
                }

                // Explanation
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Text("💡 The Money Lesson")
                        .font(Theme.Typography.headline)
                        .foregroundStyle(Theme.Colors.textPrimary)

                    Text(challenge.explanation)
                        .font(Theme.Typography.body)
                        .foregroundStyle(Theme.Colors.textSecondary)
                        .lineSpacing(5)
                }
                .padding(Theme.Spacing.md)
                .glassCard()
            }
            .opacity(appear ? 1 : 0)
            .offset(y: appear ? 0 : 20)

            // Action buttons
            VStack(spacing: Theme.Spacing.sm) {
                GradientButton(title: "Continue") {
                    onDismiss()
                }
            }
            .padding(.bottom, Theme.Spacing.xl)
            .opacity(appear ? 1 : 0)
        }
        .padding(.horizontal, Theme.Spacing.lg)
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.7)) {
                appear = true
            }
            if isCorrect {
                HapticManager.shared.success()
            }
        }
    }
}
