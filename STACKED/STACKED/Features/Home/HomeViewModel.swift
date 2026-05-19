import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var user: UserProfile?
    @Published var dailyChallenges: [Challenge] = []
    @Published var completedChallengeIds: Set<String> = []
    @Published var recentAchievements: [Achievement] = []
    @Published var leaderboardPreview: [LeaderboardEntry] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showXPAnimation = false
    @Published var lastXPGained = 0
    @Published var greeting = ""

    private let authService: MockAuthService
    private let challengeService: MockChallengeService

    init(authService: MockAuthService, challengeService: MockChallengeService) {
        self.authService = authService
        self.challengeService = challengeService
    }

    func load() async {
        isLoading = true
        greeting = buildGreeting()

        async let challenges = try? challengeService.fetchDailyChallenges()
        async let completedIds = try? challengeService.fetchCompletedIds()

        let (c, ids) = await (challenges, completedIds)

        self.user = authService.currentUser
        self.dailyChallenges = c ?? []
        self.completedChallengeIds = ids ?? []
        self.recentAchievements = DemoData.achievements.filter(\.isUnlocked).prefix(3).map { $0 }
        self.leaderboardPreview = Array(DemoData.leaderboard.prefix(3))

        isLoading = false
    }

    func refresh() async {
        await load()
    }

    func awardXP(_ amount: Int, moneyIQGain: Int = 0) async {
        lastXPGained = amount
        showXPAnimation = true
        await authService.updateUserStats(xpGained: amount, moneyIQGain: moneyIQGain)
        self.user = authService.currentUser
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        showXPAnimation = false
    }

    var challengeProgress: Double {
        guard !dailyChallenges.isEmpty else { return 0 }
        return Double(completedChallengeIds.count) / Double(dailyChallenges.count)
    }

    var completedToday: Int { completedChallengeIds.count }
    var totalToday: Int { dailyChallenges.count }

    private func buildGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        default: return "Good evening"
        }
    }
}
