import Foundation

// MARK: - Challenge Service Protocol
protocol ChallengeServiceProtocol {
    func fetchDailyChallenges() async throws -> [Challenge]
    func submitAttempt(challengeId: String, selectedIndex: Int, timeSpent: Int) async throws -> ChallengeAttempt
    func fetchCompletedIds() async throws -> Set<String>
    func fetchChallengesByCategory(_ category: ChallengeCategory) async throws -> [Challenge]
}

// MARK: - Mock Challenge Service
final class MockChallengeService: ChallengeServiceProtocol {
    private var completedIds: Set<String> = {
        let saved = UserDefaults.standard.stringArray(forKey: "completed_challenge_ids") ?? []
        return Set(saved)
    }()

    func fetchDailyChallenges() async throws -> [Challenge] {
        try await delay()
        // Rotate daily challenges based on day of year
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let shuffled = DemoData.challenges.shuffled()
        // Return 5 challenges per day
        let startIndex = (dayOfYear * 5) % DemoData.challenges.count
        var daily: [Challenge] = []
        for i in 0..<5 {
            let index = (startIndex + i) % DemoData.challenges.count
            daily.append(shuffled[index])
        }
        return daily
    }

    func submitAttempt(challengeId: String, selectedIndex: Int, timeSpent: Int) async throws -> ChallengeAttempt {
        try await delay(seconds: 0.5)
        guard let challenge = DemoData.challenges.first(where: { $0.id == challengeId }) else {
            throw ChallengeError.challengeNotFound
        }
        let isCorrect = selectedIndex == challenge.correctIndex
        let xpEarned = isCorrect ? challenge.xpReward : Int(Double(challenge.xpReward) * 0.2)

        // Persist completed challenge
        completedIds.insert(challengeId)
        UserDefaults.standard.set(Array(completedIds), forKey: "completed_challenge_ids")

        return ChallengeAttempt(
            id: UUID().uuidString,
            challengeId: challengeId,
            userId: "demo-user-001",
            selectedIndex: selectedIndex,
            isCorrect: isCorrect,
            xpEarned: xpEarned,
            completedAt: Date(),
            timeSpentSeconds: timeSpent
        )
    }

    func fetchCompletedIds() async throws -> Set<String> {
        try await delay(seconds: 0.2)
        return completedIds
    }

    func fetchChallengesByCategory(_ category: ChallengeCategory) async throws -> [Challenge] {
        try await delay()
        return DemoData.challenges.filter { $0.category == category }
    }

    func resetDailyChallenges() {
        // For demo: clear today's completed challenges
        UserDefaults.standard.removeObject(forKey: "completed_challenge_ids")
        completedIds = []
    }

    private func delay(seconds: Double = 0.6) async throws {
        try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}

// MARK: - Challenge Errors
enum ChallengeError: LocalizedError {
    case challengeNotFound
    case alreadyCompleted
    case networkError

    var errorDescription: String? {
        switch self {
        case .challengeNotFound: return "Challenge not found."
        case .alreadyCompleted: return "You've already completed this challenge today."
        case .networkError: return "Network error. Please try again."
        }
    }
}
