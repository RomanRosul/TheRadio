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
    func connectionAlive()
    
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

    //Recieve Menu tap // Player Status // Network status // Keys Tap
    //send all into presenter
    
    //Retain all workers
    
    func setWorkers(audioPlayerWorkerInstance: AudioPlayerWorker, mediaKeysWorkerInstance: HotKeysWorker, networkWorkerInstance: NetworkWorker) {
        mediaKeysWorker = mediaKeysWorkerInstance
        networkWorker = networkWorkerInstance
        audioPlayerWorker = audioPlayerWorkerInstance
        
//        audioPlayerWorker?.forcePlay()
    }
    
 //TODO:   func handleInteruptions() {
//        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeDefault)
//        try? AVAudioSession.sharedInstance().setActive(true)
//        https://blog.erikvdwal.nl/resuming-avplayer-after-being-interrupted/
//    }
   
}

extension Interactor: InteractorInterface {
    
    func handlePlayTap(sender: AnyObject?) {
        //do something with player
        audioPlayerWorker?.togglePlayStatusManually()
        print("*** manual play")
    }
    
    func handleQuitTap() {
        NSApplication.shared.terminate(self)
        
        print("*** quit")

    }
    
    func handleFacebookTap() {
        if let fbUrl = URL(string: GeneralURLs.facebook.rawValue) {
            presenter?.openURL(fbUrl)
        }
        
        print("*** fb")

    }
    
    func handleWebTap() {
        if let webUrl = URL(string: GeneralURLs.website.rawValue) {
            presenter?.openURL(webUrl)
        }
        
        print("*** web")

    }
    
    func connectionLost() {
        //player stop
        audioPlayerWorker?.stopPlayer()
        
        print("*** N lost")

    }
    
    func connectionAlive() {
        //reachability reinited automatically
        //play if needed
        audioPlayerWorker?.forcePlay()
        
        print("*** N alive")

    }
    
    func playerStatusChanged(status:PlayerStatusList) {
        if networkWorker?.isNetworkReachable == true {
            presenter?.displayStatus(status)
            print("*** status \(status.title())")
        } else {
            presenter?.displayStatus(PlayerStatusList.isNetworkLost)
//            audioPlayerWorker?.stopPlayer()
            print("*** status no inet")

        }
    }
    
}
