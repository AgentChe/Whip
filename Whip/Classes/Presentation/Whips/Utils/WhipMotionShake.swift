//
//  WhipMotionShake.swift
//  Whip
//
//  Created by Андрей Чернышев on 03.04.2024.
//

import CoreMotion
import RxSwift
import RxCocoa

// TODO: ускорить срабатывание
final class WhipMotionShake {
    enum Constants {
        static let accelerationChangeThreshold: Double = 9
    }
    
    private let motionManager = CMMotionManager()
    
    private var lastAcceleration: CMAcceleration?
    private var isIncreasing = false
    
    private lazy var didMotionShakeTrigger = PublishRelay<Void>()
    
    init() {
        motionManager.accelerometerUpdateInterval = 0.02
    }
}

// MARK: Public
extension WhipMotionShake {
    func startAccelerometer() {
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
            guard let self, let data else {
                return
            }
            
            if let lastAccel = self.lastAcceleration {
                let yChange = data.acceleration.y - lastAccel.y
                let totalChange = abs(data.acceleration.x - lastAccel.x) + abs(yChange) + abs(data.acceleration.z - lastAccel.z)
                
                if yChange > 0 && !self.isIncreasing {
                    self.isIncreasing = true
                }
                
                if yChange < 0 && self.isIncreasing && totalChange > Constants.accelerationChangeThreshold {
                    self.stop()
                    self.didMotionShakeTrigger.accept(Void())
                }
            }

            self.lastAcceleration = data.acceleration
        }
    }
    
    func stop() {
        lastAcceleration = nil
        isIncreasing = false
        
        motionManager.stopAccelerometerUpdates()
    }
    
    var didMotionShake: Signal<Void> {
        didMotionShakeTrigger.asSignal()
    }
}
