import Foundation

// MARK: - Subscription Service Protocol
protocol SubscriptionServiceProtocol {
    var currentTier: SubscriptionTier { get }
    var isPremium: Bool { get }
    func fetchOfferings() async throws -> [SubscriptionOffering]
    func purchase(_ offering: SubscriptionOffering) async throws -> SubscriptionTier
    func restorePurchases() async throws -> SubscriptionTier
    func checkSubscriptionStatus() async throws -> SubscriptionTier
}

// MARK: - Subscription Offering
struct SubscriptionOffering: Identifiable {
    let id: String
    let tier: SubscriptionTier
    let title: String
    let price: String
    let period: String
    let originalPrice: String?
    let savingsText: String?
    let features: [String]
    let isPopular: Bool
}

// MARK: - Mock Subscription Service
final class MockSubscriptionService: SubscriptionServiceProtocol, ObservableObject {
    @Published var currentTier: SubscriptionTier = .free
    var isPremium: Bool { currentTier.isPremium }

    func fetchOfferings() async throws -> [SubscriptionOffering] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return [
            SubscriptionOffering(
                id: "stacked_monthly",
                tier: .premium,
                title: "Stacked Pro Monthly",
                price: "$9.99",
                period: "per month",
                originalPrice: nil,
                savingsText: nil,
                features: [
                    "Unlimited AI simulations",
                    "Advanced wealth projections",
                    "Personalized AI coaching",
                    "Premium daily challenges",
                    "Advanced analytics",
                    "Custom learning paths",
                    "Priority support"
                ],
                isPopular: false
            ),
            SubscriptionOffering(
                id: "stacked_annual",
                tier: .annual,
                title: "Stacked Pro Annual",
                price: "$59.99",
                period: "per year",
                originalPrice: "$119.99",
                savingsText: "Save 50% — Best Value!",
                features: [
                    "Everything in Monthly",
                    "50% savings vs monthly",
                    "Early access to new features",
                    "Exclusive annual member badge",
                    "Advanced portfolio simulator",
                    "Tax optimization insights"
                ],
                isPopular: true
            )
        ]
    }

    func purchase(_ offering: SubscriptionOffering) async throws -> SubscriptionTier {
        try await Task.sleep(nanoseconds: 1_500_000_000)
        // In demo mode, simulate successful purchase
        await MainActor.run { currentTier = offering.tier }
        return offering.tier
    }

    func restorePurchases() async throws -> SubscriptionTier {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return currentTier
    }

    func checkSubscriptionStatus() async throws -> SubscriptionTier {
        try await Task.sleep(nanoseconds: 300_000_000)
        return currentTier
    }
}
