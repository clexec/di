import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var showPersonalization: Bool = false
    @Namespace private var glassNS
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(10)
                    }
                    .glassEffect(.regular.interactive())
                    
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
                    GlassEffectContainer(spacing: 40) {
                        VStack(spacing: 12) {
                            // APP section
                            VStack(alignment: .leading, spacing: 6) {
                                Text("APP")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(hex: "#9CA3AF"))
                                    .padding(.leading, 4)
                                
                                VStack(spacing: 0) {
                                    SettingsRow(icon: "cube.fill", iconColor: .purple, title: "Manage models", subtitle: nil) {}
                                    Divider().background(Color.white.opacity(0.04)).padding(.leading, 54)
                                    SettingsRow(icon: "link", iconColor: .green, title: "LM Link", subtitle: nil, badge: "New") {}
                                    Divider().background(Color.white.opacity(0.04)).padding(.leading, 54)
                                    SettingsRow(icon: "person.fill", iconColor: .purple, title: "Personalization", subtitle: nil) {
                                        showPersonalization = true
                                    }
                                    Divider().background(Color.white.opacity(0.04)).padding(.leading, 54)
                                    SettingsRow(icon: "keyboard", iconColor: .gray, title: "Show keyboard on launch", subtitle: nil) {
                                        appState.showKeyboardOnLaunch.toggle()
                                    }
                                    Divider().background(Color.white.opacity(0.04)).padding(.leading, 54)
                                    SettingsRow(icon: "trash.fill", iconColor: .red, title: "Delete conversation history", titleColor: .red, subtitle: nil) {}
                                }
                                .glassEffect(.regular)
                            }
                            
                            // ABOUT section
                            VStack(alignment: .leading, spacing: 6) {
                                Text("ABOUT")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(hex: "#9CA3AF"))
                                    .padding(.leading, 4)
                                
                                VStack(spacing: 0) {
                                    SettingsRow(icon: "doc.text.fill", iconColor: .gray, title: "Terms & Conditions", subtitle: nil) {}
                                    Divider().background(Color.white.opacity(0.04)).padding(.leading, 54)
                                    SettingsRow(icon: "lock.fill", iconColor: .gray, title: "Privacy Policy", subtitle: nil) {}
                                    Divider().background(Color.white.opacity(0.04)).padding(.leading, 54)
                                    SettingsRow(icon: "doc.fill", iconColor: .gray, title: "Licenses", subtitle: nil) {}
                                    Divider().background(Color.white.opacity(0.04)).padding(.leading, 54)
                                    SettingsRow(icon: "info.circle.fill", iconColor: .gray, title: "Version 1.57.0", subtitle: nil) {}
                                }
                                .glassEffect(.regular)
                            }
                            
                            // MORE section
                            VStack(alignment: .leading, spacing: 6) {
                                Text("MORE")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(hex: "#9CA3AF"))
                                    .padding(.leading, 4)
                                
                                VStack(spacing: 0) {
                                    SettingsRow(icon: "paperplane.fill", iconColor: .yellow, title: "Share the app", subtitle: nil) {}
                                }
                                .glassEffect(.regular)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showPersonalization) { PersonalizationView() }
    }
}

struct SettingsRow: View {
    let icon: String
    var iconColor: Color = .gray
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
                                .glassEffect(.regular.tint(badge == "New" ? .green : .yellow))
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
