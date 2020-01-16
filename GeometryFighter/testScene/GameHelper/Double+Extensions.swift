//
//  Double+Extensions.swift
//  testScene
//
//  Created by ruixinyi on 2020/1/13.
//  Copyright © 2020 ruixinyi. All rights reserved.
//

import Foundation

public extension Double {
    static func random(min: Double, max: Double) -> Double {
        let r64 = Double(arc4random_uniform(UInt32.max)) / Double(UInt32.max)
        return (r64 * (max - min)) + min
    }
}
