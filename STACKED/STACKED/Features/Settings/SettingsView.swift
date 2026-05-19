import SwiftUI

struct SettingsView: View {
    @ObservedObject var authService: MockAuthService
    @Environment(\.dismiss) private var dismiss
    @State private var notificationsEnabled = true
    @State private var reminderTime = Date()
    @State private var showDeleteConfirm = false

    var user: UserProfile { authService.currentUser ?? .guest }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.background.ignoresSafeArea()

                List {
                    // Account
                    Section {
                        SettingsRow(icon: "person.circle", title: "Username", value: user.username, iconColor: Theme.Colors.neonGreen)
                        SettingsRow(icon: "envelope", title: "Email", value: user.email, iconColor: Theme.Colors.accentBlue)
                        SettingsRow(icon: "star.fill", title: "Subscription", value: user.subscriptionTier.displayName, iconColor: Theme.Colors.accentGold)
                    } header: {
                        Text("Account")
                            .font(Theme.Typography.caption)
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }
                    .listRowBackground(Theme.Colors.surface)

                    // Notifications
                    Section {
                        Toggle(isOn: $notificationsEnabled) {
                            Label("Daily Reminders", systemImage: "bell")
                                .foregroundStyle(Theme.Colors.textPrimary)
                        }
                        .tint(Theme.Colors.neonGreen)

                        if notificationsEnabled {
                            DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                                .foregroundStyle(Theme.Colors.textPrimary)
                                .colorScheme(.dark)
                        }
                    } header: {
                        Text("Notifications")
                            .font(Theme.Typography.caption)
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }
                    .listRowBackground(Theme.Colors.surface)

                    // App
                    Section {
                        SettingsRow(icon: "info.circle", title: "App Version", value: AppConfig.appVersion, iconColor: Theme.Colors.textSecondary)
                        SettingsRow(icon: "shield.checkerboard", title: "Demo Mode", value: AppConfig.demoMode ? "On" : "Off", iconColor: Theme.Colors.accentOrange)
                        Button {
                            // Rate app
                        } label: {
                            Label("Rate STACKED ⭐", systemImage: "star")
                                .foregroundStyle(Theme.Colors.textPrimary)
                        }
                        Button {
                            // Share app
                        } label: {
                            Label("Share with a Friend", systemImage: "square.and.arrow.up")
                                .foregroundStyle(Theme.Colors.textPrimary)
                        }
                    } header: {
                        Text("App")
                            .font(Theme.Typography.caption)
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }
                    .listRowBackground(Theme.Colors.surface)

                    // Legal
                    Section {
                        Button { } label: {
                            Label("Privacy Policy", systemImage: "lock.shield")
                                .foregroundStyle(Theme.Colors.textPrimary)
                        }
                        Button { } label: {
                            Label("Terms of Service", systemImage: "doc.text")
                                .foregroundStyle(Theme.Colors.textPrimary)
                        }
                    } header: {
                        Text("Legal")
                            .font(Theme.Typography.caption)
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }
                    .listRowBackground(Theme.Colors.surface)

                    // Danger Zone
                    Section {
                        Button {
                            Task { try? await authService.signOut() }
                            dismiss()
                        } label: {
                            Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                                .foregroundStyle(Theme.Colors.errorRed)
                        }

                        Button {
                            showDeleteConfirm = true
                        } label: {
                            Label("Delete Account", systemImage: "trash")
                                .foregroundStyle(Theme.Colors.errorRed)
                        }
                    } header: {
                        Text("Account Actions")
                            .font(Theme.Typography.caption)
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }
                    .listRowBackground(Theme.Colors.surface)
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Theme.Colors.neonGreen)
                }
            }
            .alert("Delete Account", isPresented: $showDeleteConfirm) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    Task {
                        try? await authService.deleteAccount()
                        dismiss()
                    }
                }
            } message: {
                Text("This will permanently delete your account and all data. This action cannot be undone.")
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let value: String
    let iconColor: Color

    var body: some View {
        HStack {
            Label(title, systemImage: icon)
                .foregroundStyle(Theme.Colors.textPrimary)
            Spacer()
            Text(value)
                .font(Theme.Typography.caption)
                .foregroundStyle(Theme.Colors.textSecondary)
        }
    }
}
