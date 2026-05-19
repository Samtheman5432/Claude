import SwiftUI

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    var subtitle: String? = nil
    var icon: String? = nil
    var iconColor: Color = Theme.Colors.neonGreen
    var valueColor: Color = Theme.Colors.textPrimary
    var trend: StatTrend? = nil

    enum StatTrend {
        case up(String)
        case down(String)
        case neutral(String)

        var color: Color {
            switch self {
            case .up: return Theme.Colors.successGreen
            case .down: return Theme.Colors.errorRed
            case .neutral: return Theme.Colors.textSecondary
            }
        }

        var icon: String {
            switch self {
            case .up: return "arrow.up.right"
            case .down: return "arrow.down.right"
            case .neutral: return "minus"
            }
        }

        var text: String {
            switch self {
            case .up(let t), .down(let t), .neutral(let t): return t
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(iconColor)
                }
                Text(title)
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.Colors.textSecondary)
                Spacer()

                if let trend = trend {
                    HStack(spacing: 2) {
                        Image(systemName: trend.icon)
                            .font(.system(size: 10, weight: .bold))
                        Text(trend.text)
                            .font(Theme.Typography.micro)
                    }
                    .foregroundStyle(trend.color)
                }
            }

            Text(value)
                .font(Theme.Typography.title2)
                .foregroundStyle(valueColor)
                .minimumScaleFactor(0.7)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.Colors.textSecondary)
            }
        }
        .padding(Theme.Spacing.md)
        .glassCard()
    }
}

// MARK: - Money IQ Card
struct MoneyIQCard: View {
    let score: Int
    let level: Int
    let levelTitle: String
    @State private var animatedScore: Int = 0

    var body: some View {
        VStack(spacing: Theme.Spacing.sm) {
            HStack {
                Text("Money IQ")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.Colors.textSecondary)
                Spacer()
                HStack(spacing: 4) {
                    Circle()
                        .fill(Theme.Colors.neonGreen)
                        .frame(width: 6, height: 6)
                    Text("LIVE")
                        .font(Theme.Typography.micro)
                        .foregroundStyle(Theme.Colors.neonGreen)
                }
            }

            HStack(alignment: .bottom, spacing: Theme.Spacing.sm) {
                Text("\(animatedScore)")
                    .font(Theme.Typography.moneyIQ)
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .neonGlow()
                    .animation(.spring(), value: animatedScore)

                VStack(alignment: .leading, spacing: 2) {
                    Text("/ 1000")
                        .font(Theme.Typography.callout)
                        .foregroundStyle(Theme.Colors.textSecondary)
                    Text(scoreLabel)
                        .font(Theme.Typography.micro)
                        .foregroundStyle(scoreColor)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(scoreColor.opacity(0.15))
                        .clipShape(Capsule())
                }
                .padding(.bottom, 6)
            }

            // Score bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Theme.Colors.border)
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(scoreGradient)
                        .frame(width: geo.size.width * (Double(animatedScore) / 1000.0), height: 6)
                        .shadow(color: scoreColor.opacity(0.5), radius: 4)
                }
            }
            .frame(height: 6)

            HStack {
                Text("Lvl \(level) · \(levelTitle)")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.Colors.textSecondary)
                Spacer()
                Text(percentileText)
                    .font(Theme.Typography.micro)
                    .foregroundStyle(Theme.Colors.neonGreen)
            }
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.xl)
                .fill(Theme.Colors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.xl)
                        .strokeBorder(
                            LinearGradient(
                                colors: [Theme.Colors.neonGreen.opacity(0.3), Theme.Colors.border],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: Theme.Colors.neonGreen.opacity(0.1), radius: 20)
        .onAppear {
            withAnimation(.spring(response: 1.2, dampingFraction: 0.8).delay(0.3)) {
                animatedScore = score
            }
        }
        .onChange(of: score) { newValue in
            withAnimation(.spring(response: 0.8)) {
                animatedScore = newValue
            }
        }
    }

    private var scoreLabel: String {
        switch score {
        case 0..<400: return "Building"
        case 400..<600: return "Good"
        case 600..<750: return "Strong"
        case 750..<900: return "Elite"
        default: return "Legendary"
        }
    }

    private var scoreColor: Color {
        switch score {
        case 0..<400: return Theme.Colors.textSecondary
        case 400..<600: return Theme.Colors.accentBlue
        case 600..<750: return Theme.Colors.neonGreen
        case 750..<900: return Theme.Colors.accentGold
        default: return Theme.Colors.accentPurple
        }
    }

    private var scoreGradient: LinearGradient {
        LinearGradient(
            colors: [scoreColor.opacity(0.6), scoreColor],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    private var percentileText: String {
        let percentile = min(99, (score * 100) / 1000)
        return "Top \(100 - percentile)%"
    }
}

// MARK: - Streak Card
struct StreakCard: View {
    let currentStreak: Int
    let longestStreak: Int
    @State private var flameScale: CGFloat = 1.0

    var body: some View {
        VStack(spacing: Theme.Spacing.sm) {
            HStack {
                Text("Daily Streak")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.Colors.textSecondary)
                Spacer()
            }

            HStack(alignment: .center, spacing: Theme.Spacing.sm) {
                Text("🔥")
                    .font(.system(size: 44))
                    .scaleEffect(flameScale)

                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(currentStreak)")
                            .font(Theme.Typography.xpNumber)
                            .foregroundStyle(streakColor)
                        Text("days")
                            .font(Theme.Typography.callout)
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }
                    Text("Best: \(longestStreak) days")
                        .font(Theme.Typography.caption)
                        .foregroundStyle(Theme.Colors.textSecondary)
                }

                Spacer()
            }

            // Week visualizer
            HStack(spacing: Theme.Spacing.xs) {
                ForEach(0..<7) { day in
                    DayDot(
                        isCompleted: day < min(currentStreak, 7),
                        isToday: day == min(currentStreak - 1, 6)
                    )
                }
            }
        }
        .padding(Theme.Spacing.md)
        .glassCard()
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                flameScale = currentStreak > 0 ? 1.1 : 1.0
            }
        }
    }

    private var streakColor: Color {
        switch currentStreak {
        case 0: return Theme.Colors.textSecondary
        case 1..<7: return Theme.Colors.accentOrange
        case 7..<30: return Theme.Colors.accentGold
        default: return Theme.Colors.accentPurple
        }
    }
}

struct DayDot: View {
    let isCompleted: Bool
    let isToday: Bool

    var body: some View {
        Circle()
            .fill(isCompleted ? Theme.Colors.accentOrange : Theme.Colors.border)
            .frame(width: isToday ? 12 : 8, height: isToday ? 12 : 8)
            .overlay(
                Circle()
                    .strokeBorder(isToday ? Theme.Colors.accentOrange : .clear, lineWidth: 2)
                    .frame(width: 16, height: 16)
            )
            .shadow(color: isCompleted ? Theme.Colors.accentOrange.opacity(0.5) : .clear, radius: 3)
    }
}

// MARK: - XP Gain Overlay
struct XPGainOverlay: View {
    let amount: Int
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 0

    var body: some View {
        Text("+\(amount) XP")
            .font(Theme.Typography.title2)
            .foregroundStyle(Theme.Colors.neonGreen)
            .neonGlow()
            .offset(y: offset)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 0.3)) {
                    opacity = 1
                    offset = -20
                }
                withAnimation(.easeIn(duration: 0.4).delay(1.2)) {
                    opacity = 0
                    offset = -60
                }
            }
    }
}
