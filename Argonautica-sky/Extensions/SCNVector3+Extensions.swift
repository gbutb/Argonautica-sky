//
//  SCNVector3+Extensions.swift
//  Argonautica
//
//  Created by Giorgi Butbaia on 10/3/20.
//  Copyright © 2020 Argonautica. All rights reserved.
//

import Foundation
import SceneKit

extension SCNVector3 {
    static func * (_ scale: Float, _ vec: SCNVector3) -> SCNVector3 {
        return SCNVector3(scale * vec.x, scale * vec.y, scale * vec.z)
    }

    static func + (_ a: SCNVector3, _ b: SCNVector3) -> SCNVector3 {
        return SCNVector3(a.x + b.x, a.y + b.y, a.z + b.z)
    }

    static func - (_ a: SCNVector3, _ b: SCNVector3) -> SCNVector3 {
        return SCNVector3(a.x - b.x, a.y - b.y, a.z - b.z)
    }

    static func / (_ a: SCNVector3, _ scale: Float) -> SCNVector3 {
        return (1.0/scale) * a
    }
    
    static func norm(_ a: SCNVector3) -> Float {
        return sqrt(pow(a.x, 2) + pow(a.y, 2) + pow(a.z, 2))
    }
}
