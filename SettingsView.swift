import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var showPersonalization: Bool = false
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header — title left, close button RIGHT, bigger
                HStack {
                    Text("Settings")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Close button — RIGHT, bigger, with glassEffect
                    Button(action: { withAnimation { dismiss() } }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                            .frame(width: 44, height: 44)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .glassEffect(.regular.interactive())
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 16)
                
                // Sections — more spacing
                ScrollView {
                    VStack(spacing: 24) {
                        // APP section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("APP")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white.opacity(0.45))
                                .padding(.leading, 6)
                            
                            VStack(spacing: 0) {
                                SettingsRow(icon: "cube.box.fill", title: "Manage models") {}
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 60)
                                SettingsRow(icon: "link.circle.fill", title: "LM Link", badge: "New", badgeColor: .green) {}
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 60)
                                SettingsRow(icon: "person.crop.circle.fill", title: "Personalization") { withAnimation { showPersonalization = true } }
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 60)
                                SettingsToggleRow(icon: "keyboard.fill", title: "Show keyboard on launch", isOn: $appState.showKeyboardOnLaunch)
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 60)
                                SettingsRow(icon: "trash.fill", title: "Delete conversation history", isDestructive: true) {}
                            }
                            .background(Color.white.opacity(0.06))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                        // ABOUT section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("ABOUT")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white.opacity(0.45))
                                .padding(.leading, 6)
                            
                            VStack(spacing: 0) {
                                SettingsRow(icon: "doc.text.fill", title: "Terms & Conditions") {}
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 60)
                                SettingsRow(icon: "lock.shield.fill", title: "Privacy Policy") {}
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 60)
                                SettingsRow(icon: "doc.richtext.fill", title: "Licenses") {}
                                Divider().background(Color.white.opacity(0.05)).padding(.leading, 60)
                                SettingsRow(icon: "info.circle.fill", title: "Version 1.57.0") {}
                            }
                            .background(Color.white.opacity(0.06))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                        // MORE section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("MORE")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white.opacity(0.45))
                                .padding(.leading, 6)
                            
                            VStack(spacing: 0) {
                                SettingsRow(icon: "square.and.arrow.up.fill", title: "Share the app") {}
                            }
                            .background(Color.white.opacity(0.06))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
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

// MARK: - Settings Row — bigger, more spacing, icon with border
struct SettingsRow: View {
    let icon: String
    let title: String
    var isDestructive: Bool = false
    var badge: String? = nil
    var badgeColor: Color = .white.opacity(0.6)
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon with border/outline
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(isDestructive ? .red.opacity(0.8) : .white.opacity(0.8))
                    .frame(width: 34, height: 34)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 8) {
                        Text(title)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(isDestructive ? .red : .white)
                        if let badge {
                            Text(badge)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(badgeColor)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3)
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
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
        }
    }
}

// MARK: - Settings Toggle Row — green tint
struct SettingsToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon with border/outline
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
                .frame(width: 34, height: 34)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
            
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.green)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
    }
}
