//
//  Constants.swift
//  TheRadio
//
//  Created by Roman Rosul on 12/11/18.
//  Copyright © 2018 INDI. All rights reserved.
//

import Foundation

enum GeneralURLs: String {
    case website = "http://www.yedenradio.com/"
    case facebook = "https://www.facebook.com/radioyeden/"
    case stream = "http://31.128.79.192:8000/live"
}

enum PlayerStatusTitles: Int {
    case isPaused = 0
    case isWaiting = 1
    case isPlaying = 2
    
    func title() -> String {
        switch self {
        case .isPaused:
            return "Play"
        case .isWaiting:
            return "Please Wait..."
        case .isPlaying:
            return "Pause"
            
        }
    }
}

