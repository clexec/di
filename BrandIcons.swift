import SwiftUI

// MARK: - Provider Icon View — glass background
struct ProviderIconView: View {
    let provider: AIProvider
    var size: CGFloat = 20
    
    var body: some View {
        Group {
            switch provider {
            case .openai:
                Image(systemName: "brain.head.profile")
                    .font(.system(size: size * 0.7, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            case .deepseek:
                Image(systemName: "waveform.path.ecg")
                    .font(.system(size: size * 0.7, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            case .gemini:
                Image(systemName: "sparkles")
                    .font(.system(size: size * 0.7, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            case .openrouter:
                Image(systemName: "arrow.triangle.branch")
                    .font(.system(size: size * 0.7, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            case .ollama:
                Image(systemName: "desktopcomputer")
                    .font(.system(size: size * 0.7, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            case .custom:
                Image(systemName: "terminal")
                    .font(.system(size: size * 0.7, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .frame(width: size, height: size)
        .background(
            RoundedRectangle(cornerRadius: size * 0.3)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: size * 0.3)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.2),
                                    Color.white.opacity(0.06)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.5
                        )
                )
        )
    }
}

// MARK: - Settings Icon View — glass background
struct SettingsIconView: View {
    let iconName: String
    var size: CGFloat = 16
    
    var body: some View {
        Image(systemName: iconName)
            .font(.system(size: size, weight: .medium))
            .foregroundColor(.white.opacity(0.6))
            .frame(width: 32, height: 32)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                    )
            )
    }
}
