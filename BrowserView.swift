import SwiftUI

struct BrowserView: View {
    @EnvironmentObject var appState: AppState
    @State private var url: String = "https://www.google.com"
    
    var body: some View {
        ZStack {
            Color.clear
            
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.green)
                        TextField("Enter URL", text: $url)
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .glassCapsule(opacity: 0.07)
                    
                    Button(action: {}) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                Spacer()
                
                VStack(spacing: 16) {
                    Image(systemName: "globe")
                        .font(.system(size: 48))
                        .foregroundColor(.white.opacity(0.12))
                    Text("Browser")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white.opacity(0.35))
                    Text("Web browsing coming soon")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.2))
                }
                
                Spacer()
            }
        }
    }
}
