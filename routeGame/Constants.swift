//
//  Constants.swift
//  routeGame
//
//  Created by Lewis Black on 27/07/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import Foundation
import UIKit

let firstLetterDistanceFromSide:CGFloat = 0
let firstLetterDistanceFromTop:CGFloat = 0

let letterSquareViewWidth:CGFloat = 40 //change in .xib file
let letterSquareViewHeight:CGFloat = 40 //change in .xib file
let nonHighlightedLetterLabelColor:UIColor = UIColor.whiteColor() //change in .xib file
let nonHighlightedLetterViewColor:UIColor = UIColor.blackColor() //change in .xib file
let deleteColourChangeLetterLabelColor = UIColor.lightGrayColor()

let colours = [UIColor(netHex:0x59ABE3), UIColor(netHex:0x9A12B3), UIColor(netHex:0xBF55EC), UIColor(netHex:0x9B59B6), UIColor(netHex:0x59ABE3), UIColor(netHex:0x81CFE0), UIColor(netHex:0x22A7F0), UIColor(netHex:0x4183D7), UIColor(netHex:0x81CFE0), UIColor(netHex:0x19B5FE), UIColor(netHex:0x3498DB), UIColor(netHex:0x336E7B)]



extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}