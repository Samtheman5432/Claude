import Foundation

// MARK: - App Configuration
// Set demoMode = true to run fully offline with mock data (no backend required)
enum AppConfig {
    static let demoMode = true

    // Supabase
    static let supabaseURL = ProcessInfo.processInfo.environment["SUPABASE_URL"] ?? ""
    static let supabaseAnonKey = ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"] ?? ""

    // OpenAI (handled server-side via Edge Functions)
    static let edgeFunctionBaseURL = ProcessInfo.processInfo.environment["EDGE_FUNCTION_URL"] ?? ""

    // RevenueCat
    static let revenueCatAPIKey = ProcessInfo.processInfo.environment["REVENUECAT_API_KEY"] ?? ""

    // PostHog Analytics
    static let postHogAPIKey = ProcessInfo.processInfo.environment["POSTHOG_API_KEY"] ?? ""
    static let postHogHost = "https://app.posthog.com"

    // App
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    static let minimumIOSVersion = "16.0"
}
