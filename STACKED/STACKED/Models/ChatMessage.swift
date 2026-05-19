import Foundation

// MARK: - Chat Message
struct ChatMessage: Identifiable, Codable, Equatable {
    let id: String
    let role: MessageRole
    let content: String
    let timestamp: Date
    var isTyping: Bool = false

    enum MessageRole: String, Codable {
        case user, assistant, system
    }

    static func userMessage(_ text: String) -> ChatMessage {
        ChatMessage(id: UUID().uuidString, role: .user, content: text, timestamp: Date())
    }

    static func assistantMessage(_ text: String) -> ChatMessage {
        ChatMessage(id: UUID().uuidString, role: .assistant, content: text, timestamp: Date())
    }

    static func typingIndicator() -> ChatMessage {
        ChatMessage(id: "typing", role: .assistant, content: "...", timestamp: Date(), isTyping: true)
    }
}

// MARK: - Coach Session
struct CoachSession: Identifiable, Codable {
    let id: String
    let userId: String
    var messages: [ChatMessage]
    let createdAt: Date
    var updatedAt: Date
    let title: String?
}

// MARK: - Suggested Prompts
enum CoachSuggestedPrompts {
    static let categories: [PromptCategory] = [
        PromptCategory(
            title: "Investing",
            emoji: "📈",
            prompts: [
                "How do I start investing with $500?",
                "What's the difference between stocks and ETFs?",
                "Should I invest or pay off debt first?",
                "Explain index funds like I'm 5"
            ]
        ),
        PromptCategory(
            title: "Budgeting",
            emoji: "📋",
            prompts: [
                "How do I create a budget that I'll actually stick to?",
                "What's the 50/30/20 rule?",
                "Help me stop lifestyle creep",
                "How much should I spend on rent?"
            ]
        ),
        PromptCategory(
            title: "Side Hustles",
            emoji: "⚡",
            prompts: [
                "What are the best side hustles in 2025?",
                "How do I monetize my skills?",
                "How much can I realistically earn from freelancing?",
                "How do taxes work for self-employment income?"
            ]
        ),
        PromptCategory(
            title: "Mindset",
            emoji: "🧠",
            prompts: [
                "How do I stop emotional spending?",
                "Why do I feel guilty spending money I earned?",
                "How do I build a wealth mindset?",
                "What habits do wealthy people have?"
            ]
        )
    ]
}

struct PromptCategory: Identifiable {
    let id = UUID()
    let title: String
    let emoji: String
    let prompts: [String]
}
