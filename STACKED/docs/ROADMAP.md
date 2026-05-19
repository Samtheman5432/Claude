# STACKED Product Roadmap

## Vision
Become the #1 financial literacy app for Gen Z and young professionals — the Duolingo of personal finance — generating $5M ARR within 24 months of launch.

---

## V1.0 — Launch Foundation (Month 0)
*Goal: Prove core retention loop*

### Core Features
- [x] 6-step personalized onboarding
- [x] Email/password + Apple Sign In
- [x] Home dashboard with Money IQ, streak, XP
- [x] 33 daily financial challenges across 12 categories
- [x] 10-level XP progression system
- [x] 7-day streak system with visual fire
- [x] 12 achievement badges
- [x] AI Money Simulator (OpenAI GPT-4)
- [x] AI Money Coach (chat interface)
- [x] Global leaderboard
- [x] User profile with financial archetype
- [x] Premium paywall ($9.99/month, $59.99/year)
- [x] Full demo mode (no backend required)

### Infrastructure
- [x] Supabase backend (auth, DB, storage)
- [x] Edge Functions for AI (OpenAI key server-side)
- [x] Row Level Security
- [x] PostHog analytics
- [x] RevenueCat payments

### Success Metrics
- D1 retention > 40%
- D7 retention > 20%
- D30 retention > 10%
- Daily challenge completion rate > 60%
- Premium conversion > 2%

---

## V1.1 — Engagement (Month 2)
*Goal: Increase D7 and D30 retention*

### Features
- [ ] Push notifications for streak reminders (critical for retention)
- [ ] Share cards generator (Money IQ, streaks, achievements)
  - Optimized for TikTok, Instagram Stories, Twitter
  - One-tap share with beautiful gradient designs
- [ ] Friend system (add by username or link)
  - Friend leaderboard
  - Challenge a friend (same daily challenge)
- [ ] 50 additional challenges (cumulative: 83)
- [ ] Weekly Money IQ Report (email + in-app)
- [ ] Onboarding quiz for Financial Archetype
- [ ] Notification permission prompt optimization
- [ ] Streak freeze (spend coins to protect streak)

### Monetization
- [ ] Streak freeze as first in-app purchase ($0.99)
- [ ] "Lives" system for Premium (unlimited lives)
- [ ] Annual plan promotional pricing

---

## V1.2 — Content Depth (Month 3)
*Goal: Increase session length and content engagement*

### Features
- [ ] Course Mode (structured learning paths)
  - "Investing 101" (10 lessons)
  - "Debt Destruction" (8 lessons)
  - "Budget Boss" (8 lessons)
  - "FIRE Movement" (12 lessons)
- [ ] Live Events (weekly)
  - Monday Money Trivia (real-time leaderboard)
  - Friday Finance Battle
- [ ] Advanced AI Simulator features
  - Comparison mode (Option A vs. Option B)
  - Scenario saving and history
  - Sharing with commentary
- [ ] Apple Watch companion app
  - Daily challenge widget
  - Streak alert on Watch
  - Quick XP check
- [ ] Widgets (iOS 16+ widget)
  - Money IQ widget
  - Today's challenge countdown
  - Streak tracker

---

## V1.3 — Social & Community (Month 4)
*Goal: Increase viral growth and referrals*

### Features
- [ ] Public profiles (username.getstacked.app)
- [ ] Referral program (earn XP for inviting friends)
- [ ] "Money Wins" feed (achievements, milestones, streaks)
- [ ] School/University leaderboards
- [ ] City-based leaderboards
- [ ] Group Challenges (join a team, compete together)
- [ ] Challenge creator (community-submitted challenges)
- [ ] Reaction system (emoji reactions on money wins)

---

## V2.0 — Real Money Integration (Month 6)
*Goal: Become the daily financial habit for real financial decisions*

### Features
- [ ] Bank account sync (via Plaid)
  - See real spending in app context
  - "Your Netflix spending could become $X by 2040"
  - Automatic categorization and insights
- [ ] Real portfolio tracking
  - Connect brokerage (Robinhood, Fidelity, Schwab API)
  - See Money IQ vs. real portfolio performance
  - "Your portfolio in simulation vs. reality"
- [ ] Goal tracker
  - Set savings goals
  - Visual progress toward goals
  - AI adjusts daily challenges toward your goals
- [ ] Personalized AI curriculum
  - AI designs your learning path
  - Adapts based on real financial situation
  - Gamified milestone rewards

### Monetization V2
- [ ] STACKED Pro+ tier ($19.99/month)
  - Everything in Pro
  - Bank sync
  - Portfolio tracking
  - Personalized AI curriculum
- [ ] STACKED for Teams (B2B)
  - Employers offer STACKED as benefit
  - HR integration
  - Team money IQ leaderboards

---

## V2.5 — Platform (Month 9)
*Goal: Become the financial OS for young professionals*

### Features
- [ ] Web app (Next.js)
- [ ] API for financial institutions
  - Banks can embed STACKED challenges
  - Credit unions offer as member benefit
  - Financial advisors track client progress
- [ ] Content creator program
  - Finance creators make challenges
  - Revenue share model
  - Creator dashboard
- [ ] STACKED Academy (paid courses)
  - Expert-taught video courses
  - Certificates of completion
  - Resume-worthy financial credentials

---

## Revenue Projections

| Month | Users | Premium Rate | MRR |
|-------|-------|-------------|-----|
| 1 | 1,000 | 2% | $200 |
| 3 | 10,000 | 3% | $3,000 |
| 6 | 50,000 | 4% | $20,000 |
| 12 | 200,000 | 5% | $100,000 |
| 18 | 500,000 | 5% | $250,000 |
| 24 | 1,000,000 | 6% | $600,000 |

*Target: $5M ARR by Month 24*

---

## Key Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| Low D30 retention | Push notifications, streak mechanics, friend system |
| OpenAI cost scaling | Cache common queries, optimize prompts, upgrade users to help margin |
| App Store rejection | Educational disclaimer on all AI content, no financial advice |
| Competition from Duolingo (if they enter finance) | Deep AI features, real financial integration, community |
| Regulatory concerns | Clear "educational content only" labeling, consult legal counsel |

---

*Last updated: 2025 | STACKED Inc.*
