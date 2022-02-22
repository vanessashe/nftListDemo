//
//  Int+Color.swift
//  Prototype
//
//  Created by shelin on 2021/8/13.
//

import UIKit

extension Utils where Base == Int {
    
    /// Use base as RGB color code and return its UIColor.
    var asRGB: UIColor {
        get {
            let rgb = self.base
            let red = (rgb >> 16) & 0xFF
            let green = (rgb >> 8) & 0xFF
            let blue = rgb & 0xFF
            let uiColor = UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
            return uiColor
        }
    }
    
    func setAlpha(_ alpha: CGFloat) -> UIColor {
        let rgb = self.base
        let red = (rgb >> 16) & 0xFF
        let green = (rgb >> 8) & 0xFF
        let blue = rgb & 0xFF
        let uiColor = UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
        
        return uiColor
    }
    
}

extension Int: UtilsCompatible { }
