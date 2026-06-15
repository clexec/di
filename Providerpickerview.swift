import SwiftUI

struct ProviderPickerView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Deep background
            Color(red: 0.05, green: 0.05, blue: 0.08)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Select Provider")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
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
                
                // Provider list
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(AIProvider.allCases) { provider in
                            ProviderRow(provider: provider, isSelected: appState.selectedProvider == provider) {
                                withAnimation { appState.selectedProvider = provider; dismiss() }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct ProviderRow: View {
    let provider: AIProvider
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ProviderIconView(provider: provider, size: 24)
                    .frame(width: 36, height: 36)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(provider.rawValue)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(provider.defaultModel)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.25))
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.05))
        )
    }
}
