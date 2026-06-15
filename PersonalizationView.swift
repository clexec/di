import SwiftUI

struct PersonalizationView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var instructions: String = ""
    @State private var temperatureOption: String = "Default"
    
    let temperatureOptions = ["Default", "Low (0.2)", "Medium (0.7)", "High (1.2)", "Max (2.0)"]
    
    var body: some View {
        ZStack {
            // Glass sheet background
            Color(red: 0.05, green: 0.05, blue: 0.08)
                .ignoresSafeArea()
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.15, green: 0.08, blue: 0.25).opacity(0.4),
                    Color(red: 0.05, green: 0.05, blue: 0.08).opacity(0.9)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with back and save buttons
                HStack {
                    // Back button — glass circle
                    Button(action: { withAnimation { dismiss() } }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .glassCircle(size: 40)
                    }
                    
                    Text("Personalization")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Save button — glass capsule
                    Button(action: { withAnimation { appState.customInstructions = instructions; dismiss() } }) {
                        Text("Save")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                    }
                    .glassCapsule()
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 16)
                
                ScrollView {
                    VStack(spacing: 18) {
                        // Enable customization toggle — glass row
                        HStack(spacing: 14) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 16, weight: .semibold))
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
                            
                            Text("Enable customization")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Toggle("", isOn: $appState.personalizationEnabled)
                                .labelsHidden()
                                .tint(.green)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .glassRow(cornerRadius: 14)
                        
                        // Custom instructions — glass card
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 6) {
                                Image(systemName: "text.quote")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.35))
                                Text("Custom Instructions")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.35))
                            }
                            .padding(.leading, 6)
                            
                            ZStack(alignment: .bottomTrailing) {
                                TextEditor(text: $instructions)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .medium))
                                    .scrollContentBackground(.hidden)
                                    .background(Color.clear)
                                    .frame(minHeight: 150)
                                    .overlay(
                                        Group {
                                            if instructions.isEmpty {
                                                Text("Customize how the AI responds")
                                                    .foregroundColor(.white.opacity(0.15))
                                                    .font(.system(size: 16, weight: .medium))
                                                    .padding(.top, 8)
                                                    .padding(.leading, 5)
                                                    .allowsHitTesting(false)
                                            }
                                        },
                                        alignment: .topLeading
                                    )
                                Text("\(instructions.count)/1 000")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.2))
                                    .padding(8)
                            }
                            .padding(14)
                            .glassCard(cornerRadius: 14)
                        }
                        
                        // Temperature — glass row
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 14) {
                                Image(systemName: "thermometer.medium")
                                    .font(.system(size: 16, weight: .semibold))
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
                                
                                Text("Temperature")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Menu {
                                    ForEach(temperatureOptions, id: \.self) { option in
                                        Button(option) { withAnimation { temperatureOption = option } }
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        Text(temperatureOption)
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.white.opacity(0.4))
                                        Image(systemName: "chevron.up.chevron.down")
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundColor(.white.opacity(0.3))
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .glassEffect(cornerRadius: 8)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .glassRow(cornerRadius: 14)
                            
                            Text("Controls randomness in responses. Lower values make the AI more focused and deterministic, while higher values make it more creative and unpredictable.")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white.opacity(0.25))
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
