//
//  NetworkWorker.swift
//  TheRadio
//
//  Created by Roman Rosul on 23/11/18.
//  Copyright © 2018 INDI. All rights reserved.
//

import Foundation

protocol NetworkWorkerInterface {
    var isNetworkReachable:Bool { get }
}

class NetworkWorker: NSObject, NetworkWorkerInterface {
   
    fileprivate weak var interactor: InteractorInterface?
    var reachability = Reachability(hostname: GeneralURLs.stream.rawValue)!
    var isNetworkReachable: Bool = false
    
    init(_ interactorInstance: Interactor) {
        super.init()
        interactor = interactorInstance
        setup()
    }
    
    func setup() {

        reachability.whenReachable = { [weak self]  reachability in
            self?.reachability = Reachability(hostname: GeneralURLs.stream.rawValue)!
            self?.isNetworkReachable = true
            self?.interactor?.connectionAlive()
        }
        
        reachability.whenUnreachable = { [weak self] _ in
            self?.isNetworkReachable = false
            self?.interactor?.connectionLost()
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

}


