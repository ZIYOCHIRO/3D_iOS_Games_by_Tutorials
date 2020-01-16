//
//  ShapeType.swift
//  testScene
//
//  Created by ruixinyi on 2020/1/13.
//  Copyright © 2020 ruixinyi. All rights reserved.
//

import Foundation

public enum ShapeType: Int {
    case Box = 0
    case Sphere
    case Pyramid
    case Torus
    case Capsule
    case Cylinder
    case Cone
    case Tube
    
    static func random() -> ShapeType {
        let maxValue = Tube.rawValue
        let rand = Int(arc4random_uniform(UInt32(maxValue + 1)))
        return ShapeType(rawValue: rand)!
    }
}
