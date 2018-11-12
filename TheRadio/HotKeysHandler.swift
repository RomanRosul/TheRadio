//
//  HotKeysHandler.swift
//  TheRadio
//
//  Created by Roman Rosul on 12/11/18.
//  Copyright © 2018 INDI. All rights reserved.
//

import Cocoa
import SPMediaKeyTapFramework

class HotKeysHandler: NSObject {
    var audioPlayerHandler: AudioPlayerHandlerInterface?
    
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
                audioPlayerHandler?.play()
                break
            default:
                break
            }
        }
    }
    
}
