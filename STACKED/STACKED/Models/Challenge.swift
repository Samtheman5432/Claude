import Foundation

// MARK: - Challenge
struct Challenge: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let scenario: String
    let options: [ChallengeOption]
    let correctIndex: Int
    let explanation: String
    let category: ChallengeCategory
    let difficulty: ChallengeDifficulty
    let xpReward: Int
    let moneyIQGain: Int
    let estimatedSeconds: Int
    let imageURL: String?

    var correctOption: ChallengeOption { options[correctIndex] }
}

// MARK: - Challenge Option
struct ChallengeOption: Identifiable, Codable, Equatable {
    let id: String
    let text: String
    let shortLabel: String
    let detail: String?
}

// MARK: - Challenge Category
enum ChallengeCategory: String, Codable, CaseIterable, Identifiable {
    case saving = "Saving"
    case investing = "Investing"
    case credit = "Credit"
    case debt = "Debt"
    case budgeting = "Budgeting"
    case opportunityCost = "Opportunity Cost"
    case lifestyleInflation = "Lifestyle Inflation"
    case entrepreneurship = "Entrepreneurship"
    case taxes = "Taxes"
    case retirement = "Retirement"
    case compoundInterest = "Compound Interest"
    case psychology = "Money Psychology"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .saving: return "💎"
        case .investing: return "📈"
        case .credit: return "💳"
        case .debt: return "⚡"
        case .budgeting: return "📋"
        case .opportunityCost: return "🎯"
        case .lifestyleInflation: return "🔥"
        case .entrepreneurship: return "🚀"
        case .taxes: return "🏛️"
        case .retirement: return "🌴"
        case .compoundInterest: return "🌊"
        case .psychology: return "🧠"
        }
    }

    var color: String {
        switch self {
        case .saving: return "#00FF88"
        case .investing: return "#4A90E2"
        case .credit: return "#A855F7"
        case .debt: return "#FF4757"
        case .budgeting: return "#FFD700"
        case .opportunityCost: return "#FF6B35"
        case .lifestyleInflation: return "#FF8C00"
        case .entrepreneurship: return "#00C851"
        case .taxes: return "#8B8BA7"
        case .retirement: return "#4A90E2"
        case .compoundInterest: return "#00FF88"
        case .psychology: return "#A855F7"
        }
    }
}

// MARK: - Challenge Difficulty
enum ChallengeDifficulty: String, Codable, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case expert = "Expert"

    var xpMultiplier: Double {
        switch self {
        case .easy: return 1.0
        case .medium: return 1.5
        case .hard: return 2.0
        case .expert: return 3.0
        }
    }

    var color: String {
        switch self {
        case .easy: return "#00FF88"
        case .medium: return "#FFD700"
        case .hard: return "#FF6B35"
        case .expert: return "#FF4757"
        }
    }
}

// MARK: - Challenge Attempt
struct ChallengeAttempt: Identifiable, Codable {
    let id: String
    let challengeId: String
    let userId: String
    let selectedIndex: Int
    let isCorrect: Bool
    let xpEarned: Int
    let completedAt: Date
    let timeSpentSeconds: Int
}

// MARK: - Daily Challenge State
struct DailyChallengeState {
    let challenges: [Challenge]
    var completedChallengeIds: Set<String>
    var totalXPEarned: Int
    var allCompleted: Bool { completedChallengeIds.count >= challenges.count }
    var progress: Double {
        guard !challenges.isEmpty else { return 0 }
        return Double(completedChallengeIds.count) / Double(challenges.count)
    }
}
