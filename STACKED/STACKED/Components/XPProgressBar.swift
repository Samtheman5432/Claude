import SwiftUI

// MARK: - XP Progress Bar
struct XPProgressBar: View {
    let current: Int
    let max: Int
    var showLabel: Bool = true
    var height: CGFloat = 8
    var animated: Bool = true

    @State private var animatedProgress: Double = 0

    var progress: Double {
        guard max > 0 else { return 0 }
        return min(1.0, Double(current) / Double(max))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if showLabel {
                HStack {
                    Text("\(current.formattedWithCommas) XP")
                        .font(Theme.Typography.caption)
                        .foregroundStyle(Theme.Colors.textSecondary)
                    Spacer()
                    Text("\(max.formattedWithCommas) XP")
                        .font(Theme.Typography.caption)
                        .foregroundStyle(Theme.Colors.textSecondary)
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(Theme.Colors.border)
                        .frame(height: height)

                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(Theme.Colors.primaryGradient)
                        .frame(width: geo.size.width * (animated ? animatedProgress : progress), height: height)
                        .shadow(color: Theme.Colors.neonGreen.opacity(0.5), radius: 4)
                }
            }
            .frame(height: height)
        }
        .onAppear {
            if animated {
                withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.3)) {
                    animatedProgress = progress
                }
            }
        }
        .onChange(of: current) { _ in
            if animated {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                    animatedProgress = progress
                }
            }
        }
    }
}

// MARK: - Circular Progress View
struct CircularProgressView: View {
    let progress: Double
    let size: CGFloat
    var lineWidth: CGFloat = 6
    var color: Color = Theme.Colors.neonGreen

    var body: some View {
        ZStack {
            Circle()
                .stroke(Theme.Colors.border, lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: CGFloat(min(progress, 1.0)))
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: color.opacity(0.5), radius: 4)
                .animation(.spring(response: 0.8, dampingFraction: 0.7), value: progress)
        }
        .frame(width: size, height: size)
    }
}
