import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var subscriptionService: MockSubscriptionService
    @Environment(\.dismiss) private var dismiss
    @State private var offerings: [SubscriptionOffering] = []
    @State private var selectedOffering: SubscriptionOffering?
    @State private var isLoading = false
    @State private var isPurchasing = false
    @State private var appear = false
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            // Background gradient
            VStack {
                LinearGradient(
                    colors: [Theme.Colors.accentGold.opacity(0.08), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 300)
                Spacer()
            }
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Dismiss button
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Theme.Colors.textSecondary)
                            .frame(width: 30, height: 30)
                            .background(Circle().fill(Theme.Colors.surfaceElevated))
                    }
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.top, Theme.Spacing.lg)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: Theme.Spacing.xl) {
                        // Hero
                        VStack(spacing: Theme.Spacing.md) {
                            Text("⭐")
                                .font(.system(size: 56))
                                .scaleEffect(appear ? 1.0 : 0.7)
                                .opacity(appear ? 1 : 0)

                            VStack(spacing: Theme.Spacing.xs) {
                                Text("Stacked Pro")
                                    .font(Theme.Typography.largeTitle)
                                    .foregroundStyle(Theme.Colors.accentGold)

                                Text("Unlock your full wealth-building potential")
                                    .font(Theme.Typography.body)
                                    .foregroundStyle(Theme.Colors.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                            .opacity(appear ? 1 : 0)
                            .offset(y: appear ? 0 : 20)
                        }

                        // Features
                        VStack(spacing: Theme.Spacing.sm) {
                            PaywallFeatureRow(icon: "infinity", title: "Unlimited AI Simulations", subtitle: "Run as many 'what if?' scenarios as you want", isProFeature: true)
                            PaywallFeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Advanced Wealth Projections", subtitle: "30-year detailed financial modeling", isProFeature: true)
                            PaywallFeatureRow(icon: "brain", title: "Personalized AI Coaching", subtitle: "Tailored advice based on your goals", isProFeature: true)
                            PaywallFeatureRow(icon: "star", title: "Premium Challenges", subtitle: "Exclusive expert-level content", isProFeature: true)
                            PaywallFeatureRow(icon: "chart.bar", title: "Advanced Analytics", subtitle: "Track your wealth-building progress", isProFeature: true)
                            PaywallFeatureRow(icon: "bolt", title: "Daily Challenges", subtitle: "5 challenges per day", isProFeature: false)
                            PaywallFeatureRow(icon: "flame", title: "Streaks & XP", subtitle: "Full gamification system", isProFeature: false)
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                        .opacity(appear ? 1 : 0)

                        // Plans
                        if isLoading {
                            ProgressView().tint(Theme.Colors.neonGreen)
                        } else {
                            VStack(spacing: Theme.Spacing.sm) {
                                ForEach(offerings) { offering in
                                    SubscriptionPlanCard(
                                        offering: offering,
                                        isSelected: selectedOffering?.id == offering.id
                                    ) {
                                        selectedOffering = offering
                                        HapticManager.shared.selection()
                                    }
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.lg)
                            .opacity(appear ? 1 : 0)
                        }

                        // CTA
                        VStack(spacing: Theme.Spacing.sm) {
                            GradientButton(
                                title: isPurchasing ? "Processing..." : "Start Free Trial",
                                subtitle: "3 days free, then \(selectedOffering?.price ?? "$9.99")/\(selectedOffering?.period ?? "month")",
                                gradient: Theme.Colors.goldGradient,
                                isLoading: isPurchasing
                            ) {
                                Task { await purchase() }
                            }

                            if let error = errorMessage {
                                Text(error)
                                    .font(Theme.Typography.caption)
                                    .foregroundStyle(Theme.Colors.errorRed)
                            }

                            HStack(spacing: Theme.Spacing.lg) {
                                Button("Restore Purchases") {
                                    Task { await restore() }
                                }
                                Button("Privacy Policy") { }
                                Button("Terms of Use") { }
                            }
                            .font(Theme.Typography.micro)
                            .foregroundStyle(Theme.Colors.textTertiary)
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                        .opacity(appear ? 1 : 0)

                        Text("Cancel anytime. No commitment required. Subscriptions auto-renew unless cancelled 24 hours before renewal.")
                            .font(Theme.Typography.micro)
                            .foregroundStyle(Theme.Colors.textTertiary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.Spacing.xl)

                        Spacer(minLength: 40)
                    }
                }
            }
        }
        .task {
            isLoading = true
            offerings = (try? await subscriptionService.fetchOfferings()) ?? []
            selectedOffering = offerings.first(where: { $0.isPopular }) ?? offerings.first
            isLoading = false
            withAnimation(.spring(response: 0.7, dampingFraction: 0.8)) {
                appear = true
            }
        }
    }

    private func purchase() async {
        guard let offering = selectedOffering else { return }
        isPurchasing = true
        errorMessage = nil
        do {
            _ = try await subscriptionService.purchase(offering)
            HapticManager.shared.success()
            dismiss()
        } catch {
            errorMessage = "Purchase failed. Please try again."
            HapticManager.shared.error()
        }
        isPurchasing = false
    }

    private func restore() async {
        _ = try? await subscriptionService.restorePurchases()
    }
}

// MARK: - Feature Row
struct PaywallFeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let isProFeature: Bool

    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(isProFeature ? Theme.Colors.accentGold : Theme.Colors.neonGreen)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: Theme.Spacing.xs) {
                    Text(title)
                        .font(Theme.Typography.callout)
                        .foregroundStyle(Theme.Colors.textPrimary)
                    if isProFeature {
                        Text("PRO")
                            .font(Theme.Typography.micro)
                            .foregroundStyle(Theme.Colors.background)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(Theme.Colors.accentGold))
                    }
                }
                Text(subtitle)
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.Colors.textSecondary)
            }

            Spacer()

            Image(systemName: isProFeature ? "lock.open.fill" : "checkmark")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(isProFeature ? Theme.Colors.accentGold : Theme.Colors.neonGreen)
        }
    }
}

// MARK: - Plan Card
struct SubscriptionPlanCard: View {
    let offering: SubscriptionOffering
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.md) {
                // Radio
                ZStack {
                    Circle()
                        .stroke(isSelected ? Theme.Colors.accentGold : Theme.Colors.border, lineWidth: 2)
                        .frame(width: 22, height: 22)
                    if isSelected {
                        Circle()
                            .fill(Theme.Colors.accentGold)
                            .frame(width: 12, height: 12)
                    }
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(offering.title)
                            .font(Theme.Typography.headline)
                            .foregroundStyle(Theme.Colors.textPrimary)
                        if offering.isPopular {
                            Text("BEST VALUE")
                                .font(Theme.Typography.micro)
                                .foregroundStyle(Theme.Colors.background)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Capsule().fill(Theme.Colors.accentGold))
                        }
                    }
                    if let savings = offering.savingsText {
                        Text(savings)
                            .font(Theme.Typography.caption)
                            .foregroundStyle(Theme.Colors.neonGreen)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(offering.price)
                        .font(Theme.Typography.title3)
                        .foregroundStyle(Theme.Colors.textPrimary)
                    if let original = offering.originalPrice {
                        Text(original)
                            .font(Theme.Typography.caption)
                            .foregroundStyle(Theme.Colors.textTertiary)
                            .strikethrough()
                    }
                    Text(offering.period)
                        .font(Theme.Typography.micro)
                        .foregroundStyle(Theme.Colors.textSecondary)
                }
            }
            .padding(Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.lg)
                    .fill(Theme.Colors.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.lg)
                            .strokeBorder(
                                isSelected ? Theme.Colors.accentGold : Theme.Colors.border,
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
            .shadow(color: isSelected ? Theme.Colors.accentGold.opacity(0.2) : .clear, radius: 8)
        }
        .animation(.snappy, value: isSelected)
    }
}
