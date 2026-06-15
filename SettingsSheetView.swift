import SwiftUI

struct SettingsSheetView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var apiKey: String = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#6A5ACD"), Color(hex: "#2D1B69"), Color(hex: "#1A1A2E")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom header — NO navigation bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white.opacity(0.6))
                            .frame(width: 32, height: 32)
                            .liquidGlass(cornerRadius: 16, opacity: 0.1)
                    }
                    
                    Spacer()
                    
                    Text("Quick Settings")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Text("Done")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(hex: "#6366F1"))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                ScrollView {
                    VStack(spacing: 16) {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(appState.selectedProvider.color.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                Image(systemName: appState.selectedProvider.icon)
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(appState.selectedProvider.color)
                            }
                            
                            Text(appState.selectedProvider.rawValue)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("API Key")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white.opacity(0.35))
                            SecureField("sk-...", text: $apiKey)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 12)
                                .liquidGlass(cornerRadius: 10, opacity: 0.07)
                        }
                        
                        Button(action: {
                            appState.apiKeys[appState.selectedProvider] = apiKey
                            dismiss()
                        }) {
                            Text("Save")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(hex: "#6366F1"))
                                )
                        }
                    }
                    .padding(16)
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            apiKey = appState.apiKeys[appState.selectedProvider] ?? ""
        }
    }
}
