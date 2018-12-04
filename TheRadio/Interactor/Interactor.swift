//
//  Interactor.swift
//  TheRadio
//
//  Created by Roman Rosul on 25/11/18.
//  Copyright © 2018 INDI. All rights reserved.
//

import Cocoa

protocol InteractorInterface: class {
    func handlePlayTap(sender: AnyObject?)
    func handleQuitTap()
    func handleFacebookTap()
    func handleWebTap()
    func connectionLost()
    func connectionEstablished()
    func playerStatusChanged(status:PlayerStatusList)
}

class Interactor: NSObject {
    
    fileprivate var presenter: PresenterInterface?
    
    fileprivate var mediaKeysWorker: Any?
    fileprivate var audioPlayerWorker: AudioPlayerWorkerInterface?
    fileprivate var networkWorker: NetworkWorkerInterface?
    
    init(_ presenterInstance: Presenter) {
        super.init()
        presenter = presenterInstance
    }
    
    func setWorkers(audioPlayerWorkerInstance: AudioPlayerWorker, mediaKeysWorkerInstance: HotKeysWorker, networkWorkerInstance: NetworkWorker) {
        mediaKeysWorker = mediaKeysWorkerInstance
        networkWorker = networkWorkerInstance
        audioPlayerWorker = audioPlayerWorkerInstance
        audioPlayerWorker?.forcePlay()
    }
    
 //TODO:   func handleInteruptions() {
//        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeDefault)
//        try? AVAudioSession.sharedInstance().setActive(true)
//        https://blog.erikvdwal.nl/resuming-avplayer-after-being-interrupted/
//    }
   
}

extension Interactor: InteractorInterface {
    
    func handlePlayTap(sender: AnyObject?) {
        let willPlay = audioPlayerWorker?.togglePlayStatusManually() == true
        if willPlay {
            networkWorker?.startWatchingConnection()
        } else {
            networkWorker?.stopWatchingConnection()
            presenter?.displayStatus(PlayerStatusList.isPaused)
        }
    }
    
    func handleQuitTap() {
        NSApplication.shared.terminate(self)
    }
    
    func handleFacebookTap() {
        if let fbUrl = URL(string: GeneralURLs.facebook.rawValue) {
            presenter?.openURL(fbUrl)
        }
    }
    
    func handleWebTap() {
        if let webUrl = URL(string: GeneralURLs.website.rawValue) {
            presenter?.openURL(webUrl)
        }
    }
    
    func connectionLost() {
        audioPlayerWorker?.stopPlayer()
    }
    
    func connectionEstablished() {
        audioPlayerWorker?.forcePlay()
    }
    
    func playerStatusChanged(status:PlayerStatusList) {
        if networkWorker?.isNetworkReachable == true {
            presenter?.displayStatus(status)
        } else {
            presenter?.displayStatus(PlayerStatusList.isNetworkLost)
        }
    }
    
}