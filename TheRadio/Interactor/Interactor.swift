//
//  Interactor.swift
//  TheRadio
//
//  Created by Roman Rosul on 25/11/18.
//  Copyright © 2018 . All rights reserved.
//

import Cocoa

protocol InteractorInterface: class {
    func handlePlayTap(sender: AnyObject?)
    func handleQuitTap()
    func handleFacebookTap()
    func handleWebTap()
    func handleAboutTap()
    func connectionLost()
    func connectionEstablished()
    func playerStatusChanged(status:PlayerStatusList)
}

class Interactor: NSObject {
    
    fileprivate var presenter: PresenterInterface?
    
    fileprivate var mediaKeysWorker: Any?
    fileprivate var audioPlayerWorker: AudioPlayerWorkerInterface?
    fileprivate var networkWorker: NetworkWorkerInterface?
    var isReconnected = false
    
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
    
//TODO: handleInteruptions
//        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeDefault)
//        try? AVAudioSession.sharedInstance().setActive(true)
//        https://blog.erikvdwal.nl/resuming-avplayer-after-being-interrupted/
   
}

extension Interactor: InteractorInterface {
    
    func handlePlayTap(sender: AnyObject?) {
        audioPlayerWorker?.togglePlayStatusManually()
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
    
    func handleAboutTap() {
        presenter?.displayAbout()
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
            if status == .isPaused || status == .isPlaying{
                networkWorker?.stopWatchingConnection()
                isReconnected = false
            } else {
                networkWorker?.startWatchingConnection()
                if !isReconnected {
                    isReconnected = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                        if self?.isReconnected == true {
                            self?.audioPlayerWorker?.forcePlay()
                        }
                    }
                }                
            }
        } else {
            presenter?.displayStatus(PlayerStatusList.isNetworkLost)
        }
    }
    
}
