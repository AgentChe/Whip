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
    private lazy var players = [AVAudioPlayer]()
    
    private lazy var didFinishPlayingTrigger = PublishRelay<Void>()
}

// MARK: AVAudioPlayerDelegate
extension WhipSoundPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        didFinishPlayingTrigger.accept(Void())
        
        if let index = players.firstIndex(where: { $0 === player }) {
            players.remove(at: index)
        }
    }
}

// MARK: Public
extension WhipSoundPlayer {
    func play(soundName: String) {
        guard
            let assetData = NSDataAsset(name: soundName),
            let player = try? AVAudioPlayer(data: assetData.data, fileTypeHint: "wav")
        else {
            return
        }
        
        players.append(player)
        
        player.delegate = self
        player.play()
    }
    
    var didFinishPlaying: Signal<Void> {
        didFinishPlayingTrigger.asSignal()
    }
}
