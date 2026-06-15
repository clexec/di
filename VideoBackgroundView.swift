import SwiftUI
import AVFoundation

// MARK: - Gradient Background (matching reference design — deep purple to dark navy)
struct GradientBackgroundView: View {
    var body: some View {
        ZStack {
            // Richer, deeper gradient matching reference photos
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.45, green: 0.15, blue: 0.75),  // Vibrant purple top
                    Color(red: 0.30, green: 0.10, blue: 0.55),  // Deep violet
                    Color(red: 0.18, green: 0.08, blue: 0.35),  // Dark indigo
                    Color(red: 0.08, green: 0.05, blue: 0.18),   // Dark navy
                    Color(red: 0.03, green: 0.02, blue: 0.06)   // Near black bottom
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Subtle radial glow at top center for depth
            RadialGradient(
                colors: [
                    Color(red: 0.5, green: 0.2, blue: 0.8).opacity(0.15),
                    Color.clear
                ],
                center: .top,
                startRadius: 0,
                endRadius: 500
            )
            .ignoresSafeArea()
        }
    }
}

// MARK: - Looping Video Background
struct VideoBackgroundView: UIViewRepresentable {
    let videoName: String
    
    func makeUIView(context: Context) -> UIView {
        let view = LoopingVideoPlayerView(frame: .zero)
        view.setup(videoName: videoName)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        uiView.frame = uiView.superview?.bounds ?? .zero
        if let playerView = uiView as? LoopingVideoPlayerView {
            playerView.resizeLayer()
        }
    }
    
    static func dismantleUIView(_ uiView: UIView, coordinator: ()) {
        if let playerView = uiView as? LoopingVideoPlayerView {
            playerView.cleanup()
        }
    }
}

class LoopingVideoPlayerView: UIView {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var token: Any?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    func setup(videoName: String) {
        guard let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") else {
            print("Video not found: \(videoName).mp4")
            return
        }
        setupPlayer(url: url)
    }
    
    private func setupPlayer(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: playerItem)
        player.actionAtItemEnd = .none
        player.isMuted = true
        
        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        layer.frame = self.bounds
        self.layer.addSublayer(layer)
        self.playerLayer = layer
        self.player = player
        
        self.token = playerItem.observe(\.status, options: [.new]) { _, _ in }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(itemDidFinish),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
        
        player.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            player.rate = 0.7
        }
    }
    
    @objc private func itemDidFinish(_ notification: Notification) {
        guard let player = player else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            player.seek(to: .zero)
            player.play()
        }
    }
    
    func resizeLayer() {
        if let layer = playerLayer {
            layer.frame = self.bounds
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = self.bounds
    }
    
    func cleanup() {
        NotificationCenter.default.removeObserver(self)
        player?.pause()
        player = nil
    }
}
