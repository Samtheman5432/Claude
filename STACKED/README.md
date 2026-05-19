# 💰 STACKED — Build Wealth One Decision at a Time

> **Duolingo for Finance.** The gamified, AI-powered financial fitness platform that trains Gen Z and young professionals to make smarter money decisions through daily challenges, AI simulations, and progression-based learning.

---

## 🚀 Quick Start (Demo Mode)

STACKED ships with **full demo mode** — run the app immediately in Xcode Simulator without any backend setup.

```bash
# 1. Clone the repo
git clone <your-repo-url>
cd STACKED

# 2. Open in Xcode
open STACKED.xcodeproj

# 3. Select iPhone Simulator
# 4. Hit Run (Cmd+R)
# App launches immediately with full mock data!
```

Demo mode includes:
- ✅ 33 realistic financial challenges
- ✅ Mock authentication (no real accounts)
- ✅ AI simulation responses (pre-built)
- ✅ AI coach responses (pattern-matched)
- ✅ Full leaderboard with 10+ users
- ✅ All achievements and badges
- ✅ XP, streaks, Money IQ progression
- ✅ Paywall flow (mock purchases)

**Demo mode is controlled by a single flag in `AppConfig.swift`:**
```swift
static let demoMode = true  // Set to false for production
```

---

## 🏗️ Architecture

```
STACKED/
├── App/
│   ├── STACKEDApp.swift        # App entry + dependency injection
│   └── RootView.swift          # Navigation router + splash screen
├── Core/
│   └── Config/
│       ├── AppConfig.swift     # Environment config + demo flag
│       └── Theme.swift         # Design system (colors, fonts, spacing)
├── Models/
│   ├── UserProfile.swift       # User + level system + archetypes
│   ├── Challenge.swift         # Challenge + categories + difficulty
│   ├── Achievement.swift       # Achievement + rarity system
│   ├── SimulationResult.swift  # AI simulation data models
│   ├── ChatMessage.swift       # Coach chat + suggested prompts
│   └── LeaderboardEntry.swift  # Leaderboard + friend models
├── Demo/
│   ├── DemoData.swift          # 33+ challenges + mock data seed
│   ├── MockAuthService.swift   # Mock auth with UserDefaults persistence
│   ├── MockAIService.swift     # Mock AI with smart pattern matching
│   ├── MockChallengeService.swift  # Mock challenge service
│   └── MockSubscriptionService.swift  # Mock RevenueCat
├── Features/
│   ├── Onboarding/             # 6-step onboarding flow
│   ├── Auth/                   # Login/signup + Apple Sign In UI
│   ├── Home/                   # Dashboard + stats overview
│   ├── Challenges/             # Daily challenge system
│   ├── Simulator/              # AI wealth simulator
│   ├── Coach/                  # AI chat coach
│   ├── Achievements/           # Achievement gallery
│   ├── Social/                 # Leaderboard system
│   ├── Profile/                # User profile page
│   ├── Paywall/                # Premium subscription flow
│   └── Settings/               # App settings
├── Components/                 # Reusable UI components
│   ├── XPProgressBar.swift
│   ├── StatCard.swift          # MoneyIQCard, StreakCard, XPOverlay
│   ├── LevelBadge.swift        # LevelBadge, AchievementBadgeView, CategoryChip
│   └── GradientButton.swift    # GradientButton, SecondaryButton, IconButton
└── Utilities/
    ├── HapticManager.swift     # Centralized haptic feedback
    └── Extensions.swift        # Number formatting, date helpers, view utils
```

---

## 🛠️ Production Setup

### Prerequisites
- Xcode 15.0+
- iOS 16.0+ target
- Swift 5.9+
- Swift Charts framework (included in iOS 16+)

### Environment Variables

Create a `.env` file (never commit this):
```bash
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
OPENAI_API_KEY=sk-proj-...        # Only used in Edge Functions (server-side)
REVENUECAT_API_KEY=appl_...
POSTHOG_API_KEY=phc_...
EDGE_FUNCTION_URL=https://your-project.supabase.co/functions/v1
```

Set these in Xcode scheme environment variables or use a secrets manager.

### Supabase Setup

1. Create a Supabase project at [supabase.com](https://supabase.com)
2. Run the migration:
```bash
cd backend
supabase db push --db-url "postgresql://postgres:[password]@db.[project].supabase.co:5432/postgres"
# Or paste migrations/001_initial_schema.sql into the Supabase SQL editor
```
3. Enable Auth providers: Email/Password + Apple Sign In
4. Configure Apple Sign In in Supabase Auth settings

### Deploy Edge Functions

```bash
# Install Supabase CLI
brew install supabase/tap/supabase

# Login
supabase login

# Deploy functions
supabase functions deploy ai-simulator --project-ref your-project-ref
supabase functions deploy ai-coach --project-ref your-project-ref

# Set secrets (server-side only — never in the iOS app)
supabase secrets set OPENAI_API_KEY=sk-proj-...
```

### RevenueCat Setup

1. Create app at [app.revenuecat.com](https://app.revenuecat.com)
2. Add products in App Store Connect:
   - `stacked_monthly` — $9.99/month
   - `stacked_annual` — $59.99/year
3. Replace `MockSubscriptionService` with real `RevenueCatManager`:

```swift
// Install via SPM: https://github.com/RevenueCat/purchases-ios
import RevenueCat

// In STACKEDApp.swift:
Purchases.configure(withAPIKey: AppConfig.revenueCatAPIKey)
```

---

## 📊 Analytics Events

STACKED uses PostHog with this event taxonomy:

| Event | Properties | Trigger |
|-------|-----------|---------|
| `app_opened` | `version`, `demo_mode` | App launch |
| `onboarding_step_completed` | `step`, `step_name` | Each onboarding step |
| `onboarding_completed` | `goals[]`, `level`, `interests[]` | Finish onboarding |
| `challenge_started` | `challenge_id`, `category`, `difficulty` | Open challenge |
| `challenge_completed` | `challenge_id`, `is_correct`, `xp_earned`, `time_spent` | Submit answer |
| `simulation_started` | `prompt_length`, `is_premium` | Start simulation |
| `simulation_completed` | `tokens_used`, `success` | Get result |
| `coach_message_sent` | `message_length`, `session_id` | Send message |
| `streak_extended` | `new_streak`, `old_streak` | Daily streak update |
| `level_up` | `new_level`, `level_title` | Level increase |
| `achievement_unlocked` | `achievement_id`, `rarity` | Badge earned |
| `paywall_viewed` | `source`, `selected_plan` | Paywall shown |
| `subscription_started` | `tier`, `price`, `period` | Purchase completed |
| `subscription_cancelled` | `tier`, `reason` | Cancellation |

---

## 🎮 Gamification System

### XP Formula
```
Base XP per challenge: 50-200 (based on difficulty)
Difficulty multipliers: Easy 1x, Medium 1.5x, Hard 2x, Expert 3x
Streak bonus: +10% per 7-day streak milestone
Correct answer bonus: Full XP | Wrong answer: 20% XP (for participation)
```

### Level XP Requirements
```swift
xpRequired(level) = level * 500 * pow(1.3, level - 1)
// Level 1: 500 XP | Level 5: ~3,715 XP | Level 10: ~27,395 XP
```

### Money IQ
- Starts at 500
- Gains 2-9 points per correct challenge answer
- Max: 1000
- Factors into leaderboard ranking

### Streak Rules
- Streak increases for completing at least 1 challenge per day
- Streak breaks at midnight if no challenge completed
- Longest streak tracked separately

---

## 🔒 Security Architecture

- **OpenAI API key** is NEVER in the iOS app — only in Supabase Edge Functions
- All AI requests go through Edge Functions with user authentication verification
- Row Level Security on every Supabase table
- Users can only read/write their own data
- Challenge attempts validated server-side (can't replay or forge)
- Free tier simulation limits enforced at the Edge Function level

---

## 🧪 Testing Checklist

### Core Flows
- [ ] Onboarding → goal selection → auth → dashboard
- [ ] Complete a daily challenge (correct + incorrect answers)
- [ ] Run an AI simulation
- [ ] Send messages to AI coach
- [ ] XP gain animation triggers correctly
- [ ] Streak increments on challenge completion
- [ ] Achievement unlocks with animation
- [ ] Leaderboard loads and ranks correctly
- [ ] Profile stats update after challenge completion
- [ ] Paywall flow (free tier limits, upgrade)
- [ ] Sign out + sign back in (data persists)
- [ ] Settings page navigation

### Edge Cases
- [ ] No internet connection (demo mode still works)
- [ ] Empty states (new user, no achievements)
- [ ] Very long usernames/prompts
- [ ] Multiple rapid taps on submit button
- [ ] Background/foreground transitions
- [ ] Dark mode rendering (default + forced)
- [ ] Dynamic type size support

---

## 📱 App Store Launch Checklist

### Before Submission
- [ ] App icons (1024x1024 + all sizes)
- [ ] Launch screen configured
- [ ] Privacy policy URL ready
- [ ] Terms of service URL ready
- [ ] Support URL ready
- [ ] Age rating: 4+ (educational content)
- [ ] Categories: Finance (Primary), Education (Secondary)
- [ ] Keywords optimized for ASO
- [ ] Screenshots for all required device sizes
- [ ] App preview video (optional but recommended)
- [ ] In-app purchase products created in App Store Connect
- [ ] RevenueCat connected to App Store
- [ ] TestFlight build tested on real devices
- [ ] Accessibility review (VoiceOver, Dynamic Type)
- [ ] Memory profiling (no leaks)
- [ ] Battery usage profiling
- [ ] Network performance testing

### App Store Metadata
**Title:** STACKED: Money & Finance Coach  
**Subtitle:** Build Wealth One Decision at a Time  
**Keywords:** personal finance, money, investing, budgeting, financial literacy, wealth, savings, budget tracker, money coach, investment calculator  

**Description:**
> STACKED is the gamified financial fitness app that makes learning money addictive. Train your brain with daily money challenges, simulate your financial future with AI, and compete on global leaderboards — all in 5 minutes a day.

---

## 🗺️ Product Roadmap

### V1.0 (Launch)
- [x] Core gamification (XP, streaks, levels, badges)
- [x] 33 financial challenges across 12 categories
- [x] AI Money Simulator
- [x] AI Money Coach
- [x] Leaderboard system
- [x] Profile + achievements
- [x] Premium subscription

### V1.1 (Month 2)
- [ ] Friend system + challenge friends
- [ ] Push notifications for streak reminders
- [ ] Weekly Money IQ report
- [ ] Share cards (TikTok/Instagram Stories)
- [ ] 50+ additional challenges
- [ ] Apple Watch companion

### V1.2 (Month 3)
- [ ] Financial archetype quiz
- [ ] Personalized learning paths
- [ ] Course mode (structured lessons)
- [ ] Live events (weekly money trivia)

### V2.0 (Month 6)
- [ ] Bank account sync (via Plaid)
- [ ] Real portfolio tracking
- [ ] Social feed ("money wins" posts)
- [ ] School/university leaderboards
- [ ] API for financial institutions

---

## 🚀 Deployment

### Staging
```bash
# Use a separate Supabase project for staging
SUPABASE_URL=https://staging-project.supabase.co

# Deploy staging edge functions
supabase functions deploy ai-simulator --project-ref staging-ref
```

### Production
```bash
# Switch AppConfig.demoMode to false
# Set production environment variables in Xcode scheme
# Archive and upload to App Store Connect
```

### Monitoring
- Supabase Dashboard: DB performance, auth events, function logs
- PostHog: User behavior, funnel analysis, retention
- RevenueCat: Revenue, churn, MRR, LTV
- Xcode Organizer: Crash reports, performance metrics

---

## 🤝 Contributing

1. Fork the repo
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push: `git push origin feature/amazing-feature`
5. Open a Pull Request

---

## ⚖️ Legal

STACKED is educational software. All financial content is for educational purposes only and does not constitute financial advice. Users should consult licensed financial professionals for personalized advice.

---

*Built with ❤️ by the STACKED team. Let's get everyone Stacked.*
