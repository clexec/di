import SwiftUI

struct PersonalizationView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var instructions: String = ""
    @State private var temperatureOption: String = "Default"
    
    let temperatureOptions = ["Default", "Low (0.2)", "Medium (0.7)", "High (1.2)", "Max (2.0)"]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header — NO navigation bar
                HStack {
                    Button(action: { dismiss() }) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#374151"))
                                .frame(width: 40, height: 40)
                            Image(systemName: "chevron.left")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                    
                    Text("Personalization")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        appState.customInstructions = instructions
                        dismiss()
                    }) {
                        Text("Save")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Toggle
                        HStack {
                            Text("Enable customization")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            Spacer()
                            Toggle("", isOn: $appState.personalizationEnabled)
                                .labelsHidden()
                                .tint(Color(hex: "#10B981"))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(hex: "#1F2937")))
                        
                        // Custom instructions
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Custom Instructions")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(Color(hex: "#9CA3AF"))
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
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(hex: "#1F2937")))
                        }
                        
                        // Temperature
                        VStack(alignment: .leading, spacing: 8) {
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
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(hex: "#1F2937")))
                            
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
