//
//  WhipMotionShake.swift
//  Whip
//
//  Created by Андрей Чернышев on 03.04.2024.
//

import CoreMotion
import RxSwift
import RxCocoa

final class WhipMotionShake {
    enum Constants {
        static let accelerationChangeThreshold: Double = 0.8
        static let minimumHitAcceleration: Double = 0.5
    }
    
    private let motionManager = CMMotionManager()
    
    private var lastAcceleration: CMAcceleration?
    private var isIncreasing = false
    
    private lazy var didMotionShakeTrigger = PublishRelay<Void>()
    
    init() {
        motionManager.accelerometerUpdateInterval = 0.01
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
                let changes = (x: data.acceleration.x - lastAccel.x, y: data.acceleration.y - lastAccel.y, z: data.acceleration.z - lastAccel.z)
                let totalChange = abs(changes.x) + abs(changes.y) + abs(changes.z)
                
                if totalChange > Constants.accelerationChangeThreshold {
                    if changes.y > Constants.minimumHitAcceleration && !self.isIncreasing {
                        self.isIncreasing = true
                    }
                    
                    if changes.y < 0 && self.isIncreasing {
                        self.stop()
                        
                        self.didMotionShakeTrigger.accept(Void())
                    }
                } else if self.isIncreasing && totalChange < Constants.accelerationChangeThreshold / 2 {
                    self.isIncreasing = false
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
