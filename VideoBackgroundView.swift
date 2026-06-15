import SwiftUI
import AVFoundation

// MARK: - Looping Video Background
// Plays video in loop, slowed down, with 2-second gap between loops
struct VideoBackgroundView: UIViewRepresentable {
    let videoName: String
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        guard let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") else {
            print("Video not found: \(videoName).mp4")
            return view
        }
        
        let player = AVPlayer(url: url)
        player.actionAtItemEnd = .none
        
        // Slow down playback to ~0.7x speed
        player.rate = 0.7
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)
        
        // Loop with 2-second delay after video ends
        let controller = PlayerController(player: player)
        context.coordinator.controller = controller
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            // Wait 2 seconds then restart
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                player.seek(to: .zero)
                player.play()
            }
        }
        
        player.play()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let layer = uiView.layer.sublayers?.first as? AVPlayerLayer {
            layer.frame = uiView.bounds
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var controller: PlayerController?
    }
    
    class PlayerController {
        let player: AVPlayer
        init(player: AVPlayer) { self.player = player }
    }
}
