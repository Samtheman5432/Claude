import Foundation

// MARK: - Simulation Query
struct SimulationQuery: Codable {
    let id: String
    let userId: String
    let prompt: String
    let createdAt: Date
}

// MARK: - Simulation Result
struct SimulationResult: Identifiable, Codable {
    let id: String
    let query: String
    let headline: String
    let summary: String
    let projections: [Projection]
    let opportunityCost: OpportunityCost?
    let smarterAlternatives: [SmartAlternative]
    let motivationalTakeaway: String
    let disclaimer: String
    let timeframe: String
    let charts: [ChartData]
    let tags: [String]

    static let educationalDisclaimer = "⚠️ This is educational content, not financial advice. Projections are illustrative estimates based on general assumptions. Consult a licensed financial advisor for personalized guidance."
}

// MARK: - Projection
struct Projection: Identifiable, Codable {
    let id: String
    let label: String
    let value: Double
    let formatted: String
    let timeframe: String
    let isPositive: Bool
    let emoji: String
}

// MARK: - Opportunity Cost
struct OpportunityCost: Codable {
    let description: String
    let amount: Double
    let formatted: String
    let emoji: String
    let comparison: String
}

// MARK: - Smarter Alternative
struct SmartAlternative: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let potentialGain: String
    let emoji: String
}

// MARK: - Chart Data
struct ChartData: Identifiable, Codable {
    let id: String
    let title: String
    let type: ChartType
    let dataPoints: [ChartDataPoint]
    let yAxisLabel: String
    let xAxisLabel: String

    enum ChartType: String, Codable {
        case line, bar, area, comparison
    }
}

// MARK: - Chart Data Point
struct ChartDataPoint: Identifiable, Codable {
    let id: String
    let label: String
    let value: Double
    let formattedValue: String
    let series: String?
}
