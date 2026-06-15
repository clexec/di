import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var apiKey: String = ""
    @State private var showPersonalization: Bool = false
    
    var body: some View {
        ZStack {
            Color.clear
            
            ScrollView {
                VStack(spacing: 12) {
                    // API Key section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("APP")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.35))
                            .padding(.leading, 4)
                        
                        HStack(spacing: 8) {
                            SecureField("Enter API Key", text: $apiKey)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .liquidGlass(cornerRadius: 12, opacity: 0.07)
                            
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
                    .liquidGlass(cornerRadius: 16, opacity: 0.05)
                    
                    // Settings rows
                    VStack(spacing: 0) {
                        SettingsRow(icon: "person.fill", title: "Personalization", subtitle: "Custom instructions & temperature") {
                            showPersonalization = true
                        }
                        Divider().background(Color.white.opacity(0.04))
                        SettingsRow(icon: "externaldrive.fill", title: "Custom API URL", subtitle: appState.customAPIURL.isEmpty ? "Not set" : appState.customAPIURL) {}
                        Divider().background(Color.white.opacity(0.04))
                        SettingsRow(icon: "keyboard", title: "Show Keyboard on Launch", subtitle: nil) {
                            appState.showKeyboardOnLaunch.toggle()
                        }
                    }
                    .liquidGlass(cornerRadius: 16, opacity: 0.05)
                    
                    // About section
                    VStack(spacing: 0) {
                        SettingsRow(icon: "questionmark.circle.fill", title: "Help & FAQ", subtitle: nil) {}
                        Divider().background(Color.white.opacity(0.04))
                        SettingsRow(icon: "star.fill", title: "Rate DeAI", subtitle: nil) {}
                        Divider().background(Color.white.opacity(0.04))
                        SettingsRow(icon: "info.circle.fill", title: "About", subtitle: "Version 1.0.0") {}
                    }
                    .liquidGlass(cornerRadius: 16, opacity: 0.05)
                    
                    // Danger zone
                    VStack(spacing: 0) {
                        SettingsRow(icon: "trash.fill", title: "Delete conversation history", subtitle: nil) {}
                    }
                    .liquidGlass(cornerRadius: 16, opacity: 0.05)
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
                        .fill(Color(hex: "#6366F1").opacity(0.12))
                        .frame(width: 34, height: 34)
                    Image(systemName: icon)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(hex: "#6366F1"))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(title == "Delete conversation history" ? Color(hex: "#FF3B30") : .white)
                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.3))
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.15))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}
