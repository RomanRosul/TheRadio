//
//  AudioPlayerHandler.swift
//  TheRadio
//
//  Created by Roman Rosul on 12/11/18.
//  Copyright © 2018 INDI. All rights reserved.
//

import Cocoa
import AVFoundation

protocol AudioPlayerHandlerInterface {
    func play()
}

class AudioPlayerHandler: NSObject, AudioPlayerHandlerInterface {
    var player: AVPlayer?
    var statusMenu: StatusMenuControllerInterface?
    var observation: AnyObject?
    
    deinit {
        observation?.invalidate()
    }
    
    func play() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
                return
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        } else {
            setupPlayer()
            player?.play()
        }
    }
    
    func setupPlayer() {
        let path = GeneralURLs.stream.rawValue
        guard let url = URL.init(string: path) else { return }
        let playerItem = AVPlayerItem.init(url: url)
        player = AVPlayer.init(playerItem: playerItem)
        let statusKeyPath = \AVPlayer.timeControlStatus
        
        observation = player?.observe(statusKeyPath, options: [.initial, .old]) { [weak self] (player, change) in
            let newStatus = player.timeControlStatus
            if let newTitle = PlayerStatusTitles(rawValue: newStatus.rawValue)?.title() {
                self?.statusMenu?.setStatusItemTitle(newTitle)
            }

//            switch player.timeControlStatus {
//            case .paused:
//                print("*** Player status: paused")
//
//            case .waitingToPlayAtSpecifiedRate:
//                print("*** Player status: waiting")
//
//            case .playing:
//                print("*** Player status: playing")
//
//            }
        }
    }

}
