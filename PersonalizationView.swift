import SwiftUI

struct PersonalizationView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var instructions: String = ""
    @State private var temperatureOption: String = "Default"
    
    let temperatureOptions = ["Default", "Low (0.2)", "Medium (0.7)", "High (1.2)", "Max (2.0)"]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#6A5ACD"), Color(hex: "#2D1B69"), Color(hex: "#1A1A2E")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom header — NO navigation bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white.opacity(0.6))
                            .frame(width: 32, height: 32)
                            .liquidGlass(cornerRadius: 16, opacity: 0.1)
                    }
                    
                    Spacer()
                    
                    Text("Personalization")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        appState.customInstructions = instructions
                        dismiss()
                    }) {
                        Text("Save")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(hex: "#6366F1"))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .glassCapsule(opacity: 0.08)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Enable toggle
                        HStack {
                            Text("Enable customization")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            Spacer()
                            Toggle("", isOn: $appState.personalizationEnabled)
                                .labelsHidden()
                                .tint(Color(hex: "#34C759"))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .liquidGlass(cornerRadius: 14, opacity: 0.07)
                        
                        // Custom instructions
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Custom Instructions")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white.opacity(0.35))
                                .padding(.leading, 4)
                            
                            ZStack(alignment: .bottomTrailing) {
                                TextEditor(text: $instructions)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .scrollContentBackground(.hidden)
                                    .background(Color.clear)
                                    .frame(minHeight: 160)
                                    .overlay(
                                        Group {
                                            if instructions.isEmpty {
                                                Text("Customize how the AI responds")
                                                    .foregroundColor(.white.opacity(0.2))
                                                    .font(.system(size: 15))
                                                    .padding(.top, 8)
                                                    .padding(.leading, 5)
                                                    .allowsHitTesting(false)
                                            }
                                        },
                                        alignment: .topLeading
                                    )
                                
                                Text("\(instructions.count)/1 000")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.25))
                                    .padding(8)
                            }
                            .padding(12)
                            .liquidGlass(cornerRadius: 14, opacity: 0.07)
                        }
                        
                        // Temperature
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Temperature")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                Spacer()
                                Menu {
                                    ForEach(temperatureOptions, id: \.self) { option in
                                        Button(option) { temperatureOption = option }
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        Text(temperatureOption)
                                            .font(.system(size: 15))
                                            .foregroundColor(.white.opacity(0.45))
                                        Image(systemName: "chevron.up.chevron.down")
                                            .font(.system(size: 11))
                                            .foregroundColor(.white.opacity(0.35))
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .liquidGlass(cornerRadius: 14, opacity: 0.07)
                            
                            Text("Controls randomness in responses. Lower values make the AI more focused and deterministic, while higher values make it more creative and unpredictable.")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.3))
                                .padding(.horizontal, 4)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            instructions = appState.customInstructions
        }
    }
}
