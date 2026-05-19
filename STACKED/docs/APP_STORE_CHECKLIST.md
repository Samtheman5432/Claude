# STACKED App Store Launch Checklist

## 🎨 Assets
- [ ] App Icon 1024×1024 PNG (no alpha, no rounded corners — Apple adds them)
- [ ] All icon sizes generated (use Asset Catalog)
- [ ] Launch Screen (LaunchScreen.storyboard or Info.plist key)
- [ ] Screenshots for all required sizes:
  - iPhone 6.7" (1290×2796) — required
  - iPhone 6.5" (1284×2778) — required
  - iPhone 5.5" (1242×2208) — required
  - iPad Pro 12.9" (2048×2732) — if universal
- [ ] App Preview video (optional but increases conversion 25-35%)

## 📋 App Store Connect Metadata
- [ ] App name: "STACKED: Money & Finance Coach" (30 char limit)
- [ ] Subtitle: "Build Wealth One Decision at a Time" (30 char limit)
- [ ] Primary category: Finance
- [ ] Secondary category: Education
- [ ] Keywords (100 chars): "personal finance,money,investing,budgeting,financial literacy,wealth,savings,budget tracker,money coach"
- [ ] Description (4000 chars): Written and reviewed
- [ ] What's New text (for updates)
- [ ] Support URL configured
- [ ] Privacy Policy URL (required for apps with accounts)
- [ ] Marketing URL (optional)
- [ ] Copyright: "© 2025 STACKED Inc."

## 🔒 Privacy & Legal
- [ ] App Privacy labels configured in App Store Connect
  - [ ] Data collected: Account Info (required for auth)
  - [ ] Data linked to user: Email, User ID
  - [ ] Data used for: App Functionality, Analytics
- [ ] NSUserTrackingUsageDescription if using IDFA (likely not needed)
- [ ] Info.plist has all required usage descriptions:
  - [ ] NSFaceIDUsageDescription (if using Face ID)
  - [ ] NSCameraUsageDescription (if adding photo upload)
  - [ ] NSUserNotificationsUsageDescription for reminders
- [ ] In-App Purchase products approved in App Store Connect
- [ ] Privacy Policy hosted and accessible
- [ ] Terms of Service hosted and accessible

## 💳 Payments
- [ ] stacked_monthly product created ($9.99/month)
- [ ] stacked_annual product created ($59.99/year)
- [ ] Products approved by Apple (can take 24-48 hours)
- [ ] RevenueCat Entitlements configured: "pro"
- [ ] RevenueCat Offerings configured: "default"
- [ ] StoreKit testing completed in sandbox environment
- [ ] Free trial configured (3 days for annual)
- [ ] Restore purchases tested

## ⚙️ Technical
- [ ] Production bundle ID: com.getstacked.app
- [ ] Push notification certificates configured (for streak reminders)
- [ ] Sign In with Apple capability added
- [ ] Push Notifications capability added
- [ ] AppConfig.demoMode = false for production build
- [ ] All environment variables set in Xcode scheme (production)
- [ ] Archive built successfully with Release configuration
- [ ] No compiler warnings in Release build
- [ ] App runs on oldest supported device (iPhone with A12 chip, iOS 16)
- [ ] Memory usage profiled (< 200MB typical)
- [ ] Launch time < 2 seconds on older devices

## 🧪 Testing
- [ ] TestFlight beta distributed to at least 5 external testers
- [ ] All 6 onboarding steps tested end-to-end
- [ ] Challenge completion flow tested (correct + wrong answers)
- [ ] AI Simulator tested with real OpenAI API
- [ ] AI Coach tested with real API
- [ ] Subscription purchase tested in Sandbox
- [ ] Restore purchases tested
- [ ] Streak logic tested across midnight boundary
- [ ] Achievement unlock animations tested
- [ ] Leaderboard tested with real data
- [ ] Dark mode tested on all screens
- [ ] VoiceOver accessibility tested on key screens
- [ ] Dynamic Type tested (largest text size)
- [ ] Crash-free rate > 99.5% in TestFlight

## 🚀 Launch Day
- [ ] App Store page live and ready
- [ ] Press kit prepared (screenshots, description, founder story)
- [ ] Product Hunt launch prepared
- [ ] Twitter/X announcement ready
- [ ] TikTok content planned (app demo walkthrough)
- [ ] Reddit posts planned (r/personalfinance, r/financialindependence)
- [ ] Discord/community notified
- [ ] App Store Optimization (ASO) monitored
- [ ] Day 1 analytics dashboard ready (PostHog)
- [ ] Day 1 revenue dashboard ready (RevenueCat)
- [ ] Crash monitoring active (Xcode Organizer)
- [ ] Support channel ready (email/Twitter/Discord)

## 📊 Post-Launch Metrics to Track
- D1, D7, D30 retention rates
- Daily Active Users (DAU)
- Challenge completion rate
- AI simulation usage
- Streak distribution
- Conversion rate to premium (goal: > 3%)
- Average Revenue Per User (ARPU)
- Money IQ score distribution
- Most popular challenge categories
- Most common coach questions
