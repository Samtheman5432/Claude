import Foundation

// MARK: - Auth Service Protocol
protocol AuthServiceProtocol {
    var currentUser: UserProfile? { get }
    var isAuthenticated: Bool { get }
    func signIn(email: String, password: String) async throws -> UserProfile
    func signUp(email: String, password: String, username: String) async throws -> UserProfile
    func signOut() async throws
    func signInWithApple() async throws -> UserProfile
    func updateProfile(_ profile: UserProfile) async throws
    func deleteAccount() async throws
}

// MARK: - Mock Auth Service
final class MockAuthService: AuthServiceProtocol, ObservableObject {
    @Published var currentUser: UserProfile? = nil
    var isAuthenticated: Bool { currentUser != nil }

    init() {
        // Check for persisted demo session
        if let data = UserDefaults.standard.data(forKey: "demo_user"),
           let user = try? JSONDecoder().decode(UserProfile.self, from: data) {
            self.currentUser = user
        }
    }

    func signIn(email: String, password: String) async throws -> UserProfile {
        try await simulateNetworkDelay()
        // Simulate auth validation
        guard !email.isEmpty, !password.isEmpty else {
            throw AuthError.invalidCredentials
        }
        let user = DemoData.currentUser
        await MainActor.run { currentUser = user }
        persistUser(user)
        return user
    }

    func signUp(email: String, password: String, username: String) async throws -> UserProfile {
        try await simulateNetworkDelay()
        guard email.contains("@"), password.count >= 8, !username.isEmpty else {
            throw AuthError.invalidCredentials
        }
        var user = DemoData.currentUser
        // Create fresh user for signup
        user = UserProfile(
            id: UUID().uuidString,
            username: username,
            email: email,
            avatarURL: nil,
            moneyIQ: 500,
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
        await MainActor.run { currentUser = user }
        persistUser(user)
        return user
    }

    func signOut() async throws {
        try await simulateNetworkDelay(seconds: 0.3)
        await MainActor.run { currentUser = nil }
        UserDefaults.standard.removeObject(forKey: "demo_user")
    }

    func signInWithApple() async throws -> UserProfile {
        try await simulateNetworkDelay()
        let user = DemoData.currentUser
        await MainActor.run { currentUser = user }
        persistUser(user)
        return user
    }

    func updateProfile(_ profile: UserProfile) async throws {
        try await simulateNetworkDelay(seconds: 0.3)
        await MainActor.run { currentUser = profile }
        persistUser(profile)
    }

    func deleteAccount() async throws {
        try await simulateNetworkDelay()
        await MainActor.run { currentUser = nil }
        UserDefaults.standard.removeObject(forKey: "demo_user")
    }

    func updateUserStats(xpGained: Int, moneyIQGain: Int) async {
        guard var user = currentUser else { return }
        user = UserProfile(
            id: user.id,
            username: user.username,
            email: user.email,
            avatarURL: user.avatarURL,
            moneyIQ: min(1000, user.moneyIQ + moneyIQGain),
            level: user.level,
            xp: user.xp + xpGained,
            xpToNextLevel: user.xpToNextLevel,
            currentStreak: user.currentStreak,
            longestStreak: user.longestStreak,
            lastActiveDate: Date(),
            financialGoals: user.financialGoals,
            experienceLevel: user.experienceLevel,
            interests: user.interests,
            subscriptionTier: user.subscriptionTier,
            totalChallengesCompleted: user.totalChallengesCompleted + 1,
            totalSimulationsRun: user.totalSimulationsRun,
            joinedAt: user.joinedAt,
            financialArchetype: user.financialArchetype
        )
        await MainActor.run { self.currentUser = user }
        persistUser(user)
    }

    private func persistUser(_ user: UserProfile) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: "demo_user")
        }
    }

    private func simulateNetworkDelay(seconds: Double = 0.8) async throws {
        try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}

// MARK: - Auth Errors
enum AuthError: LocalizedError {
    case invalidCredentials
    case userNotFound
    case emailAlreadyInUse
    case weakPassword
    case networkError
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidCredentials: return "Invalid email or password. Please try again."
        case .userNotFound: return "No account found with this email."
        case .emailAlreadyInUse: return "An account with this email already exists."
        case .weakPassword: return "Password must be at least 8 characters."
        case .networkError: return "Network error. Please check your connection."
        case .unknown: return "Something went wrong. Please try again."
        }
    }
}
