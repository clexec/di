import SwiftUI

struct ConversationsListView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with close button
                HStack {
                    Button(action: { withAnimation { dismiss() } }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                            .frame(width: 32, height: 32)
                    }
                    .glassEffect(.regular.interactive())
                    
                    Spacer()
                    
                    Text("Conversations")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 32, height: 32)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
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
                            Button(action: { withAnimation { appState.currentConversation = conversation; dismiss() } }) {
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
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
