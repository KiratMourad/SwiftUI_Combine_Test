//
//  ColorHexadecimal.swift
//  Salatuk_TESTUI
//
//  Created by Mourad KIRAT on 24/03/2023.
//
// Extension UIColor have a function to  convert code hexadecimal (#00000) to color 

import Foundation
import UIKit

    extension UIColor {
        convenience init(hexString: String, alpha: CGFloat = 1.0) {
            let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let scanner = Scanner(string: hexString)
            if (hexString.hasPrefix("#")) {
                scanner.scanLocation = 1
            }
            var color: UInt32 = 0
            scanner.scanHexInt32(&color)
            let mask = 0x000000FF
            let redR = Int(color >> 16) & mask
            let greenG = Int(color >> 8) & mask
            let blueB = Int(color) & mask
            let red   = CGFloat(redR) / 255.0
            let green = CGFloat(greenG) / 255.0
            let blue  = CGFloat(blueB ) / 255.0
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
        func toHexString() -> String {
            var redRR: CGFloat = 0
            var geenGG: CGFloat = 0
            var blueBB: CGFloat = 0
            var alphaA: CGFloat = 0
            getRed(&redRR, green: &geenGG, blue: &blueBB, alpha: &alphaA)
            let rgb: Int = (Int)(redRR*255)<<16 | (Int)(geenGG*255)<<8 | (Int)(blueBB*255)<<0
            return String(format: "#%06x", rgb)
        }
        // for textField 
        convenience init?(hex: String) {
            var hexStringColor = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            if hexStringColor.count == 3 {
                hexStringColor = hexStringColor.compactMap { String(repeating: $0, count: 2) }.joined()
            }
            
            var rgbValueColor: UInt64 = 0
            guard Scanner(string: hexStringColor).scanHexInt64(&rgbValueColor) else {
                return nil
            }
            
            let reddd = CGFloat((rgbValueColor & 0xFF0000) >> 16) / 255.0
            let grennnn = CGFloat((rgbValueColor & 0x00FF00) >> 8) / 255.0
            let blueee = CGFloat(rgbValueColor & 0x0000FF) / 255.0
            
            self.init(red: reddd, green: grennnn, blue: blueee, alpha: 1.0)
        }

    }

    

