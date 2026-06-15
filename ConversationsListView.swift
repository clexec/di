import SwiftUI

struct ConversationsListView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with glassEffect
                HStack {
                    Text("Chats")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { withAnimation { dismiss() } }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                            .frame(width: 44, height: 44)
                    }
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 12))
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 16)
                
                if appState.conversations.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .font(.system(size: 44, weight: .light))
                            .foregroundColor(.white.opacity(0.12))
                        Text("No conversations yet")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white.opacity(0.25))
                    }
                    .padding(32)
                    .glassEffect(.regular, in: .rect(cornerRadius: 20))
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

// MARK: - Conversation Row with glassEffect
struct ConversationRow: View {
    let conversation: Conversation
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ProviderIconView(provider: conversation.provider, size: 22)
                    .frame(width: 36, height: 36)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(conversation.title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    HStack(spacing: 4) {
                        Image(systemName: "message.fill")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white.opacity(0.2))
                        Text("\(conversation.messages.count) messages")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.3))
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white.opacity(0.15))
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
        }
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 14))
    }
}
