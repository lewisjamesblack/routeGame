//
//  LetterSquareView.swift
//  routeGame
//
//  Created by Lewis Black on 27/07/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import UIKit

class LetterSquareView: UIView {

    var isSelected:Bool
    var letter:String!

    
    @IBOutlet weak var letterSquareViewView: LetterSquareViewView!
    @IBOutlet var letterSquareView: UIView!
    @IBOutlet weak var letterLbl: UILabel!
    
    init(frame: CGRect, letter: String) {
        
        
        
        self.isSelected = false

        super.init(frame: frame)
        
        NSBundle.mainBundle().loadNibNamed("LetterSquareView", owner: self, options:  nil)
        
        letterLbl.text = letter.capitalizedString
        self.letter = letter
        self.addSubview(letterSquareView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return false
    }

    
    
    
}