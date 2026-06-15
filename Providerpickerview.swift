import SwiftUI

struct ProviderPickerView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    // Liquid Glass
    @Namespace private var pickerNamespace
    @State private var isMerged: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header — glass buttons
                HStack {
                    Button(action: { withAnimation { dismiss() } }) {
                        Image(systemName: "xmark").font(.system(size: 14, weight: .bold)).foregroundColor(.white).padding(10)
                    }
                    .glassEffect(.regular.interactive())
                    .glassEffectID(id: "closePicker", namespace: pickerNamespace)
                    
                    Spacer()
                    
                    Text("Select Provider").font(.system(size: 20, weight: .medium)).foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { withAnimation { dismiss() } }) {
                        Text("Done").font(.system(size: 15, weight: .semibold)).foregroundColor(.blue)
                    }
                    .glassEffect(.clear.interactive().tint(.blue))
                }
                .padding(.horizontal, 16).padding(.vertical, 12)
                
                // Provider list — GlassEffectContainer for merge animation
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
                ZStack { RoundedRectangle(cornerRadius: 10).fill(provider.color.opacity(0.2)).frame(width: 40, height: 40); Image(systemName: provider.icon).font(.system(size: 18, weight: .medium)).foregroundColor(provider.color) }
                Text(provider.rawValue).font(.system(size: 16, weight: .medium)).foregroundColor(.white)
                Spacer()
                if isSelected { Image(systemName: "checkmark.circle.fill").font(.system(size: 20)).foregroundColor(.blue) }
            }
            .padding(.horizontal, 16).padding(.vertical, 14)
        }
        .glassEffect(isSelected ? .regular.interactive().tint(.blue) : .clear.interactive())
        .glassEffectID(id: provider.rawValue, namespace: namespace)
    }
}
