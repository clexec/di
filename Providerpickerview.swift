import SwiftUI

struct ProviderPickerView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Glass sheet background
            Color(red: 0.05, green: 0.05, blue: 0.08)
                .ignoresSafeArea()
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.15, green: 0.08, blue: 0.25).opacity(0.4),
                    Color(red: 0.05, green: 0.05, blue: 0.08).opacity(0.9)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Select Provider")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { withAnimation { dismiss() } }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(Color.white.opacity(0.5))
                            .glassCircle(size: 40)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 16)
                
                // Provider list — glass rows
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

// MARK: - Provider Row — glass row with active glow
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
                        .activeGlow()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .glassRow(cornerRadius: 14)
        .if(isSelected, transform: { view in
            view
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.5, green: 0.3, blue: 0.9).opacity(0.4),
                                    Color(red: 0.3, green: 0.4, blue: 1.0).opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .activeGlow()
        })
    }
}

// MARK: - Conditional Modifier Helper
extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
