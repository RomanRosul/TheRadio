//
//  NetworkWorker.swift
//  TheRadio
//
//  Created by Roman Rosul on 23/11/18.
//  Copyright © 2018 INDI. All rights reserved.
//

import Foundation
import SystemConfiguration

protocol NetworkWorkerInterface {
    var isNetworkReachable:Bool { get }
}

class NetworkWorker: NSObject, NetworkWorkerInterface {
   
    fileprivate weak var interactor: InteractorInterface?
    private let reachability = SCNetworkReachabilityCreateWithName(nil, GeneralURLs.stream.rawValue)
    private var currentReachabilityFlags: SCNetworkReachabilityFlags?
    private var isListening = false
    var timer: Timer?

    var isNetworkReachable: Bool {
        return connectedToNetwork()
    }
    
    init(_ interactorInstance: Interactor) {
        super.init()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkReachability), userInfo: nil, repeats: true)
        interactor = interactorInstance
    }
    
    @objc func checkReachability() {
        guard let reachability = reachability, isListening == true else { return }
        var flags: SCNetworkReachabilityFlags
        flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        
        if currentReachabilityFlags != flags {
            //changed here
            currentReachabilityFlags = flags
            print("*** flags set")
        }
        print("*** check reachability")
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        let out = "*** " + (isReachable ? "isReachable" : "NotisReachable") + " " + (needsConnection ? "needsConnection" : "NoneedsConnection")
        
        print(out)
    }
    
//    func stop() {
//
//        guard isListening,let reachability = reachability else { return }
//
//        // Remove callback and dispatch queue
//        SCNetworkReachabilitySetCallback(reachability, nil, nil)
//        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
//
//        isListening = false
//    }
    
    private func connectedToNetwork() -> Bool {
        guard let reachability = reachability else { return false }
        var flags: SCNetworkReachabilityFlags
//        SCNetworkReachabilityGetFlags(reachability, &flags)
        
//        if let currentReachabilityFlags = currentReachabilityFlags {
//            flags = currentReachabilityFlags
//            print("*** current flags used")
//        } else {
            flags = SCNetworkReachabilityFlags()
            SCNetworkReachabilityGetFlags(reachability, &flags)
//            start()
//        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
//        let out = "*** " + (isReachable ? "isReachable" : "NotisReachable") + " " + (needsConnection ? "needsConnection" : "NoneedsConnection")
//
//        print(out)
        
        return (isReachable && !needsConnection)
    }
    
}


