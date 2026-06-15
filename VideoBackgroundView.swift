import SwiftUI
import AVFoundation

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
}

@MainActor
class LoopingVideoPlayerView: UIView {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var observer: NSObjectProtocol?
    
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
        self.observer = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                player.seek(to: .zero)
                player.play()
            }
        }
        
        // Slow playback
        player.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            player.rate = 0.7
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
    
    deinit {
        if let obs = observer {
            NotificationCenter.default.removeObserver(obs)
        }
    }
}
