import SwiftUI

struct ConversationsListView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    // Liquid Glass
    @Namespace private var convNamespace
    @State private var isMerged: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header — glass buttons
                HStack {
                    Button(action: { withAnimation { dismiss() } }) {
                        Image(systemName: "xmark").font(.system(size: 14, weight: .bold)).foregroundColor(.white).padding(10)
                    }
                    .glassEffect(.regular.interactive())
                    .glassEffectID(convNamespace, in: "closeConv")
                    
                    Spacer()
                    
                    Text("Conversations").font(.system(size: 20, weight: .medium)).foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { withAnimation { dismiss() } }) {
                        Text("Done").font(.system(size: 15, weight: .semibold)).foregroundColor(.blue)
                    }
                    .glassEffect(.clear.interactive().tint(.blue))
                }
                .padding(.horizontal, 16).padding(.vertical, 12)
                
                if appState.conversations.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "bubble.left.and.bubble.right").font(.system(size: 40)).foregroundColor(.white.opacity(0.12))
                        Text("No conversations yet").font(.system(size: 16)).foregroundColor(.white.opacity(0.25))
                    }
                    .glassEffect(.clear).padding(32)
                    Spacer()
                } else {
                    // List — GlassEffectContainer for merge
                    GlassEffectContainer(spacing: 30) {
                        List {
                            ForEach(appState.conversations) { conversation in
                                Button(action: { withAnimation { appState.currentConversation = conversation; dismiss() } }) {
                                    HStack(spacing: 12) {
                                        ZStack { RoundedRectangle(cornerRadius: 8).fill(conversation.provider.color.opacity(0.2)).frame(width: 36, height: 36); Image(systemName: conversation.provider.icon).font(.system(size: 14, weight: .medium)).foregroundColor(conversation.provider.color) }
                                        VStack(alignment: .leading, spacing: 3) { Text(conversation.title).font(.system(size: 15, weight: .medium)).foregroundColor(.white); Text("\(conversation.messages.count) messages").font(.system(size: 13)).foregroundColor(.white.opacity(0.3)) }
                                        Spacer()
                                        Image(systemName: "chevron.right").font(.system(size: 12, weight: .semibold)).foregroundColor(.white.opacity(0.15))
                                    }
                                    .padding(.vertical, 4)
                                }
                                .listRowBackground(Color.clear)
                                .glassEffect(.clear.interactive())
                                .glassEffectID(convNamespace, in: conversation.id.uuidString)
                            }
                        }
                        .listStyle(.plain).scrollContentBackground(.hidden)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
