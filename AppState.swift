import SwiftUI
import Combine

// MARK: - App Background Color — brighter gray
extension Color {
    static let appBackground = Color(red: 0.16, green: 0.16, blue: 0.19)
}

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
        case .openai: "brain"
        case .deepseek: "waveform.path.ecg"
        case .gemini: "star.circle"
        case .openrouter: "network"
        case .ollama: "server.rack"
        case .custom: "terminal"
        }
    }
    var defaultModel: String {
        switch self { case .openai: "gpt-4o-mini"; case .deepseek: "deepseek-chat"; case .gemini: "gemini-pro"; case .openrouter: "openai/gpt-4o-mini"; case .ollama: "llama3.2"; case .custom: "" }
    }
    var baseURL: String {
        switch self { case .openai: "https://api.openai.com/v1"; case .deepseek: "https://api.deepseek.com/v1"; case .gemini: "https://generativelanguage.googleapis.com/v1beta"; case .openrouter: "https://openrouter.ai/api/v1"; case .ollama: "http://localhost:11434"; case .custom: "" }
    }
}

// MARK: - Available Models
struct AIModel: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let subtitle: String?
    let provider: AIProvider
    let modelId: String
    
    static let availableModels: [AIModel] = [
        AIModel(name: "Bonsai", subtitle: "8B", provider: .ollama, modelId: "bonsai-8b"),
        AIModel(name: "Qwen 3.5", subtitle: "2B", provider: .ollama, modelId: "qwen3.5-2b"),
        AIModel(name: "SmolLM 3", subtitle: "3B", provider: .ollama, modelId: "smollm3-3b"),
        AIModel(name: "Gemma 3 QAT", subtitle: "1B", provider: .ollama, modelId: "gemma3-qat-1b"),
    ]
    
    static let lmLink = AIModel(name: "LM Link", subtitle: "Login required", provider: .ollama, modelId: "lm-link")
    
    var displayName: String { name }
}

struct ChatMessage: Identifiable { let id = UUID(); let content: String; let isUser: Bool; let timestamp: Date }
struct Conversation: Identifiable { let id = UUID(); var title: String; var messages: [ChatMessage]; var provider: AIProvider; var createdAt: Date }

class AppState: ObservableObject {
    @Published var selectedProvider: AIProvider = .ollama
    @Published var conversations: [Conversation] = []
    @Published var currentConversation: Conversation?
    @Published var apiKeys: [AIProvider: String] = [:]
    @Published var ollamaURL: String = "http://localhost:11434"
    @Published var customInstructions: String = ""
    @Published var personalizationEnabled: Bool = true
    @Published var selectedModel: String = "Gemma 3 QAT 1B"
    @Published var selectedAIModel: AIModel = AIModel.availableModels[3]
    @Published var showKeyboardOnLaunch: Bool = true
    
    init() { apiKeys[.openrouter] = "76f439c65f4941278295e5552e463d11.BmVE0opP9oCNGcLfyTWbOGE-" }
}
