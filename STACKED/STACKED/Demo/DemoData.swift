import Foundation

// MARK: - Demo Data Seed
// All mock data for demo mode — no backend required
enum DemoData {

    // MARK: - Demo User
    static let currentUser = UserProfile(
        id: "demo-user-001",
        username: "StackedUser",
        email: "demo@getstacked.app",
        avatarURL: nil,
        moneyIQ: 742,
        level: 4,
        xp: 1840,
        xpToNextLevel: 2500,
        currentStreak: 7,
        longestStreak: 14,
        lastActiveDate: Date(),
        financialGoals: [.buildWealth, .startInvesting, .financialFreedom],
        experienceLevel: .intermediate,
        interests: [.investing, .sideHustles, .entrepreneurship],
        subscriptionTier: .free,
        totalChallengesCompleted: 23,
        totalSimulationsRun: 5,
        joinedAt: Calendar.current.date(byAdding: .day, value: -30, to: Date())!,
        financialArchetype: .builder
    )

    // MARK: - Challenges (30+)
    static let challenges: [Challenge] = [

        // MARK: Compound Interest
        Challenge(
            id: "ch-001",
            title: "The Early Bird Investor",
            scenario: "Alex starts investing $200/month at age 22. Jordan starts the same at age 32. Both earn 8% annual returns and invest until age 65. Who ends up with more money?",
            options: [
                ChallengeOption(id: "a", text: "Alex, with roughly $1.2M", shortLabel: "Alex ~$1.2M", detail: "10 extra years of compounding is massive"),
                ChallengeOption(id: "b", text: "Jordan, because they invest smarter", shortLabel: "Jordan", detail: "Starting later forces better choices"),
                ChallengeOption(id: "c", text: "About the same — 10 years doesn't matter much", shortLabel: "About equal", detail: "Time doesn't make a big difference"),
                ChallengeOption(id: "d", text: "Alex, with roughly $750K", shortLabel: "Alex ~$750K", detail: "Alex has slightly more")
            ],
            correctIndex: 0,
            explanation: "Alex ends up with ~$1.2M vs Jordan's ~$560K — more than double! Those 10 extra years aren't just additive, they're exponential. Compound interest is like a snowball: the earlier you start rolling it, the bigger it gets. Starting at 22 vs 32 is one of the highest-ROI financial decisions you can make.",
            category: .compoundInterest,
            difficulty: .easy,
            xpReward: 75,
            moneyIQGain: 3,
            estimatedSeconds: 45,
            imageURL: nil
        ),

        Challenge(
            id: "ch-002",
            title: "The Coffee Trap",
            scenario: "You spend $7/day on coffee shop drinks. If instead you invested that $210/month in an S&P 500 index fund averaging 10% annual returns, how much would you have after 30 years?",
            options: [
                ChallengeOption(id: "a", text: "$75,000", shortLabel: "$75K", detail: "Just the raw deposits"),
                ChallengeOption(id: "b", text: "$143,000", shortLabel: "$143K", detail: "With some growth"),
                ChallengeOption(id: "c", text: "$474,000", shortLabel: "$474K", detail: "The power of compounding"),
                ChallengeOption(id: "d", text: "$210,000", shortLabel: "$210K", detail: "Double what you put in")
            ],
            correctIndex: 2,
            explanation: "That daily $7 habit compounds to ~$474,000 over 30 years — nearly half a million dollars! This isn't about shaming coffee. It's about understanding that small, consistent investments grow astronomically. Even redirecting $50-100/month earlier in life can build life-changing wealth.",
            category: .compoundInterest,
            difficulty: .easy,
            xpReward: 75,
            moneyIQGain: 3,
            estimatedSeconds: 40,
            imageURL: nil
        ),

        // MARK: Investing
        Challenge(
            id: "ch-003",
            title: "Index Fund vs. Stock Picking",
            scenario: "Research shows 90%+ of actively managed funds underperform the S&P 500 over 10 years. Which strategy has historically produced better long-term results for most investors?",
            options: [
                ChallengeOption(id: "a", text: "Picking individual stocks based on research", shortLabel: "Stock picking", detail: "More control, higher potential"),
                ChallengeOption(id: "b", text: "Low-cost S&P 500 index funds (set and forget)", shortLabel: "Index funds", detail: "Boring but proven"),
                ChallengeOption(id: "c", text: "Active funds managed by Wall Street pros", shortLabel: "Active funds", detail: "Experts know best"),
                ChallengeOption(id: "d", text: "Depends entirely on the individual", shortLabel: "It depends", detail: "No universal answer")
            ],
            correctIndex: 1,
            explanation: "Low-cost index funds win for most investors. Warren Buffett himself bet $1M on it — and won. The reason: lower fees, automatic diversification, and zero emotional decision-making. Most professional fund managers don't beat the market. An S&P 500 index fund with a 0.03% fee vs an active fund at 1%+ makes an enormous difference over decades.",
            category: .investing,
            difficulty: .medium,
            xpReward: 100,
            moneyIQGain: 4,
            estimatedSeconds: 60,
            imageURL: nil
        ),

        Challenge(
            id: "ch-004",
            title: "The Roth IRA Advantage",
            scenario: "You're 24 years old. You can put $6,500 into a Traditional IRA (tax deduction now, pay taxes later) or a Roth IRA (no deduction now, tax-FREE growth forever). Which is likely better at your age?",
            options: [
                ChallengeOption(id: "a", text: "Traditional IRA — save on taxes today", shortLabel: "Traditional IRA", detail: "Immediate tax break"),
                ChallengeOption(id: "b", text: "Roth IRA — tax-free compounding for 40+ years", shortLabel: "Roth IRA", detail: "Pay now, grow forever"),
                ChallengeOption(id: "c", text: "Neither — invest in stocks directly", shortLabel: "Neither", detail: "More flexibility"),
                ChallengeOption(id: "d", text: "Split 50/50 between both", shortLabel: "Split 50/50", detail: "Balance both benefits")
            ],
            correctIndex: 1,
            explanation: "At 24, a Roth IRA is almost always the superior choice. You're likely in a lower tax bracket now than you'll be at retirement. The math is staggering: $6,500 invested at 24, growing at 8% to age 65 = ~$180,000 — and with a Roth, you pay ZERO taxes on that gain. With a Traditional IRA, you'd owe taxes on the full $180K withdrawal.",
            category: .investing,
            difficulty: .medium,
            xpReward: 100,
            moneyIQGain: 5,
            estimatedSeconds: 75,
            imageURL: nil
        ),

        Challenge(
            id: "ch-005",
            title: "The Market Crash Trap",
            scenario: "The stock market drops 35%. Your $10,000 portfolio is now worth $6,500. What does history say is the smartest move?",
            options: [
                ChallengeOption(id: "a", text: "Sell everything to stop further losses", shortLabel: "Sell all", detail: "Protect what's left"),
                ChallengeOption(id: "b", text: "Do nothing — stay the course", shortLabel: "Hold steady", detail: "Ride it out"),
                ChallengeOption(id: "c", text: "Invest MORE while prices are discounted", shortLabel: "Buy more", detail: "Sale prices on stocks"),
                ChallengeOption(id: "d", text: "Move to cash and wait for recovery", shortLabel: "Move to cash", detail: "Safer position")
            ],
            correctIndex: 2,
            explanation: "Every major market crash has been followed by recovery and new highs. Selling locks in losses permanently. Historically, investors who bought MORE during the 2008 crash, 2020 COVID crash, etc. saw extraordinary returns within 1-3 years. Market dips are sales on future wealth — the wealthy treat them as buying opportunities, not reasons to panic.",
            category: .investing,
            difficulty: .hard,
            xpReward: 150,
            moneyIQGain: 6,
            estimatedSeconds: 60,
            imageURL: nil
        ),

        // MARK: Saving
        Challenge(
            id: "ch-006",
            title: "Emergency Fund Math",
            scenario: "Financial experts recommend an emergency fund of how many months of expenses?",
            options: [
                ChallengeOption(id: "a", text: "1 month", shortLabel: "1 month", detail: "A basic buffer"),
                ChallengeOption(id: "b", text: "2-3 months", shortLabel: "2-3 months", detail: "Moderate safety net"),
                ChallengeOption(id: "c", text: "3-6 months", shortLabel: "3-6 months", detail: "Standard recommendation"),
                ChallengeOption(id: "d", text: "12+ months", shortLabel: "12+ months", detail: "Maximum security")
            ],
            correctIndex: 2,
            explanation: "The standard recommendation is 3-6 months of living expenses in a high-yield savings account. This covers unexpected job loss, medical bills, or major repairs without going into debt. If you're self-employed or have variable income, lean toward 6+ months. The goal isn't to maximize this fund — just have enough that emergencies don't derail your wealth-building.",
            category: .saving,
            difficulty: .easy,
            xpReward: 50,
            moneyIQGain: 2,
            estimatedSeconds: 30,
            imageURL: nil
        ),

        Challenge(
            id: "ch-007",
            title: "High-Yield vs. Regular Savings",
            scenario: "You have $10,000 in savings. A regular bank savings account pays 0.5% APY. A high-yield savings account (HYSA) pays 5.0% APY. How much more do you earn in the HYSA per year?",
            options: [
                ChallengeOption(id: "a", text: "$50 more", shortLabel: "$50", detail: "Small difference"),
                ChallengeOption(id: "b", text: "$450 more", shortLabel: "$450", detail: "Significant difference"),
                ChallengeOption(id: "c", text: "$500 more", shortLabel: "$500", detail: "Major difference"),
                ChallengeOption(id: "d", text: "$1,000 more", shortLabel: "$1,000", detail: "Huge difference")
            ],
            correctIndex: 1,
            explanation: "Regular account: $50/year. HYSA: $500/year. That's $450 more — just for switching banks online! With $10K sitting idle in a regular account, you're leaving $450/year on the table. Over 5 years, that's $2,250+ in missed interest (and compounding). Switching takes 10 minutes and requires no lifestyle change.",
            category: .saving,
            difficulty: .easy,
            xpReward: 75,
            moneyIQGain: 3,
            estimatedSeconds: 45,
            imageURL: nil
        ),

        // MARK: Debt
        Challenge(
            id: "ch-008",
            title: "The Debt Avalanche",
            scenario: "You have: Credit Card at 24% interest ($3,000 balance), Student Loan at 5% interest ($15,000 balance), Car Loan at 8% interest ($8,000 balance). You have $500 extra per month. Which debt do you attack first?",
            options: [
                ChallengeOption(id: "a", text: "Student loan — largest balance", shortLabel: "Student loan", detail: "Biggest psychological win"),
                ChallengeOption(id: "b", text: "Credit card — highest interest rate", shortLabel: "Credit card", detail: "Math-optimal choice"),
                ChallengeOption(id: "c", text: "Car loan — middle ground", shortLabel: "Car loan", detail: "Balanced approach"),
                ChallengeOption(id: "d", text: "Split evenly between all three", shortLabel: "Split evenly", detail: "Reduce all simultaneously")
            ],
            correctIndex: 1,
            explanation: "The 'debt avalanche' method targets highest interest first — the credit card at 24%. That $3,000 balance costs you $720/year in interest alone. Pay that off first, then redirect to the car loan, then the student loan. This is mathematically optimal and saves the most money. (The 'debt snowball' targets smallest balance first for psychological momentum — both work, but avalanche costs less.)",
            category: .debt,
            difficulty: .medium,
            xpReward: 100,
            moneyIQGain: 5,
            estimatedSeconds: 75,
            imageURL: nil
        ),

        Challenge(
            id: "ch-009",
            title: "Minimum Payment Trap",
            scenario: "You owe $5,000 on a credit card at 20% APR. You only make the minimum payment of $100/month. How long until it's paid off?",
            options: [
                ChallengeOption(id: "a", text: "About 3 years", shortLabel: "~3 years", detail: "Manageable timeline"),
                ChallengeOption(id: "b", text: "About 7 years", shortLabel: "~7 years", detail: "Long but doable"),
                ChallengeOption(id: "c", text: "Over 10 years, paying $3,000+ in interest", shortLabel: "10+ years", detail: "Painful reality"),
                ChallengeOption(id: "d", text: "5 years flat", shortLabel: "5 years", detail: "Moderate estimate")
            ],
            correctIndex: 2,
            explanation: "Making only minimum payments on $5,000 at 20% APR takes 94 months (nearly 8 years!) and costs an extra $4,311 in interest — paying nearly double the original balance. Credit card minimum payments are designed to keep you in debt as long as possible. Even adding $50-100/month dramatically cuts years and thousands in interest.",
            category: .debt,
            difficulty: .hard,
            xpReward: 125,
            moneyIQGain: 6,
            estimatedSeconds: 60,
            imageURL: nil
        ),

        // MARK: Budgeting
        Challenge(
            id: "ch-010",
            title: "The 50/30/20 Rule",
            scenario: "You make $4,000/month after taxes. Using the 50/30/20 budget rule, how much should go toward wants (non-essentials like dining, entertainment, hobbies)?",
            options: [
                ChallengeOption(id: "a", text: "$800 (20%)", shortLabel: "$800", detail: "Savings/debt first"),
                ChallengeOption(id: "b", text: "$1,200 (30%)", shortLabel: "$1,200", detail: "Standard wants allocation"),
                ChallengeOption(id: "c", text: "$2,000 (50%)", shortLabel: "$2,000", detail: "Half for needs"),
                ChallengeOption(id: "d", text: "$600 (15%)", shortLabel: "$600", detail: "Conservative approach")
            ],
            correctIndex: 1,
            explanation: "The 50/30/20 rule: 50% ($2,000) for needs (rent, utilities, groceries), 30% ($1,200) for wants (dining, Netflix, fun), 20% ($800) for savings and debt paydown. It's a flexible guideline — not a rigid law. In high cost-of-living cities, you might need to adjust. The key insight: deliberately allocate before spending, rather than spending then hoping something's left.",
            category: .budgeting,
            difficulty: .easy,
            xpReward: 75,
            moneyIQGain: 3,
            estimatedSeconds: 45,
            imageURL: nil
        ),

        Challenge(
            id: "ch-011",
            title: "Lifestyle Inflation Reality Check",
            scenario: "You just got a $1,000/month raise. Which approach builds the most wealth over 10 years?",
            options: [
                ChallengeOption(id: "a", text: "Spend it all — you earned it!", shortLabel: "Spend all", detail: "Reward yourself"),
                ChallengeOption(id: "b", text: "Spend half, invest half ($500)", shortLabel: "Half/half", detail: "Balance lifestyle & wealth"),
                ChallengeOption(id: "c", text: "Invest 80% ($800), spend 20% ($200)", shortLabel: "80% invest", detail: "Aggressive wealth building"),
                ChallengeOption(id: "d", text: "Invest all $1,000 immediately", shortLabel: "Invest all", detail: "Maximum growth")
            ],
            correctIndex: 2,
            explanation: "Investing $800/month of your raise at 8% over 10 years = ~$147,000. Meanwhile, $200/month still lets you enjoy the raise. Lifestyle inflation — automatically upgrading your spending every time income increases — is one of the biggest wealth killers. The wealthy 'pay themselves first' and live on a portion of each raise while building assets.",
            category: .lifestyleInflation,
            difficulty: .medium,
            xpReward: 100,
            moneyIQGain: 5,
            estimatedSeconds: 60,
            imageURL: nil
        ),

        // MARK: Opportunity Cost
        Challenge(
            id: "ch-012",
            title: "The Car Decision",
            scenario: "You're considering financing a $45,000 car at 7% interest for 60 months. Monthly payment: $891. What's the total real cost?",
            options: [
                ChallengeOption(id: "a", text: "$45,000 — the car's price", shortLabel: "$45K", detail: "Base price only"),
                ChallengeOption(id: "b", text: "$53,460 — car plus all interest paid", shortLabel: "$53,460", detail: "Car + interest"),
                ChallengeOption(id: "c", text: "$68,000 — car, interest, and depreciation", shortLabel: "$68K", detail: "Full true cost"),
                ChallengeOption(id: "d", text: "$100,000+ — including opportunity cost of invested payments", shortLabel: "$100K+", detail: "Full opportunity cost")
            ],
            correctIndex: 3,
            explanation: "The true cost is devastating: $53,460 paid in payments + $12,000+ in depreciation (most cars lose 20-30% in year 1) + the $891/month that could have been invested ($891/month at 8% over 5 years = ~$65,000). You're not just buying a $45K car — you're potentially sacrificing $100K+ in future wealth. This doesn't mean never buy a nice car, but understanding the full cost changes the decision.",
            category: .opportunityCost,
            difficulty: .hard,
            xpReward: 150,
            moneyIQGain: 7,
            estimatedSeconds: 90,
            imageURL: nil
        ),

        Challenge(
            id: "ch-013",
            title: "Buy vs. Rent: The Real Math",
            scenario: "You're deciding whether to buy a $400,000 home or keep renting at $2,000/month. Which statement about this decision is most financially accurate?",
            options: [
                ChallengeOption(id: "a", text: "Always buy — renting is throwing money away", shortLabel: "Always buy", detail: "Classic wisdom"),
                ChallengeOption(id: "b", text: "Always rent — buying is too risky", shortLabel: "Always rent", detail: "Modern contrarian view"),
                ChallengeOption(id: "c", text: "It depends on location, timeline, and alternative investment returns", shortLabel: "Depends on factors", detail: "Nuanced reality"),
                ChallengeOption(id: "d", text: "Buying is always better for wealth building", shortLabel: "Buying = better wealth", detail: "Real estate wins")
            ],
            correctIndex: 2,
            explanation: "The buy vs. rent debate is nuanced. Buying can be excellent wealth-building IF: you stay 5+ years, local appreciation is strong, and the price-to-rent ratio makes sense. But renting isn't 'throwing money away' — you're paying for housing (like homeowners pay interest, taxes, insurance, maintenance). In expensive cities, renting and investing the difference can outperform buying. Use the NY Times rent vs. buy calculator for your specific situation.",
            category: .opportunityCost,
            difficulty: .expert,
            xpReward: 200,
            moneyIQGain: 8,
            estimatedSeconds: 90,
            imageURL: nil
        ),

        // MARK: Credit
        Challenge(
            id: "ch-014",
            title: "Credit Score Boosters",
            scenario: "Which action has the BIGGEST positive impact on your credit score?",
            options: [
                ChallengeOption(id: "a", text: "Closing old credit card accounts you don't use", shortLabel: "Close old cards", detail: "Seems like a clean move"),
                ChallengeOption(id: "b", text: "Paying all bills on time, every time", shortLabel: "Pay on time", detail: "Consistency matters"),
                ChallengeOption(id: "c", text: "Opening many new credit accounts quickly", shortLabel: "Open more accounts", detail: "More credit available"),
                ChallengeOption(id: "d", text: "Only using cash to avoid credit dependency", shortLabel: "Use only cash", detail: "Avoid debt entirely")
            ],
            correctIndex: 1,
            explanation: "Payment history is 35% of your FICO score — the single biggest factor. Always pay on time. Closing old cards HURTS your score (reduces available credit = higher utilization ratio). Opening many accounts also hurts (hard inquiries + new accounts = lower average age). Only using cash means no credit history at all. The formula: pay on time, keep utilization below 30%, keep old accounts open.",
            category: .credit,
            difficulty: .easy,
            xpReward: 75,
            moneyIQGain: 3,
            estimatedSeconds: 50,
            imageURL: nil
        ),

        Challenge(
            id: "ch-015",
            title: "The Credit Utilization Game",
            scenario: "You have a $10,000 credit limit across all cards. Experts recommend keeping your credit utilization below what percentage to protect your score?",
            options: [
                ChallengeOption(id: "a", text: "10%", shortLabel: "10%", detail: "Very conservative"),
                ChallengeOption(id: "b", text: "30%", shortLabel: "30%", detail: "Standard recommendation"),
                ChallengeOption(id: "c", text: "50%", shortLabel: "50%", detail: "Half your limit"),
                ChallengeOption(id: "d", text: "70%", shortLabel: "70%", detail: "High utilization")
            ],
            correctIndex: 1,
            explanation: "Keep utilization below 30% — and ideally below 10% for the best scores. With a $10K limit, that means keeping your balance below $3,000 (ideally below $1,000). Credit utilization accounts for 30% of your FICO score. If you're near the limit each month, consider requesting a credit limit increase or paying mid-cycle to keep the reported balance low.",
            category: .credit,
            difficulty: .easy,
            xpReward: 75,
            moneyIQGain: 3,
            estimatedSeconds: 35,
            imageURL: nil
        ),

        // MARK: Retirement
        Challenge(
            id: "ch-016",
            title: "401(k) Match = Free Money",
            scenario: "Your employer matches 100% of your 401(k) contributions up to 4% of your salary. You earn $60,000/year. If you only contribute 2%, what are you leaving on the table annually?",
            options: [
                ChallengeOption(id: "a", text: "$600 in unmatched employer contributions", shortLabel: "$600", detail: "Some free money missed"),
                ChallengeOption(id: "b", text: "$1,200 in unmatched employer contributions", shortLabel: "$1,200", detail: "Significant missed benefit"),
                ChallengeOption(id: "c", text: "$2,400 in unmatched employer contributions", shortLabel: "$2,400", detail: "Substantial loss"),
                ChallengeOption(id: "d", text: "Nothing — the match is still 2%", shortLabel: "Nothing", detail: "You're getting the match")
            ],
            correctIndex: 1,
            explanation: "Your employer matches up to 4% of $60K = $2,400 max match. You're only contributing 2% ($1,200). They match that $1,200 — but you're leaving another $1,200 unclaimed. Over 10 years, that $1,200/year at 8% returns = ~$18,000 in missed free money. Always contribute AT LEAST enough to get the full employer match — it's an instant 100% return on that money.",
            category: .retirement,
            difficulty: .medium,
            xpReward: 100,
            moneyIQGain: 5,
            estimatedSeconds: 60,
            imageURL: nil
        ),

        Challenge(
            id: "ch-017",
            title: "The Millionaire Timeline",
            scenario: "If you invest $500/month at an average 8% annual return, approximately how long will it take to become a millionaire?",
            options: [
                ChallengeOption(id: "a", text: "About 40 years", shortLabel: "~40 years", detail: "Slow but steady"),
                ChallengeOption(id: "b", text: "About 35 years", shortLabel: "~35 years", detail: "Moderately long"),
                ChallengeOption(id: "c", text: "About 30 years", shortLabel: "~30 years", detail: "Significant milestone"),
                ChallengeOption(id: "d", text: "About 25 years", shortLabel: "~25 years", detail: "Faster than expected")
            ],
            correctIndex: 2,
            explanation: "$500/month at 8% for 30 years grows to approximately $754,000 — and you hit $1M at about year 33. Start at 25 and you're a millionaire by 58. The math is real and achievable. Most people think millionaires are extraordinary. They're not — they're often regular people who invested consistently for decades. The formula isn't a secret. It's discipline + time + compound growth.",
            category: .retirement,
            difficulty: .medium,
            xpReward: 100,
            moneyIQGain: 5,
            estimatedSeconds: 60,
            imageURL: nil
        ),

        // MARK: Taxes
        Challenge(
            id: "ch-018",
            title: "Tax Bracket Myth",
            scenario: "You earn $85,000/year. You just got a $5,000 raise pushing you into a higher tax bracket. Some people say 'I don't want the raise — I'll take home less!' Is this true?",
            options: [
                ChallengeOption(id: "a", text: "True — getting a raise can leave you with less money", shortLabel: "True, risky raise", detail: "Higher bracket = less take-home"),
                ChallengeOption(id: "b", text: "False — only the amount ABOVE the threshold is taxed higher", shortLabel: "False, still better off", detail: "Marginal tax system"),
                ChallengeOption(id: "c", text: "True, but only if you don't have deductions", shortLabel: "Partially true", detail: "Depends on deductions"),
                ChallengeOption(id: "d", text: "It depends on your state", shortLabel: "State dependent", detail: "State taxes change things")
            ],
            correctIndex: 1,
            explanation: "This is one of the most common tax misconceptions! The US uses a MARGINAL tax system — only the dollars ABOVE the bracket threshold get taxed at the higher rate. If the 22% bracket starts at $89,075, and you earn $90,000, only $925 gets taxed at 22%. The rest is taxed at lower rates. A raise ALWAYS means more take-home pay. You can never 'make less by earning more.'",
            category: .taxes,
            difficulty: .medium,
            xpReward: 125,
            moneyIQGain: 6,
            estimatedSeconds: 75,
            imageURL: nil
        ),

        Challenge(
            id: "ch-019",
            title: "Tax-Loss Harvesting",
            scenario: "You have a stock investment down $3,000. You also have another investment up $3,000 that you planned to sell. What's the smart tax move?",
            options: [
                ChallengeOption(id: "a", text: "Sell the winner, ignore the loser — take your gains", shortLabel: "Sell winner only", detail: "Take profits"),
                ChallengeOption(id: "b", text: "Hold both — don't realize any gains or losses", shortLabel: "Hold both", detail: "No tax events"),
                ChallengeOption(id: "c", text: "Sell both — the loss offsets the gain, potentially eliminating the tax bill", shortLabel: "Sell both (harvest)", detail: "Tax-efficient move"),
                ChallengeOption(id: "d", text: "Sell only the loser to lock in the loss", shortLabel: "Sell loser only", detail: "Lock in the loss")
            ],
            correctIndex: 2,
            explanation: "Tax-loss harvesting: selling the loser offsets the $3,000 gain, potentially eliminating capital gains taxes entirely. You've realized $0 net gain on paper. You can then reinvest in a similar (but not identical) asset. This is a completely legal strategy that can save hundreds or thousands in taxes annually. Wealthy investors use this systematically every year.",
            category: .taxes,
            difficulty: .hard,
            xpReward: 150,
            moneyIQGain: 7,
            estimatedSeconds: 90,
            imageURL: nil
        ),

        // MARK: Psychology
        Challenge(
            id: "ch-020",
            title: "The Latte Factor Debate",
            scenario: "Personal finance guru David Bach says cutting your $5 daily latte will make you rich. Finance author Ramit Sethi disagrees. Who's more right for long-term wealth building?",
            options: [
                ChallengeOption(id: "a", text: "Bach — small cuts compound into massive wealth over time", shortLabel: "Small cuts matter", detail: "Discipline builds wealth"),
                ChallengeOption(id: "b", text: "Sethi — focus on big wins (salary, housing, car) instead of lattes", shortLabel: "Big wins > small cuts", detail: "Optimize what matters most"),
                ChallengeOption(id: "c", text: "Both are equally important for financial success", shortLabel: "Both equally valid", detail: "Balance both approaches"),
                ChallengeOption(id: "d", text: "Neither — personal finance is completely individual", shortLabel: "It's individual", detail: "No universal answer")
            ],
            correctIndex: 1,
            explanation: "Both have merit, but Sethi's approach has a stronger financial case. Optimizing 3-4 'big wins' — negotiating salary (worth $5K-50K/year), refinancing debt, optimizing housing costs — creates far more wealth than denying yourself a $5 coffee. That said, Bach's point is psychological: small habits reveal your relationship with money. The best approach: automate big financial wins, then spend guilt-free on what genuinely makes you happy.",
            category: .psychology,
            difficulty: .hard,
            xpReward: 150,
            moneyIQGain: 6,
            estimatedSeconds: 90,
            imageURL: nil
        ),

        Challenge(
            id: "ch-021",
            title: "The Anchoring Trap",
            scenario: "A jacket is on sale: 'Was $300, NOW $150!' You weren't planning to buy a jacket. What psychological trap might you fall into?",
            options: [
                ChallengeOption(id: "a", text: "FOMO — fear of missing the deal before it ends", shortLabel: "FOMO trap", detail: "Fear of missing out"),
                ChallengeOption(id: "b", text: "Anchoring — using $300 as the reference makes $150 feel like a steal", shortLabel: "Anchoring bias", detail: "Reference point manipulation"),
                ChallengeOption(id: "c", text: "Loss aversion — feeling you'd lose by NOT buying it", shortLabel: "Loss aversion", detail: "Fear of missing savings"),
                ChallengeOption(id: "d", text: "All of the above work together to manipulate spending", shortLabel: "All of the above", detail: "Combined psychological tricks")
            ],
            correctIndex: 3,
            explanation: "All three work in concert! Anchoring makes $300 feel like the 'real' price, making $150 seem like a massive win. Loss aversion makes 'saving $150' feel like you're losing $150 by NOT buying. FOMO creates urgency. The reality: you're spending $150 you didn't plan to spend on something you didn't need. Understanding these tricks is your superpower against impulse spending.",
            category: .psychology,
            difficulty: .medium,
            xpReward: 125,
            moneyIQGain: 5,
            estimatedSeconds: 75,
            imageURL: nil
        ),

        // MARK: Entrepreneurship
        Challenge(
            id: "ch-022",
            title: "Side Hustle Tax Reality",
            scenario: "You earn $1,000/month from freelance work on top of your full-time job. How much should you set aside for taxes?",
            options: [
                ChallengeOption(id: "a", text: "Nothing — it's under $10,000/year", shortLabel: "Nothing", detail: "Below the threshold"),
                ChallengeOption(id: "b", text: "10-15%", shortLabel: "10-15%", detail: "Standard income tax"),
                ChallengeOption(id: "c", text: "25-30%", shortLabel: "25-30%", detail: "Includes self-employment tax"),
                ChallengeOption(id: "d", text: "40-50%", shortLabel: "40-50%", detail: "Maximum possible rate")
            ],
            correctIndex: 2,
            explanation: "Set aside 25-30% of freelance income. Here's why: you owe self-employment tax (15.3% on Social Security/Medicare that employers normally split), plus federal income tax at your marginal rate (probably 22-24%), plus state income tax. Common mistake: treating all freelance income as pure profit. The IRS also requires quarterly estimated payments — missing them causes penalties. Open a dedicated savings account for tax funds immediately.",
            category: .entrepreneurship,
            difficulty: .medium,
            xpReward: 100,
            moneyIQGain: 5,
            estimatedSeconds: 60,
            imageURL: nil
        ),

        Challenge(
            id: "ch-023",
            title: "The Business Credit Strategy",
            scenario: "You're starting a side business. Why might you want to establish business credit (separate from personal credit) early?",
            options: [
                ChallengeOption(id: "a", text: "To hide business expenses from your personal finances", shortLabel: "Hide expenses", detail: "Separation of finances"),
                ChallengeOption(id: "b", text: "To protect personal assets and access business-specific financing", shortLabel: "Asset protection + financing", detail: "Legal and financial benefits"),
                ChallengeOption(id: "c", text: "Because it's legally required for all businesses", shortLabel: "Legal requirement", detail: "Compliance reason"),
                ChallengeOption(id: "d", text: "Because business accounts have lower fees than personal accounts", shortLabel: "Lower fees", detail: "Cost savings")
            ],
            correctIndex: 1,
            explanation: "Establishing business credit does two powerful things: (1) Liability protection — your personal home, car, savings can't be touched if the business has legal problems. (2) Access to business financing — credit cards, lines of credit, and SBA loans that aren't tied to your personal score. Building business credit takes time, so start early: get an EIN, open a business bank account, and get a business credit card you pay in full monthly.",
            category: .entrepreneurship,
            difficulty: .hard,
            xpReward: 150,
            moneyIQGain: 6,
            estimatedSeconds: 90,
            imageURL: nil
        ),

        // MARK: More Compound Interest
        Challenge(
            id: "ch-024",
            title: "The Rule of 72",
            scenario: "You invest money at 6% annual return. Using the 'Rule of 72,' roughly how long until your investment doubles?",
            options: [
                ChallengeOption(id: "a", text: "6 years", shortLabel: "6 years", detail: "Quick double"),
                ChallengeOption(id: "b", text: "12 years", shortLabel: "12 years", detail: "Standard estimate"),
                ChallengeOption(id: "c", text: "18 years", shortLabel: "18 years", detail: "Longer timeline"),
                ChallengeOption(id: "d", text: "24 years", shortLabel: "24 years", detail: "Conservative estimate")
            ],
            correctIndex: 1,
            explanation: "The Rule of 72: divide 72 by your interest rate = years to double. At 6%, that's 72÷6 = 12 years. At 10% (historical S&P 500), it's 72÷10 = 7.2 years. This mental math tool is incredibly powerful. $10K at 10% becomes: $20K (7 yrs), $40K (14 yrs), $80K (21 yrs), $160K (28 yrs) — just by sitting in an index fund. The earlier you start, the more doublings you get.",
            category: .compoundInterest,
            difficulty: .easy,
            xpReward: 75,
            moneyIQGain: 4,
            estimatedSeconds: 45,
            imageURL: nil
        ),

        // MARK: Lifestyle Inflation
        Challenge(
            id: "ch-025",
            title: "The Hedonic Treadmill",
            scenario: "Research shows that most people, after a major purchase (luxury car, bigger home, designer clothes), return to their baseline happiness within 3-6 months. This is called hedonic adaptation. What's the financially smart conclusion?",
            options: [
                ChallengeOption(id: "a", text: "Never buy luxuries — they don't bring lasting happiness", shortLabel: "Never buy luxuries", detail: "Extreme frugality"),
                ChallengeOption(id: "b", text: "Buy luxuries faster since the happiness boost is temporary", shortLabel: "Buy more, faster", detail: "Maximize fleeting joy"),
                ChallengeOption(id: "c", text: "Prioritize experiences and recurring pleasures over one-time purchases", shortLabel: "Experiences > things", detail: "Experiences resist adaptation better"),
                ChallengeOption(id: "d", text: "Buy luxuries only when you can truly afford them", shortLabel: "Afford it first", detail: "Financial readiness matters")
            ],
            correctIndex: 2,
            explanation: "Research consistently shows experiences (travel, concerts, meals, learning) provide more lasting happiness than material goods. Experiences become memories that grow richer over time. Objects adapt to quickly. This doesn't mean never buy things — but when you're spending to feel happier, research supports investing in experiences. The best financial move: automate savings, eliminate financial stress, then spend intentionally on what genuinely brings lasting joy.",
            category: .psychology,
            difficulty: .medium,
            xpReward: 100,
            moneyIQGain: 4,
            estimatedSeconds: 75,
            imageURL: nil
        ),

        Challenge(
            id: "ch-026",
            title: "Subscription Audit",
            scenario: "The average American spends $219/month on subscription services. If you audited your subscriptions and cut $100/month, investing that instead at 8% for 20 years, what would it grow to?",
            options: [
                ChallengeOption(id: "a", text: "$24,000 — just the cash saved", shortLabel: "$24K", detail: "Raw savings only"),
                ChallengeOption(id: "b", text: "$58,902 — with compound growth", shortLabel: "$58K", detail: "Invested and grown"),
                ChallengeOption(id: "c", text: "$100,000+ with compound growth", shortLabel: "$100K+", detail: "High growth estimate"),
                ChallengeOption(id: "d", text: "$35,000 — moderate growth", shortLabel: "$35K", detail: "Moderate estimate")
            ],
            correctIndex: 1,
            explanation: "$100/month at 8% for 20 years = $58,902. That's nearly $59K from unnoticed subscriptions. Do a subscription audit monthly: list every recurring charge, ask 'did I use this in the last 30 days?' Cancel anything that doesn't improve your life meaningfully. The goal isn't deprivation — it's directing money from things you forgot about to things that actively build your future.",
            category: .budgeting,
            difficulty: .easy,
            xpReward: 75,
            moneyIQGain: 3,
            estimatedSeconds: 45,
            imageURL: nil
        ),

        Challenge(
            id: "ch-027",
            title: "Negotiating Your Salary",
            scenario: "You're offered a $70,000 salary. Negotiating for $75,000 sounds awkward, but what's the real long-term financial impact over a 10-year career (assuming 3% annual raises)?",
            options: [
                ChallengeOption(id: "a", text: "$50,000 more over 10 years", shortLabel: "$50K more", detail: "Significant difference"),
                ChallengeOption(id: "b", text: "$67,000 more over 10 years", shortLabel: "$67K more", detail: "Compounding raises"),
                ChallengeOption(id: "c", text: "$5,000 per year, no compounding effect", shortLabel: "$5K/year", detail: "Simple math only"),
                ChallengeOption(id: "d", text: "About $150,000 more over 10 years", shortLabel: "$150K+", detail: "Major lifetime impact")
            ],
            correctIndex: 1,
            explanation: "That one negotiation conversation = ~$67,000 more over 10 years (because raises compound off the higher base). It also affects your 401(k) match, bonus calculations, and any future salary negotiations. The 5-minute conversation that feels awkward could be worth more per hour than any other activity in your career. Most companies expect negotiation. 85% of people who negotiate get more. Just ask.",
            category: .entrepreneurship,
            difficulty: .medium,
            xpReward: 100,
            moneyIQGain: 5,
            estimatedSeconds: 60,
            imageURL: nil
        ),

        Challenge(
            id: "ch-028",
            title: "HSA: The Secret Wealth Tool",
            scenario: "A Health Savings Account (HSA) offers triple tax advantages. Which THREE benefits does an HSA provide?",
            options: [
                ChallengeOption(id: "a", text: "Tax-deductible contributions, tax-free growth, tax-free withdrawals for medical expenses", shortLabel: "Triple tax advantage", detail: "The ultimate tax hack"),
                ChallengeOption(id: "b", text: "Tax-deductible contributions only — it's just a savings account", shortLabel: "Single benefit", detail: "Basic tax benefit"),
                ChallengeOption(id: "c", text: "Tax-free growth and withdrawals, but not contributions", shortLabel: "Two benefits", detail: "Like a Roth account"),
                ChallengeOption(id: "d", text: "Tax-free employer match contributions only", shortLabel: "Employer match", detail: "Match benefit only")
            ],
            correctIndex: 0,
            explanation: "The HSA is the ONLY account with triple tax advantages: (1) Contributions are tax-deductible, reducing your taxable income now. (2) Growth is completely tax-free. (3) Withdrawals are tax-free for qualified medical expenses. After 65, you can withdraw for ANY reason (just pay regular income tax — same as a Traditional IRA). Strategy: max your HSA, pay medical expenses out-of-pocket while young, let the HSA compound into retirement. It's a secret retirement account.",
            category: .taxes,
            difficulty: .expert,
            xpReward: 200,
            moneyIQGain: 8,
            estimatedSeconds: 90,
            imageURL: nil
        ),

        Challenge(
            id: "ch-029",
            title: "The 4% Rule",
            scenario: "You want to retire early. The '4% rule' says you can safely withdraw 4% of your portfolio annually without running out of money. To retire on $50,000/year, how large does your portfolio need to be?",
            options: [
                ChallengeOption(id: "a", text: "$500,000", shortLabel: "$500K", detail: "Based on 10% annual return"),
                ChallengeOption(id: "b", text: "$750,000", shortLabel: "$750K", detail: "Conservative estimate"),
                ChallengeOption(id: "c", text: "$1,000,000", shortLabel: "$1M", detail: "Standard safe estimate"),
                ChallengeOption(id: "d", text: "$1,250,000", shortLabel: "$1.25M", detail: "Higher safety margin")
            ],
            correctIndex: 3,
            explanation: "$50,000 ÷ 0.04 = $1,250,000 needed. This is the FIRE movement math (Financial Independence, Retire Early). The 4% rule means your portfolio generates returns of 6-7% annually, you spend 4%, and 2-3% covers inflation. Based on historical data, this has been safe for 30-year retirements. For very early retirement (40+ years), some use the 3.5% rule: $50K/year needs $1.43M. Knowing your 'FIRE number' transforms retirement from abstract dream to concrete goal.",
            category: .retirement,
            difficulty: .hard,
            xpReward: 150,
            moneyIQGain: 7,
            estimatedSeconds: 75,
            imageURL: nil
        ),

        Challenge(
            id: "ch-030",
            title: "Dollar-Cost Averaging",
            scenario: "The market is volatile. You have $12,000 to invest. Which strategy is typically better for reducing risk?",
            options: [
                ChallengeOption(id: "a", text: "Invest all $12,000 immediately (lump sum)", shortLabel: "Lump sum now", detail: "Maximize time in market"),
                ChallengeOption(id: "b", text: "Invest $1,000/month for 12 months (DCA)", shortLabel: "DCA over 12 months", detail: "Smooth out volatility"),
                ChallengeOption(id: "c", text: "Wait for the market to dip, then invest all", shortLabel: "Wait for dip", detail: "Time the market"),
                ChallengeOption(id: "d", text: "Split: $6,000 now, $6,000 in 6 months", shortLabel: "Split approach", detail: "Partial commitment")
            ],
            correctIndex: 0,
            explanation: "Statistically, lump-sum investing beats DCA about 2/3 of the time because time in market typically beats timing the market. However, DCA is psychologically easier and still excellent. The worst strategy is waiting for 'the right time' — market timing consistently fails. The real answer: lump sum is mathematically optimal, but DCA removes emotional barriers to investing. If DCA gets you to invest when you otherwise wouldn't, it wins for YOUR situation.",
            category: .investing,
            difficulty: .hard,
            xpReward: 150,
            moneyIQGain: 7,
            estimatedSeconds: 90,
            imageURL: nil
        ),

        Challenge(
            id: "ch-031",
            title: "The Rent vs. Invest Decision",
            scenario: "You can either: (A) Put $30,000 down on a $300,000 house, or (B) Continue renting ($1,500/month) and invest the $30,000 + $300/month (difference in costs) in index funds. Over 20 years in a moderate market, which likely builds more wealth?",
            options: [
                ChallengeOption(id: "a", text: "Buying the house always wins — real estate appreciates", shortLabel: "Buy always wins", detail: "Real estate appreciation"),
                ChallengeOption(id: "b", text: "Renting + investing often produces comparable or better returns in many markets", shortLabel: "Renting can compete", detail: "Investment returns may match"),
                ChallengeOption(id: "c", text: "Renting is always throwing money away", shortLabel: "Renting wastes money", detail: "Classic wisdom"),
                ChallengeOption(id: "d", text: "Both are exactly equal over 20 years", shortLabel: "Exactly equal", detail: "Same outcome")
            ],
            correctIndex: 1,
            explanation: "This is one of the most debated topics in personal finance. In many US cities, renting + investing yields comparable or better returns than buying, especially when accounting for: mortgage interest, property taxes, insurance, maintenance (1-2% of home value/year), and opportunity cost. In appreciating markets (NYC, SF), buying often wins. The NYT Rent vs. Buy calculator factors in all hidden costs. The best answer depends entirely on your local market, timeline, and discipline to actually invest the difference.",
            category: .opportunityCost,
            difficulty: .expert,
            xpReward: 200,
            moneyIQGain: 8,
            estimatedSeconds: 90,
            imageURL: nil
        ),

        Challenge(
            id: "ch-032",
            title: "Backdoor Roth IRA",
            scenario: "You earn $200,000/year — above the Roth IRA income limit ($153,000 for single filers in 2024). How can you still legally contribute to a Roth IRA?",
            options: [
                ChallengeOption(id: "a", text: "You can't — high earners are excluded from Roth IRAs", shortLabel: "Not possible", detail: "Income limit blocks you"),
                ChallengeOption(id: "b", text: "Ask your employer to set one up through your 401(k)", shortLabel: "Through employer", detail: "Employer workaround"),
                ChallengeOption(id: "c", text: "Use the 'backdoor Roth': contribute to Traditional IRA, then convert to Roth", shortLabel: "Backdoor Roth", detail: "Legal conversion strategy"),
                ChallengeOption(id: "d", text: "Contribute through a spouse's account", shortLabel: "Spousal strategy", detail: "Use spouse's account")
            ],
            correctIndex: 2,
            explanation: "The backdoor Roth is completely legal and widely used by high earners. Steps: (1) Make a non-deductible contribution to a Traditional IRA ($7,000 in 2024). (2) Convert it to a Roth IRA — pay taxes only on any growth between deposit and conversion. (3) Your money is now in a Roth and grows tax-free forever. Many CPAs recommend doing this conversion quickly to minimize taxable growth. There's also a 'mega backdoor Roth' through 401(k)s for up to $43,500/year.",
            category: .taxes,
            difficulty: .expert,
            xpReward: 200,
            moneyIQGain: 9,
            estimatedSeconds: 90,
            imageURL: nil
        ),

        Challenge(
            id: "ch-033",
            title: "Net Worth vs. Income",
            scenario: "Who is wealthier: Person A earns $300,000/year but spends $310,000, has no savings, and $50K in debt. Person B earns $70,000/year, lives on $45,000, and has $200,000 in investments. Why?",
            options: [
                ChallengeOption(id: "a", text: "Person A — higher income means more opportunities to build wealth", shortLabel: "Person A (income)", detail: "Income drives future wealth"),
                ChallengeOption(id: "b", text: "Person B — net worth (assets minus liabilities) is what matters, not income", shortLabel: "Person B (net worth)", detail: "Assets determine wealth"),
                ChallengeOption(id: "c", text: "Person A — their career trajectory will lead to more savings", shortLabel: "Person A (trajectory)", detail: "Future potential"),
                ChallengeOption(id: "d", text: "They're equal — income and savings balance out", shortLabel: "Equal", detail: "Balanced perspective")
            ],
            correctIndex: 1,
            explanation: "Person B is wealthier. Net worth = assets minus liabilities. Person A has negative net worth (-$50K). Person B has $200K in investments and lives below their means. Income is a tool — net worth is the score. This is why wealthy people often look middle class while many high earners are one paycheck away from crisis. The goal isn't to earn more (though helpful) — it's to keep more of what you earn and make it work for you.",
            category: .psychology,
            difficulty: .medium,
            xpReward: 100,
            moneyIQGain: 5,
            estimatedSeconds: 60,
            imageURL: nil
        )
    ]

    // MARK: - Achievements
    static let achievements: [Achievement] = [
        Achievement(
            id: "ach-001",
            title: "First Step",
            description: "Complete your first daily challenge",
            emoji: "🎯",
            category: .challenges,
            requirement: .challengesCompleted(count: 1),
            xpReward: 100,
            rarity: .common,
            isUnlocked: true,
            unlockedAt: Calendar.current.date(byAdding: .day, value: -28, to: Date())
        ),
        Achievement(
            id: "ach-002",
            title: "On Fire",
            description: "Maintain a 3-day streak",
            emoji: "🔥",
            category: .streaks,
            requirement: .streak(days: 3),
            xpReward: 150,
            rarity: .common,
            isUnlocked: true,
            unlockedAt: Calendar.current.date(byAdding: .day, value: -24, to: Date())
        ),
        Achievement(
            id: "ach-003",
            title: "Week Warrior",
            description: "Keep a 7-day streak going",
            emoji: "⚡",
            category: .streaks,
            requirement: .streak(days: 7),
            xpReward: 300,
            rarity: .rare,
            isUnlocked: true,
            unlockedAt: Calendar.current.date(byAdding: .day, value: -17, to: Date())
        ),
        Achievement(
            id: "ach-004",
            title: "Money Mind",
            description: "Complete 10 challenges correctly",
            emoji: "🧠",
            category: .challenges,
            requirement: .correctAnswers(count: 10),
            xpReward: 250,
            rarity: .rare,
            isUnlocked: true,
            unlockedAt: Calendar.current.date(byAdding: .day, value: -14, to: Date())
        ),
        Achievement(
            id: "ach-005",
            title: "Simulation King",
            description: "Run your first AI financial simulation",
            emoji: "🤖",
            category: .simulator,
            requirement: .simulationsRun(count: 1),
            xpReward: 200,
            rarity: .rare,
            isUnlocked: true,
            unlockedAt: Calendar.current.date(byAdding: .day, value: -10, to: Date())
        ),
        Achievement(
            id: "ach-006",
            title: "Debt Destroyer",
            description: "Complete 5 debt-related challenges",
            emoji: "💥",
            category: .challenges,
            requirement: .custom(id: "debt-challenges-5"),
            xpReward: 350,
            rarity: .epic,
            isUnlocked: false
        ),
        Achievement(
            id: "ach-007",
            title: "Investor Mindset",
            description: "Complete 5 investing challenges",
            emoji: "📈",
            category: .challenges,
            requirement: .custom(id: "investing-challenges-5"),
            xpReward: 350,
            rarity: .epic,
            isUnlocked: false
        ),
        Achievement(
            id: "ach-008",
            title: "Month Master",
            description: "Maintain a 30-day streak",
            emoji: "🏆",
            category: .streaks,
            requirement: .streak(days: 30),
            xpReward: 1000,
            rarity: .legendary,
            isUnlocked: false
        ),
        Achievement(
            id: "ach-009",
            title: "IQ Elite",
            description: "Reach a Money IQ of 800",
            emoji: "💎",
            category: .milestones,
            requirement: .moneyIQ(score: 800),
            xpReward: 500,
            rarity: .legendary,
            isUnlocked: false
        ),
        Achievement(
            id: "ach-010",
            title: "Level Up Legend",
            description: "Reach Level 5",
            emoji: "🚀",
            category: .milestones,
            requirement: .level(number: 5),
            xpReward: 500,
            rarity: .epic,
            isUnlocked: false
        ),
        Achievement(
            id: "ach-011",
            title: "Budget Boss",
            description: "Complete all budgeting challenges",
            emoji: "📋",
            category: .challenges,
            requirement: .custom(id: "budget-all"),
            xpReward: 400,
            rarity: .epic,
            isUnlocked: false
        ),
        Achievement(
            id: "ach-012",
            title: "Opportunity Hunter",
            description: "Complete all opportunity cost challenges",
            emoji: "🎯",
            category: .challenges,
            requirement: .custom(id: "opportunity-all"),
            xpReward: 400,
            rarity: .epic,
            isUnlocked: false
        )
    ]

    // MARK: - Leaderboard
    static let leaderboard: [LeaderboardEntry] = [
        LeaderboardEntry(id: "l1", userId: "u1", username: "WealthNinja", avatarURL: nil, moneyIQ: 952, level: 9, currentStreak: 45, weeklyXP: 2840, rank: 1, levelTitle: "Stacked Master", changeInRank: 0),
        LeaderboardEntry(id: "l2", userId: "u2", username: "MoneyMaster", avatarURL: nil, moneyIQ: 931, level: 9, currentStreak: 38, weeklyXP: 2650, rank: 2, levelTitle: "Stacked Master", changeInRank: 2),
        LeaderboardEntry(id: "l3", userId: "u3", username: "InvestorIQ", avatarURL: nil, moneyIQ: 917, level: 8, currentStreak: 22, weeklyXP: 2410, rank: 3, levelTitle: "Financial Maestro", changeInRank: -1),
        LeaderboardEntry(id: "l4", userId: "u4", username: "FinanceKing", avatarURL: nil, moneyIQ: 895, level: 8, currentStreak: 19, weeklyXP: 2200, rank: 4, levelTitle: "Financial Maestro", changeInRank: 1),
        LeaderboardEntry(id: "l5", userId: "u5", username: "StackedQueen", avatarURL: nil, moneyIQ: 871, level: 7, currentStreak: 31, weeklyXP: 2100, rank: 5, levelTitle: "Capital Commander", changeInRank: 3),
        LeaderboardEntry(id: "l6", userId: "u6", username: "BullMarket", avatarURL: nil, moneyIQ: 858, level: 7, currentStreak: 14, weeklyXP: 1950, rank: 6, levelTitle: "Capital Commander", changeInRank: -2),
        LeaderboardEntry(id: "l7", userId: "u7", username: "CompoundKing", avatarURL: nil, moneyIQ: 842, level: 7, currentStreak: 8, weeklyXP: 1820, rank: 7, levelTitle: "Capital Commander", changeInRank: 0),
        LeaderboardEntry(id: "l8", userId: "u8", username: "RothQueen", avatarURL: nil, moneyIQ: 823, level: 6, currentStreak: 21, weeklyXP: 1700, rank: 8, levelTitle: "Wealth Strategist", changeInRank: 4),
        LeaderboardEntry(id: "l9", userId: "u9", username: "FIREwalker", avatarURL: nil, moneyIQ: 810, level: 6, currentStreak: 16, weeklyXP: 1580, rank: 9, levelTitle: "Wealth Strategist", changeInRank: -1),
        LeaderboardEntry(id: "l10", userId: "u10", username: "DividendDave", avatarURL: nil, moneyIQ: 795, level: 6, currentStreak: 11, weeklyXP: 1430, rank: 10, levelTitle: "Wealth Strategist", changeInRank: 2),
        LeaderboardEntry(id: "l-demo", userId: "demo-user-001", username: "StackedUser", avatarURL: nil, moneyIQ: 742, level: 4, currentStreak: 7, weeklyXP: 1240, rank: 24, levelTitle: "Asset Architect", changeInRank: 5, isCurrentUser: true)
    ]

    // MARK: - Mock AI Simulation Responses
    static let simulationResponses: [String: SimulationResult] = [
        "invest-100-month": SimulationResult(
            id: "sim-001",
            query: "What if I invest $100/month?",
            headline: "💰 $100/month = Life-Changing Wealth",
            summary: "Starting today, investing just $100/month in a diversified index fund could build you a massive wealth base. Here's the math that will blow your mind:",
            projections: [
                Projection(id: "p1", label: "5 Years", value: 7348, formatted: "$7,348", timeframe: "5 years", isPositive: true, emoji: "🌱"),
                Projection(id: "p2", label: "10 Years", value: 18294, formatted: "$18,294", timeframe: "10 years", isPositive: true, emoji: "📈"),
                Projection(id: "p3", label: "20 Years", value: 58902, formatted: "$58,902", timeframe: "20 years", isPositive: true, emoji: "🚀"),
                Projection(id: "p4", label: "30 Years", value: 149035, formatted: "$149,035", timeframe: "30 years", isPositive: true, emoji: "💎"),
                Projection(id: "p5", label: "40 Years", value: 349070, formatted: "$349,070", timeframe: "40 years", isPositive: true, emoji: "🏆")
            ],
            opportunityCost: OpportunityCost(
                description: "Every month you wait costs you compounding time",
                amount: 2920,
                formatted: "$2,920+",
                emoji: "⏰",
                comparison: "Waiting 1 year to start means ~$2,920 less at 30 years"
            ),
            smarterAlternatives: [
                SmartAlternative(id: "a1", title: "Boost to $200/month", description: "Cut one subscription and redirect a side hustle payment", potentialGain: "$298,070 in 30 years", emoji: "⚡"),
                SmartAlternative(id: "a2", title: "Use a Roth IRA", description: "Same $100/month but completely tax-free growth", potentialGain: "Save $30K+ in future taxes", emoji: "🏛️"),
                SmartAlternative(id: "a3", title: "Automate it today", description: "Set up auto-invest so willpower isn't required", potentialGain: "Consistency = everything", emoji: "🤖")
            ],
            motivationalTakeaway: "The best time to start was 10 years ago. The second best time is RIGHT NOW. $100/month sounds small, but $349,000 sounds pretty life-changing. 🚀",
            disclaimer: SimulationResult.educationalDisclaimer,
            timeframe: "Up to 40 years",
            charts: [
                ChartData(
                    id: "c1",
                    title: "Growth Over Time",
                    type: .area,
                    dataPoints: [
                        ChartDataPoint(id: "dp1", label: "Year 5", value: 7348, formattedValue: "$7K", series: "Portfolio"),
                        ChartDataPoint(id: "dp2", label: "Year 10", value: 18294, formattedValue: "$18K", series: "Portfolio"),
                        ChartDataPoint(id: "dp3", label: "Year 20", value: 58902, formattedValue: "$59K", series: "Portfolio"),
                        ChartDataPoint(id: "dp4", label: "Year 30", value: 149035, formattedValue: "$149K", series: "Portfolio"),
                        ChartDataPoint(id: "dp5", label: "Year 40", value: 349070, formattedValue: "$349K", series: "Portfolio")
                    ],
                    yAxisLabel: "Value ($)",
                    xAxisLabel: "Years"
                )
            ],
            tags: ["investing", "compound interest", "index funds", "retirement"]
        )
    ]

    // MARK: - Mock AI Coach Responses
    static let coachResponses: [String: String] = [
        "budget": "Great question! The simplest budget that actually works: automate your savings first (pay yourself first), then spend what's left. Try the 50/30/20 rule — 50% needs, 30% wants, 20% savings. The key is making saving automatic so willpower isn't required. 💪",
        "invest": "Start with the basics: if your employer offers a 401(k) match, contribute enough to get the full match — that's an instant 100% return. Then open a Roth IRA and invest in low-cost index funds like VTI or VTSAX. Simple, boring, effective. 📈",
        "debt": "Attack high-interest debt first (debt avalanche method). List your debts by interest rate. Make minimums on everything except the highest rate — throw everything extra at that one. The math wins every time. 🔥",
        "default": "That's a great financial question! The core principle: spend less than you earn, invest the difference consistently, and let time do the heavy lifting. What specific area would you like to dive deeper into? 💰"
    ]
}
