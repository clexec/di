import SwiftUI

struct ChatView: View {
    @EnvironmentObject var appState: AppState
    @State private var messageText: String = ""
    @State private var showAttachMenu: Bool = false
    @State private var showProviderPicker: Bool = false
    @State private var showSettingsSheet: Bool = false
    @State private var showConversationsList: Bool = false
    @State private var messages: [ChatMessage] = []
    
    var body: some View {
        ZStack {
            // Transparent — background handled by ContentView
            Color.clear
            
            VStack(spacing: 0) {
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
        .sheet(isPresented: $showSettingsSheet) {
            SettingsSheetView()
        }
        .sheet(isPresented: $showConversationsList) {
            ConversationsListView()
        }
        .sheet(isPresented: $showProviderPicker) {
            ProviderPickerView()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 20) {
                Text("Use models from your computer")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Link to LM Studio and run larger models remotely from your computer. End-to-end encrypted.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white.opacity(0.45))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
                
                Button(action: {}) {
                    Text("Try it")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 44)
                        .padding(.vertical, 14)
                        .liquidGlass(cornerRadius: 22, opacity: 0.1)
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            loadingIndicator
            
            quickPromptsRow
        }
    }
    
    private var loadingIndicator: some View {
        HStack(spacing: 6) {
            Text("Loading model...")
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.35))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .glassCapsule(opacity: 0.06)
        .padding(.bottom, 16)
    }
    
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
    
    private var messagesListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(messages) { message in
                    ChatBubble(message: message)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
    
    private var bottomInputArea: some View {
        VStack(spacing: 0) {
            Divider().background(Color.white.opacity(0.06))
            
            HStack(spacing: 12) {
                Button(action: { withAnimation(.spring()) { showAttachMenu.toggle() } }) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 38, height: 38)
                        .glassCapsule(opacity: 0.08)
                }
                
                TextField("Ask anything", text: $messageText)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 11)
                    .glassCapsule(opacity: 0.06)
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(messageText.isEmpty ? .white.opacity(0.35) : .black)
                        .frame(width: 38, height: 38)
                        .background(
                            Circle()
                                .fill(messageText.isEmpty ? Color.white.opacity(0.12) : Color.white)
                        )
                }
                .disabled(messageText.isEmpty)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .padding(.bottom, 8)
        }
        .background(Color.black.opacity(0.4))
    }
    
    private var attachMenuOverlay: some View {
        ZStack(alignment: .bottomLeading) {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture { withAnimation(.spring()) { showAttachMenu = false } }
            
            VStack(alignment: .leading, spacing: 0) {
                AttachMenuItem(icon: "folder.fill", title: "Attach file", subtitle: nil) {
                    showAttachMenu = false
                }
                Divider().background(Color.white.opacity(0.06))
                AttachMenuItem(icon: "camera.fill", title: "Take photo", subtitle: "Vision support required") {
                    showAttachMenu = false
                }
                Divider().background(Color.white.opacity(0.06))
                AttachMenuItem(icon: "photo.fill", title: "Attach photo", subtitle: "Vision support required") {
                    showAttachMenu = false
                }
            }
            .liquidGlass(cornerRadius: 16, opacity: 0.1)
            .padding(.leading, 14)
            .padding(.bottom, 80)
            .frame(width: 260)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .bottomLeading)))
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        let userMsg = ChatMessage(content: messageText, isUser: true, timestamp: Date())
        messages.append(userMsg)
        messageText = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let aiMsg = ChatMessage(content: "This is a response from \(appState.selectedProvider.rawValue).", isUser: false, timestamp: Date())
            messages.append(aiMsg)
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
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .liquidGlass(cornerRadius: 16, opacity: 0.08)
        }
    }
}

// MARK: - Chat Bubble (Liquid Glass style)
struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            if message.isUser {
                // User bubble — dark glass
                Text(message.content)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(.ultraThinMaterial)
                            .opacity(0.5)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.white.opacity(0.08))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                    )
                    .frame(maxWidth: 280, alignment: .trailing)
            } else {
                // AI bubble — purple glass
                VStack(alignment: .leading, spacing: 10) {
                    Text(message.content)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(.ultraThinMaterial)
                                .opacity(0.4)
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color(hex: "#5A4FCF").opacity(0.25))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.15), Color.white.opacity(0.03)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 0.5
                                )
                        )
                    
                    // Action icons under AI message
                    HStack(spacing: 18) {
                        Image(systemName: "hand.thumbsup")
                        Image(systemName: "hand.thumbsdown")
                        Image(systemName: "arrow.clockwise")
                        Image(systemName: "doc.on.doc")
                        Image(systemName: "ellipsis")
                        Spacer()
                        Image(systemName: "speaker.wave.2")
                    }
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.leading, 4)
                }
                .frame(maxWidth: 300, alignment: .leading)
                
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
