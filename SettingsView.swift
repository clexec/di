import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var showPersonalization: Bool = false
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header — title left, close button RIGHT side, bigger
                HStack {
                    Text("Settings")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Close button — RIGHT side, bigger
                    Button(action: { withAnimation { dismiss() } }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .glassEffect(.regular.interactive())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                
                // Sections
                ScrollView {
                    VStack(spacing: 16) {
                        // APP section
                        VStack(alignment: .leading, spacing: 6) {
                            Text("APP")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white.opacity(0.4))
                                .padding(.leading, 4)
                            
                            VStack(spacing: 0) {
                                SettingsRow(icon: "cube.box.fill", title: "Manage models") {}
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 54)
                                SettingsRow(icon: "link.circle.fill", title: "LM Link", badge: "New", badgeColor: .green) {}
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 54)
                                SettingsRow(icon: "person.crop.circle.fill", title: "Personalization") { withAnimation { showPersonalization = true } }
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 54)
                                // Show keyboard — with toggle
                                SettingsToggleRow(icon: "keyboard.fill", title: "Show keyboard on launch", isOn: $appState.showKeyboardOnLaunch)
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 54)
                                SettingsRow(icon: "trash.fill", title: "Delete conversation history", isDestructive: true) {}
                            }
                            .background(Color.white.opacity(0.05))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        
                        // ABOUT section
                        VStack(alignment: .leading, spacing: 6) {
                            Text("ABOUT")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white.opacity(0.4))
                                .padding(.leading, 4)
                            
                            VStack(spacing: 0) {
                                SettingsRow(icon: "doc.text.fill", title: "Terms & Conditions") {}
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 54)
                                SettingsRow(icon: "lock.shield.fill", title: "Privacy Policy") {}
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 54)
                                SettingsRow(icon: "doc.richtext.fill", title: "Licenses") {}
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 54)
                                SettingsRow(icon: "info.circle.fill", title: "Version 1.57.0") {}
                            }
                            .background(Color.white.opacity(0.05))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        
                        // MORE section
                        VStack(alignment: .leading, spacing: 6) {
                            Text("MORE")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white.opacity(0.4))
                                .padding(.leading, 4)
                            
                            VStack(spacing: 0) {
                                SettingsRow(icon: "square.and.arrow.up.fill", title: "Share the app") {}
                            }
                            .background(Color.white.opacity(0.05))
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

// MARK: - Settings Row
struct SettingsRow: View {
    let icon: String
    let title: String
    var isDestructive: Bool = false
    var badge: String? = nil
    var badgeColor: Color = .white.opacity(0.6)
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(isDestructive ? .red.opacity(0.7) : .white.opacity(0.7))
                    .frame(width: 30, height: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(title)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(isDestructive ? .red : .white)
                        if let badge {
                            Text(badge)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(badgeColor)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(badgeColor.opacity(0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white.opacity(0.15))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}

// MARK: - Settings Toggle Row (for on/off switches)
struct SettingsToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 30, height: 30)
            
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.white.opacity(0.5))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
