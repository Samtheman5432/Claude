import SwiftUI

// MARK: - Primary Gradient Button
struct GradientButton: View {
    let title: String
    var subtitle: String? = nil
    var icon: String? = nil
    var gradient: LinearGradient = Theme.Colors.primaryGradient
    var isLoading: Bool = false
    var isDisabled: Bool = false
    var action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            guard !isDisabled && !isLoading else { return }
            HapticManager.shared.medium()
            action()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: Theme.Radius.lg)
                    .fill(isDisabled ? AnyShapeStyle(Theme.Colors.border) : AnyShapeStyle(gradient))
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .shadow(color: isDisabled ? .clear : Theme.Colors.neonGreen.opacity(0.3), radius: 12, y: 4)

                if isLoading {
                    ProgressView()
                        .tint(Theme.Colors.background)
                } else {
                    HStack(spacing: Theme.Spacing.sm) {
                        if let icon = icon {
                            Image(systemName: icon)
                                .font(.system(size: 18, weight: .bold))
                        }
                        VStack(spacing: 2) {
                            Text(title)
                                .font(Theme.Typography.headline)
                                .foregroundStyle(isDisabled ? Theme.Colors.textSecondary : Theme.Colors.background)
                            if let subtitle = subtitle {
                                Text(subtitle)
                                    .font(Theme.Typography.micro)
                                    .foregroundStyle(isDisabled ? Theme.Colors.textSecondary : Theme.Colors.background.opacity(0.8))
                            }
                        }
                    }
                }
            }
        }
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.snappy, value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .disabled(isDisabled || isLoading)
    }
}

// MARK: - Secondary Button
struct SecondaryButton: View {
    let title: String
    var icon: String? = nil
    var action: () -> Void

    var body: some View {
        Button(action: {
            HapticManager.shared.light()
            action()
        }) {
            HStack(spacing: Theme.Spacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .font(Theme.Typography.headline)
            }
            .foregroundStyle(Theme.Colors.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.lg)
                    .fill(Theme.Colors.surfaceElevated)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.lg)
                            .strokeBorder(Theme.Colors.border, lineWidth: 1)
                    )
            )
        }
    }
}

// MARK: - Icon Button
struct IconButton: View {
    let icon: String
    var color: Color = Theme.Colors.neonGreen
    var size: CGFloat = 44
    var action: () -> Void

    var body: some View {
        Button(action: {
            HapticManager.shared.light()
            action()
        }) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .fill(Theme.Colors.surfaceElevated)
                        .overlay(
                            Circle()
                                .strokeBorder(Theme.Colors.border, lineWidth: 1)
                        )
                )
        }
    }
}
