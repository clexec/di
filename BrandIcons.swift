import SwiftUI

// MARK: - Provider Icon View
// All providers use real SF Symbols with borders

struct ProviderIconView: View {
    let provider: AIProvider
    var size: CGFloat = 20
    
    var body: some View {
        Group {
            switch provider {
            case .openai:
                Image(systemName: "brain.head.profile")
                    .font(.system(size: size * 0.75, weight: .semibold))
                    .foregroundColor(.white.opacity(0.85))
            case .deepseek:
                Image(systemName: "waveform.path.ecg")
                    .font(.system(size: size * 0.75, weight: .medium))
                    .foregroundColor(.white.opacity(0.85))
            case .gemini:
                Image(systemName: "sparkles")
                    .font(.system(size: size * 0.75, weight: .medium))
                    .foregroundColor(.white.opacity(0.85))
            case .openrouter:
                Image(systemName: "arrow.triangle.branch")
                    .font(.system(size: size * 0.75, weight: .medium))
                    .foregroundColor(.white.opacity(0.85))
            case .ollama:
                Image(systemName: "desktopcomputer")
                    .font(.system(size: size * 0.75, weight: .medium))
                    .foregroundColor(.white.opacity(0.85))
            case .custom:
                Image(systemName: "terminal")
                    .font(.system(size: size * 0.75, weight: .medium))
                    .foregroundColor(.white.opacity(0.85))
            }
        }
        .frame(width: size, height: size)
        .overlay(
            RoundedRectangle(cornerRadius: size * 0.3)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
    }
}

// MARK: - Settings Icon View — with border

struct SettingsIconView: View {
    let iconName: String
    var size: CGFloat = 16
    
    var body: some View {
        Image(systemName: iconName)
            .font(.system(size: size, weight: .medium))
            .foregroundColor(.white.opacity(0.7))
            .frame(width: 34, height: 34)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
    }
}
