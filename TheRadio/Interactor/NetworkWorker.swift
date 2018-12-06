//
//  NetworkWorker.swift
//  TheRadio
//
//  Created by Roman Rosul on 23/11/18.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import SystemConfiguration

protocol NetworkWorkerInterface {
    var isNetworkReachable:Bool { get }
    func stopWatchingConnection()
    func startWatchingConnection()
}

class NetworkWorker: NSObject, NetworkWorkerInterface {
   
    fileprivate weak var interactor: InteractorInterface?
    private var reachability = SCNetworkReachabilityCreateWithName(nil, GeneralURLs.stream.rawValue)
    private var currentReachabilityFlags: SCNetworkReachabilityFlags?
    private var isListening = false
    var timer: Timer?

    var isNetworkReachable: Bool {
        return connectedToNetwork(true)
    }
    
    func stopWatchingConnection() {
        isListening = false
    }
    
    func startWatchingConnection() {
        isListening = true
    }
    
    init(_ interactorInstance: Interactor) {
        super.init()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerEvent), userInfo: nil, repeats: true)
        interactor = interactorInstance
    }
    
    @objc func timerEvent() {
        guard isListening == true else { return }
        checkReachability()
    }
    
     func checkReachability() {
        guard let reachability = reachability else { return }
        var flags: SCNetworkReachabilityFlags
        flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        
        if currentReachabilityFlags != flags {
            currentReachabilityFlags = flags
            if connectedToNetwork(false) {
                interactor?.connectionEstablished()
            } else {
                interactor?.connectionLost()
            }
        }
    }
    
    private func connectedToNetwork(_ forceRefresh: Bool) -> Bool {
        if forceRefresh {
            isListening = false
            checkReachability()
            isListening = true
        }
        guard let currentReachabilityFlags = currentReachabilityFlags else { return false }
        let isReachable = currentReachabilityFlags.contains(.reachable)
        let needsConnection = currentReachabilityFlags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}


