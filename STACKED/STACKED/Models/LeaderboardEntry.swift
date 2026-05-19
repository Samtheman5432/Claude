import Foundation

// MARK: - Leaderboard Entry
struct LeaderboardEntry: Identifiable, Codable {
    let id: String
    let userId: String
    let username: String
    let avatarURL: String?
    let moneyIQ: Int
    let level: Int
    let currentStreak: Int
    let weeklyXP: Int
    let rank: Int
    let levelTitle: String
    let changeInRank: Int  // positive = moved up, negative = moved down

    var isCurrentUser: Bool = false

    var rankDisplay: String {
        switch rank {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return "#\(rank)"
        }
    }
}

// MARK: - Leaderboard Type
enum LeaderboardType: String, CaseIterable, Identifiable {
    case global = "Global"
    case friends = "Friends"
    case weekly = "This Week"

    var id: String { rawValue }
    var emoji: String {
        switch self {
        case .global: return "🌍"
        case .friends: return "👥"
        case .weekly: return "⚡"
        }
    }
}

// MARK: - Friend
struct Friend: Identifiable, Codable {
    let id: String
    let userId: String
    let friendUserId: String
    let username: String
    let avatarURL: String?
    let moneyIQ: Int
    let currentStreak: Int
    let level: Int
    let status: FriendStatus
    let createdAt: Date
}

enum FriendStatus: String, Codable {
    case pending, accepted, blocked
}
