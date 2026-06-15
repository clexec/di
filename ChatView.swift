import SwiftUI

struct ChatView: View {
    @EnvironmentObject var appState: AppState
    @State private var messageText: String = ""
    @State private var showAttachMenu: Bool = false
    @State private var messages: [ChatMessage] = []
    @State private var isLoading: Bool = false
    @State private var showSettings: Bool = false
    @State private var showConversations: Bool = false
    @State private var showProviderPicker: Bool = false
    @Namespace private var glassNamespace
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                topNavBar
                if messages.isEmpty { emptyStateView } else { messagesListView }
                bottomInputArea
            }
            
            if showAttachMenu { attachMenuOverlay }
        }
        .sheet(isPresented: $showSettings) { SettingsView() }
        .sheet(isPresented: $showConversations) { ConversationsListView() }
        .sheet(isPresented: $showProviderPicker) { ProviderPickerView() }
    }
    
    // MARK: - Top Nav Bar — NO GlassEffectContainer, each button separate
    private var topNavBar: some View {
        HStack(spacing: 12) {
            // Settings button — separate, bigger
            Button(action: { showSettings = true }) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 42, height: 42)
            }
            .glassEffect(.regular.interactive())
            
            // Chat list button — separate, bigger
            Button(action: { showConversations = true }) {
                Image(systemName: "bubble.left.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 42, height: 42)
            }
            .glassEffect(.regular.interactive())
            
            // Model selector button
            Button(action: { withAnimation { showProviderPicker = true } }) {
                HStack(spacing: 6) {
                    ProviderIconView(provider: appState.selectedProvider, size: 16)
                    Text(appState.selectedModel)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.4))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
            }
            .glassEffect(.regular.interactive())
            
            Spacer()
            
            // New chat button — separate
            Button(action: { withAnimation { messages = [] } }) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 42, height: 42)
            }
            .glassEffect(.regular.interactive())
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 12)
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 20) {
                ProviderIconView(provider: appState.selectedProvider, size: 48)
                
                Text("Use models from your computer")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Link to LM Studio and run larger models remotely from your computer. End-to-end encrypted.")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.4))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
                
                Button(action: {}) {
                    HStack(spacing: 8) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 14, weight: .medium))
                        Text("Try it")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 44)
                    .padding(.vertical, 12)
                }
                .glassEffect(.regular.interactive())
                .padding(.top, 4)
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Quick prompts — separate chips, NO GlassEffectContainer
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    QuickPromptChip(icon: "dumbbell.fill", title: "Design", subtitle: "a workout routine") { messageText = "Design a workout routine" }
                    QuickPromptChip(icon: "lightbulb.fill", title: "Explain", subtitle: "a complex topic simply") { messageText = "Explain a complex topic simply" }
                    QuickPromptChip(icon: "camera.fill", title: "Master", subtitle: "smartphone photography") { messageText = "Master smartphone photography" }
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 12)
        }
    }
    
    // MARK: - Messages List
    private var messagesListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(messages) { message in
                    ChatBubble(message: message, namespace: glassNamespace)
                }
                if isLoading {
                    HStack { TypingIndicator(); Spacer() }
                        .padding(.horizontal, 16)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
    
    // MARK: - Bottom Input — NO GlassEffectContainer, separate elements
    private var bottomInputArea: some View {
        HStack(spacing: 10) {
            // Plus button
            Button(action: { withAnimation(.spring()) { showAttachMenu.toggle() } }) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 42, height: 42)
            }
            .glassEffect(.regular.interactive())
            
            // Text field
            TextField("Ask anything", text: $messageText)
                .foregroundColor(.white)
                .font(.system(size: 16))
                .padding(.horizontal, 16)
                .padding(.vertical, 11)
                .glassEffect(.regular)
            
            // Send button
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(messageText.isEmpty ? .white.opacity(0.25) : .white.opacity(0.9))
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .padding(.bottom, 8)
    }
    
    // MARK: - Attach Menu — simple VStack, NO GlassEffectContainer
    private var attachMenuOverlay: some View {
        ZStack(alignment: .bottomLeading) {
            Color.clear.contentShape(Rectangle())
                .onTapGesture { withAnimation(.spring()) { showAttachMenu = false } }
            
            VStack(alignment: .leading, spacing: 0) {
                AttachMenuItem(icon: "doc.fill", title: "Attach file", subtitle: nil) { withAnimation { showAttachMenu = false } }
                AttachMenuItem(icon: "camera.fill", title: "Take photo", subtitle: "Vision support required") { withAnimation { showAttachMenu = false } }
                AttachMenuItem(icon: "photo.fill", title: "Attach photo", subtitle: "Vision support required") { withAnimation { showAttachMenu = false } }
            }
            .glassEffect(.regular)
            .padding(.leading, 14)
            .padding(.bottom, 80)
            .frame(width: 260)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .bottomLeading)))
    }
    
    // MARK: - Send
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        messages.append(ChatMessage(content: messageText, isUser: true, timestamp: Date()))
        let prompt = messageText
        messageText = ""
        isLoading = true
        
        Task {
            do {
                let response = try await AIService.shared.sendMessage(
                    provider: appState.selectedProvider, message: prompt,
                    apiKey: appState.apiKeys[appState.selectedProvider],
                    model: appState.selectedProvider.defaultModel,
                    systemPrompt: appState.personalizationEnabled ? appState.customInstructions : nil,
                    ollamaURL: appState.ollamaURL
                )
                await MainActor.run {
                    withAnimation { messages.append(ChatMessage(content: response, isUser: false, timestamp: Date())) }
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    withAnimation { messages.append(ChatMessage(content: "Error: \(error.localizedDescription)", isUser: false, timestamp: Date())) }
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Quick Prompt Chip
struct QuickPromptChip: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Image(systemName: icon)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                    Text(title).font(.system(size: 14, weight: .bold)).foregroundColor(.white)
                }
                Text(subtitle).font(.system(size: 13)).foregroundColor(.white.opacity(0.4))
            }
            .padding(.horizontal, 16).padding(.vertical, 14)
        }
        .glassEffect(.regular.interactive())
    }
}

// MARK: - Chat Bubble
struct ChatBubble: View {
    let message: ChatMessage
    var namespace: Namespace.ID
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            HStack(spacing: 8) {
                if !message.isUser {
                    Image(systemName: "sparkles")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
                Text(message.content)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 14).padding(.vertical, 10)
            .glassEffect(message.isUser ? .regular.interactive() : .clear.interactive())
            .frame(maxWidth: 280, alignment: message.isUser ? .trailing : .leading)
            if !message.isUser { Spacer() }
        }
    }
}

// MARK: - Attach Menu Item
struct AttachMenuItem: View {
    let icon: String
    let title: String
    let subtitle: String?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .frame(width: 28)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.system(size: 16, weight: .medium)).foregroundColor(.white)
                    if let subtitle { Text(subtitle).font(.system(size: 12)).foregroundColor(.white.opacity(0.35)) }
                }
                Spacer()
            }
            .padding(.horizontal, 16).padding(.vertical, 14)
        }
    }
}

// MARK: - Typing Indicator
struct TypingIndicator: View {
    @State private var animating = false
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "ellipsis")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
        }
        .padding(.horizontal, 16).padding(.vertical, 12)
        .glassEffect(.clear)
        .onAppear { animating = true }
    }
}
