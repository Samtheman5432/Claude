import Foundation

@MainActor
final class SimulatorViewModel: ObservableObject {
    @Published var prompt: String = ""
    @Published var result: SimulationResult?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var suggestions: [String] = []
    @Published var history: [SimulationResult] = []
    @Published var showResult = false

    private let aiService: MockAIService
    private let authService: MockAuthService

    init(aiService: MockAIService, authService: MockAuthService) {
        self.aiService = aiService
        self.authService = authService
    }

    func loadSuggestions() async {
        suggestions = (try? await aiService.generateSimulationSuggestions()) ?? []
    }

    func runSimulation() async {
        guard !prompt.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        isLoading = true
        errorMessage = nil

        do {
            let sim = try await aiService.runSimulation(prompt: prompt)
            result = sim
            history.insert(sim, at: 0)
            showResult = true
            await authService.updateUserStats(xpGained: 50, moneyIQGain: 2)
            HapticManager.shared.success()
        } catch {
            errorMessage = "Simulation failed. Please try again."
            HapticManager.shared.error()
        }
        isLoading = false
    }

    func useSuggestion(_ suggestion: String) {
        prompt = suggestion
        HapticManager.shared.selection()
    }

    func resetSimulation() {
        result = nil
        showResult = false
        prompt = ""
    }
}
