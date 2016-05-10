//
//  Motion.swift
//  Project3
//
//  Created by Michael Boom on 5/9/16.
//  Copyright © 2016 Jon Lauer. All rights reserved.
//

import Foundation
import CoreMotion

class MotionHandler {
    let motionManager:CMMotionManager
    let zAccelThreshhold:Double = 0.95
    
    static let singleton = MotionHandler()
    private init() {
        motionManager = CMMotionManager()
    }
}
