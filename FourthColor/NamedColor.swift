//
//  NamedColor.swift
//  FourthColor
//
//  Created by Natalia Wcisło on 16/05/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import Foundation
import SwiftUI

struct NamedColor {
    let name: String
    let color: UIColor
}

class ColorSet {
    var sortedColors: [(Int, NamedColor, RGB, HSL)]
    
    struct RGB {
        let r: CGFloat
        let g: CGFloat
        let b: CGFloat
    }
    
    struct HSL {
        let h: CGFloat
        let s: CGFloat
        let l: CGFloat
    }
    
    public static func new(fromFilename filename: String) -> ColorSet? {
        do {
            return try ColorSet(fromFilename: filename)
        } catch {
            return nil
        }
    }
    
    private init(fromFilename filename: String) throws {
        let path = Bundle.main.path(forResource: filename, ofType: "txt")!
        let data = try String(contentsOfFile: path, encoding: .utf8)
        let lines: [String] = data.components(separatedBy: .newlines)
        self.sortedColors = []
        for line in lines {
            if line != "" {
                let components = line.split(separator: ";")
                let name: String = String(components[0])
                let r: Int = Int(components[1]) ?? 0
                let g: Int = Int(components[2]) ?? 0
                let b: Int = Int(components[3]) ?? 0
                let value = (r << 16) + (g << 8) + b
                let red = CGFloat(r) / 255.0
                let green = CGFloat(g) / 255.0
                let blue = CGFloat(b) / 255.0
                let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
                let namedColor = NamedColor(name: name, color: color)
                let rgb = RGB(r: red, g: green, b: blue)
                let hsl = toHSL(rgb: rgb)
                self.sortedColors.append((value, namedColor, rgb, hsl))
            }
        }
        self.sortedColors = self.sortedColors.sorted(by: { $0.0 > $1.0 })
    }
    
    private func toHSL(rgb: RGB) -> HSL {
        let maximum = max(rgb.r, max(rgb.g, rgb.b))
        let minimum = min(rgb.r, min(rgb.g, rgb.b))
        
        let delta = maximum - minimum
        
        var h: CGFloat = 0.0
        var s: CGFloat = 0.0
        let l: CGFloat = (maximum + minimum) / 2.0
        
        if delta != 0.0 {
            if l < 0.5 {
                s = delta / (maximum + minimum)
            }
            else {
                s = delta / (2.0 - maximum - minimum)
            }
    
            if rgb.r == maximum {
                h = ((rgb.g - rgb.b) / delta) + (rgb.g < rgb.b ? 6.0 : 0.0)
            }
            else if rgb.g == maximum {
                h = ((rgb.b - rgb.r) / delta) + 2.0
            }
            else if rgb.b == maximum {
                h = ((rgb.r - rgb.g) / delta) + 4.0
            }
        }
    
        h /= 6.0
        return HSL(h: h, s: s, l: l)
    }
    
    func getNearest(from color: UIColor) -> NamedColor? {
        var red : CGFloat = 0
        var green : CGFloat = 0
        var blue : CGFloat = 0
        var alpha: CGFloat = 0
        if color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return getNearest(rgb: RGB(r: red, g: green, b: blue))
        }
        return nil
    }
    
    func getNearest(from color: CGColor) -> NamedColor? {
        let components = color.components
        let red = components![0]
        let green = components![1]
        let blue = components![2]
        return getNearest(rgb: RGB(r: red, g: green, b: blue))
    }
    
    private func getNearest(rgb: RGB) -> NamedColor? {
        let hsl = toHSL(rgb: rgb)
        let f = { (x: (Int, NamedColor, RGB, HSL)) -> CGFloat in
            let ndf1 = pow(rgb.r - x.2.r, 2) + pow(rgb.g - x.2.g, 2) + pow(rgb.b - x.2.b, 2)
            let ndf2 = pow(hsl.h - x.3.h, 2) + pow(hsl.s - x.3.s, 2) + pow(hsl.l - x.3.l, 2)
            let ndf = ndf1 + 2 * ndf2
            return ndf
        }
        return self.sortedColors.max(by: { f($0) > f($1) })?.1
    }
}
