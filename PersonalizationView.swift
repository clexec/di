import SwiftUI

struct PersonalizationView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var instructions: String = ""
    @State private var temperatureOption: String = "Default"
    // Liquid Glass
    @Namespace private var persNamespace
    @State private var isMerged: Bool = false
    
    let temperatureOptions = ["Default", "Low (0.2)", "Medium (0.7)", "High (1.2)", "Max (2.0)"]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header — glass buttons
                HStack {
                    Button(action: { withAnimation { dismiss() } }) {
                        Image(systemName: "chevron.left").font(.system(size: 13, weight: .bold)).foregroundColor(.white).padding(10)
                    }
                    .glassEffect(.regular.interactive())
                    .glassEffectID(persNamespace, in: "backBtn")
                    
                    Spacer()
                    
                    Text("Personalization").font(.system(size: 20, weight: .medium)).foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { withAnimation { appState.customInstructions = instructions; dismiss() } }) {
                        Text("Save").font(.system(size: 15, weight: .medium)).foregroundColor(.white.opacity(0.6)).padding(.horizontal, 14).padding(.vertical, 7)
                    }
                    .glassEffect(.regular.interactive().tint(.blue))
                    .glassEffectID(persNamespace, in: "saveBtn")
                }
                .padding(.horizontal, 16).padding(.vertical, 12)
                
                // Content — GlassEffectContainer for merge
                ScrollView {
                    GlassEffectContainer(spacing: 40) {
                        VStack(spacing: 16) {
                            // Toggle — regular glass with green tint
                            HStack {
                                Text("Enable customization").font(.system(size: 16, weight: .medium)).foregroundColor(.white)
                                Spacer()
                                Toggle("", isOn: $appState.personalizationEnabled).labelsHidden().tint(.green)
                            }
                            .padding(.horizontal, 16).padding(.vertical, 14)
                            .glassEffect(.regular.interactive().tint(.green))
                            .glassEffectID(persNamespace, in: "toggleGlass")
                            
                            // Custom instructions — regular glass
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Custom Instructions").font(.system(size: 13, weight: .medium)).foregroundColor(Color(hex: "#9CA3AF")).padding(.leading, 4)
                                
                                ZStack(alignment: .bottomTrailing) {
                                    TextEditor(text: $instructions).foregroundColor(.white).font(.system(size: 15)).scrollContentBackground(.hidden).background(Color.clear).frame(minHeight: 160)
                                        .overlay(Group { if instructions.isEmpty { Text("Customize how the AI responds").foregroundColor(.white.opacity(0.2)).font(.system(size: 15)).padding(.top, 8).padding(.leading, 5).allowsHitTesting(false) } }, alignment: .topLeading)
                                    Text("\(instructions.count)/1 000").font(.system(size: 12)).foregroundColor(.white.opacity(0.25)).padding(8)
                                }
                                .padding(12)
                                .glassEffect(.regular)
                                .glassEffectID(persNamespace, in: "instructionsGlass")
                            }
                            
                            // Temperature — regular glass with orange tint
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Temperature").font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
                                    Spacer()
                                    Menu {
                                        ForEach(temperatureOptions, id: \.self) { option in Button(option) { withAnimation { temperatureOption = option } } }
                                    } label: {
                                        HStack(spacing: 4) {
                                            Text(temperatureOption).font(.system(size: 15)).foregroundColor(.white.opacity(0.45))
                                            Image(systemName: "chevron.up.chevron.down").font(.system(size: 11)).foregroundColor(.white.opacity(0.35))
                                        }.padding(.horizontal, 10).padding(.vertical, 6)
                                    }
                                    .glassEffect(.clear.interactive())
                                }
                                .padding(.horizontal, 16).padding(.vertical, 14)
                                .glassEffect(.regular.interactive().tint(.orange))
                                .glassEffectID(persNamespace, in: "tempGlass")
                                
                                Text("Controls randomness in responses. Lower values make the AI more focused and deterministic, while higher values make it more creative and unpredictable.")
                                    .font(.system(size: 13)).foregroundColor(.white.opacity(0.3)).padding(.horizontal, 4)
                            }
                        }
                        .padding(.horizontal, 16).padding(.top, 8).padding(.bottom, 32)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear { instructions = appState.customInstructions }
    }
}
