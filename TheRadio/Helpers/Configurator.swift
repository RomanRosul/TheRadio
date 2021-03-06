//
//  Configurator.swift
//  TheRadio
//
//  Created by Roman Rosul on 25/11/18.
//  Copyright © 2018 . All rights reserved.
//

import Cocoa

final class Configurator {

    static let sharedInstance = Configurator()
    
    private init() {}
    
    func configure(_ viewController: MainMenuViewController) {
        
        let presenter = Presenter(viewController)
        let interactor = Interactor(presenter)
        let mediaKeysWorkerInstance = HotKeysWorker(interactor)
        let audioPlayerWorkerInstance = AudioPlayerWorker(interactor)
        let networkWorkerInstance = NetworkWorker(interactor)

        interactor.setWorkers(audioPlayerWorkerInstance: audioPlayerWorkerInstance, mediaKeysWorkerInstance: mediaKeysWorkerInstance, networkWorkerInstance: networkWorkerInstance)
        viewController.interactor = interactor
        
    }

}
