//
//  MotionManager.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 27/01/22.
//

import CoreMotion
//motion just by tilting the iPhone
//just move your head with airpods and it will draw on iPhone
class MotionManager {
    private var motionManager = CMHeadphoneMotionManager()
    var pitch = 0.0
    var roll = 0.0
    var yaw = 0.0
    
    init() {
        motionManager.startDeviceMotionUpdates(to: OperationQueue()) {[weak self] motion, error in
            guard let self = self, let motion = motion else {return}
            self.pitch = motion.attitude.pitch
            self.roll = motion.attitude.roll
            self.yaw = motion.attitude.yaw
        }
    }
    
    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
}
