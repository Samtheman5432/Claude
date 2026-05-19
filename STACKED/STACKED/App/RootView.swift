import SwiftUI

struct RootView: View {
    @EnvironmentObject var authService: MockAuthService
    @AppStorage("has_completed_onboarding") private var hasCompletedOnboarding = false
    @State private var showSplash = true

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            if showSplash {
                SplashView()
                    .transition(.opacity)
            } else if !hasCompletedOnboarding || !authService.isAuthenticated {
                OnboardingFlowView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)
                    ))
            } else {
                MainTabView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)
                    ))
            }
        }
        .animation(.smooth, value: authService.isAuthenticated)
        .animation(.smooth, value: hasCompletedOnboarding)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                withAnimation(.smooth) {
                    showSplash = false
                }
            }
        }
    }
}

// MARK: - Splash Screen
struct SplashView: View {
    @State private var logoScale: CGFloat = 0.7
    @State private var logoOpacity: Double = 0
    @State private var taglineOpacity: Double = 0
    @State private var shimmerOffset: CGFloat = -200

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            // Background glow
            RadialGradient(
                colors: [Theme.Colors.neonGreen.opacity(0.08), .clear],
                center: .center,
                startRadius: 50,
                endRadius: 300
            )
            .ignoresSafeArea()

            VStack(spacing: Theme.Spacing.lg) {
                // Logo
                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(
                            LinearGradient(
                                colors: [Theme.Colors.neonGreen, Color(hex: "#00C851")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .shadow(color: Theme.Colors.neonGreen.opacity(0.4), radius: 20)

                    Text("$")
                        .font(.system(size: 56, weight: .black, design: .rounded))
                        .foregroundStyle(Theme.Colors.background)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

                VStack(spacing: Theme.Spacing.xs) {
                    Text("STACKED")
                        .font(Theme.Typography.largeTitle)
                        .foregroundStyle(Theme.Colors.textPrimary)
                        .opacity(logoOpacity)

                    Text("Build wealth one decision at a time.")
                        .font(Theme.Typography.callout)
                        .foregroundStyle(Theme.Colors.textSecondary)
                        .opacity(taglineOpacity)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.7)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            withAnimation(.easeInOut(duration: 0.5).delay(0.4)) {
                taglineOpacity = 1.0
            }
        }
    }
}
