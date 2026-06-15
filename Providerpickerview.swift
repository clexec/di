import SwiftUI

struct ProviderPickerView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with glass buttons
                HStack {
                    // Close button — new style with glassEffect
                    Button(action: { withAnimation { dismiss() } }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                            .frame(width: 32, height: 32)
                    }
                    .glassEffect(.regular.interactive())
                    
                    Spacer()
                    
                    Text("Select Provider")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Done button with glassEffect
                    Button(action: { withAnimation { dismiss() } }) {
                        Text("Done")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                    }
                    .glassEffect(.regular.interactive())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                // Provider list — NO ovals
                ScrollView {
                    VStack(spacing: 6) {
                        ForEach(AIProvider.allCases) { provider in
                            ProviderRow(provider: provider, isSelected: appState.selectedProvider == provider) {
                                withAnimation { appState.selectedProvider = provider; dismiss() }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 32)
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
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.3))
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(isSelected ? Color.white.opacity(0.06) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
