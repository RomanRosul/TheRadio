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
        alert.messageText = "The Radio"
        alert.informativeText = "\"The Radio\" is an open source app, distributed under MIT license. It is configured for playing a stream of YedenRadio.com, and is tried to make you happy. Please notice \"The Radio\" is not responsible for any content on YedenRadio.com. It doesn’t check in any way the accuracy or completeness of the information delivered. \"The Radio\" does not accept any liability arising from inaccuracy or omission in this information."
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
