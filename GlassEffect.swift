import SwiftUI

// MARK: - Glass Effect View Modifiers
// Reusable glassmorphism styling matching reference design:
// Frosted glass backgrounds, subtle white borders, soft shadows, glow effects

extension View {
    /// Primary glass effect — frosted material background with subtle white border and shadow
    func glassEffect(cornerRadius: CGFloat = 16) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.25),
                                Color.white.opacity(0.08)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.8
                    )
            )
            .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
    }
    
    /// Capsule glass effect — for buttons, chips, badges
    func glassCapsule(cornerRadius: CGFloat = .infinity) -> some View {
        self
            .background(
                Capsule(style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.22),
                                Color.white.opacity(0.06)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.7
                    )
            )
            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    }
    
    /// Circle glass effect — for icon buttons
    func glassCircle(size: CGFloat) -> some View {
        self
            .frame(width: size, height: size)
            .background(
                Circle()
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                Circle()
                    .stroke(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.white.opacity(0.05)
                            ],
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: size
                        ),
                        lineWidth: 0.7
                    )
            )
            .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 3)
    }
    
    /// Subtle glass row effect — for list rows, settings items
    func glassRow(cornerRadius: CGFloat = 14) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
            )
    }
    
    /// Glass section container — for grouped sections with inner content
    func glassSection(cornerRadius: CGFloat = 18) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.2),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 0.8
                    )
            )
            .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 8)
    }
    
    /// Popup overlay glass — for modals, dropdowns
    func glassPopup(cornerRadius: CGFloat = 16) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.regularMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.white.opacity(0.1),
                                Color.white.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.4), radius: 24, x: 0, y: 12)
    }
    
    /// Glow effect — adds a soft colored glow behind content
    func glowEffect(color: Color = .white, radius: CGFloat = 12, opacity: Double = 0.15) -> some View {
        self
            .shadow(color: color.opacity(opacity), radius: radius, x: 0, y: 0)
            .shadow(color: color.opacity(opacity * 0.5), radius: radius * 2, x: 0, y: 0)
    }
    
    /// Active state glow — purple/blue glow for selected items
    func activeGlow() -> some View {
        self
            .shadow(color: Color(red: 0.5, green: 0.3, blue: 0.9).opacity(0.25), radius: 10, x: 0, y: 0)
            .shadow(color: Color(red: 0.3, green: 0.4, blue: 1.0).opacity(0.15), radius: 20, x: 0, y: 0)
    }
    
    /// Inner glow highlight — top edge shine on glass surfaces
    func innerGlow(cornerRadius: CGFloat = 16) -> some View {
        self
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.08),
                                Color.clear
                            ],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
                    .allowsHitTesting(false)
            )
    }
    
    /// Glass card — complete card with material, border, shadow, and inner glow
    func glassCard(cornerRadius: CGFloat = 20) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.regularMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.28),
                                Color.white.opacity(0.08)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.06),
                                Color.clear
                            ],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
                    .allowsHitTesting(false)
            )
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
    
    /// Glass input field — text field with glass styling
    func glassInput(cornerRadius: CGFloat = 16) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.18),
                                Color.white.opacity(0.06)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.8
                    )
            )
            .innerGlow(cornerRadius: cornerRadius)
    }
    
    /// Glass divider — subtle glass-styled separator
    func glassDivider(leadingInset: CGFloat = 0) -> some View {
        self
            .background(
                LinearGradient(
                    colors: [
                        Color.clear,
                        Color.white.opacity(0.1),
                        Color.clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }
}

// MARK: - Glass Button Styles
struct GlassButtonStyle: ButtonStyle {
    var cornerRadius: CGFloat = 12
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.22),
                                Color.white.opacity(0.06)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.7
                    )
            )
            .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 3)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
    }
}

// MARK: - Glass Sheet Presentation Modifier
struct GlassSheetBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Deep background matching main app
                    Color(red: 0.05, green: 0.05, blue: 0.08)
                    
                    // Subtle gradient overlay for depth
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.15, green: 0.08, blue: 0.25).opacity(0.5),
                            Color(red: 0.05, green: 0.05, blue: 0.08).opacity(0.8)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .ignoresSafeArea()
            )
    }
}

extension View {
    func glassSheetBackground() -> some View {
        modifier(GlassSheetBackground())
    }
}
