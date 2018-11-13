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
    let reachability = Reachability()!
    var isPausedManually: Bool = false
    
    override init() {
        super.init()
        setupReachability()
    }
    
    deinit {
        observation?.invalidate()
    }
    
    func play() {
        if reachability.connection != Reachability.Connection.none {
            if let player = player {
                if player.timeControlStatus == .playing {
                    player.pause()
                    isPausedManually = true
                    return
                } else if player.timeControlStatus == .paused {
                    reload()
                    player.play()
                    isPausedManually = false
                }
            } else {
                setupPlayer()
                player?.play()
                isPausedManually = false
            }
        } else {
            isPausedManually = !isPausedManually
            statusMenu?.setStatusItemTitle("No Internet Connection")
            statusMenu?.setStatusItemImage(PlayerStatusList.isWaiting.icon())
        }
    }
    
    func reload() {
        self.player?.replaceCurrentItem(with: setupPlayerItem())
    }
    
    func handleInteruptions() {
        //TODO:
        //        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeDefault)
        //        try? AVAudioSession.sharedInstance().setActive(true)
//        https://blog.erikvdwal.nl/resuming-avplayer-after-being-interrupted/
    }
    
    func setupPlayerItem() -> AVPlayerItem? {
        let path = GeneralURLs.stream.rawValue
        guard let url = URL.init(string: path) else { return nil}
        return AVPlayerItem.init(url: url)
    }
    
    func setupReachability() {
        
        reachability.whenReachable = { [weak self]  reachability in
            if self?.isPausedManually == false {
                self?.reload()
                self?.play()
            } else {
                let newStatus = self?.player?.timeControlStatus
                if let status = newStatus?.rawValue, let newTitle = PlayerStatusList(rawValue: status)?.title() {
                    self?.statusMenu?.setStatusItemTitle(newTitle)
                }
            }
        }
        
        reachability.whenUnreachable = { [weak self] _ in
            self?.statusMenu?.setStatusItemTitle("No Internet Connection")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func setupPlayer() {
        
        player = AVPlayer.init(playerItem: setupPlayerItem())
        
        let statusKeyPath = \AVPlayer.timeControlStatus
        observation = player?.observe(statusKeyPath, options: [.initial, .old]) { [weak self] (player, change) in
            let newStatus = player.timeControlStatus
            if let newTitle = PlayerStatusList(rawValue: newStatus.rawValue)?.title() {
                if self?.reachability.connection != Reachability.Connection.none {
                    self?.statusMenu?.setStatusItemTitle(newTitle)
                }
            }
            
            if let newIcon = PlayerStatusList(rawValue: newStatus.rawValue)?.icon() {
                self?.statusMenu?.setStatusItemImage(newIcon)
            }
        }
    }

}
