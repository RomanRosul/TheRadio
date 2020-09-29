//
//  Constants.swift
//  TheRadio
//
//  Created by Roman Rosul on 12/11/18.
//  Copyright © 2018 . All rights reserved.
//

import Cocoa

enum GeneralURLs: String {
    case website = "http://www.yedenradio.com/"
    case facebook = "https://www.facebook.com/radioyeden/"
    case stream = "http://live.yedenradio.com:9015/yedenradio" 
    case repo = "https://github.com/RomanRosul/TheRadio/blob/master/README.md"
}

enum PlayerStatusList: Int {
    case isPaused = 0
    case isWaiting = 1
    case isPlaying = 2
    case isNetworkLost = 3

    
    func title() -> String {
        switch self {
        case .isPaused:
            return "Play"
        case .isWaiting:
            return "Loading..."
        case .isPlaying:
            return "Pause"
        case .isNetworkLost:
            return "No Internet Connection"
        }
    }
    
    func icon() -> NSImage? {
        switch self {
        case .isPaused:
            return NSImage(named: "logoYedenOff")
        case .isWaiting:
            return NSImage(named: "logoYedenWait")
        case .isPlaying:
            return NSImage(named: "logoYedenOn")
        case .isNetworkLost:
            return NSImage(named: "logoYedenOff")
        }
    }
    
}

