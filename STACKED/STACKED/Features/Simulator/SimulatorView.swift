import SwiftUI
import Charts

struct SimulatorView: View {
    @ObservedObject var viewModel: SimulatorViewModel
    @State private var appear = false
    @EnvironmentObject var subscriptionService: MockSubscriptionService

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.background.ignoresSafeArea()

                if viewModel.showResult, let result = viewModel.result {
                    SimulationResultDetailView(result: result) {
                        viewModel.resetSimulation()
                    }
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .opacity
                    ))
                } else {
                    SimulatorInputView(viewModel: viewModel)
                }
            }
            .animation(.smooth, value: viewModel.showResult)
            .navigationBarHidden(true)
            .task { await viewModel.loadSuggestions() }
        }
    }
}

// MARK: - Input View
struct SimulatorInputView: View {
    @ObservedObject var viewModel: SimulatorViewModel
    @FocusState private var isFocused: Bool
    @State private var appear = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Theme.Spacing.xl) {
                // Header
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("🤖")
                        .font(.system(size: 40))
                        .opacity(appear ? 1 : 0)
                        .offset(y: appear ? 0 : -10)

                    Text("AI Money Simulator")
                        .font(Theme.Typography.largeTitle)
                        .foregroundStyle(Theme.Colors.textPrimary)

                    Text("Ask 'what if?' about any financial decision.\nGet AI-powered projections in seconds.")
                        .font(Theme.Typography.callout)
                        .foregroundStyle(Theme.Colors.textSecondary)
                        .lineSpacing(3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.top, Theme.Spacing.lg)
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? 0 : 20)

                // Input Field
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Text("Your 'What If?' Scenario")
                        .font(Theme.Typography.callout)
                        .foregroundStyle(Theme.Colors.textSecondary)
                        .padding(.horizontal, Theme.Spacing.lg)

                    VStack(spacing: Theme.Spacing.sm) {
                        TextEditor(text: $viewModel.prompt)
                            .font(Theme.Typography.body)
                            .foregroundStyle(Theme.Colors.textPrimary)
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 100, maxHeight: 160)
                            .focused($isFocused)
                            .overlay(alignment: .topLeading) {
                                if viewModel.prompt.isEmpty {
                                    Text("e.g. What if I invest $200/month for 20 years?")
                                        .font(Theme.Typography.body)
                                        .foregroundStyle(Theme.Colors.textTertiary)
                                        .allowsHitTesting(false)
                                        .padding(.top, 8)
                                        .padding(.leading, 4)
                                }
                            }

                        Divider()
                            .background(Theme.Colors.border)

                        HStack {
                            Text("\(viewModel.prompt.count)/300")
                                .font(Theme.Typography.micro)
                                .foregroundStyle(Theme.Colors.textTertiary)

                            Spacer()

                            if !viewModel.prompt.isEmpty {
                                Button {
                                    viewModel.prompt = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(Theme.Colors.textSecondary)
                                }
                            }
                        }
                    }
                    .padding(Theme.Spacing.md)
                    .glassCard()
                    .padding(.horizontal, Theme.Spacing.lg)

                    // Run button
                    GradientButton(
                        title: viewModel.isLoading ? "Simulating..." : "Run Simulation",
                        icon: viewModel.isLoading ? nil : "sparkles",
                        isLoading: viewModel.isLoading,
                        isDisabled: viewModel.prompt.trimmingCharacters(in: .whitespaces).isEmpty
                    ) {
                        isFocused = false
                        Task { await viewModel.runSimulation() }
                    }
                    .padding(.horizontal, Theme.Spacing.lg)

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(Theme.Typography.caption)
                            .foregroundStyle(Theme.Colors.errorRed)
                            .padding(.horizontal, Theme.Spacing.lg)
                    }
                }
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? 0 : 20)

                // Loading state
                if viewModel.isLoading {
                    SimulationLoadingView()
                        .padding(.horizontal, Theme.Spacing.lg)
                        .transition(.opacity)
                }

                // Suggestions
                if !viewModel.isLoading && !viewModel.suggestions.isEmpty {
                    VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                        Text("💡 Try These Scenarios")
                            .font(Theme.Typography.headline)
                            .foregroundStyle(Theme.Colors.textPrimary)
                            .padding(.horizontal, Theme.Spacing.lg)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: Theme.Spacing.sm) {
                                ForEach(viewModel.suggestions, id: \.self) { suggestion in
                                    SuggestionChip(text: suggestion) {
                                        viewModel.useSuggestion(suggestion)
                                    }
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.lg)
                        }
                    }
                    .opacity(appear ? 1 : 0)
                }

                // Disclaimer
                Text("⚠️ Educational content only, not financial advice. Projections are estimates based on general assumptions.")
                    .font(Theme.Typography.micro)
                    .foregroundStyle(Theme.Colors.textTertiary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.Spacing.xl)
                    .opacity(appear ? 1 : 0)

                Spacer(minLength: 100)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.8)) {
                appear = true
            }
        }
    }
}

// MARK: - Simulation Loading
struct SimulationLoadingView: View {
    @State private var dots = 0
    let messages = [
        "🤖 Analyzing your scenario...",
        "📊 Running financial projections...",
        "💡 Calculating opportunity costs...",
        "🎯 Finding smarter alternatives...",
        "✨ Generating your wealth report..."
    ]
    @State private var messageIndex = 0

    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            ProgressView()
                .tint(Theme.Colors.neonGreen)
                .scaleEffect(1.2)

            Text(messages[messageIndex])
                .font(Theme.Typography.callout)
                .foregroundStyle(Theme.Colors.textSecondary)
                .animation(.smooth, value: messageIndex)
        }
        .frame(maxWidth: .infinity)
        .padding(Theme.Spacing.xl)
        .glassCard()
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                withAnimation {
                    messageIndex = (messageIndex + 1) % messages.count
                }
            }
        }
    }
}

// MARK: - Suggestion Chip
struct SuggestionChip: View {
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(Theme.Typography.caption)
                .foregroundStyle(Theme.Colors.textSecondary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.vertical, Theme.Spacing.sm)
                .frame(width: 180, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: Theme.Radius.md)
                        .fill(Theme.Colors.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.md)
                                .strokeBorder(Theme.Colors.border, lineWidth: 1)
                        )
                )
        }
    }
}

// MARK: - Result Detail View
struct SimulationResultDetailView: View {
    let result: SimulationResult
    let onReset: () -> Void

    @State private var appear = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Theme.Spacing.xl) {
                // Header
                VStack(spacing: Theme.Spacing.sm) {
                    Text(result.headline)
                        .font(Theme.Typography.title1)
                        .foregroundStyle(Theme.Colors.textPrimary)
                        .multilineTextAlignment(.center)
                        .opacity(appear ? 1 : 0)
                        .offset(y: appear ? 0 : -10)

                    Text(result.summary)
                        .font(Theme.Typography.body)
                        .foregroundStyle(Theme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .opacity(appear ? 1 : 0)
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.top, Theme.Spacing.lg)

                // Chart
                if let chartData = result.charts.first {
                    SimulationChartView(data: chartData)
                        .padding(.horizontal, Theme.Spacing.lg)
                        .opacity(appear ? 1 : 0)
                }

                // Projections Grid
                VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                    Text("📊 Wealth Projections")
                        .font(Theme.Typography.headline)
                        .foregroundStyle(Theme.Colors.textPrimary)
                        .padding(.horizontal, Theme.Spacing.lg)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Theme.Spacing.sm) {
                            ForEach(result.projections) { projection in
                                ProjectionCard(projection: projection)
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                    }
                }
                .opacity(appear ? 1 : 0)

                // Opportunity Cost
                if let oc = result.opportunityCost {
                    OpportunityCostCard(oc: oc)
                        .padding(.horizontal, Theme.Spacing.lg)
                        .opacity(appear ? 1 : 0)
                }

                // Smarter Alternatives
                if !result.smarterAlternatives.isEmpty {
                    VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                        Text("⚡ Smarter Moves")
                            .font(Theme.Typography.headline)
                            .foregroundStyle(Theme.Colors.textPrimary)
                            .padding(.horizontal, Theme.Spacing.lg)

                        ForEach(result.smarterAlternatives) { alt in
                            SmartAlternativeCard(alternative: alt)
                                .padding(.horizontal, Theme.Spacing.lg)
                        }
                    }
                    .opacity(appear ? 1 : 0)
                }

                // Motivational Takeaway
                VStack(spacing: Theme.Spacing.sm) {
                    Text("🎯 The Bottom Line")
                        .font(Theme.Typography.headline)
                        .foregroundStyle(Theme.Colors.textPrimary)
                    Text(result.motivationalTakeaway)
                        .font(Theme.Typography.body)
                        .foregroundStyle(Theme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(Theme.Spacing.lg)
                .background(
                    RoundedRectangle(cornerRadius: Theme.Radius.xl)
                        .fill(Theme.Colors.neonGreen.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.xl)
                                .strokeBorder(Theme.Colors.neonGreen.opacity(0.2), lineWidth: 1)
                        )
                )
                .padding(.horizontal, Theme.Spacing.lg)
                .opacity(appear ? 1 : 0)

                // Disclaimer
                Text(result.disclaimer)
                    .font(Theme.Typography.micro)
                    .foregroundStyle(Theme.Colors.textTertiary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.Spacing.xl)

                // CTA
                VStack(spacing: Theme.Spacing.sm) {
                    GradientButton(title: "Run Another Simulation", icon: "arrow.clockwise") {
                        onReset()
                    }
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.bottom, Theme.Spacing.xxxl)
                .opacity(appear ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1)) {
                appear = true
            }
        }
    }
}

// MARK: - Simulation Chart
struct SimulationChartView: View {
    let data: ChartData

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text(data.title)
                .font(Theme.Typography.callout)
                .foregroundStyle(Theme.Colors.textSecondary)

            Chart(data.dataPoints) { point in
                AreaMark(
                    x: .value("Time", point.label),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [Theme.Colors.neonGreen.opacity(0.3), Theme.Colors.neonGreen.opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                LineMark(
                    x: .value("Time", point.label),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(Theme.Colors.neonGreen)
                .lineStyle(StrokeStyle(lineWidth: 2))

                PointMark(
                    x: .value("Time", point.label),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(Theme.Colors.neonGreen)
                .symbolSize(40)
            }
            .frame(height: 180)
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel()
                        .foregroundStyle(Theme.Colors.textSecondary)
                        .font(Theme.Typography.micro)
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let d = value.as(Double.self) {
                            Text(d.compactCurrencyFormatted)
                                .font(Theme.Typography.micro)
                                .foregroundStyle(Theme.Colors.textSecondary)
                        }
                    }
                }
            }
        }
        .padding(Theme.Spacing.md)
        .glassCard()
    }
}

// MARK: - Projection Card
struct ProjectionCard: View {
    let projection: Projection
    @State private var appear = false

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
            Text(projection.emoji)
                .font(.system(size: 24))
            Text(projection.label)
                .font(Theme.Typography.caption)
                .foregroundStyle(Theme.Colors.textSecondary)
            Text(projection.formatted)
                .font(Theme.Typography.title3)
                .foregroundStyle(Theme.Colors.neonGreen)
                .neonGlow(radius: 3)
            Text(projection.timeframe)
                .font(Theme.Typography.micro)
                .foregroundStyle(Theme.Colors.textTertiary)
        }
        .padding(Theme.Spacing.md)
        .frame(width: 130)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg)
                .fill(Theme.Colors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.lg)
                        .strokeBorder(Theme.Colors.neonGreen.opacity(0.2), lineWidth: 1)
                )
        )
        .scaleEffect(appear ? 1.0 : 0.9)
        .opacity(appear ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                appear = true
            }
        }
    }
}

// MARK: - Opportunity Cost Card
struct OpportunityCostCard: View {
    let oc: OpportunityCost

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            Text(oc.emoji)
                .font(.system(size: 32))

            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text("⏰ Opportunity Cost")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.Colors.textSecondary)
                Text(oc.description)
                    .font(Theme.Typography.headline)
                    .foregroundStyle(Theme.Colors.textPrimary)
                Text(oc.comparison)
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.Colors.accentOrange)
            }

            Spacer()

            Text(oc.formatted)
                .font(Theme.Typography.title3)
                .foregroundStyle(Theme.Colors.accentOrange)
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg)
                .fill(Theme.Colors.accentOrange.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.lg)
                        .strokeBorder(Theme.Colors.accentOrange.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Smart Alternative Card
struct SmartAlternativeCard: View {
    let alternative: SmartAlternative

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            Text(alternative.emoji)
                .font(.system(size: 28))
                .padding(Theme.Spacing.sm)
                .background(Theme.Colors.neonGreen.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))

            VStack(alignment: .leading, spacing: 4) {
                Text(alternative.title)
                    .font(Theme.Typography.headline)
                    .foregroundStyle(Theme.Colors.textPrimary)
                Text(alternative.description)
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.Colors.textSecondary)
                Text(alternative.potentialGain)
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.Colors.neonGreen)
            }

            Spacer()
        }
        .padding(Theme.Spacing.md)
        .glassCard()
    }
}
