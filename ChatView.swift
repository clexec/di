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
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(hex: "#4C1D95"), Color(hex: "#1F1F2E"), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top nav bar — glass capsule
                topNavBar
                
                if messages.isEmpty {
                    emptyStateView
                } else {
                    messagesListView
                }
                
                bottomInputArea
            }
            
            if showAttachMenu {
                attachMenuOverlay
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showConversations) {
            ConversationsListView()
        }
        .sheet(isPresented: $showProviderPicker) {
            ProviderPickerView()
        }
    }
    
    // MARK: - Top Nav Bar (glass capsule)
    private var topNavBar: some View {
        HStack(spacing: 10) {
            // Settings + Conversations buttons in glass capsule
            HStack(spacing: 8) {
                Button(action: { showSettings = true }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Button(action: { showConversations = true }) {
                    Image(systemName: "bubble.left.fill")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(Color(hex: "#1F2937").opacity(0.9))
            )
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .opacity(0.4)
            )
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
            )
            
            // Model selector
            Button(action: { showProviderPicker = true }) {
                HStack(spacing: 4) {
                    Text(appState.selectedModel)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.4))
                }
            }
            
            Spacer()
            
            // New chat button
            Button(action: { messages = [] }) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#6D28D9"))
                        .frame(width: 40, height: 40)
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                }
            }
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
                Text("Use models from your computer")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Link to LM Studio and run larger models remotely from your computer. End-to-end encrypted.")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color(hex: "#9CA3AF"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
                
                Button(action: {}) {
                    Text("Try it")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 44)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex: "#312E81"))
                        )
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            quickPromptsRow
        }
    }
    
    // MARK: - Quick Prompts
    private var quickPromptsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                QuickPromptChip(title: "Design", subtitle: "a workout routine") {
                    messageText = "Design a workout routine"
                }
                QuickPromptChip(title: "Explain", subtitle: "a complex topic simply") {
                    messageText = "Explain a complex topic simply"
                }
                QuickPromptChip(title: "Master", subtitle: "smartphone photography") {
                    messageText = "Master smartphone photography"
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 12)
    }
    
    // MARK: - Messages List
    private var messagesListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(messages) { message in
                    ChatBubble(message: message)
                }
                
                if isLoading {
                    HStack {
                        TypingIndicator()
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
    
    // MARK: - Bottom Input
    private var bottomInputArea: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Button(action: { withAnimation(.spring()) { showAttachMenu.toggle() } }) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#374151"))
                            .frame(width: 40, height: 40)
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                
                TextField("Ask anything", text: $messageText)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 11)
                    .background(
                        Capsule()
                            .fill(Color(hex: "#1F2937").opacity(0.9))
                    )
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .opacity(0.3)
                    )
                
                Button(action: sendMessage) {
                    ZStack {
                        Circle()
                            .fill(messageText.isEmpty ? Color(hex: "#374151") : Color(hex: "#3B82F6"))
                            .frame(width: 40, height: 40)
                        Image(systemName: "arrow.up")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .disabled(messageText.isEmpty)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .padding(.bottom, 8)
        }
        .background(Color(hex: "#1F2937").opacity(0.95))
    }
    
    // MARK: - Attach Menu
    private var attachMenuOverlay: some View {
        ZStack(alignment: .bottomLeading) {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture { withAnimation(.spring()) { showAttachMenu = false } }
            
            VStack(alignment: .leading, spacing: 0) {
                AttachMenuItem(icon: "folder.fill", title: "Attach file", subtitle: nil) { showAttachMenu = false }
                Divider().background(Color.white.opacity(0.06))
                AttachMenuItem(icon: "camera.fill", title: "Take photo", subtitle: "Vision support required") { showAttachMenu = false }
                Divider().background(Color.white.opacity(0.06))
                AttachMenuItem(icon: "photo.fill", title: "Attach photo", subtitle: "Vision support required") { showAttachMenu = false }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "#1F2937").opacity(0.95))
            )
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .opacity(0.3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
            )
            .padding(.leading, 14)
            .padding(.bottom, 80)
            .frame(width: 260)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .bottomLeading)))
    }
    
    // MARK: - Send Message
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        let userMsg = ChatMessage(content: messageText, isUser: true, timestamp: Date())
        messages.append(userMsg)
        let prompt = messageText
        messageText = ""
        isLoading = true
        
        Task {
            do {
                let response = try await AIService.shared.sendMessage(
                    provider: appState.selectedProvider,
                    message: prompt,
                    apiKey: appState.apiKeys[appState.selectedProvider],
                    model: appState.selectedProvider.defaultModel,
                    systemPrompt: appState.personalizationEnabled ? appState.customInstructions : nil,
                    ollamaURL: appState.ollamaURL
                )
                await MainActor.run {
                    messages.append(ChatMessage(content: response, isUser: false, timestamp: Date()))
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    messages.append(ChatMessage(content: "Error: \(error.localizedDescription)", isUser: false, timestamp: Date()))
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Quick Prompt Chip
struct QuickPromptChip: View {
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#9CA3AF"))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "#1F2937").opacity(0.9))
            )
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .opacity(0.3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.06), lineWidth: 0.5)
            )
        }
    }
}

// MARK: - Chat Bubble
struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.content)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(message.isUser ? Color(hex: "#374151") : Color(hex: "#4B5563"))
                )
                .frame(maxWidth: 280, alignment: message.isUser ? .trailing : .leading)
            
            if !message.isUser {
                Spacer()
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
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 28)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.35))
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}

// MARK: - Typing Indicator
struct TypingIndicator: View {
    @State private var animating = false
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(0.4))
                    .frame(width: 8, height: 8)
                    .offset(y: animating ? -4 : 4)
                    .animation(
                        .easeInOut(duration: 0.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.15),
                        value: animating
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(hex: "#4B5563")))
        .onAppear { animating = true }
    }
}
