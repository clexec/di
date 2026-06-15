import SwiftUI

struct ConversationsListView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header (no close button — it's a tab)
                HStack {
                    Text("Chats")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 8)
                
                if appState.conversations.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.12))
                        Text("No conversations yet")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.25))
                    }
                    .padding(32)
                    Spacer()
                } else {
                    List {
                        ForEach(appState.conversations) { conversation in
                            Button(action: { withAnimation { appState.currentConversation = conversation } }) {
                                HStack(spacing: 12) {
                                    ProviderIconView(provider: conversation.provider, size: 22)
                                        .frame(width: 36, height: 36)
                                    
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(conversation.title)
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.white)
                                        HStack(spacing: 4) {
                                            Image(systemName: "message.fill")
                                                .font(.system(size: 10))
                                                .foregroundColor(.white.opacity(0.2))
                                            Text("\(conversation.messages.count) messages")
                                                .font(.system(size: 13))
                                                .foregroundColor(.white.opacity(0.3))
                                        }
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.15))
                                }
                                .padding(.vertical, 4)
                            }
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .padding(.bottom, 80)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
