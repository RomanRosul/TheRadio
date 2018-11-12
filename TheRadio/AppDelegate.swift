//
//  AppDelegate.swift
//  TheRadio
//
//  Created by Roman Rosul on 05.10.18.
//  Copyright © 2018 INDI. All rights reserved.
//

import Cocoa
import SPMediaKeyTapFramework

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var keyTap: SPMediaKeyTap?
    var mediaKeysHandler: HotKeysHandler?
    
    override init () {
        super.init()
        guard let check = SPMediaKeyTap.defaultMediaKeyUserBundleIdentifiers() else { return }
        var keys = Dictionary<String, Any>()
        for item in check {
           keys[item as! String] = kMediaKeyUsingBundleIdentifiersDefaultsKey
        }
        UserDefaults.standard.register(defaults:keys)
        mediaKeysHandler = HotKeysHandler()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        keyTap = SPMediaKeyTap(delegate: mediaKeysHandler)
        
        if SPMediaKeyTap.usesGlobalMediaKeyTap() {
            keyTap?.startWatchingMediaKeys()
        } else {
            print("Media key monitoring disabled")
        }
    }

}

