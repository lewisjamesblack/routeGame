//
//  LetterTextView.swift
//  routeGame
//
//  Created by Lewis Black on 28/07/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import Foundation
import UIKit

class LetterSquareViewTextLabel: UILabel {
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return false
    }
}

class LetterSquareViewView: UIView {
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return false
    }
}