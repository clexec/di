import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var showPersonalization: Bool = false
    
    var body: some View {
        ZStack {
            // Deep background
            Color(red: 0.05, green: 0.05, blue: 0.08)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Settings")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Close button
                    Button(action: { withAnimation { dismiss() } }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(Color.white.opacity(0.5))
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.08))
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 16)
                
                // Sections
                ScrollView {
                    VStack(spacing: 22) {
                        // APP section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("APP")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white.opacity(0.4))
                                .padding(.leading, 6)
                            
                            VStack(spacing: 0) {
                                SettingsRow(icon: "cube.box.fill", title: "Manage models") {}
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 58)
                                SettingsRow(icon: "link.circle.fill", title: "LM Link", badge: "New", badgeColor: .green) {}
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 58)
                                SettingsRow(icon: "person.crop.circle.fill", title: "Personalization") { withAnimation { showPersonalization = true } }
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 58)
                                SettingsToggleRow(icon: "keyboard.fill", title: "Show keyboard on launch", isOn: $appState.showKeyboardOnLaunch)
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 58)
                                SettingsRow(icon: "trash.fill", title: "Delete conversation history", isDestructive: true) {}
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.05))
                            )
                        }
                        
                        // ABOUT section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("ABOUT")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white.opacity(0.4))
                                .padding(.leading, 6)
                            
                            VStack(spacing: 0) {
                                SettingsRow(icon: "doc.text.fill", title: "Terms & Conditions") {}
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 58)
                                SettingsRow(icon: "lock.shield.fill", title: "Privacy Policy") {}
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 58)
                                SettingsRow(icon: "doc.richtext.fill", title: "Licenses") {}
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 58)
                                SettingsRow(icon: "info.circle.fill", title: "Version 1.57.0") {}
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.05))
                            )
                        }
                        
                        // MORE section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("MORE")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white.opacity(0.4))
                                .padding(.leading, 6)
                            
                            VStack(spacing: 0) {
                                SettingsRow(icon: "square.and.arrow.up.fill", title: "Share the app") {}
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 58)
                                SettingsRow(icon: "at.circle.fill", title: "Follow us on X") {}
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.05))
                            )
                        }
                        
                        // Footer
                        Text("Made with ❤️ in 🇫🇷")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.25))
                            .padding(.top, 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                }
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showPersonalization) { PersonalizationView() }
    }
}

// MARK: - Settings Row
struct SettingsRow: View {
    let icon: String
    let title: String
    var isDestructive: Bool = false
    var badge: String? = nil
    var badgeColor: Color = .green
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(isDestructive ? .red.opacity(0.8) : .white.opacity(0.7))
                    .frame(width: 32, height: 32)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isDestructive ? Color.red.opacity(0.1) : Color.white.opacity(0.06))
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 8) {
                        Text(title)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(isDestructive ? .red : .white)
                        if let badge {
                            Text(badge)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(badgeColor)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(
                                    Capsule()
                                        .fill(badgeColor.opacity(0.15))
                                )
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

// MARK: - Settings Toggle Row
struct SettingsToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 14) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 32, height: 32)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.06))
                )
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.green)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
