//
//  Float+Extensions.swift
//  testScene
//
//  Created by ruixinyi on 2020/1/13.
//  Copyright © 2020 ruixinyi. All rights reserved.
//

import Foundation

public extension Float {
    static func random(min: Float, max: Float) -> Float {
        let r32 = Float(arc4random_uniform(UInt32.max)) / Float(UInt32.max)
        return (r32 * (max - min)) + min
    }
}
