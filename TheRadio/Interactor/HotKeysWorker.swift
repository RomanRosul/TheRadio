//
//  HotKeysWorker.swift
//  TheRadio
//
//  Created by Roman Rosul on 12/11/18.
//  Copyright © 2018 INDI. All rights reserved.
//

import Cocoa
import SPMediaKeyTapFramework

class HotKeysWorker: NSObject {
    fileprivate var keyTap: SPMediaKeyTap?
    fileprivate var isAccessibilityAccessGranted: Bool = false
    fileprivate weak var interactor: InteractorInterface?
    
    init(_ interactorInstance: Interactor) {
        super.init()
        interactor = interactorInstance
        let askPrivilegesFlag = UserDefaults.standard.bool(forKey: "askPrivilegesFlag")
        isAccessibilityAccessGranted = acquirePrivileges(askUserIfNeeded: !askPrivilegesFlag)
        UserDefaults.standard.set(true, forKey: "askPrivilegesFlag")
        setupMediaKeysHandler()
    }
    
    //MARK: MediaKeysHandlerSetup
    fileprivate func setupMediaKeysHandler() {
        guard isAccessibilityAccessGranted == true, let appIdsList = SPMediaKeyTap.defaultMediaKeyUserBundleIdentifiers() else { return }
        var keys = Dictionary<String, Any>()
        for appId in appIdsList {
            keys[appId as! String] = kMediaKeyUsingBundleIdentifiersDefaultsKey
        }
        UserDefaults.standard.register(defaults:keys)
        startMediaKeysHandler()
    }
    
    fileprivate func startMediaKeysHandler() {
        guard isAccessibilityAccessGranted == true else { return }
        keyTap = SPMediaKeyTap(delegate: self)
        
        if SPMediaKeyTap.usesGlobalMediaKeyTap() {
            keyTap?.startWatchingMediaKeys()
        } else {
            print("Media key monitoring disabled")
        }
    }
    
    //MARK: CheckAccessibilityPrivileges

    fileprivate func acquirePrivileges(askUserIfNeeded: Bool) -> Bool {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: askUserIfNeeded]
        let accessEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary)
        
        if accessEnabled != true {
            print("You need to grant access in the System Preferences")
        }
        return accessEnabled == true
    }
    
    //MARK: MediaKeysHandlerDelegate

    override func mediaKeyTap(_ keyTap: SPMediaKeyTap, receivedMediaKeyEvent event:NSEvent) {
        let shouldHandleMediaKeyEventLocally = SPMediaKeyTap.usesGlobalMediaKeyTap()
        
        if (shouldHandleMediaKeyEventLocally && event.type == .systemDefined && event.subtype.rawValue == 8) {
            let keyCode = ((event.data1 & 0xFFFF0000) >> 16)
            let keyFlags = (event.data1 & 0x0000FFFF)
            // Get the key state. 0xA is KeyDown, OxB is KeyUp
            let keyState = (((keyFlags & 0xFF00) >> 8)) == 0xA
            let keyRepeat = (keyFlags & 0x1)
            mediaKeyEvent(key: Int32(keyCode), state: keyState, keyRepeat: Bool(truncating: keyRepeat as NSNumber))
        }
    }

    func mediaKeyEvent(key: Int32, state: Bool, keyRepeat: Bool) {
        // Only send events on KeyDown. Without this check, these events will happen twice
        if (state) {
            switch(key) {
            case NX_KEYTYPE_PLAY:
                interactor?.handlePlayTap(sender: nil)
                break
            default:
                break
            }
        }
    }
    
}
