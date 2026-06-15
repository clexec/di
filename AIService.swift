import Foundation

// MARK: - AI Service
class AIService {
    static let shared = AIService()
    
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 120
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - Send Message (non-streaming)
    func sendMessage(
        provider: AIProvider,
        message: String,
        apiKey: String?,
        model: String? = nil,
        systemPrompt: String? = nil,
        ollamaURL: String = "http://localhost:11434"
    ) async throws -> String {
        switch provider {
        case .ollama:
            return try await sendOllamaRequest(message: message, model: model ?? provider.defaultModel, systemPrompt: systemPrompt, baseURL: ollamaURL)
        case .openai, .deepseek, .openrouter:
            return try await sendOpenAICompatibleRequest(
                baseURL: provider.baseURL,
                apiKey: apiKey ?? "",
                message: message,
                model: model ?? provider.defaultModel,
                systemPrompt: systemPrompt
            )
        case .gemini:
            return try await sendGeminiRequest(apiKey: apiKey ?? "", message: message, model: model ?? provider.defaultModel, systemPrompt: systemPrompt)
        case .custom:
            throw AIError.invalidConfiguration
        }
    }
    
    // MARK: - Ollama API
    private func sendOllamaRequest(message: String, model: String, systemPrompt: String?, baseURL: String) async throws -> String {
        guard let url = URL(string: "\(baseURL)/api/chat") else {
            throw AIError.invalidURL
        }
        
        var messages: [[String: String]] = []
        if let systemPrompt, !systemPrompt.isEmpty {
            messages.append(["role": "system", "content": systemPrompt])
        }
        messages.append(["role": "user", "content": message])
        
        let body: [String: Any] = [
            "model": model,
            "messages": messages,
            "stream": false
        ]
        
        let data = try await performRequest(url: url, body: body, headers: [:])
        let response = try JSONDecoder().decode(OllamaResponse.self, from: data)
        return response.message.content
    }
    
    // MARK: - OpenAI Compatible API (OpenAI, DeepSeek, OpenRouter)
    private func sendOpenAICompatibleRequest(baseURL: String, apiKey: String, message: String, model: String, systemPrompt: String?) async throws -> String {
        guard let url = URL(string: "\(baseURL)/chat/completions") else {
            throw AIError.invalidURL
        }
        
        var messages: [[String: String]] = []
        if let systemPrompt, !systemPrompt.isEmpty {
            messages.append(["role": "system", "content": systemPrompt])
        }
        messages.append(["role": "user", "content": message])
        
        let body: [String: Any] = [
            "model": model,
            "messages": messages,
            "max_tokens": 2048
        ]
        
        let headers = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        let data = try await performRequest(url: url, body: body, headers: headers)
        let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        guard let content = response.choices.first?.message.content else {
            throw AIError.emptyResponse
        }
        return content
    }
    
    // MARK: - Gemini API
    private func sendGeminiRequest(apiKey: String, message: String, model: String, systemPrompt: String?) async throws -> String {
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent?key=\(apiKey)") else {
            throw AIError.invalidURL
        }
        
        var contents: [[String: Any]] = []
        if let systemPrompt, !systemPrompt.isEmpty {
            contents.append([
                "role": "user",
                "parts": [["text": systemPrompt]]
            ])
            contents.append([
                "role": "model",
                "parts": [["text": "Understood."]]
            ])
        }
        contents.append([
            "role": "user",
            "parts": [["text": message]]
        ])
        
        let body: [String: Any] = ["contents": contents]
        let headers = ["Content-Type": "application/json"]
        
        let data = try await performRequest(url: url, body: body, headers: headers)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let candidates = json?["candidates"] as? [[String: Any]]
        let content = candidates?.first?["content"] as? [String: Any]
        let parts = content?["parts"] as? [[String: Any]]
        let text = parts?.first?["text"] as? String
        return text ?? "No response from Gemini."
    }
    
    // MARK: - Generic Request
    private func performRequest(url: URL, body: [String: Any], headers: [String: String]) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AIError.invalidResponse
        }
        
        if httpResponse.statusCode != 200 {
            let errorBody = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw AIError.apiError(statusCode: httpResponse.statusCode, message: errorBody)
        }
        
        return data
    }
}

// MARK: - Response Models
struct OpenAIResponse: Decodable {
    let choices: [Choice]
    
    struct Choice: Decodable {
        let message: Message
    }
    
    struct Message: Decodable {
        let content: String
    }
}

struct OllamaResponse: Decodable {
    let message: OllamaMessage
}

struct OllamaMessage: Decodable {
    let content: String
}

// MARK: - Errors
enum AIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case emptyResponse
    case apiError(statusCode: Int, message: String)
    case invalidConfiguration
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .emptyResponse:
            return "Empty response from AI"
        case .apiError(let code, let message):
            return "API Error (\(code)): \(message)"
        case .invalidConfiguration:
            return "Invalid provider configuration"
        }
    }
}
