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
            LinearGradient(
                colors: [Color(hex: "#3B1FA3"), Color(hex: "#1A0A5E"), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                chatNavBar
                
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
    
    private var chatNavBar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 8) {
                Button(action: { showSettingsSheet = true }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Button(action: { showConversationsList = true }) {
                    Image(systemName: "bubble.left.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(Color(hex: "#3B2F9E").opacity(0.8))
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
            )
            
            Button(action: { showProviderPicker = true }) {
                HStack(spacing: 4) {
                    Text(appState.selectedProvider.rawValue)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    Text("1B")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.white.opacity(0.5))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            
            Spacer()
            
            Button(action: { messages = [] }) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#3B2F9E").opacity(0.8))
                        .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
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
    
    private var emptyStateView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 16) {
                Text("Use models from your computer")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Link to LM Studio and run larger models remotely from your computer. End-to-end encrypted.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Button(action: {}) {
                    Text("Try it")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.08))
                                .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
                        )
                }
                .padding(.top, 8)
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
                .foregroundColor(.white.opacity(0.4))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.06))
                .overlay(Capsule().stroke(Color.white.opacity(0.1), lineWidth: 1))
        )
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
            Divider().background(Color.white.opacity(0.08))
            
            HStack(spacing: 12) {
                Button(action: { withAnimation(.spring()) { showAttachMenu.toggle() } }) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.08))
                            .overlay(Circle().stroke(Color.white.opacity(0.12), lineWidth: 1))
                            .frame(width: 38, height: 38)
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
                            .fill(Color.white.opacity(0.07))
                            .overlay(Capsule().stroke(Color.white.opacity(0.1), lineWidth: 1))
                    )
                
                Button(action: sendMessage) {
                    ZStack {
                        Circle()
                            .fill(messageText.isEmpty ? Color.white.opacity(0.15) : Color.white)
                            .frame(width: 38, height: 38)
                        Image(systemName: "arrow.up")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(messageText.isEmpty ? .white.opacity(0.4) : .black)
                    }
                }
                .disabled(messageText.isEmpty)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .padding(.bottom, 8)
        }
        .background(Color.black.opacity(0.6))
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
                Divider().background(Color.white.opacity(0.08))
                AttachMenuItem(icon: "camera.fill", title: "Take photo", subtitle: "Vision support required") {
                    showAttachMenu = false
                }
                Divider().background(Color.white.opacity(0.08))
                AttachMenuItem(icon: "photo.fill", title: "Attach photo", subtitle: "Vision support required") {
                    showAttachMenu = false
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "#1C1C2E").opacity(0.95))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
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
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
}

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.content)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(message.isUser ? Color(hex: "#2D2D3F") : Color.white.opacity(0.05))
                )
                .frame(maxWidth: 280, alignment: message.isUser ? .trailing : .leading)
            
            if !message.isUser {
                VStack(alignment: .leading, spacing: 8) {
                    Spacer()
                    HStack(spacing: 16) {
                        Image(systemName: "hand.thumbsup")
                        Image(systemName: "hand.thumbsdown")
                        Image(systemName: "arrow.clockwise")
                        Image(systemName: "doc.on.doc")
                        Image(systemName: "ellipsis")
                        Spacer()
                        Image(systemName: "speaker.wave.2")
                    }
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.4))
                }
                Spacer()
            }
        }
    }
}

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
                            .foregroundColor(.white.opacity(0.4))
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}