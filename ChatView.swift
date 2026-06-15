import SwiftUI

struct ChatView: View {
    @EnvironmentObject var appState: AppState
    @State private var messageText: String = ""
    @State private var showAttachMenu: Bool = false
    @State private var messages: [ChatMessage] = []
    @State private var isLoading: Bool = false
    @State private var showSettings: Bool = false
    @State private var showConversations: Bool = false
    @State private var showModelPicker: Bool = false
    @Namespace private var glassNamespace
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                topNavBar
                if messages.isEmpty { emptyStateView } else { messagesListView }
                bottomInputArea
            }
            
            // Model picker popup overlay
            if showModelPicker { modelPickerOverlay }
            
            if showAttachMenu { attachMenuOverlay }
        }
        .sheet(isPresented: $showSettings) { SettingsView() }
        .sheet(isPresented: $showConversations) { ConversationsListView() }
    }
    
    // MARK: - Top Nav Bar
    private var topNavBar: some View {
        HStack(spacing: 12) {
            // Settings button
            Button(action: { showSettings = true }) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
            }
            .glassEffect(.regular.interactive())
            
            // Chat list button
            Button(action: { showConversations = true }) {
                Image(systemName: "bubble.left.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
            }
            .glassEffect(.regular.interactive())
            
            // Model selector — tap to open popup
            Button(action: { withAnimation(.spring(response: 0.3)) { showModelPicker.toggle() } }) {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    Text(appState.selectedAIModel.displayName)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.5))
                        .rotationEffect(.degrees(showModelPicker ? 180 : 0))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
            }
            .glassEffect(.regular.interactive())
            
            Spacer()
            
            // New chat button
            Button(action: { withAnimation { messages = [] } }) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
            }
            .glassEffect(.regular.interactive())
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 12)
    }
    
    // MARK: - Model Picker Popup (overlay on chat, not a sheet)
    private var modelPickerOverlay: some View {
        ZStack {
            // Dim background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { withAnimation(.spring(response: 0.3)) { showModelPicker = false } }
            
            // Popup card
            VStack(spacing: 0) {
                // Header
                Text("Select model")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 18)
                    .padding(.bottom, 12)
                
                // Model list
                VStack(spacing: 0) {
                    ForEach(AIModel.availableModels) { model in
                        Button(action: {
                            withAnimation(.spring(response: 0.3)) {
                                appState.selectedAIModel = model
                                appState.selectedModel = model.displayName
                                showModelPicker = false
                            }
                        }) {
                            HStack(spacing: 12) {
                                // Checkmark
                                if appState.selectedAIModel == model {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                } else {
                                    Color.clear.frame(width: 16)
                                }
                                
                                Text(model.displayName)
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                        }
                    }
                    
                    // Divider
                    Divider().background(Color.white.opacity(0.08)).padding(.horizontal, 20)
                    
                    // LM Link row
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) { showModelPicker = false }
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "link")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.5))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("LM Link")
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundColor(.white)
                                Text("Login required")
                                    .font(.system(size: 13))
                                    .foregroundColor(.white.opacity(0.3))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.2))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                    }
                }
                .padding(.bottom, 16)
            }
            .frame(width: 320)
            .glassEffect(.regular)
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 20) {
                // App logo
                Image(systemName: "sparkles")
                    .font(.system(size: 44, weight: .light))
                    .foregroundColor(.white.opacity(0.15))
                
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
            
            // Quick prompts
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    QuickPromptChip(icon: "book.fill", title: "Discover", subtitle: "my next book") { messageText = "Discover my next book" }
                    QuickPromptChip(icon: "lightbulb.fill", title: "Tell me", subtitle: "something fascinating") { messageText = "Tell me something fascinating" }
                    QuickPromptChip(icon: "pencil.line", title: "Help me", subtitle: "write an email") { messageText = "Help me write an email" }
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
    
    // MARK: - Bottom Input
    private var bottomInputArea: some View {
        HStack(spacing: 10) {
            // Plus button
            Button(action: { withAnimation(.spring()) { showAttachMenu.toggle() } }) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
            }
            .glassEffect(.regular.interactive())
            
            // Text field
            TextField("Ask anything", text: $messageText)
                .foregroundColor(.white)
                .font(.system(size: 16))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
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
    
    // MARK: - Attach Menu
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
                    model: appState.selectedAIModel.modelId,
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
