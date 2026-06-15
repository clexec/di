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
                // Header — title left, save + close RIGHT, bigger close button with glass
                HStack {
                    Text("Personalization")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Save button
                    Button(action: { withAnimation { appState.customInstructions = instructions; dismiss() } }) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 44, height: 44)
                    }
                    .glassEffect(.regular.interactive())
                    
                    // Close button — RIGHT, bigger, with glassEffect
                    Button(action: { withAnimation { dismiss() } }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                            .frame(width: 44, height: 44)
                    }
                    .glassEffect(.regular.interactive())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                
                // Content
                ScrollView {
                    VStack(spacing: 16) {
                        // Toggle — green tint, NO oval, use glassEffect
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
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .glassEffect(.regular.interactive())
                        
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
                            .padding(.leading, 4)
                            
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
                            .padding(12)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .glassEffect(.regular)
                        }
                        
                        // Temperature — NO oval, use glassEffect
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
                                .glassEffect(.clear.interactive())
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .glassEffect(.regular.interactive())
                            
                            Text("Controls randomness in responses. Lower values make the AI more focused and deterministic, while higher values make it more creative and unpredictable.")
                                .font(.system(size: 14, weight: .medium))
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
        .onAppear { instructions = appState.customInstructions }
    }
}
