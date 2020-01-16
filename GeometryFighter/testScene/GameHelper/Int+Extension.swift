//
//  Int+Extension.swift
//  testScene
//
//  Created by ruixinyi on 2020/1/13.
//  Copyright © 2020 ruixinyi. All rights reserved.
//

import Foundation

public extension Int {
    static func random(min: Int, max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max - min + 1))) + min
    }
}
