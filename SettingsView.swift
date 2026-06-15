import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var apiKey: String = ""
    @State private var showPersonalization: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header — NO navigation bar
                HStack {
                    Button(action: { dismiss() }) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#374151"))
                                .frame(width: 40, height: 40)
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                    
                    Text("Settings")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 40, height: 40)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                ScrollView {
                    VStack(spacing: 12) {
                        // APP section
                        VStack(alignment: .leading, spacing: 6) {
                            Text("APP")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(hex: "#9CA3AF"))
                                .padding(.leading, 4)
                            
                            VStack(spacing: 0) {
                                SettingsRow(icon: "cube.fill", iconColor: Color(hex: "#8B5CF6"), title: "Manage models", subtitle: nil) {}
                                Divider().background(Color.white.opacity(0.04)).padding(.leading, 54)
                                SettingsRow(icon: "link", iconColor: Color(hex: "#10B981"), title: "LM Link", subtitle: nil, badge: "New") {}
                                Divider().background(Color.white.opacity(0.04)).padding(.leading, 54)
                                SettingsRow(icon: "person.fill", iconColor: Color(hex: "#8B5CF6"), title: "Personalization", subtitle: nil) {
                                    showPersonalization = true
                                }
                                Divider().background(Color.white.opacity(0.04)).padding(.leading, 54)
                                SettingsRow(icon: "keyboard", iconColor: Color(hex: "#6B7280"), title: "Show keyboard on launch", subtitle: nil) {
                                    appState.showKeyboardOnLaunch.toggle()
                                }
                                Divider().background(Color.white.opacity(0.04)).padding(.leading, 54)
                                SettingsRow(icon: "trash.fill", iconColor: Color(hex: "#DC2626"), title: "Delete conversation history", titleColor: Color(hex: "#DC2626"), subtitle: nil) {}
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "#1F2937"))
                            )
                        }
                        
                        // ABOUT section
                        VStack(alignment: .leading, spacing: 6) {
                            Text("ABOUT")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(hex: "#9CA3AF"))
                                .padding(.leading, 4)
                            
                            VStack(spacing: 0) {
                                SettingsRow(icon: "doc.text.fill", iconColor: Color(hex: "#6B7280"), title: "Terms & Conditions", subtitle: nil) {}
                                Divider().background(Color.white.opacity(0.04)).padding(.leading, 54)
                                SettingsRow(icon: "lock.fill", iconColor: Color(hex: "#6B7280"), title: "Privacy Policy", subtitle: nil) {}
                                Divider().background(Color.white.opacity(0.04)).padding(.leading, 54)
                                SettingsRow(icon: "doc.fill", iconColor: Color(hex: "#6B7280"), title: "Licenses", subtitle: nil) {}
                                Divider().background(Color.white.opacity(0.04)).padding(.leading, 54)
                                SettingsRow(icon: "info.circle.fill", iconColor: Color(hex: "#6B7280"), title: "Version 1.57.0", subtitle: nil) {}
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "#1F2937"))
                            )
                        }
                        
                        // MORE section
                        VStack(alignment: .leading, spacing: 6) {
                            Text("MORE")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(hex: "#9CA3AF"))
                                .padding(.leading, 4)
                            
                            VStack(spacing: 0) {
                                SettingsRow(icon: "paperplane.fill", iconColor: Color(hex: "#F59E0B"), title: "Share the app", subtitle: nil) {}
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "#1F2937"))
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
        }
        .preferredColorScheme(.dark)
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
    var iconColor: Color = Color(hex: "#6B7280")
    let title: String
    var titleColor: Color = .white
    let subtitle: String?
    var badge: String? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 30, height: 30)
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(title)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(titleColor)
                        if let badge {
                            Text(badge)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule()
                                        .fill(badge == "New" ? Color(hex: "#10B981") : Color(hex: "#F59E0B"))
                                )
                        }
                    }
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
