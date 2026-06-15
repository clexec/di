import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var showPersonalization: Bool = false
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with close button
                HStack {
                    Button(action: { withAnimation { dismiss() } }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                            .frame(width: 32, height: 32)
                    }
                    .glassEffect(.regular.interactive())
                    
                    Spacer()
                    
                    Text("Settings")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 32, height: 32)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                // Sections — NO ovals
                ScrollView {
                    VStack(spacing: 16) {
                        // APP section
                        VStack(alignment: .leading, spacing: 6) {
                            Text("APP")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.4))
                                .padding(.leading, 4)
                            
                            VStack(spacing: 0) {
                                SettingsRow(icon: "cube.box.fill", title: "Manage models") {}
                                Divider().background(Color.white.opacity(0.04)).padding(.leading, 54)
                                SettingsRow(icon: "link.circle.fill", title: "LM Link", badge: "New") {}
                                Divider().background(Color.white.opacity(0.04)).padding(.leading, 54)
                                SettingsRow(icon: "person.crop.circle.fill", title: "Personalization") { withAnimation { showPersonalization = true } }
                                Divider().background(Color.white.opacity(0.04)).padding(.leading, 54)
                                SettingsRow(icon: "keyboard.fill", title: "Show keyboard on launch") { appState.showKeyboardOnLaunch.toggle() }
                                Divider().background(Color.white.opacity(0.04)).padding(.leading, 54)
                                SettingsRow(icon: "trash.circle.fill", title: "Delete conversation history", isDestructive: true) {}
                            }
                            .background(Color.white.opacity(0.03))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        
                        // ABOUT section
                        VStack(alignment: .leading, spacing: 6) {
                            Text("ABOUT")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.4))
                                .padding(.leading, 4)
                            
                            VStack(spacing: 0) {
                                SettingsRow(icon: "doc.text.fill", title: "Terms & Conditions") {}
                                Divider().background(Color.white.opacity(0.04)).padding(.leading, 54)
                                SettingsRow(icon: "lock.shield.fill", title: "Privacy Policy") {}
                                Divider().background(Color.white.opacity(0.04)).padding(.leading, 54)
                                SettingsRow(icon: "doc.richtext.fill", title: "Licenses") {}
                                Divider().background(Color.white.opacity(0.04)).padding(.leading, 54)
                                SettingsRow(icon: "info.circle.fill", title: "Version 1.57.0") {}
                            }
                            .background(Color.white.opacity(0.03))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        
                        // MORE section
                        VStack(alignment: .leading, spacing: 6) {
                            Text("MORE")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.4))
                                .padding(.leading, 4)
                            
                            VStack(spacing: 0) {
                                SettingsRow(icon: "square.and.arrow.up.fill", title: "Share the app") {}
                            }
                            .background(Color.white.opacity(0.03))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                }
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showPersonalization) { PersonalizationView() }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    var isDestructive: Bool = false
    var badge: String? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isDestructive ? .white.opacity(0.5) : .white.opacity(0.7))
                    .frame(width: 30, height: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(title)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(isDestructive ? .white.opacity(0.5) : .white)
                        if let badge {
                            Text(badge)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white.opacity(0.6))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.white.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
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
