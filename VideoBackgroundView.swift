import SwiftUI
import AVFoundation

// MARK: - Gradient Background (matching reference design)
struct GradientBackgroundView: View {
    var body: some View {
        ZStack {
            // Deep purple/violet at top transitioning to dark navy/black
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.35, green: 0.15, blue: 0.65),  // Vibrant purple
                    Color(red: 0.15, green: 0.1, blue: 0.35),   // Deep violet
                    Color(red: 0.05, green: 0.05, blue: 0.15),  // Dark navy
                    Color(red: 0.02, green: 0.02, blue: 0.05)   // Near black
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
}

// MARK: - Looping Video Background
// Plays video in loop, slowed down, with 2-second gap between loops
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
        
        // Observe end to loop with 2s delay
        self.token = playerItem.observe(\.status, options: [.new]) { _, _ in }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(itemDidFinish),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
        
        // Slow playback
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
