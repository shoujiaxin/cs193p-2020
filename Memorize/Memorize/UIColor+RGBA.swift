//
//  UIColor+RGBA.swift
//  Memorize
//
//  Created by Jiaxin Shou on 2021/1/3.
//

import SwiftUI

extension Color {
    init(_ rgb: UIColor.RGB) {
        self.init(UIColor(rgb))
    }
}

public extension UIColor {
    struct RGB: Hashable, Codable {
        var red: CGFloat
        var green: CGFloat
        var blue: CGFloat
        var alpha: CGFloat
    }

    convenience init(_ rgb: RGB) {
        self.init(red: rgb.red, green: rgb.green, blue: rgb.blue, alpha: rgb.alpha)
    }

    var rgb: RGB {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return RGB(red: red, green: green, blue: blue, alpha: alpha)
    }
}
