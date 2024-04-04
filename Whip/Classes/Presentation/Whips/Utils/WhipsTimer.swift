//
//  WhipsTimer.swift
//  Whip
//
//  Created by Андрей Чернышев on 04.04.2024.
//

import RxSwift
import RxCocoa

final class WhipsTimer {
    enum Constants {
        static let secondsLimit = 60
    }
    
    private var timer: Timer?
    
    private var secondsPassed = 0
    
    private lazy var didTimeLimitTrigger = PublishRelay<Void>()
    private lazy var didSecondsLeftTrigger = PublishRelay<Int>()
}

// MARK: Public
extension WhipsTimer {
    func reset() {
        stop()
        
        secondsPassed = 0
        didSecondsLeftTrigger.accept(Constants.secondsLimit)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else {
                return
            }
            
            self.secondsPassed += 1
            
            if self.secondsPassed == Constants.secondsLimit {
                self.didTimeLimitTrigger.accept(Void())
            }
            
            let secondsLeft = max(0, Constants.secondsLimit - self.secondsPassed)
            self.didSecondsLeftTrigger.accept(secondsLeft)
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    var didTimeLimit: Signal<Void> {
        didTimeLimitTrigger.asSignal()
    }
    
    var didSecondsLeft: Signal<Int> {
        didSecondsLeftTrigger.asSignal()
    }
}
