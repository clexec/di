import SwiftUI
import Combine

enum AIProvider: String, CaseIterable, Identifiable {
    case openai = "OpenAI"
    case deepseek = "DeepSeek"
    case gemini = "Gemini"
    case openrouter = "OpenRouter"
    case ollama = "Ollama"
    case custom = "Custom API"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .openai: return "sparkles"
        case .deepseek: return "waveform"
        case .gemini: return "star.circle"
        case .openrouter: return "arrow.triangle.branch"
        case .ollama: return "cloud.fill"
        case .custom: return "terminal"
        }
    }
    
    var color: Color {
        switch self {
        case .openai: return Color(hex: "#10A37F")
        case .deepseek: return Color(hex: "#4C6EF5")
        case .gemini: return Color(hex: "#4285F4")
        case .openrouter: return Color(hex: "#FF6B35")
        case .ollama: return Color(hex: "#F0F0F0")
        case .custom: return Color(hex: "#8B5CF6")
        }
    }
    
    var defaultModel: String {
        switch self {
        case .openai: return "gpt-4o-mini"
        case .deepseek: return "deepseek-chat"
        case .gemini: return "gemini-pro"
        case .openrouter: return "openai/gpt-4o-mini"
        case .ollama: return "llama3.2"
        case .custom: return ""
        }
    }
    
    var baseURL: String {
        switch self {
        case .openai: return "https://api.openai.com/v1"
        case .deepseek: return "https://api.deepseek.com/v1"
        case .gemini: return "https://generativelanguage.googleapis.com/v1beta"
        case .openrouter: return "https://openrouter.ai/api/v1"
        case .ollama: return "http://localhost:11434"
        case .custom: return ""
        }
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
}

struct Conversation: Identifiable {
    let id = UUID()
    var title: String
    var messages: [ChatMessage]
    var provider: AIProvider
    var createdAt: Date
}

class AppState: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var selectedProvider: AIProvider = .openai
    @Published var conversations: [Conversation] = []
    @Published var currentConversation: Conversation?
    @Published var apiKeys: [AIProvider: String] = [:]
    @Published var customAPIURL: String = ""
    @Published var ollamaURL: String = "http://localhost:11434"
    @Published var showKeyboardOnLaunch: Bool = true
    @Published var customInstructions: String = ""
    @Published var personalizationEnabled: Bool = true
    @Published var browserURL: String = "https://www.google.com"
    
    init() {
        // Pre-set API keys
        apiKeys[.openrouter] = "76f439c65f4941278295e5552e463d11.BmVE0opP9oCNGcLfyTWbOGE-"
        selectedProvider = .ollama
        
        conversations = [
            Conversation(title: "Swift UI help", messages: [
                ChatMessage(content: "Can you help me with SwiftUI animations?", isUser: true, timestamp: Date()),
                ChatMessage(content: "Sure! SwiftUI has great built-in animation support.", isUser: false, timestamp: Date())
            ], provider: .ollama, createdAt: Date()),
            Conversation(title: "Recipe ideas", messages: [
                ChatMessage(content: "Give me pasta recipe ideas", isUser: true, timestamp: Date())
            ], provider: .gemini, createdAt: Date().addingTimeInterval(-3600))
        ]
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Liquid Glass Modifier
struct LiquidGlassBackground: ViewModifier {
    var cornerRadius: CGFloat = 16
    var opacity: Double = 0.15
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .opacity(0.6)
            )
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white.opacity(opacity))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.3), Color.white.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            )
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
    }
}

struct GlassCapsuleBackground: ViewModifier {
    var opacity: Double = 0.12
    
    func body(content: Content) -> some View {
        content
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .opacity(0.6)
            )
            .background(
                Capsule()
                    .fill(Color.white.opacity(opacity))
            )
            .overlay(
                Capsule()
                    .stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.25), Color.white.opacity(0.05)],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 0.5
                    )
            )
    }
}

extension View {
    func liquidGlass(cornerRadius: CGFloat = 16, opacity: Double = 0.15) -> some View {
        modifier(LiquidGlassBackground(cornerRadius: cornerRadius, opacity: opacity))
    }
    
    func glassCapsule(opacity: Double = 0.12) -> some View {
        modifier(GlassCapsuleBackground(opacity: opacity))
    }
}
