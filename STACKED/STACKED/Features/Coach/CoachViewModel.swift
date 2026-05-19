import Foundation

@MainActor
final class CoachViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isTyping = false
    @Published var errorMessage: String?
    @Published var showSuggestions = true

    private let aiService: MockAIService

    init(aiService: MockAIService) {
        self.aiService = aiService
        setupWelcomeMessage()
    }

    private func setupWelcomeMessage() {
        let welcome = ChatMessage.assistantMessage(
            "Hey! 👋 I'm your STACKED Money Coach — your personal CFO in your pocket.\n\nI can help you with budgeting, investing, debt, side hustles, and building real wealth. What's on your financial mind today?"
        )
        messages = [welcome]
    }

    func sendMessage() async {
        let text = inputText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }

        let userMsg = ChatMessage.userMessage(text)
        messages.append(userMsg)
        inputText = ""
        showSuggestions = false
        HapticManager.shared.selection()

        let typingMsg = ChatMessage.typingIndicator()
        messages.append(typingMsg)
        isTyping = true

        do {
            let response = try await aiService.sendCoachMessage(text, history: messages)
            messages.removeAll { $0.isTyping }
            let assistantMsg = ChatMessage.assistantMessage(response)
            messages.append(assistantMsg)
            HapticManager.shared.light()
        } catch {
            messages.removeAll { $0.isTyping }
            errorMessage = "Message failed. Please try again."
        }
        isTyping = false
    }

    func useSuggestedPrompt(_ prompt: String) {
        inputText = prompt
        Task { await sendMessage() }
    }

    func clearConversation() {
        messages = []
        showSuggestions = true
        setupWelcomeMessage()
    }
}
