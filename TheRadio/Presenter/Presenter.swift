//
//  Presenter.swift
//  TheRadio
//
//  Created by Roman Rosul on 25/11/18.
//  Copyright © 2018 INDI. All rights reserved.
//

import Cocoa

protocol PresenterInterface {
    func displayStatus(_ status:PlayerStatusList)
    func openURL(_ url: URL)
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
}
