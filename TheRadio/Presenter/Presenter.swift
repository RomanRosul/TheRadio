//
//  Presenter.swift
//  TheRadio
//
//  Created by Roman Rosul on 25/11/18.
//  Copyright © 2018 . All rights reserved.
//

import Cocoa

protocol PresenterInterface {
    func displayStatus(_ status:PlayerStatusList)
    func openURL(_ url: URL)
    func displayAbout()
}

class Presenter: NSObject {
    fileprivate weak var view: MainMenuViewControllerInterface?
    
    init(_ viewInstance: MainMenuViewController) {
        super.init()
        view = viewInstance
    }
}

extension Presenter: PresenterInterface {
    func displayStatus(_ status: PlayerStatusList) {
        view?.setStatusItemImage(status.icon())
        view?.setStatusItemTitle(status.title())
    }
    
    func openURL(_ url: URL) {
        NSWorkspace.shared.open(url)
    }
    
    func displayAbout() {
        let alert = NSAlert()
        alert.messageText = "The Radio Player"
        alert.informativeText = "The app is just for fun"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "MORE..")
        alert.addButton(withTitle: "OK")
        let result = alert.runModal()
        if result == NSApplication.ModalResponse.alertFirstButtonReturn {
            if let repoUrl = URL(string: GeneralURLs.repo.rawValue) {
                openURL(repoUrl)
            }
        }
    }
}
