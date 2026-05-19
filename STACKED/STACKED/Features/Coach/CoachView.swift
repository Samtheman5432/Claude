import SwiftUI

struct CoachView: View {
    @ObservedObject var viewModel: CoachViewModel
    @State private var appear = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    CoachHeaderView()

                    // Chat Area
                    ScrollViewReader { proxy in
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: Theme.Spacing.sm) {
                                // Suggestions
                                if viewModel.showSuggestions {
                                    SuggestedPromptsView(viewModel: viewModel)
                                        .padding(.top, Theme.Spacing.md)
                                        .transition(.opacity)
                                }

                                // Messages
                                ForEach(viewModel.messages) { message in
                                    ChatBubble(message: message)
                                        .id(message.id)
                                        .transition(.asymmetric(
                                            insertion: .move(edge: .bottom).combined(with: .opacity),
                                            removal: .opacity
                                        ))
                                }

                                Spacer(minLength: 20)
                                    .id("bottom")
                            }
                            .padding(.horizontal, Theme.Spacing.md)
                        }
                        .onChange(of: viewModel.messages.count) { _ in
                            withAnimation(.smooth) {
                                proxy.scrollTo("bottom", anchor: .bottom)
                            }
                        }
                    }

                    // Input
                    CoachInputView(viewModel: viewModel)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Header
struct CoachHeaderView: View {
    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            // AI Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Theme.Colors.accentPurple, Theme.Colors.accentBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                Text("🤖")
                    .font(.system(size: 20))
            }
            .shadow(color: Theme.Colors.accentPurple.opacity(0.3), radius: 8)

            VStack(alignment: .leading, spacing: 2) {
                Text("Money Coach")
                    .font(Theme.Typography.headline)
                    .foregroundStyle(Theme.Colors.textPrimary)
                HStack(spacing: 4) {
                    Circle()
                        .fill(Theme.Colors.neonGreen)
                        .frame(width: 6, height: 6)
                    Text("Online · Powered by AI")
                        .font(Theme.Typography.micro)
                        .foregroundStyle(Theme.Colors.textSecondary)
                }
            }

            Spacer()

            IconButton(icon: "trash", color: Theme.Colors.textSecondary) {
                // Clear conversation
            }
        }
        .padding(.horizontal, Theme.Spacing.lg)
        .padding(.vertical, Theme.Spacing.md)
        .background(
            Rectangle()
                .fill(Theme.Colors.surface)
                .overlay(
                    Rectangle()
                        .fill(Theme.Colors.border)
                        .frame(height: 1),
                    alignment: .bottom
                )
        )
    }
}

// MARK: - Chat Bubble
struct ChatBubble: View {
    let message: ChatMessage
    @State private var appear = false

    var isUser: Bool { message.role == .user }

    var body: some View {
        HStack(alignment: .bottom, spacing: Theme.Spacing.sm) {
            if !isUser {
                // AI avatar
                ZStack {
                    Circle()
                        .fill(Theme.Colors.accentPurple.opacity(0.2))
                        .frame(width: 28, height: 28)
                    Text("🤖")
                        .font(.system(size: 14))
                }
            }

            VStack(alignment: isUser ? .trailing : .leading, spacing: 4) {
                if message.isTyping {
                    TypingIndicatorView()
                } else {
                    Text(message.content)
                        .font(Theme.Typography.body)
                        .foregroundStyle(isUser ? Theme.Colors.background : Theme.Colors.textPrimary)
                        .lineSpacing(3)
                        .padding(.horizontal, Theme.Spacing.md)
                        .padding(.vertical, Theme.Spacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(isUser ? Theme.Colors.neonGreen : Theme.Colors.surface)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .strokeBorder(isUser ? .clear : Theme.Colors.border, lineWidth: 1)
                                )
                        )
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: isUser ? .trailing : .leading)
                }

                Text(message.timestamp.formatted(.relative(presentation: .named)))
                    .font(Theme.Typography.micro)
                    .foregroundStyle(Theme.Colors.textTertiary)
            }

            if isUser { Spacer(minLength: 0) }
        }
        .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
        .scaleEffect(appear ? 1.0 : 0.95, anchor: isUser ? .bottomTrailing : .bottomLeading)
        .opacity(appear ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                appear = true
            }
        }
    }
}

// MARK: - Typing Indicator
struct TypingIndicatorView: View {
    @State private var dotOffset: [CGFloat] = [0, 0, 0]

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Theme.Colors.textSecondary)
                    .frame(width: 6, height: 6)
                    .offset(y: dotOffset[index])
                    .animation(
                        .easeInOut(duration: 0.4)
                        .repeatForever()
                        .delay(Double(index) * 0.15),
                        value: dotOffset[index]
                    )
            }
        }
        .padding(.horizontal, Theme.Spacing.md)
        .padding(.vertical, Theme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Theme.Colors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(Theme.Colors.border, lineWidth: 1)
                )
        )
        .onAppear {
            dotOffset = [-4, -4, -4]
        }
    }
}

// MARK: - Suggested Prompts
struct SuggestedPromptsView: View {
    @ObservedObject var viewModel: CoachViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("💬 Popular Questions")
                .font(Theme.Typography.callout)
                .foregroundStyle(Theme.Colors.textSecondary)

            ForEach(CoachSuggestedPrompts.categories) { category in
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("\(category.emoji) \(category.title)")
                        .font(Theme.Typography.caption)
                        .foregroundStyle(Theme.Colors.textTertiary)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Theme.Spacing.sm) {
                            ForEach(category.prompts, id: \.self) { prompt in
                                Button {
                                    viewModel.useSuggestedPrompt(prompt)
                                } label: {
                                    Text(prompt)
                                        .font(Theme.Typography.caption)
                                        .foregroundStyle(Theme.Colors.textSecondary)
                                        .padding(.horizontal, Theme.Spacing.sm)
                                        .padding(.vertical, 6)
                                        .background(
                                            Capsule()
                                                .fill(Theme.Colors.surfaceElevated)
                                                .overlay(
                                                    Capsule()
                                                        .strokeBorder(Theme.Colors.border, lineWidth: 1)
                                                )
                                        )
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Theme.Spacing.md)
        .glassCard()
    }
}

// MARK: - Input View
struct CoachInputView: View {
    @ObservedObject var viewModel: CoachViewModel
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Theme.Colors.border)

            HStack(spacing: Theme.Spacing.sm) {
                TextField("Ask me anything about money...", text: $viewModel.inputText, axis: .vertical)
                    .font(Theme.Typography.body)
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .lineLimit(1...4)
                    .focused($isFocused)
                    .onSubmit {
                        Task { await viewModel.sendMessage() }
                    }

                Button {
                    isFocused = false
                    Task { await viewModel.sendMessage() }
                } label: {
                    ZStack {
                        Circle()
                            .fill(viewModel.inputText.isEmpty ? Theme.Colors.border : Theme.Colors.neonGreen)
                            .frame(width: 36, height: 36)
                        Image(systemName: "arrow.up")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(viewModel.inputText.isEmpty ? Theme.Colors.textTertiary : Theme.Colors.background)
                    }
                }
                .disabled(viewModel.inputText.isEmpty || viewModel.isTyping)
                .animation(.snappy, value: viewModel.inputText.isEmpty)
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, Theme.Spacing.sm)
            .background(Theme.Colors.surface)
        }
        .background(Theme.Colors.surface)
    }
}
