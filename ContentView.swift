import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(hex: "#6A5ACD"), Color(hex: "#2D1B69"), Color(hex: "#1A1A2E")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Liquid Glass Tab Bar at top
                liquidGlassTabBar
                
                // Content
                TabView(selection: $selectedTab) {
                    ChatView()
                        .tag(0)
                    
                    BrowserView()
                        .tag(1)
                    
                    SettingsView()
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
        .onChange(of: selectedTab) { _, newValue in
            appState.selectedTab = newValue
        }
    }
    
    private var liquidGlassTabBar: some View {
        HStack(spacing: 6) {
            // Settings button
            Button(action: { withAnimation(.spring(response: 0.3)) { selectedTab = 2 } }) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(selectedTab == 2 ? .white : .white.opacity(0.5))
                    .frame(width: 36, height: 36)
                    .background(
                        selectedTab == 2
                            ? RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.2))
                            : nil
                    )
            }
            
            // Conversations button
            Button(action: { /* TODO: show conversations */ }) {
                Image(systemName: "bubble.left.fill")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
                    .frame(width: 36, height: 36)
            }
            
            // Provider selector
            Button(action: { /* TODO: show provider picker */ }) {
                HStack(spacing: 4) {
                    Text(appState.selectedProvider.rawValue)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    Text("1B")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.4))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white.opacity(0.4))
                }
            }
            
            Spacer()
            
            // Chat tab
            Button(action: { withAnimation(.spring(response: 0.3)) { selectedTab = 0 } }) {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(selectedTab == 0 ? .white : .white.opacity(0.5))
                    .frame(width: 36, height: 36)
                    .background(
                        selectedTab == 0
                            ? RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.2))
                            : nil
                    )
            }
            
            // New chat
            Button(action: { /* TODO: new chat */ }) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .opacity(0.6)
        )
        .background(
            Capsule()
                .fill(Color.white.opacity(0.08))
        )
        .overlay(
            Capsule()
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.2), Color.white.opacity(0.03)],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 0.5
                )
        )
        .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 4)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}
