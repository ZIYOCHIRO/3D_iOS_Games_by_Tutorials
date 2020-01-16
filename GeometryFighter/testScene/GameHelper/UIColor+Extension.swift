//
//  UIColor+Extension.swift
//  testScene
//
//  Created by ruixinyi on 2020/1/13.
//  Copyright © 2020 ruixinyi. All rights reserved.
//
import SceneKit

let UIColorList:[UIColor] = [
    UIColor.black,
    UIColor.white,
    UIColor.red,
    UIColor.limeColor(),
    UIColor.blue,
    UIColor.yellow,
    UIColor.cyan,
    UIColor.silverColor(),
    UIColor.gray,
    UIColor.maroonColor(),
    UIColor.oliveColor(),
    UIColor.brown,
    UIColor.green,
    UIColor.lightGray,
    UIColor.magenta,
    UIColor.orange,
    UIColor.purple,
    UIColor.tealColor(),
    UIColor.navyColor()
]

public extension UIColor {
    static func random() -> UIColor {
        let maxValue = UIColorList.count
        let random = Int(arc4random_uniform(UInt32(maxValue)))
        return UIColorList[random]
    }
    
    static func limeColor() -> UIColor {
        return UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
    }
    
    static func silverColor() -> UIColor {
        return UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0)
    }
    
    static func maroonColor() -> UIColor {
        return UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    
    static func oliveColor() -> UIColor {
        return UIColor(red: 0.5, green: 0.5, blue: 0.0, alpha: 1.0)
    }
    
    static func tealColor() -> UIColor {
        return UIColor(red: 0.0, green: 0.5, blue: 0.5, alpha: 1.0)
    }
    
    static func navyColor() -> UIColor {
        return UIColor(red: 0.0, green: 0.0, blue: 128, alpha: 1.0)
    }
}
