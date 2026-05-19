import Foundation

// MARK: - Analytics Manager
// Implements PostHog event tracking
// Replace with real PostHog SDK for production
final class AnalyticsManager {
    static let shared = AnalyticsManager()
    private init() {}

    private var isEnabled: Bool { !AppConfig.demoMode && !AppConfig.postHogAPIKey.isEmpty }

    func track(_ event: AnalyticsEvent) {
        guard isEnabled else {
            #if DEBUG
            print("📊 Analytics [DEMO]: \(event.name) \(event.properties)")
            #endif
            return
        }
        sendToPostHog(event: event.name, properties: event.properties)
    }

    func identify(userId: String, traits: [String: Any] = [:]) {
        guard isEnabled else { return }
        // PostHog identify call
        var enrichedTraits = traits
        enrichedTraits["app_version"] = AppConfig.appVersion
        enrichedTraits["platform"] = "ios"
        sendIdentify(userId: userId, traits: enrichedTraits)
    }

    private func sendToPostHog(event: String, properties: [String: Any]) {
        guard let url = URL(string: "\(AppConfig.postHogHost)/capture/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "api_key": AppConfig.postHogAPIKey,
            "event": event,
            "properties": properties,
            "timestamp": ISO8601DateFormatter().string(from: Date())
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request).resume()
    }

    private func sendIdentify(userId: String, traits: [String: Any]) {
        // PostHog identify implementation
    }
}

// MARK: - Analytics Events
struct AnalyticsEvent {
    let name: String
    let properties: [String: Any]

    static func appOpened() -> AnalyticsEvent {
        AnalyticsEvent(name: "app_opened", properties: [
            "version": AppConfig.appVersion,
            "demo_mode": AppConfig.demoMode
        ])
    }

    static func onboardingStepCompleted(_ step: Int, name: String) -> AnalyticsEvent {
        AnalyticsEvent(name: "onboarding_step_completed", properties: [
            "step": step,
            "step_name": name
        ])
    }

    static func challengeStarted(_ challenge: Challenge) -> AnalyticsEvent {
        AnalyticsEvent(name: "challenge_started", properties: [
            "challenge_id": challenge.id,
            "category": challenge.category.rawValue,
            "difficulty": challenge.difficulty.rawValue
        ])
    }

    static func challengeCompleted(_ attempt: ChallengeAttempt, challenge: Challenge) -> AnalyticsEvent {
        AnalyticsEvent(name: "challenge_completed", properties: [
            "challenge_id": attempt.challengeId,
            "is_correct": attempt.isCorrect,
            "xp_earned": attempt.xpEarned,
            "time_spent": attempt.timeSpentSeconds,
            "category": challenge.category.rawValue,
            "difficulty": challenge.difficulty.rawValue
        ])
    }

    static func simulationStarted(promptLength: Int, isPremium: Bool) -> AnalyticsEvent {
        AnalyticsEvent(name: "simulation_started", properties: [
            "prompt_length": promptLength,
            "is_premium": isPremium
        ])
    }

    static func simulationCompleted(success: Bool) -> AnalyticsEvent {
        AnalyticsEvent(name: "simulation_completed", properties: ["success": success])
    }

    static func coachMessageSent(length: Int) -> AnalyticsEvent {
        AnalyticsEvent(name: "coach_message_sent", properties: ["message_length": length])
    }

    static func achievementUnlocked(_ achievement: Achievement) -> AnalyticsEvent {
        AnalyticsEvent(name: "achievement_unlocked", properties: [
            "achievement_id": achievement.id,
            "title": achievement.title,
            "rarity": achievement.rarity.rawValue
        ])
    }

    static func paywallViewed(source: String) -> AnalyticsEvent {
        AnalyticsEvent(name: "paywall_viewed", properties: ["source": source])
    }

    static func subscriptionStarted(tier: String, price: String) -> AnalyticsEvent {
        AnalyticsEvent(name: "subscription_started", properties: [
            "tier": tier,
            "price": price
        ])
    }

    static func levelUp(newLevel: Int, title: String) -> AnalyticsEvent {
        AnalyticsEvent(name: "level_up", properties: [
            "new_level": newLevel,
            "level_title": title
        ])
    }

    static func streakExtended(newStreak: Int) -> AnalyticsEvent {
        AnalyticsEvent(name: "streak_extended", properties: ["new_streak": newStreak])
    }
}
