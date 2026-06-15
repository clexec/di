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
    @State private var showProviderPicker: Bool = false
    
    var body: some View {
        ZStack {
            // Gradient background matching reference design
            GradientBackgroundView()
            
            // Subtle video overlay
            VideoBackgroundView(videoName: "bg_video")
                .ignoresSafeArea()
                .opacity(0.25)
            
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
        .sheet(isPresented: $showProviderPicker) { ProviderPickerView() }
    }
    
    // MARK: - Top Nav Bar
    private var topNavBar: some View {
        HStack(spacing: 8) {
            // Settings + Chats — glass capsule button group
            HStack(spacing: 4) {
                Button(action: { showSettings = true }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .glassCircle(size: 36)
                }
                
                Button(action: { showConversations = true }) {
                    ZStack {
                        Image(systemName: "bubble.left.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .glassCircle(size: 36)
                        
                        // Glow effect for active state
                        Circle()
                            .fill(Color.white.opacity(0.15))
                            .frame(width: 36, height: 36)
                            .blur(radius: 8)
                    }
                }
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .glassCapsule()
            
            // Model selector — glass capsule dropdown
            Button(action: { withAnimation(.spring(response: 0.3)) { showModelPicker.toggle() } }) {
                HStack(spacing: 4) {
                    Text(appState.selectedAIModel.displayName)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white.opacity(0.5))
                        .rotationEffect(.degrees(showModelPicker ? 180 : 0))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .glassCapsule()
            
            Spacer()
            
            // New chat button — glass circle
            Button(action: { withAnimation { messages = [] } }) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .glassCircle(size: 36)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 12)
    }
    
    // MARK: - Model Picker Popup
    private var modelPickerOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { withAnimation(.spring(response: 0.3)) { showModelPicker = false } }
            
            VStack(spacing: 0) {
                Text("Select model")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.4))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 14)
                    .padding(.top, 12)
                    .padding(.bottom, 6)
                
                VStack(spacing: 0) {
                    ForEach(AIModel.availableModels) { model in
                        Button(action: {
                            withAnimation(.spring(response: 0.3)) {
                                appState.selectedAIModel = model
                                appState.selectedModel = model.displayName
                                appState.selectedProvider = model.provider
                                showModelPicker = false
                            }
                        }) {
                            HStack(spacing: 8) {
                                if appState.selectedAIModel == model {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 14)
                                } else {
                                    Color.clear.frame(width: 14)
                                }
                                
                                Text(model.displayName)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                
                                if let sub = model.subtitle {
                                    Text(sub)
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(.white.opacity(0.3))
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 9)
                        }
                    }
                    
                    Divider()
                        .glassDivider(leadingInset: 14)
                        .padding(.horizontal, 14)
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) { showModelPicker = false }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "link")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white.opacity(0.4))
                                .frame(width: 14)
                            
                            VStack(alignment: .leading, spacing: 1) {
                                Text("LM Link")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                                Text("Login required")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.white.opacity(0.25))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white.opacity(0.15))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 9)
                    }
                }
                .padding(.bottom, 10)
            }
            .frame(width: 240)
            .glassPopup(cornerRadius: 14)
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 18) {
                // Sparkles icon with glow
                ZStack {
                    Image(systemName: "sparkles")
                        .font(.system(size: 48, weight: .light))
                        .foregroundColor(.white.opacity(0.12))
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 48, weight: .light))
                        .foregroundColor(.white)
                        .blur(radius: 12)
                        .glowEffect(color: .white, radius: 20, opacity: 0.12)
                }
                
                Text("Use models from your computer")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Link to LM Studio and run larger models remotely from your computer. End-to-end encrypted.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.4))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                // Try it button — glass capsule with gradient border
                Button(action: {}) {
                    HStack(spacing: 8) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Try it")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 12)
                }
                .glassCapsule()
                .glowEffect(color: Color(red: 0.5, green: 0.3, blue: 0.9), radius: 16, opacity: 0.2)
                .padding(.top, 4)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 28)
            .glassCard(cornerRadius: 24)
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Loading status badge
            if isLoading {
                HStack(spacing: 6) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white.opacity(0.4)))
                        .scaleEffect(0.7)
                    Text("Loading model...")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.4))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .glassCapsule()
                .padding(.bottom, 8)
            }
            
            // Quick prompts — glass chips
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
                    ChatBubble(message: message)
                }
                if isLoading {
                    HStack(alignment: .top) { 
                        TypingIndicator()
                        Spacer() 
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
    
    // MARK: - Bottom Input Area — full glass
    private var bottomInputArea: some View {
        HStack(spacing: 10) {
            // Plus button — glass
            Button(action: { withAnimation(.spring()) { showAttachMenu.toggle() } }) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .glassCircle(size: 40)
            }
            
            // Text field — glass input
            TextField("Ask anything", text: $messageText)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .glassInput(cornerRadius: 16)
            
            // Send button — glass with active state
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(messageText.isEmpty ? .white.opacity(0.2) : .white.opacity(0.8))
                    .frame(width: 40, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                messageText.isEmpty
                                    ? Color.white.opacity(0.06)
                                    : LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.25),
                                            Color.white.opacity(0.08)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                lineWidth: messageText.isEmpty ? 0.5 : 0.8
                            )
                    )
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .scaleEffect(messageText.isEmpty ? 1.0 : 1.0)
            }
            .disabled(messageText.isEmpty)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .padding(.bottom, 8)
    }
    
    // MARK: - Attach Menu — glass popup
    private var attachMenuOverlay: some View {
        ZStack(alignment: .bottomLeading) {
            Color.clear.contentShape(Rectangle())
                .onTapGesture { withAnimation(.spring()) { showAttachMenu = false } }
            
            VStack(alignment: .leading, spacing: 0) {
                AttachMenuItem(icon: "doc.fill", title: "Attach file", subtitle: nil) { withAnimation { showAttachMenu = false } }
                Divider().glassDivider().padding(.horizontal, 14)
                AttachMenuItem(icon: "camera.fill", title: "Take photo", subtitle: "Vision support required") { withAnimation { showAttachMenu = false } }
                Divider().glassDivider().padding(.horizontal, 14)
                AttachMenuItem(icon: "photo.fill", title: "Attach photo", subtitle: "Vision support required") { withAnimation { showAttachMenu = false } }
            }
            .glassPopup(cornerRadius: 14)
            .padding(.leading, 14)
            .padding(.bottom, 80)
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
                let modelProvider = appState.selectedAIModel.provider
                let response = try await AIService.shared.sendMessage(
                    provider: modelProvider, message: prompt,
                    apiKey: appState.apiKeys[modelProvider],
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

// MARK: - Quick Prompt Chip — glass chip
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
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.5))
                    Text(title).font(.system(size: 14, weight: .bold)).foregroundColor(.white)
                }
                Text(subtitle).font(.system(size: 13, weight: .medium)).foregroundColor(.white.opacity(0.35))
            }
            .padding(.horizontal, 16).padding(.vertical, 12)
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 4)
        .glassEffect(cornerRadius: 12)
    }
}

// MARK: - Chat Bubble — glass style
struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 8) {
                HStack(spacing: 8) {
                    if !message.isUser {
                        Image(systemName: "sparkles")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.4))
                    }
                    Text(message.content)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
                
                // Action buttons for AI messages — glass icon buttons
                if !message.isUser {
                    HStack(spacing: 16) {
                        Button(action: {}) {
                            Image(systemName: "hand.thumbsup")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.3))
                                .padding(6)
                                .background(Circle().fill(.ultraThinMaterial))
                        }
                        Button(action: {}) {
                            Image(systemName: "hand.thumbsdown")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.3))
                                .padding(6)
                                .background(Circle().fill(.ultraThinMaterial))
                        }
                        Button(action: {}) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.3))
                                .padding(6)
                                .background(Circle().fill(.ultraThinMaterial))
                        }
                        Button(action: {}) {
                            Image(systemName: "doc.on.doc")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.3))
                                .padding(6)
                                .background(Circle().fill(.ultraThinMaterial))
                        }
                        Button(action: {}) {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.3))
                                .padding(6)
                                .background(Circle().fill(.ultraThinMaterial))
                        }
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "speaker.wave.2")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.3))
                                .padding(6)
                                .background(Circle().fill(.ultraThinMaterial))
                        }
                    }
                    .padding(.top, 4)
                }
            }
            .padding(.horizontal, 14).padding(.vertical, 10)
            .background(
                message.isUser ?
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.2),
                                        Color.white.opacity(0.06)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.7
                            )
                    )
                    .innerGlow(cornerRadius: 16) :
                Color.clear
            )
            
            if !message.isUser { Spacer() }
        }
        .contextMenu {
            Button(action: { UIPasteboard.general.string = message.content }) {
                Label("Copy", systemImage: "doc.on.doc")
            }
            if !message.isUser {
                Button(action: {}) {
                    Label("Repeat request", systemImage: "arrow.clockwise")
                }
            }
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
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
                    .frame(width: 28)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
                    if let subtitle { Text(subtitle).font(.system(size: 12, weight: .medium)).foregroundColor(.white.opacity(0.3)) }
                }
                Spacer()
            }
            .padding(.horizontal, 16).padding(.vertical, 14)
        }
    }
}

// MARK: - Typing Indicator — glass
struct TypingIndicator: View {
    @State private var animating = false
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(Color.white.opacity(0.4))
                .frame(width: 6, height: 6)
            Circle()
                .fill(Color.white.opacity(0.4))
                .frame(width: 6, height: 6)
            Circle()
                .fill(Color.white.opacity(0.4))
                .frame(width: 6, height: 6)
        }
        .padding(.horizontal, 16).padding(.vertical, 12)
        .glassEffect(cornerRadius: 12)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).repeatForever()) {
                animating = true
            }
        }
    }
}
