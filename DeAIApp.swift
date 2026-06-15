import SwiftUI

@main
struct DeAIApp: App {
    @StateObject private var appState = AppState()
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(appState)
                .preferredColorScheme(.dark)
        }
    }
}
