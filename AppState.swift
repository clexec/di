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
        switch self { case .openai: "sparkles"; case .deepseek: "waveform"; case .gemini: "star.circle"; case .openrouter: "arrow.triangle.branch"; case .ollama: "cloud.fill"; case .custom: "terminal" }
    }
    var color: Color {
        switch self { case .openai: Color(hex: "#10A37F"); case .deepseek: Color(hex: "#4C6EF5"); case .gemini: Color(hex: "#4285F4"); case .openrouter: Color(hex: "#FF6B35"); case .ollama: Color(hex: "#F0F0F0"); case .custom: Color(hex: "#8B5CF6") }
    }
    var defaultModel: String {
        switch self { case .openai: "gpt-4o-mini"; case .deepseek: "deepseek-chat"; case .gemini: "gemini-pro"; case .openrouter: "openai/gpt-4o-mini"; case .ollama: "llama3.2"; case .custom: "" }
    }
    var baseURL: String {
        switch self { case .openai: "https://api.openai.com/v1"; case .deepseek: "https://api.deepseek.com/v1"; case .gemini: "https://generativelanguage.googleapis.com/v1beta"; case .openrouter: "https://openrouter.ai/api/v1"; case .ollama: "http://localhost:11434"; case .custom: "" }
    }
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
    @Published var showKeyboardOnLaunch: Bool = true
    
    init() { apiKeys[.openrouter] = "76f439c65f4941278295e5552e463d11.BmVE0opP9oCNGcLfyTWbOGE-" }
}

extension Color {
    init(hex: String) {
        let h = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0; Scanner(string: h).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch h.count { case 3: (a,r,g,b) = (255,(int>>8)*17,(int>>4&0xF)*17,(int&0xF)*17); case 6: (a,r,g,b) = (255,int>>16,int>>8&0xFF,int&0xFF); case 8: (a,r,g,b) = (int>>24,int>>16&0xFF,int>>8&0xFF,int&0xFF); default: (a,r,g,b) = (1,1,1,0) }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}
