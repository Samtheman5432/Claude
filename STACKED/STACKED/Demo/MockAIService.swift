import Foundation

// MARK: - AI Service Protocol
protocol AIServiceProtocol {
    func runSimulation(prompt: String) async throws -> SimulationResult
    func sendCoachMessage(_ message: String, history: [ChatMessage]) async throws -> String
    func generateSimulationSuggestions() async throws -> [String]
}

// MARK: - Mock AI Service
final class MockAIService: AIServiceProtocol {

    func runSimulation(prompt: String) async throws -> SimulationResult {
        // Simulate thinking time
        try await Task.sleep(nanoseconds: 2_000_000_000)

        // Return pre-built simulation or generate generic one
        if let cached = DemoData.simulationResponses["invest-100-month"],
           prompt.lowercased().contains("invest") || prompt.lowercased().contains("100") {
            return cached
        }

        return generateGenericSimulation(for: prompt)
    }

    func sendCoachMessage(_ message: String, history: [ChatMessage]) async throws -> String {
        // Simulate AI thinking
        try await Task.sleep(nanoseconds: UInt64.random(in: 1_200_000_000...2_500_000_000))

        let lowered = message.lowercased()

        if lowered.contains("budget") || lowered.contains("spend") {
            return DemoData.coachResponses["budget"] ?? ""
        } else if lowered.contains("invest") || lowered.contains("stock") || lowered.contains("fund") {
            return DemoData.coachResponses["invest"] ?? ""
        } else if lowered.contains("debt") || lowered.contains("credit card") || lowered.contains("loan") {
            return DemoData.coachResponses["debt"] ?? ""
        } else if lowered.contains("side hustle") || lowered.contains("income") || lowered.contains("earn") {
            return "Side hustles are one of the fastest ways to accelerate wealth building! The most scalable ones leverage your existing skills: freelancing, consulting, content creation, or digital products. Start with what you already know — that's where you can charge premium rates immediately. What skills do you have that others would pay for? 💡"
        } else if lowered.contains("save") || lowered.contains("emergency fund") {
            return "Emergency funds are your financial foundation — non-negotiable! Aim for 3-6 months of expenses in a high-yield savings account (check Marcus, Ally, or SoFi — they're offering 4-5% APY). Automate a transfer on payday so you never see the money. Once it's funded, every dollar above that threshold can go to work in investments. 💎"
        } else if lowered.contains("house") || lowered.contains("rent") || lowered.contains("mortgage") {
            return "The rent vs. buy decision depends heavily on your local market, how long you'll stay (5+ years generally favors buying), and what you'd do with the down payment if you rented instead. In many high-cost cities, renting + investing the difference can match or beat buying. What's your local market like? 🏠"
        } else if lowered.contains("retire") || lowered.contains("401k") || lowered.contains("ira") {
            return "Retirement investing priority order: (1) 401(k) up to employer match — free money, (2) Max your Roth IRA — $7K/year in 2024, tax-free forever, (3) Max your 401(k) — $23K/year, (4) HSA if eligible — triple tax advantage, (5) Taxable brokerage for anything extra. Follow this order and you'll be in the top 10% of savers. 🌴"
        } else if lowered.contains("hello") || lowered.contains("hi") || lowered.contains("hey") {
            return "Hey! 👋 I'm your STACKED Money Coach — think of me as your personal CFO. I'm here to help you make smarter money moves, answer financial questions, and build your wealth game. What's on your financial mind today?"
        } else {
            return generateContextualResponse(for: message)
        }
    }

    func generateSimulationSuggestions() async throws -> [String] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return [
            "What if I invest $200/month for 20 years?",
            "What if I paid off my $10K credit card debt?",
            "What if I maxed my Roth IRA every year?",
            "What if I bought a $350K house?",
            "What if I started a side hustle earning $1K/month?",
            "What if I negotiated a $10K raise?",
            "What if I moved to a lower cost-of-living city?",
            "What if I invested my tax refund?",
            "What if I cut my expenses by $300/month?",
            "What if I retired at 50?"
        ]
    }

    // MARK: - Private Helpers
    private func generateGenericSimulation(for prompt: String) -> SimulationResult {
        let isPositive = !prompt.lowercased().contains("debt") && !prompt.lowercased().contains("buy") && !prompt.lowercased().contains("finance")

        let baseAmount = extractAmount(from: prompt) ?? 500
        let monthly = Double(baseAmount)

        return SimulationResult(
            id: UUID().uuidString,
            query: prompt,
            headline: isPositive ? "📈 Smart Move Alert!" : "💡 Let's Run the Numbers",
            summary: "Here's what the financial math looks like for your scenario. These projections assume consistent execution and average market conditions.",
            projections: [
                Projection(id: "p1", label: "1 Year", value: monthly * 12 * 1.08, formatted: formatCurrency(monthly * 12 * 1.08), timeframe: "1 year", isPositive: isPositive, emoji: "🌱"),
                Projection(id: "p2", label: "5 Years", value: monthly * 12 * 5 * 1.47, formatted: formatCurrency(monthly * 12 * 5 * 1.47), timeframe: "5 years", isPositive: isPositive, emoji: "📈"),
                Projection(id: "p3", label: "10 Years", value: monthly * 12 * 10 * 2.16, formatted: formatCurrency(monthly * 12 * 10 * 2.16), timeframe: "10 years", isPositive: isPositive, emoji: "🚀"),
                Projection(id: "p4", label: "20 Years", value: monthly * 12 * 20 * 4.66, formatted: formatCurrency(monthly * 12 * 20 * 4.66), timeframe: "20 years", isPositive: isPositive, emoji: "💎")
            ],
            opportunityCost: OpportunityCost(
                description: "The cost of waiting one year to start",
                amount: monthly * 12 * 0.4,
                formatted: formatCurrency(monthly * 12 * 0.4),
                emoji: "⏰",
                comparison: "Waiting costs you compounding time that can never be recovered"
            ),
            smarterAlternatives: [
                SmartAlternative(id: "a1", title: "Automate it", description: "Set up automatic transfers so it happens without thinking", potentialGain: "Consistency is the #1 wealth driver", emoji: "🤖"),
                SmartAlternative(id: "a2", title: "Use tax-advantaged accounts", description: "Roth IRA or 401(k) for maximum tax efficiency", potentialGain: "Save thousands in future taxes", emoji: "🏛️"),
                SmartAlternative(id: "a3", title: "Increase by 1% annually", description: "Add just 1% more each year as income grows", potentialGain: "Exponentially more wealth long-term", emoji: "📊")
            ],
            motivationalTakeaway: "Every financial decision compounds — both positively and negatively. The best move? Start now, optimize later. 💪",
            disclaimer: SimulationResult.educationalDisclaimer,
            timeframe: "Up to 20 years",
            charts: [
                ChartData(
                    id: "c1",
                    title: "Projected Growth",
                    type: .area,
                    dataPoints: [
                        ChartDataPoint(id: "dp1", label: "1Y", value: monthly * 12 * 1.08, formattedValue: formatCurrency(monthly * 12 * 1.08), series: "Value"),
                        ChartDataPoint(id: "dp2", label: "5Y", value: monthly * 12 * 5 * 1.47, formattedValue: formatCurrency(monthly * 12 * 5 * 1.47), series: "Value"),
                        ChartDataPoint(id: "dp3", label: "10Y", value: monthly * 12 * 10 * 2.16, formattedValue: formatCurrency(monthly * 12 * 10 * 2.16), series: "Value"),
                        ChartDataPoint(id: "dp4", label: "20Y", value: monthly * 12 * 20 * 4.66, formattedValue: formatCurrency(monthly * 12 * 20 * 4.66), series: "Value")
                    ],
                    yAxisLabel: "Value",
                    xAxisLabel: "Timeline"
                )
            ],
            tags: ["simulation", "planning", "wealth building"]
        )
    }

    private func generateContextualResponse(for message: String) -> String {
        let responses = [
            "Great question! The key principle in personal finance is: automate good behaviors and make bad behaviors harder. What specifically would you like to explore? 🎯",
            "Here's the wealth-building truth most people miss: it's not about how much you earn — it's about the gap between what you earn and what you spend, consistently invested over time. Tell me more about your situation! 💰",
            "Smart that you're thinking about this! Financial mastery is a skill, not a talent. Every question you ask puts you ahead of 90% of people who never ask. What's your biggest financial challenge right now? 🧠",
            "The boring answer that actually works: spend less than you earn, invest the difference in boring index funds, and wait. The exciting part? The math is absolutely wild over time. What specific move are you considering? 📈"
        ]
        return responses.randomElement() ?? responses[0]
    }

    private func extractAmount(from text: String) -> Int? {
        let pattern = #"\$?(\d{1,6}(?:,\d{3})*(?:\.\d{2})?)"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)),
              let range = Range(match.range(at: 1), in: text) else { return nil }
        let numberString = text[range].replacingOccurrences(of: ",", with: "")
        return Int(Double(numberString) ?? 500)
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$\(Int(value))"
    }
}
