import SwiftUI

struct SettingsSheetView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var apiKey: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#0F0F1A").ignoresSafeArea()
                
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
                                .foregroundColor(.white.opacity(0.4))
                            SecureField("sk-...", text: $apiKey)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white.opacity(0.07))
                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.08), lineWidth: 1))
                                )
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
            .navigationTitle("Quick Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(Color(hex: "#6366F1"))
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            apiKey = appState.apiKeys[appState.selectedProvider] ?? ""
        }
    }
}
