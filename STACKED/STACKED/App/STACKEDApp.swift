import SwiftUI

@main
struct STACKEDApp: App {
    // MARK: - Services (injected as environment objects)
    @StateObject private var authService = MockAuthService()
    @StateObject private var subscriptionService = MockSubscriptionService()

    private let challengeService = MockChallengeService()
    private let aiService = MockAIService()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authService)
                .environmentObject(subscriptionService)
                .environment(\.challengeService, challengeService)
                .environment(\.aiService, aiService)
                .preferredColorScheme(.dark)
        }
    }
}

// MARK: - Environment Keys
struct ChallengeServiceKey: EnvironmentKey {
    static let defaultValue: MockChallengeService = MockChallengeService()
}

struct AIServiceKey: EnvironmentKey {
    static let defaultValue: MockAIService = MockAIService()
}

extension EnvironmentValues {
    var challengeService: MockChallengeService {
        get { self[ChallengeServiceKey.self] }
        set { self[ChallengeServiceKey.self] = newValue }
    }

    var aiService: MockAIService {
        get { self[AIServiceKey.self] }
        set { self[AIServiceKey.self] = newValue }
    }
}
