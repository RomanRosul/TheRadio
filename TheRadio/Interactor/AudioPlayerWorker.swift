//
//  AudioPlayerWorker.swift
//  TheRadio
//
//  Created by Roman Rosul on 12/11/18.
//  Copyright © 2018 . All rights reserved.
//

import Cocoa
import AVFoundation

protocol AudioPlayerWorkerInterface {
    func togglePlayStatusManually()
    func forcePlay()
    func stopPlayer()
}

class AudioPlayerWorker: NSObject {
    var player: AVPlayer?
    fileprivate weak var interactor: InteractorInterface?
    
    var playerStatusObserver: AnyObject?
    var isPausedManually: Bool = false
    
    init(_ interactorInstance: Interactor) {
        super.init()
        interactor = interactorInstance
    }
    
    deinit {
        playerStatusObserver?.invalidate()
    }
    
   fileprivate func setupPlayerItem() -> AVPlayerItem? {
        let path = GeneralURLs.stream.rawValue
        guard let url = URL.init(string: path) else { return nil}
        let item = AVPlayerItem.init(url: url)
        item.canUseNetworkResourcesForLiveStreamingWhilePaused = true
        return item
    }
    
    fileprivate func setupPlayer() {
        isPausedManually = false
        player = AVPlayer.init(playerItem: setupPlayerItem())
        
        let statusKeyPath = \AVPlayer.timeControlStatus
        playerStatusObserver = player?.observe(statusKeyPath, options: [.initial, .old]) { [weak self] (player, change) in
            if let newStatus = PlayerStatusList(rawValue: player.timeControlStatus.rawValue) {
                self?.interactor?.playerStatusChanged(status: newStatus)
            }
        }
        if isPausedManually {
            return
        }
        player?.play()
    }

}

extension AudioPlayerWorker: AudioPlayerWorkerInterface {
    
    func forcePlay(){
        if player == nil {
            setupPlayer()
            return
        }
        player?.replaceCurrentItem(with: setupPlayerItem())
        if isPausedManually {
            player?.pause()
        } else {
            player?.play()
        }
    }
    
    func togglePlayStatusManually() {
        isPausedManually = !isPausedManually

        if player?.timeControlStatus == .paused {
            player?.play()
        } else {
            player?.pause()
        }
    }
    
    func stopPlayer() {
        player?.pause()
        playerStatusObserver?.invalidate()
        player = nil
    }
    
}
