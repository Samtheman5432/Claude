import Foundation
import SwiftUI

@MainActor
final class ChallengeViewModel: ObservableObject {
    @Published var challenges: [Challenge] = []
    @Published var currentChallenge: Challenge?
    @Published var selectedOption: Int? = nil
    @Published var hasSubmitted = false
    @Published var isCorrect = false
    @Published var isLoading = false
    @Published var showResult = false
    @Published var lastAttempt: ChallengeAttempt?
    @Published var completedIds: Set<String> = []
    @Published var showXPGain = false
    @Published var xpGained = 0
    @Published var selectedCategory: ChallengeCategory? = nil
    @Published var errorMessage: String?

    private var startTime: Date = Date()
    private let challengeService: MockChallengeService
    private let authService: MockAuthService

    init(challengeService: MockChallengeService, authService: MockAuthService) {
        self.challengeService = challengeService
        self.authService = authService
    }

    func loadChallenges() async {
        isLoading = true
        do {
            challenges = try await challengeService.fetchDailyChallenges()
            completedIds = try await challengeService.fetchCompletedIds()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func startChallenge(_ challenge: Challenge) {
        currentChallenge = challenge
        selectedOption = nil
        hasSubmitted = false
        isCorrect = false
        showResult = false
        startTime = Date()
    }

    func selectOption(_ index: Int) {
        guard !hasSubmitted else { return }
        selectedOption = index
        HapticManager.shared.selection()
    }

    func submitAnswer() async {
        guard let challenge = currentChallenge,
              let selected = selectedOption,
              !hasSubmitted else { return }

        hasSubmitted = true
        let timeSpent = Int(Date().timeIntervalSince(startTime))
        isCorrect = selected == challenge.correctIndex

        if isCorrect {
            HapticManager.shared.success()
        } else {
            HapticManager.shared.error()
        }

        do {
            let attempt = try await challengeService.submitAttempt(
                challengeId: challenge.id,
                selectedIndex: selected,
                timeSpent: timeSpent
            )
            lastAttempt = attempt
            xpGained = attempt.xpEarned
            completedIds.insert(challenge.id)

            await authService.updateUserStats(
                xpGained: attempt.xpEarned,
                moneyIQGain: isCorrect ? challenge.moneyIQGain : 0
            )

            showXPGain = true
            try await Task.sleep(nanoseconds: 500_000_000)
            showXPGain = false
            showResult = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func nextChallenge() {
        guard let current = currentChallenge,
              let index = challenges.firstIndex(where: { $0.id == current.id }),
              index + 1 < challenges.count else {
            currentChallenge = nil
            return
        }
        startChallenge(challenges[index + 1])
    }

    func dismissCurrentChallenge() {
        currentChallenge = nil
        selectedOption = nil
        hasSubmitted = false
        showResult = false
    }

    var filteredChallenges: [Challenge] {
        if let category = selectedCategory {
            return challenges.filter { $0.category == category }
        }
        return challenges
    }

    var progress: Double {
        guard !challenges.isEmpty else { return 0 }
        return Double(completedIds.count) / Double(challenges.count)
    }

    func isCompleted(_ challenge: Challenge) -> Bool {
        completedIds.contains(challenge.id)
    }
}
