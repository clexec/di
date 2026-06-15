import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Swipeable content using page-style TabView
            TabView(selection: $selectedTab) {
                ChatView()
                    .tag(0)
                ConversationsListView()
                    .tag(1)
                SettingsView()
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Custom glass tab bar
            HStack(spacing: 0) {
                tabButton(icon: "bubble.left.fill", title: "Chat", tag: 0)
                tabButton(icon: "clock.arrow.circlepath", title: "Chats", tag: 1)
                tabButton(icon: "gearshape.fill", title: "Settings", tag: 2)
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 10)
            .glassEffect(.regular)
            .padding(.horizontal, 16)
            .padding(.bottom, 2)
        }
    }
    
    private func tabButton(icon: String, title: String, tag: Int) -> some View {
        Button(action: { withAnimation(.easeInOut(duration: 0.2)) { selectedTab = tag } }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: selectedTab == tag ? .semibold : .regular))
                Text(title)
                    .font(.system(size: 10, weight: selectedTab == tag ? .medium : .regular))
            }
            .foregroundColor(selectedTab == tag ? .white : .white.opacity(0.4))
            .frame(maxWidth: .infinity)
        }
    }
}
