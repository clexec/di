import SwiftUI

struct ConversationsListView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#6A5ACD"), Color(hex: "#2D1B69"), Color(hex: "#1A1A2E")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom header — NO navigation bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white.opacity(0.6))
                            .frame(width: 32, height: 32)
                            .liquidGlass(cornerRadius: 16, opacity: 0.1)
                    }
                    
                    Spacer()
                    
                    Text("Conversations")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Text("Done")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(hex: "#6366F1"))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                if appState.conversations.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.12))
                        Text("No conversations yet")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.25))
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(appState.conversations) { conversation in
                            Button(action: {
                                appState.currentConversation = conversation
                                dismiss()
                            }) {
                                HStack(spacing: 12) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(conversation.provider.color.opacity(0.2))
                                            .frame(width: 36, height: 36)
                                        Image(systemName: conversation.provider.icon)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(conversation.provider.color)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(conversation.title)
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.white)
                                        Text("\(conversation.messages.count) messages")
                                            .font(.system(size: 13))
                                            .foregroundColor(.white.opacity(0.3))
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.15))
                                }
                                .padding(.vertical, 4)
                            }
                            .listRowBackground(Color.white.opacity(0.03))
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
