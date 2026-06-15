import SwiftUI

struct ProviderPickerView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with glassEffect
                HStack {
                    Text("Select Provider")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { withAnimation { dismiss() } }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                            .frame(width: 44, height: 44)
                    }
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 12))
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 16)
                
                // Provider list with glassEffect
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
            HStack(spacing: 16) {
                ProviderIconView(provider: provider, size: 24)
                    .frame(width: 36, height: 36)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(provider.rawValue)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    Text(provider.defaultModel)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.3))
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
        }
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 14))
    }
}
