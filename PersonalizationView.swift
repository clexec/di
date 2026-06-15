import SwiftUI

struct PersonalizationView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var instructions: String = ""
    @State private var temperatureOption: String = "Default"
    
    let temperatureOptions = ["Default", "Low (0.2)", "Medium (0.7)", "High (1.2)", "Max (2.0)"]
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with back and close buttons
                HStack {
                    // Back button with glassEffect
                    Button(action: { withAnimation { dismiss() } }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                    }
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 12))
                    
                    Text("Personalization")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { withAnimation { appState.customInstructions = instructions; dismiss() } }) {
                        Text("Save")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                    }
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 12))
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 16)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Toggle with glassEffect
                        HStack {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white.opacity(0.6))
                            Text("Enable customization")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                            Toggle("", isOn: $appState.personalizationEnabled)
                                .labelsHidden()
                                .tint(.green)
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 16)
                        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 14))
                        
                        // Custom instructions
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 6) {
                                Image(systemName: "text.quote")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.4))
                                Text("Custom Instructions")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white.opacity(0.4))
                            }
                            .padding(.leading, 6)
                            
                            ZStack(alignment: .bottomTrailing) {
                                TextEditor(text: $instructions)
                                    .foregroundColor(.white)
                                    .font(.system(size: 17, weight: .medium))
                                    .scrollContentBackground(.hidden)
                                    .background(Color.clear)
                                    .frame(minHeight: 160)
                                    .overlay(
                                        Group {
                                            if instructions.isEmpty {
                                                Text("Customize how the AI responds")
                                                    .foregroundColor(.white.opacity(0.2))
                                                    .font(.system(size: 17, weight: .medium))
                                                    .padding(.top, 8)
                                                    .padding(.leading, 5)
                                                    .allowsHitTesting(false)
                                            }
                                        },
                                        alignment: .topLeading
                                    )
                                Text("\(instructions.count)/1 000")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white.opacity(0.25))
                                    .padding(8)
                            }
                            .padding(14)
                            .glassEffect(.regular, in: .rect(cornerRadius: 14))
                        }
                        
                        // Temperature with glassEffect
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "thermometer.medium")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.6))
                                Text("Temperature")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.white)
                                Spacer()
                                Menu {
                                    ForEach(temperatureOptions, id: \.self) { option in
                                        Button(option) { withAnimation { temperatureOption = option } }
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        Text(temperatureOption)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.white.opacity(0.45))
                                        Image(systemName: "chevron.up.chevron.down")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.white.opacity(0.35))
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                }
                                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 8))
                            }
                            .padding(.horizontal, 18)
                            .padding(.vertical, 16)
                            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 14))
                            
                            Text("Controls randomness in responses. Lower values make the AI more focused and deterministic, while higher values make it more creative and unpredictable.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.3))
                                .padding(.horizontal, 6)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear { instructions = appState.customInstructions }
    }
}
