//
//  VideoPlayer.swift
//  JID.COM
//
//  Created by Panda on 08/05/24.
//

import Foundation
import SwiftUI
import AVFoundation
import AVKit

struct PlayerVidio : UIViewControllerRepresentable {

    @State var player : AVPlayer
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PlayerVidio>) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = true
        controller.videoGravity = .resize
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}
