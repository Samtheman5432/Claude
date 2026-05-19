import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authService: MockAuthService
    @Environment(\.dismiss) private var dismiss
    var onComplete: (() -> Void)? = nil

    @State private var isLogin = true
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showPassword = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: Theme.Spacing.xl) {
                        // Header
                        VStack(spacing: Theme.Spacing.sm) {
                            Text(isLogin ? "Welcome back! 👋" : "Join STACKED 🚀")
                                .font(Theme.Typography.title1)
                                .foregroundStyle(Theme.Colors.textPrimary)
                            Text(isLogin ? "Sign in to continue your streak." : "Create your free account today.")
                                .font(Theme.Typography.body)
                                .foregroundStyle(Theme.Colors.textSecondary)
                        }
                        .padding(.top, Theme.Spacing.xl)

                        // Form
                        VStack(spacing: Theme.Spacing.md) {
                            if !isLogin {
                                AuthTextField(
                                    placeholder: "Username",
                                    text: $username,
                                    icon: "person"
                                )
                            }

                            AuthTextField(
                                placeholder: "Email address",
                                text: $email,
                                icon: "envelope",
                                keyboardType: .emailAddress
                            )

                            AuthTextField(
                                placeholder: "Password",
                                text: $password,
                                icon: "lock",
                                isSecure: !showPassword,
                                trailingButton: {
                                    Button {
                                        showPassword.toggle()
                                    } label: {
                                        Image(systemName: showPassword ? "eye.slash" : "eye")
                                            .foregroundStyle(Theme.Colors.textSecondary)
                                    }
                                }
                            )

                            if let error = errorMessage {
                                HStack {
                                    Image(systemName: "exclamationmark.circle")
                                    Text(error)
                                }
                                .font(Theme.Typography.caption)
                                .foregroundStyle(Theme.Colors.errorRed)
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.lg)

                        // Submit
                        VStack(spacing: Theme.Spacing.sm) {
                            GradientButton(
                                title: isLogin ? "Sign In" : "Create Account",
                                isLoading: isLoading
                            ) {
                                Task { await submit() }
                            }
                            .padding(.horizontal, Theme.Spacing.lg)

                            // Divider
                            HStack {
                                Rectangle().fill(Theme.Colors.border).frame(height: 1)
                                Text("or").font(Theme.Typography.caption).foregroundStyle(Theme.Colors.textSecondary)
                                Rectangle().fill(Theme.Colors.border).frame(height: 1)
                            }
                            .padding(.horizontal, Theme.Spacing.lg)

                            // Apple Sign In placeholder
                            Button {
                                Task { await appleSignIn() }
                            } label: {
                                HStack(spacing: Theme.Spacing.sm) {
                                    Image(systemName: "apple.logo")
                                        .font(.system(size: 18, weight: .semibold))
                                    Text("Continue with Apple")
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
                            .padding(.horizontal, Theme.Spacing.lg)
                        }

                        // Toggle
                        Button {
                            withAnimation(.smooth) { isLogin.toggle() }
                            errorMessage = nil
                        } label: {
                            HStack(spacing: 4) {
                                Text(isLogin ? "New here?" : "Already have an account?")
                                    .foregroundStyle(Theme.Colors.textSecondary)
                                Text(isLogin ? "Create account" : "Sign in")
                                    .foregroundStyle(Theme.Colors.neonGreen)
                            }
                            .font(Theme.Typography.callout)
                        }

                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Theme.Colors.textSecondary)
                }
            }
        }
    }

    private func submit() async {
        guard validate() else { return }
        isLoading = true
        errorMessage = nil

        do {
            if isLogin {
                _ = try await authService.signIn(email: email, password: password)
            } else {
                _ = try await authService.signUp(email: email, password: password, username: username)
            }
            onComplete?()
            dismiss()
        } catch let error as AuthError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Something went wrong. Please try again."
        }
        isLoading = false
    }

    private func appleSignIn() async {
        isLoading = true
        _ = try? await authService.signInWithApple()
        onComplete?()
        dismiss()
        isLoading = false
    }

    private func validate() -> Bool {
        if email.isBlank {
            errorMessage = "Please enter your email."
            return false
        }
        if password.count < 6 {
            errorMessage = "Password must be at least 6 characters."
            return false
        }
        if !isLogin && username.isBlank {
            errorMessage = "Please choose a username."
            return false
        }
        return true
    }
}

// MARK: - Auth Text Field
struct AuthTextField<Trailing: View>: View {
    let placeholder: String
    @Binding var text: String
    var icon: String? = nil
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    @ViewBuilder var trailingButton: () -> Trailing

    init(
        placeholder: String,
        text: Binding<String>,
        icon: String? = nil,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        @ViewBuilder trailingButton: @escaping () -> Trailing = { EmptyView() }
    ) {
        self.placeholder = placeholder
        self._text = text
        self.icon = icon
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.trailingButton = trailingButton
    }

    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .frame(width: 20)
            }

            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                        .autocapitalization(keyboardType == .emailAddress ? .none : .words)
                        .autocorrectionDisabled(keyboardType == .emailAddress)
                }
            }
            .font(Theme.Typography.body)
            .foregroundStyle(Theme.Colors.textPrimary)

            trailingButton()
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg)
                .fill(Theme.Colors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.lg)
                        .strokeBorder(text.isEmpty ? Theme.Colors.border : Theme.Colors.neonGreen.opacity(0.5), lineWidth: 1)
                )
        )
        .animation(.smooth, value: text.isEmpty)
    }
}
