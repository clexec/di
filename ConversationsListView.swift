import SwiftUI

struct ConversationsListView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#0F0F1A").ignoresSafeArea()
                
                if appState.conversations.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.15))
                        Text("No conversations yet")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.3))
                    }
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
                                            .foregroundColor(.white.opacity(0.35))
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.2))
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
            .navigationTitle("Conversations")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(Color(hex: "#6366F1"))
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
