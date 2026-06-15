import SwiftUI

struct ConversationsListView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Deep background
            Color(red: 0.05, green: 0.05, blue: 0.08)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Chats")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { withAnimation { dismiss() } }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(Color.white.opacity(0.5))
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.08))
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 16)
                
                if appState.conversations.isEmpty {
                    Spacer()
                    
                    VStack(spacing: 14) {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .font(.system(size: 44, weight: .light))
                            .foregroundColor(.white.opacity(0.08))
                        
                        Text("No conversations yet")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.2))
                    }
                    .padding(40)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.03))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.05), lineWidth: 0.5)
                    )
                    
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(appState.conversations) { conversation in
                                ConversationRow(conversation: conversation) {
                                    withAnimation { appState.currentConversation = conversation; dismiss() }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Conversation Row
struct ConversationRow: View {
    let conversation: Conversation
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ProviderIconView(provider: conversation.provider, size: 22)
                    .frame(width: 36, height: 36)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(conversation.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "message.fill")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white.opacity(0.15))
                        Text("\(conversation.messages.count) messages")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.25))
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.12))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.05))
        )
    }
}
