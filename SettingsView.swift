import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var apiKey: String = ""
    @State private var showPersonalization: Bool = false
    
    var body: some View {
        ZStack {
            Color(hex: "#0F0F1A").ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("API KEY")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.4))
                            .padding(.leading, 4)
                        
                        HStack(spacing: 8) {
                            SecureField("Enter API Key", text: $apiKey)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.07))
                                )
                            
                            Button(action: {
                                appState.apiKeys[appState.selectedProvider] = apiKey
                            }) {
                                Text("Save")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(hex: "#6366F1"))
                                    )
                            }
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.05))
                    )
                    
                    VStack(spacing: 0) {
                        SettingsRow(icon: "person.fill", title: "Personalization", subtitle: "Custom instructions & temperature") {
                            showPersonalization = true
                        }
                        Divider().background(Color.white.opacity(0.06))
                        SettingsRow(icon: "externaldrive.fill", title: "Custom API URL", subtitle: appState.customAPIURL.isEmpty ? "Not set" : appState.customAPIURL) {
                            // TODO: Custom URL input
                        }
                        Divider().background(Color.white.opacity(0.06))
                        SettingsRow(icon: "keyboard", title: "Show Keyboard on Launch", subtitle: nil) {
                            appState.showKeyboardOnLaunch.toggle()
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.05))
                    )
                    
                    VStack(spacing: 0) {
                        SettingsRow(icon: "questionmark.circle.fill", title: "Help & FAQ", subtitle: nil) {}
                        Divider().background(Color.white.opacity(0.06))
                        SettingsRow(icon: "star.fill", title: "Rate DeAI", subtitle: nil) {}
                        Divider().background(Color.white.opacity(0.06))
                        SettingsRow(icon: "info.circle.fill", title: "About", subtitle: "Version 1.0.0") {}
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.05))
                    )
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
        }
        .sheet(isPresented: $showPersonalization) {
            PersonalizationView()
        }
        .onAppear {
            apiKey = appState.apiKeys[appState.selectedProvider] ?? ""
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: "#6366F1").opacity(0.15))
                        .frame(width: 34, height: 34)
                    Image(systemName: icon)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(hex: "#6366F1"))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.35))
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.2))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}
