//
//  StatusMenuController.swift
//  TheRadio
//
//  Created by Roman Rosul on 5/11/18.
//  Copyright © 2018 INDI. All rights reserved.
//

import Cocoa
import AVFoundation

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var playPauseMenuItem: NSMenuItem!

    var player: AVPlayer!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override func awakeFromNib() {
        let icon = NSImage(named: "statusBarIcon")
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        play()
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func playPauseClicked(sender: NSMenuItem) {
        play()
    }
    
    @IBAction func facebookClicked(sender: NSMenuItem) {
        if let fbUrl = URL(string: "https://www.facebook.com/radioyeden/") {
            NSWorkspace.shared.open(fbUrl)
        }
    }
    
    @IBAction func webClicked(sender: NSMenuItem) {
        if let webUrl = URL(string: "http://www.yedenradio.com/") {
            NSWorkspace.shared.open(webUrl)
        }
    }
    
    func play() {
        if player?.timeControlStatus == .playing {
            player.pause()
            playPauseMenuItem.title = "Play"
            return
        }
        let path = "http://31.128.79.192:8000/live"
        guard let url = URL.init(string: path)
            else {
                return
        }
        let playerItem = AVPlayerItem.init(url: url)
        player = AVPlayer.init(playerItem: playerItem)
        
        player.play()
        playPauseMenuItem.title = "Pause"
    }

}
