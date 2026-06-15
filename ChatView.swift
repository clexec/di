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
    // Liquid Glass variables
    @Namespace private var glassNamespace
    @State private var isMerged: Bool = false
    @State private var isInputExpanded: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "#4C1D95"), Color(hex: "#1F1F2E"), Color.black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
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
    
    // MARK: - Top Nav Bar — Liquid Glass container with morphing IDs
    private var topNavBar: some View {
        GlassEffectContainer(spacing: 40) {
            HStack(spacing: 10) {
                // Settings + Chat buttons — glass capsule that merges
                HStack(spacing: 8) {
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .glassEffectID("navLeft", in: glassNamespace)
                    
                    Button(action: { showConversations = true }) {
                        Image(systemName: "bubble.left.fill")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .glassEffectID("navRight", in: glassNamespace)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .glassEffect(.regular.interactive().tint(.purple))
                .glassEffectUnion(id: "navLeft", in: glassNamespace)
                .glassEffectUnion(id: "navRight", in: glassNamespace)
                
                // Model selector button
                Button(action: { withAnimation { showProviderPicker = true } }) {
                    HStack(spacing: 4) {
                        Text(appState.selectedModel)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white.opacity(0.4))
                    }
                }
                .glassEffect(.clear.interactive())
                
                Spacer()
                
                // New chat — glass with purple tint
                Button(action: { withAnimation { messages = [] } }) {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                        .padding(10)
                }
                .glassEffect(.regular.interactive().tint(.purple))
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 12)
        }
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
                
                // Try it button — regular glass + purple tint + interactive
                Button(action: {}) {
                    Text("Try it")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 44)
                        .padding(.vertical, 12)
                }
                .glassEffect(.regular.interactive().tint(.purple))
                .padding(.top, 4)
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Quick prompts — GlassEffectContainer for merge animation
            GlassEffectContainer(spacing: 20) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        QuickPromptChip(title: "Design", subtitle: "a workout routine") { messageText = "Design a workout routine" }
                        QuickPromptChip(title: "Explain", subtitle: "a complex topic simply") { messageText = "Explain a complex topic simply" }
                        QuickPromptChip(title: "Master", subtitle: "smartphone photography") { messageText = "Master smartphone photography" }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 12)
            }
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
    
    // MARK: - Bottom Input — Liquid Glass container for merge
    private var bottomInputArea: some View {
        GlassEffectContainer(spacing: 0) {
            HStack(spacing: 12) {
                // Plus button — interactive glass with red tint
                Button(action: { withAnimation(.spring()) { showAttachMenu.toggle() } }) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(10)
                }
                .glassEffect(.regular.interactive().tint(.red))
                .glassEffectID("attachBtn", in: glassNamespace)
                
                // Text field — regular glass
                TextField("Ask anything", text: $messageText)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 11)
                    .glassEffect(.regular)
                    .glassEffectID("inputField", in: glassNamespace)
                
                // Send button — interactive glass with blue tint
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(messageText.isEmpty ? .white.opacity(0.35) : .white)
                        .padding(10)
                }
                .glassEffect(.regular.interactive().tint(.blue))
                .glassEffectID("sendBtn", in: glassNamespace)
                // Merge attach + input + send into one glass when typing
                .glassEffectUnion(id: "attachBtn", in: glassNamespace)
                .glassEffectUnion(id: "inputField", in: glassNamespace)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .padding(.bottom, 8)
        }
    }
    
    // MARK: - Attach Menu — glass container
    private var attachMenuOverlay: some View {
        ZStack(alignment: .bottomLeading) {
            Color.clear.contentShape(Rectangle())
                .onTapGesture { withAnimation(.spring()) { showAttachMenu = false } }
            
            GlassEffectContainer(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    AttachMenuItem(icon: "folder.fill", title: "Attach file", subtitle: nil) { withAnimation { showAttachMenu = false } }
                    AttachMenuItem(icon: "camera.fill", title: "Take photo", subtitle: "Vision support required") { withAnimation { showAttachMenu = false } }
                    AttachMenuItem(icon: "photo.fill", title: "Attach photo", subtitle: "Vision support required") { withAnimation { showAttachMenu = false } }
                }
                .glassEffect(.regular)
            }
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

// MARK: - Quick Prompt Chip — glass with purple tint + interactive
struct QuickPromptChip: View {
    let title: String; let subtitle: String; let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 14, weight: .bold)).foregroundColor(.white)
                Text(subtitle).font(.system(size: 13)).foregroundColor(Color(hex: "#9CA3AF"))
            }
            .padding(.horizontal, 16).padding(.vertical, 14)
        }
        .glassEffect(.regular.interactive().tint(.purple))
    }
}

// MARK: - Chat Bubble — glass effect with tint per role
struct ChatBubble: View {
    let message: ChatMessage
    var namespace: Namespace.ID
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            Text(message.content)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .padding(.horizontal, 14).padding(.vertical, 10)
                .glassEffect(message.isUser ? .regular.interactive().tint(.purple) : .clear.interactive().tint(.blue))
                .glassEffectID(message.id.uuidString, in: namespace)
                .frame(maxWidth: 280, alignment: message.isUser ? .trailing : .leading)
            if !message.isUser { Spacer() }
        }
    }
}

// MARK: - Attach Menu Item
struct AttachMenuItem: View {
    let icon: String; let title: String; let subtitle: String?; let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon).font(.system(size: 18, weight: .medium)).foregroundColor(.white).frame(width: 28)
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

// MARK: - Typing Indicator — clear glass
struct TypingIndicator: View {
    @State private var animating = false
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<3, id: \.self) { i in
                Circle().fill(Color.white.opacity(0.4)).frame(width: 8, height: 8)
                    .offset(y: animating ? -4 : 4)
                    .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(Double(i)*0.15), value: animating)
            }
        }
        .padding(.horizontal, 16).padding(.vertical, 12)
        .glassEffect(.clear)
        .onAppear { animating = true }
    }
}
