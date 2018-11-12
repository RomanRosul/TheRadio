//
//  StatusMenuController.swift
//  TheRadio
//
//  Created by Roman Rosul on 5/11/18.
//  Copyright © 2018 INDI. All rights reserved.
//

//StatusMenuController and AudioPlayerHandler bind by delegate

protocol StatusMenuControllerInterface {
    func setStatusItemTitle(_ title: String)
}

import Cocoa

class StatusMenuController: NSObject {
    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var playerStatusMenuItem: NSMenuItem!
    
    var audioPlayerHandler: AudioPlayerHandlerInterface?
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    //MARK: LifeCycle
    
    override func awakeFromNib() {
        let icon = NSImage(named: "statusBarIcon")
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        buildAllInstances()
        
        audioPlayerHandler?.play()
    }
    
    func buildAllInstances() {
        let audioPlayerHandlerInstance = AudioPlayerHandler()
        audioPlayerHandlerInstance.statusMenu = self
        audioPlayerHandler = audioPlayerHandlerInstance
        
        (NSApplication.shared.delegate as? AppDelegate)?.mediaKeysHandler?.audioPlayerHandler = audioPlayerHandlerInstance
    }
    
    //MARK: Actions

    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func playPauseClicked(sender: NSMenuItem) {
        audioPlayerHandler?.play()
        sender.isEnabled = false
    }
    
    @IBAction func facebookClicked(sender: NSMenuItem) {
        if let fbUrl = URL(string: GeneralURLs.facebook.rawValue) {
            NSWorkspace.shared.open(fbUrl)
        }
    }
    
    @IBAction func webClicked(sender: NSMenuItem) {
        if let webUrl = URL(string: GeneralURLs.website.rawValue) {
            NSWorkspace.shared.open(webUrl)
        }
    }
    
}

extension StatusMenuController: StatusMenuControllerInterface {
    
    func setStatusItemTitle(_ title: String) {
        playerStatusMenuItem.title = title
    }
}
