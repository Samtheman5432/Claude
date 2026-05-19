import Foundation

// MARK: - User Profile
struct UserProfile: Identifiable, Codable, Equatable {
    let id: String
    var username: String
    var email: String
    var avatarURL: String?
    var moneyIQ: Int
    var level: Int
    var xp: Int
    var xpToNextLevel: Int
    var currentStreak: Int
    var longestStreak: Int
    var lastActiveDate: Date
    var financialGoals: [FinancialGoal]
    var experienceLevel: ExperienceLevel
    var interests: [FinancialInterest]
    var subscriptionTier: SubscriptionTier
    var totalChallengesCompleted: Int
    var totalSimulationsRun: Int
    var joinedAt: Date
    var financialArchetype: FinancialArchetype

    var levelTitle: String { LevelSystem.title(for: level) }
    var xpProgress: Double { Double(xp) / Double(xpToNextLevel) }

    static let guest = UserProfile(
        id: "guest",
        username: "Guest",
        email: "",
        moneyIQ: 0,
        level: 1,
        xp: 0,
        xpToNextLevel: 500,
        currentStreak: 0,
        longestStreak: 0,
        lastActiveDate: Date(),
        financialGoals: [],
        experienceLevel: .beginner,
        interests: [],
        subscriptionTier: .free,
        totalChallengesCompleted: 0,
        totalSimulationsRun: 0,
        joinedAt: Date(),
        financialArchetype: .curious
    )
}

// MARK: - Level System
enum LevelSystem {
    static let titles = [
        "Wealth Rookie",        // 1
        "Smart Saver",          // 2
        "Money Builder",        // 3
        "Budget Boss",          // 4
        "Asset Architect",      // 5
        "Wealth Strategist",    // 6
        "Capital Commander",    // 7
        "Portfolio Pro",        // 8
        "Financial Maestro",    // 9
        "Stacked Master"        // 10+
    ]

    static func title(for level: Int) -> String {
        let index = min(level - 1, titles.count - 1)
        return titles[max(0, index)]
    }

    static func xpRequired(for level: Int) -> Int {
        // Exponential scaling: each level requires progressively more XP
        return Int(Double(level) * 500 * pow(1.3, Double(level - 1)))
    }

    static func levelForXP(_ totalXP: Int) -> (level: Int, xpIntoLevel: Int, xpToNext: Int) {
        var level = 1
        var accumulatedXP = 0
        while true {
            let required = xpRequired(for: level)
            if accumulatedXP + required > totalXP {
                return (level, totalXP - accumulatedXP, required)
            }
            accumulatedXP += required
            level += 1
            if level > 100 { break }
        }
        return (level, 0, xpRequired(for: level))
    }
}

// MARK: - Financial Goal
enum FinancialGoal: String, Codable, CaseIterable, Identifiable {
    case buildEmergencyFund = "Build Emergency Fund"
    case payOffDebt = "Pay Off Debt"
    case startInvesting = "Start Investing"
    case buyHome = "Buy a Home"
    case retireEarly = "Retire Early"
    case buildWealth = "Build Wealth"
    case startBusiness = "Start a Business"
    case financialFreedom = "Financial Freedom"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .buildEmergencyFund: return "🛡️"
        case .payOffDebt: return "⚡"
        case .startInvesting: return "📈"
        case .buyHome: return "🏠"
        case .retireEarly: return "🌴"
        case .buildWealth: return "💰"
        case .startBusiness: return "🚀"
        case .financialFreedom: return "🔓"
        }
    }
}

// MARK: - Experience Level
enum ExperienceLevel: String, Codable, CaseIterable, Identifiable {
    case complete_beginner = "Complete Beginner"
    case beginner = "Beginner"
    case intermediate = "Some Knowledge"
    case advanced = "Experienced"
    case expert = "Finance Nerd"

    var id: String { rawValue }

    var description: String {
        switch self {
        case .complete_beginner: return "Money? What's that?"
        case .beginner: return "I know the basics"
        case .intermediate: return "I've done some research"
        case .advanced: return "I actively manage my money"
        case .expert: return "I read financial reports for fun"
        }
    }

    var emoji: String {
        switch self {
        case .complete_beginner: return "🌱"
        case .beginner: return "📚"
        case .intermediate: return "💡"
        case .advanced: return "📊"
        case .expert: return "🧠"
        }
    }
}

// MARK: - Financial Interest
enum FinancialInterest: String, Codable, CaseIterable, Identifiable {
    case investing = "Investing"
    case saving = "Saving"
    case entrepreneurship = "Entrepreneurship"
    case budgeting = "Budgeting"
    case sideHustles = "Side Hustles"
    case realEstate = "Real Estate"
    case crypto = "Crypto"
    case retirement = "Retirement"
    case taxes = "Taxes"
    case creditCards = "Credit Cards"

    var id: String { rawValue }
    var emoji: String {
        switch self {
        case .investing: return "📈"
        case .saving: return "💎"
        case .entrepreneurship: return "🚀"
        case .budgeting: return "📋"
        case .sideHustles: return "⚡"
        case .realEstate: return "🏠"
        case .crypto: return "₿"
        case .retirement: return "🌴"
        case .taxes: return "🏛️"
        case .creditCards: return "💳"
        }
    }
}

// MARK: - Subscription Tier
enum SubscriptionTier: String, Codable {
    case free = "Free"
    case premium = "Premium"
    case annual = "Annual"

    var isPremium: Bool { self != .free }

    var displayName: String {
        switch self {
        case .free: return "Free"
        case .premium: return "Stacked Pro"
        case .annual: return "Stacked Pro Annual"
        }
    }
}

// MARK: - Financial Archetype
enum FinancialArchetype: String, Codable, CaseIterable {
    case curious = "The Curious Learner"
    case saver = "The Disciplined Saver"
    case investor = "The Bold Investor"
    case builder = "The Wealth Builder"
    case hustler = "The Relentless Hustler"
    case optimizer = "The Strategic Optimizer"

    var emoji: String {
        switch self {
        case .curious: return "🔍"
        case .saver: return "🛡️"
        case .investor: return "📈"
        case .builder: return "🏗️"
        case .hustler: return "⚡"
        case .optimizer: return "🎯"
        }
    }

    var description: String {
        switch self {
        case .curious: return "You're hungry to learn and soak up every money lesson like a sponge."
        case .saver: return "You prioritize security and build financial safety with discipline."
        case .investor: return "You think long-term and aren't afraid to put money to work."
        case .builder: return "You're focused on creating lasting wealth through smart systems."
        case .hustler: return "You chase every income opportunity and never stop grinding."
        case .optimizer: return "You analyze every decision to maximize financial efficiency."
        }
    }
}
