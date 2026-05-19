import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var authService: MockAuthService
    @Environment(\.challengeService) var challengeService
    @Environment(\.aiService) var aiService

    var body: some View {
        ZStack(alignment: .bottom) {
            // Content
            TabView(selection: $selectedTab) {
                HomeView(
                    viewModel: HomeViewModel(
                        authService: authService,
                        challengeService: challengeService
                    )
                )
                .tag(0)

                ChallengesView(
                    viewModel: ChallengeViewModel(
                        challengeService: challengeService,
                        authService: authService
                    )
                )
                .tag(1)

                SimulatorView(
                    viewModel: SimulatorViewModel(
                        aiService: aiService,
                        authService: authService
                    )
                )
                .tag(2)

                CoachView(
                    viewModel: CoachViewModel(aiService: aiService)
                )
                .tag(3)

                ProfileView(authService: authService)
                .tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Custom Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: Int

    struct TabItem {
        let icon: String
        let selectedIcon: String
        let label: String
        let tag: Int
    }

    let items: [TabItem] = [
        TabItem(icon: "house", selectedIcon: "house.fill", label: "Home", tag: 0),
        TabItem(icon: "bolt", selectedIcon: "bolt.fill", label: "Challenges", tag: 1),
        TabItem(icon: "chart.line.uptrend.xyaxis", selectedIcon: "chart.line.uptrend.xyaxis", label: "Simulate", tag: 2),
        TabItem(icon: "bubble.left", selectedIcon: "bubble.left.fill", label: "Coach", tag: 3),
        TabItem(icon: "person", selectedIcon: "person.fill", label: "Profile", tag: 4)
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(items, id: \.tag) { item in
                TabBarButton(
                    item: item,
                    isSelected: selectedTab == item.tag
                ) {
                    withAnimation(.snappy) {
                        selectedTab = item.tag
                    }
                    HapticManager.shared.selection()
                }
            }
        }
        .padding(.horizontal, Theme.Spacing.sm)
        .padding(.top, Theme.Spacing.md)
        .padding(.bottom, 28)
        .background(
            Rectangle()
                .fill(Theme.Colors.surface)
                .overlay(
                    Rectangle()
                        .fill(Theme.Colors.border)
                        .frame(height: 1),
                    alignment: .top
                )
                .ignoresSafeArea()
        )
    }
}

struct TabBarButton: View {
    let item: CustomTabBar.TabItem
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Capsule()
                            .fill(Theme.Colors.neonGreen.opacity(0.15))
                            .frame(width: 40, height: 28)
                    }
                    Image(systemName: isSelected ? item.selectedIcon : item.icon)
                        .font(.system(size: 18, weight: isSelected ? .semibold : .regular))
                        .foregroundStyle(isSelected ? Theme.Colors.neonGreen : Theme.Colors.textTertiary)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }

                Text(item.label)
                    .font(Theme.Typography.micro)
                    .foregroundStyle(isSelected ? Theme.Colors.neonGreen : Theme.Colors.textTertiary)
            }
            .frame(maxWidth: .infinity)
        }
        .animation(.snappy, value: isSelected)
    }
}
