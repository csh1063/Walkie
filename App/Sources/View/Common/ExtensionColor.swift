//
//  ExtensionColor.swift
//  Walkie
//
//  Created by sanghyeon on 2/3/26.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String, opacity: Double = 1.0) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)

        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(.sRGB, red: r, green: g, blue: b, opacity: opacity)
    }
}

extension UIColor {
    
    var hexStringFromColor: String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
    
    convenience init(redInt: Int, greenInt: Int, blueInt: Int, alpha: CGFloat) {
        self.init(red: CGFloat(redInt) / 255, green: CGFloat(greenInt) / 255,
                  blue: CGFloat(blueInt) / 255, alpha: alpha)
    }
    
    convenience init(rgbInt: Int, alpha: CGFloat) {
        self.init(redInt: rgbInt, greenInt: rgbInt, blueInt: rgbInt, alpha: alpha)
    }
    
    convenience init(_ rgb: String, alpha: CGFloat = 1.0) {
        guard rgb.hasPrefix("#") else {
            fatalError("rgb does not start with a #.")
        }
        
        let hexString = String(rgb[rgb.index(rgb.startIndex, offsetBy: 1) ..< rgb.endIndex])
        
        guard hexString.count == 6 else {
            fatalError("hexString has an invalid length.")
        }
        
        guard let hexValue = UInt32(hexString, radix: 16) else {
            fatalError("hexString is not a hexadecimal.")
        }
        
        let red = CGFloat((hexValue & 0xFF0000) >> 16) / CGFloat(255)
        let green = CGFloat((hexValue & 0x00FF00) >> 8) / CGFloat(255)
        let blue = CGFloat(hexValue & 0x0000FF) / CGFloat(255)
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
