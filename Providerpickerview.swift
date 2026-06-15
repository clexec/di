import SwiftUI

struct ProviderPickerView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @Namespace private var pickerNamespace
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { withAnimation { dismiss() } }) {
                        Image(systemName: "xmark").font(.system(size: 14, weight: .bold)).foregroundColor(.white).padding(10)
                    }
                    .glassEffect(.regular.interactive())
                    
                    Spacer()
                    
                    Text("Select Provider").font(.system(size: 20, weight: .medium)).foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { withAnimation { dismiss() } }) {
                        Text("Done").font(.system(size: 15, weight: .semibold)).foregroundColor(.white.opacity(0.7))
                    }
                    .glassEffect(.clear.interactive())
                }
                .padding(.horizontal, 16).padding(.vertical, 12)
                
                // Provider list
                ScrollView {
                    GlassEffectContainer(spacing: 40) {
                        VStack(spacing: 8) {
                            ForEach(AIProvider.allCases) { provider in
                                ProviderRow(provider: provider, isSelected: appState.selectedProvider == provider, namespace: pickerNamespace) {
                                    withAnimation { appState.selectedProvider = provider; dismiss() }
                                }
                            }
                        }
                        .padding(.horizontal, 16).padding(.top, 8)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct ProviderRow: View {
    let provider: AIProvider
    let isSelected: Bool
    var namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                // Monochrome icon — no colored background
                Image(systemName: provider.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .frame(width: 40, height: 40)
                
                Text(provider.rawValue).font(.system(size: 16, weight: .medium)).foregroundColor(.white)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark").font(.system(size: 16, weight: .semibold)).foregroundColor(.white.opacity(0.7))
                }
            }
            .padding(.horizontal, 16).padding(.vertical, 14)
        }
        .glassEffect(isSelected ? .regular.interactive() : .clear.interactive())
    }
}
