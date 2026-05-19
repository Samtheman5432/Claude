import SwiftUI

struct OnboardingFlowView: View {
    @State private var currentStep = 0
    @State private var selectedGoals: Set<FinancialGoal> = []
    @State private var selectedInterests: Set<FinancialInterest> = []
    @State private var selectedLevel: ExperienceLevel = .beginner
    @State private var reminderTime = Date()
    @State private var navigateToAuth = false
    @AppStorage("has_completed_onboarding") private var hasCompletedOnboarding = false

    private let totalSteps = 6

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Progress
                    OnboardingProgressBar(current: currentStep, total: totalSteps)
                        .padding(.horizontal, Theme.Spacing.lg)
                        .padding(.top, Theme.Spacing.md)

                    // Content
                    TabView(selection: $currentStep) {
                        WelcomeStepView().tag(0)
                        GoalSelectionStepView(selected: $selectedGoals).tag(1)
                        ExperienceLevelStepView(selected: $selectedLevel).tag(2)
                        InterestSelectionStepView(selected: $selectedInterests).tag(3)
                        XPExplainerStepView().tag(4)
                        AuthStepView(
                            onComplete: {
                                hasCompletedOnboarding = true
                            }
                        ).tag(5)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.smooth, value: currentStep)

                    // Navigation buttons
                    if currentStep < totalSteps - 1 {
                        OnboardingNavButtons(
                            currentStep: currentStep,
                            totalSteps: totalSteps,
                            onNext: advanceStep,
                            onSkip: currentStep == 0 ? nil : skipToAuth
                        )
                        .padding(.horizontal, Theme.Spacing.lg)
                        .padding(.bottom, Theme.Spacing.xl)
                    }
                }
            }
        }
    }

    private func advanceStep() {
        HapticManager.shared.selection()
        withAnimation(.smooth) {
            currentStep = min(currentStep + 1, totalSteps - 1)
        }
    }

    private func skipToAuth() {
        withAnimation(.smooth) {
            currentStep = totalSteps - 1
        }
    }
}

// MARK: - Progress Bar
struct OnboardingProgressBar: View {
    let current: Int
    let total: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<total, id: \.self) { step in
                Capsule()
                    .fill(step <= current ? Theme.Colors.neonGreen : Theme.Colors.border)
                    .frame(height: 4)
                    .animation(.smooth, value: current)
            }
        }
    }
}

// MARK: - Nav Buttons
struct OnboardingNavButtons: View {
    let currentStep: Int
    let totalSteps: Int
    let onNext: () -> Void
    let onSkip: (() -> Void)?

    var body: some View {
        VStack(spacing: Theme.Spacing.sm) {
            GradientButton(title: nextButtonTitle, action: onNext)

            if let onSkip = onSkip {
                Button("Skip for now", action: onSkip)
                    .font(Theme.Typography.callout)
                    .foregroundStyle(Theme.Colors.textSecondary)
            }
        }
    }

    private var nextButtonTitle: String {
        currentStep == 0 ? "Let's Go 🚀" : "Continue"
    }
}

// MARK: - Step 1: Welcome
struct WelcomeStepView: View {
    @State private var appear = false

    var body: some View {
        VStack(spacing: Theme.Spacing.xl) {
            Spacer()

            // Hero
            ZStack {
                Circle()
                    .fill(Theme.Colors.neonGreen.opacity(0.08))
                    .frame(width: 200, height: 200)

                VStack(spacing: Theme.Spacing.sm) {
                    Text("💰")
                        .font(.system(size: 72))
                    Text("📈")
                        .font(.system(size: 48))
                        .offset(x: 40, y: -10)
                }
            }
            .scaleEffect(appear ? 1.0 : 0.8)
            .opacity(appear ? 1.0 : 0)

            VStack(spacing: Theme.Spacing.sm) {
                Text("Welcome to")
                    .font(Theme.Typography.title2)
                    .foregroundStyle(Theme.Colors.textSecondary)

                Text("STACKED")
                    .font(Theme.Typography.largeTitle)
                    .foregroundStyle(Theme.Colors.neonGreen)
                    .neonGlow()

                Text("Build wealth one decision at a time.")
                    .font(Theme.Typography.body)
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .opacity(appear ? 1.0 : 0)
            .offset(y: appear ? 0 : 20)

            // Feature pills
            VStack(spacing: Theme.Spacing.sm) {
                FeaturePill(emoji: "🎯", text: "Daily money challenges")
                FeaturePill(emoji: "🤖", text: "AI-powered wealth simulations")
                FeaturePill(emoji: "🔥", text: "Streaks, XP, and achievements")
                FeaturePill(emoji: "📊", text: "Your personal Money IQ score")
            }
            .opacity(appear ? 1.0 : 0)
            .offset(y: appear ? 0 : 30)

            Spacer()
            Spacer()
        }
        .padding(.horizontal, Theme.Spacing.xl)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                appear = true
            }
        }
    }
}

struct FeaturePill: View {
    let emoji: String
    let text: String

    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            Text(emoji)
                .font(.system(size: 20))
            Text(text)
                .font(Theme.Typography.body)
                .foregroundStyle(Theme.Colors.textPrimary)
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Theme.Colors.neonGreen)
        }
        .padding(Theme.Spacing.md)
        .glassCard()
    }
}

// MARK: - Step 2: Goal Selection
struct GoalSelectionStepView: View {
    @Binding var selected: Set<FinancialGoal>

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            VStack(spacing: Theme.Spacing.xs) {
                Text("What are your\nfinancial goals?")
                    .font(Theme.Typography.title1)
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                Text("Select all that apply — we'll personalize your experience.")
                    .font(Theme.Typography.callout)
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, Theme.Spacing.xl)

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Theme.Spacing.sm) {
                    ForEach(FinancialGoal.allCases) { goal in
                        GoalChip(
                            goal: goal,
                            isSelected: selected.contains(goal)
                        ) {
                            if selected.contains(goal) {
                                selected.remove(goal)
                            } else {
                                selected.insert(goal)
                                HapticManager.shared.selection()
                            }
                        }
                    }
                }
                .padding(.horizontal, Theme.Spacing.lg)
            }

            Spacer()
        }
    }
}

struct GoalChip: View {
    let goal: FinancialGoal
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Theme.Spacing.xs) {
                Text(goal.emoji)
                    .font(.system(size: 28))
                Text(goal.rawValue)
                    .font(Theme.Typography.callout)
                    .foregroundStyle(isSelected ? Theme.Colors.background : Theme.Colors.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.lg)
                    .fill(isSelected ? Theme.Colors.neonGreen : Theme.Colors.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.lg)
                            .strokeBorder(isSelected ? .clear : Theme.Colors.border, lineWidth: 1)
                    )
            )
            .shadow(color: isSelected ? Theme.Colors.neonGreen.opacity(0.3) : .clear, radius: 8)
        }
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.snappy, value: isSelected)
    }
}

// MARK: - Step 3: Experience Level
struct ExperienceLevelStepView: View {
    @Binding var selected: ExperienceLevel

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            VStack(spacing: Theme.Spacing.xs) {
                Text("How's your money\nknowledge?")
                    .font(Theme.Typography.title1)
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                Text("No judgment — we'll meet you where you are.")
                    .font(Theme.Typography.callout)
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, Theme.Spacing.xl)

            VStack(spacing: Theme.Spacing.sm) {
                ForEach(ExperienceLevel.allCases) { level in
                    ExperienceLevelRow(
                        level: level,
                        isSelected: selected == level
                    ) {
                        selected = level
                        HapticManager.shared.selection()
                    }
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)

            Spacer()
        }
    }
}

struct ExperienceLevelRow: View {
    let level: ExperienceLevel
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.md) {
                Text(level.emoji)
                    .font(.system(size: 28))

                VStack(alignment: .leading, spacing: 2) {
                    Text(level.rawValue)
                        .font(Theme.Typography.headline)
                        .foregroundStyle(Theme.Colors.textPrimary)
                    Text(level.description)
                        .font(Theme.Typography.caption)
                        .foregroundStyle(Theme.Colors.textSecondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(Theme.Colors.neonGreen)
                }
            }
            .padding(Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.lg)
                    .fill(Theme.Colors.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.lg)
                            .strokeBorder(isSelected ? Theme.Colors.neonGreen : Theme.Colors.border, lineWidth: isSelected ? 2 : 1)
                    )
            )
            .shadow(color: isSelected ? Theme.Colors.neonGreen.opacity(0.2) : .clear, radius: 8)
        }
        .animation(.snappy, value: isSelected)
    }
}

// MARK: - Step 4: Interests
struct InterestSelectionStepView: View {
    @Binding var selected: Set<FinancialInterest>

    let columns = [GridItem(.adaptive(minimum: 100), spacing: Theme.Spacing.sm)]

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            VStack(spacing: Theme.Spacing.xs) {
                Text("What topics\nexcite you?")
                    .font(Theme.Typography.title1)
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                Text("We'll prioritize these in your daily challenges.")
                    .font(Theme.Typography.callout)
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, Theme.Spacing.xl)

            ScrollView {
                LazyVGrid(columns: columns, spacing: Theme.Spacing.sm) {
                    ForEach(FinancialInterest.allCases) { interest in
                        InterestChip(
                            interest: interest,
                            isSelected: selected.contains(interest)
                        ) {
                            if selected.contains(interest) {
                                selected.remove(interest)
                            } else {
                                selected.insert(interest)
                                HapticManager.shared.selection()
                            }
                        }
                    }
                }
                .padding(.horizontal, Theme.Spacing.lg)
            }

            Spacer()
        }
    }
}

struct InterestChip: View {
    let interest: FinancialInterest
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(interest.emoji)
                    .font(.system(size: 24))
                Text(interest.rawValue)
                    .font(Theme.Typography.caption)
                    .foregroundStyle(isSelected ? Theme.Colors.background : Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Theme.Spacing.sm)
            .padding(.horizontal, Theme.Spacing.xs)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.md)
                    .fill(isSelected ? Theme.Colors.neonGreen : Theme.Colors.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.md)
                            .strokeBorder(isSelected ? .clear : Theme.Colors.border, lineWidth: 1)
                    )
            )
            .shadow(color: isSelected ? Theme.Colors.neonGreen.opacity(0.3) : .clear, radius: 6)
        }
        .scaleEffect(isSelected ? 1.03 : 1.0)
        .animation(.snappy, value: isSelected)
    }
}

// MARK: - Step 5: XP Explainer
struct XPExplainerStepView: View {
    @State private var xpAnimated: CGFloat = 0
    @State private var appear = false

    var body: some View {
        VStack(spacing: Theme.Spacing.xl) {
            Spacer()

            VStack(spacing: Theme.Spacing.md) {
                Text("How STACKED works")
                    .font(Theme.Typography.title1)
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .opacity(appear ? 1 : 0)

                Text("A daily habit that builds lasting wealth.")
                    .font(Theme.Typography.body)
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .opacity(appear ? 1 : 0)
            }

            // XP demo
            VStack(spacing: Theme.Spacing.md) {
                HStack {
                    Text("⚡ Daily Challenge")
                        .font(Theme.Typography.headline)
                        .foregroundStyle(Theme.Colors.textPrimary)
                    Spacer()
                    Text("+75 XP")
                        .font(Theme.Typography.headline)
                        .foregroundStyle(Theme.Colors.neonGreen)
                        .neonGlow(radius: 4)
                }

                XPProgressBar(current: Int(xpAnimated), max: 500, animated: false)
            }
            .padding(Theme.Spacing.md)
            .glassCard()
            .padding(.horizontal, Theme.Spacing.lg)
            .opacity(appear ? 1 : 0)
            .offset(y: appear ? 0 : 20)

            VStack(spacing: Theme.Spacing.sm) {
                ExplainerRow(emoji: "🎯", title: "Daily Challenges", description: "3–5 quick money decisions per day")
                ExplainerRow(emoji: "⚡", title: "Earn XP", description: "Level up through 10 wealth tiers")
                ExplainerRow(emoji: "🔥", title: "Build Streaks", description: "Daily habits that compound like money")
                ExplainerRow(emoji: "🧠", title: "Raise Money IQ", description: "Track your financial intelligence score")
                ExplainerRow(emoji: "🤖", title: "AI Simulations", description: "See your real financial future")
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .opacity(appear ? 1 : 0)
            .offset(y: appear ? 0 : 30)

            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.8)) {
                appear = true
            }
            withAnimation(.easeOut(duration: 1.5).delay(0.8)) {
                xpAnimated = 325
            }
        }
    }
}

struct ExplainerRow: View {
    let emoji: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            Text(emoji)
                .font(.system(size: 24))
                .frame(width: 36)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(Theme.Typography.headline)
                    .foregroundStyle(Theme.Colors.textPrimary)
                Text(description)
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.Colors.textSecondary)
            }
            Spacer()
        }
    }
}

// MARK: - Step 6: Auth Step
struct AuthStepView: View {
    @EnvironmentObject var authService: MockAuthService
    let onComplete: () -> Void

    @State private var showLogin = false
    @State private var appear = false

    var body: some View {
        VStack(spacing: Theme.Spacing.xl) {
            Spacer()

            VStack(spacing: Theme.Spacing.md) {
                Text("🚀")
                    .font(.system(size: 64))
                    .scaleEffect(appear ? 1.0 : 0.5)
                    .opacity(appear ? 1 : 0)

                VStack(spacing: Theme.Spacing.xs) {
                    Text("You're ready to get")
                        .font(Theme.Typography.title2)
                        .foregroundStyle(Theme.Colors.textSecondary)
                    Text("STACKED")
                        .font(Theme.Typography.largeTitle)
                        .foregroundStyle(Theme.Colors.neonGreen)
                        .neonGlow()
                }
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? 0 : 20)
            }

            VStack(spacing: Theme.Spacing.sm) {
                GradientButton(title: "Create Free Account", icon: "person.badge.plus") {
                    showLogin = false
                    Task { await quickSignUp() }
                }

                SecondaryButton(title: "Sign In", icon: "arrow.right.circle") {
                    showLogin = true
                    Task { await quickSignUp() }
                }

                Text("Free forever • No credit card required")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.Colors.textTertiary)
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .opacity(appear ? 1 : 0)
            .offset(y: appear ? 0 : 30)

            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.7).delay(0.1)) {
                appear = true
            }
        }
        .sheet(isPresented: $showLogin) {
            AuthView(onComplete: onComplete)
        }
    }

    private func quickSignUp() async {
        // Demo: auto-create demo account
        _ = try? await authService.signIn(email: "demo@getstacked.app", password: "demopassword")
        onComplete()
    }
}
