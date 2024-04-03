//
//  WhipSoundPlayer.swift
//  Whip
//
//  Created by Андрей Чернышев on 03.04.2024.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

final class WhipSoundPlayer: NSObject {
    private var player: AVAudioPlayer?
    
    private lazy var didFinishPlayingTrigger = PublishRelay<Void>()
}

// MARK: AVAudioPlayerDelegate
extension WhipSoundPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stop()
        didFinishPlayingTrigger.accept(Void())
    }
}

// MARK: Public
extension WhipSoundPlayer {
    func play(soundName: String) {
        guard let assetData = NSDataAsset(name: soundName) else {
            return
        }
        
        player = try? AVAudioPlayer(data: assetData.data, fileTypeHint: "wav")
        player?.delegate = self
        player?.play()
    }
    
    func stop() {
        player?.stop()
        player = nil
    }
    
    var didFinishPlaying: Signal<Void> {
        didFinishPlayingTrigger.asSignal()
    }
}
