//
//  MainMenuViewController
//  TheRadio
//
//  Created by Roman Rosul on 5/11/18.
//  Copyright © 2018 . All rights reserved.
//

protocol MainMenuViewControllerInterface: class {
    func setStatusItemTitle(_ title: String)
    func setStatusItemImage(_ image: NSImage?)
}

import Cocoa

class MainMenuViewController: NSObject {
    
    @IBOutlet weak var mainMenuView: NSMenu!
    @IBOutlet weak var playerStatusMenuItem: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var interactor: InteractorInterface?
    
    //MARK: LifeCycle
    
    override func awakeFromNib() {
        let icon = NSImage(named: "logoYedenOn")
        setStatusItemImage(icon)
        statusItem.menu = mainMenuView
        Configurator.sharedInstance.configure(self)
    }
    
    //MARK: Actions

    @IBAction func quitClicked(sender: NSMenuItem) {
        interactor?.handleQuitTap()
    }
    
    @IBAction func playPauseClicked(sender: NSMenuItem) {
        interactor?.handlePlayTap(sender:sender)
    }
    
    @IBAction func facebookClicked(sender: NSMenuItem) {
        interactor?.handleFacebookTap()
    }
    
    @IBAction func webClicked(sender: NSMenuItem) {
        interactor?.handleWebTap()
    }
    
    @IBAction func aboutClicked(sender: NSMenuItem) {
        interactor?.handleAboutTap()
    }
    
}

extension MainMenuViewController: MainMenuViewControllerInterface {
    
    func setStatusItemTitle(_ title: String) {
        playerStatusMenuItem.title = title
    }
    
    func setStatusItemImage(_ image: NSImage?) {
        image?.isTemplate = true
        statusItem.image = image
    }
}
