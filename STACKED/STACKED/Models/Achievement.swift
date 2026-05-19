import Foundation

// MARK: - Achievement
struct Achievement: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let description: String
    let emoji: String
    let category: AchievementCategory
    let requirement: AchievementRequirement
    let xpReward: Int
    let rarity: AchievementRarity
    var isUnlocked: Bool
    var unlockedAt: Date?

    var displayEmoji: String { isUnlocked ? emoji : "🔒" }
}

// MARK: - Achievement Category
enum AchievementCategory: String, Codable, CaseIterable {
    case streaks = "Streaks"
    case challenges = "Challenges"
    case simulator = "Simulator"
    case social = "Social"
    case milestones = "Milestones"
    case money = "Money Moves"
}

// MARK: - Achievement Requirement
enum AchievementRequirement: Codable, Equatable {
    case streak(days: Int)
    case challengesCompleted(count: Int)
    case correctAnswers(count: Int)
    case simulationsRun(count: Int)
    case moneyIQ(score: Int)
    case level(number: Int)
    case xpEarned(total: Int)
    case custom(id: String)
}

// MARK: - Achievement Rarity
enum AchievementRarity: String, Codable {
    case common = "Common"
    case rare = "Rare"
    case epic = "Epic"
    case legendary = "Legendary"

    var color: String {
        switch self {
        case .common: return "#8B8BA7"
        case .rare: return "#4A90E2"
        case .epic: return "#A855F7"
        case .legendary: return "#FFD700"
        }
    }

    var glowColor: String {
        switch self {
        case .common: return "#8B8BA730"
        case .rare: return "#4A90E230"
        case .epic: return "#A855F730"
        case .legendary: return "#FFD70030"
        }
    }
}

// MARK: - User Achievement
struct UserAchievement: Identifiable, Codable {
    let id: String
    let userId: String
    let achievementId: String
    let unlockedAt: Date
}
