//
//  CharacterGridView.swift
//  routeGame
//
//  Created by Lewis Black on 29/07/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import Foundation
import UIKit

class CharacterGridView: UIView {
    


    var numberOfCols:Int!
    var numberOfRows:Int!
    var maxWordLength:Int!

    var height:CGFloat!
    var width:CGFloat!

    
    var currentColor:Int = 0
    var color:UIColor{
        get {
            if (currentColor % 4) == 0 {
                return UIColor.blueColor()
            } else if (currentColor % 4) == 1 {
                return UIColor.redColor()
            } else if (currentColor % 4) == 2 {
                return UIColor.yellowColor()
            } else {
                return UIColor.greenColor()
            }
        }
    }
    var selectedPoints:Array<(Int,Int)> = []
    var arrayOfRows:Array<Array<LetterSquareView>> = []
    var squaresHighlightedInThisWord = 0
    var lastSquareHighlighted:(Int,Int)?
    

    init(frame: CGRect, numberOfCols:Int, numberOfRows:Int, maxWordLength: Int) {
        self.maxWordLength = maxWordLength
        self.numberOfCols = numberOfCols
        self.numberOfRows = numberOfRows
        self.height = firstLetterDistanceFromTop * 2 + letterSquareViewHeight * CGFloat(self.numberOfRows)
        self.width = firstLetterDistanceFromSide * 2 + letterSquareViewWidth * CGFloat(self.numberOfCols)
        
        super.init(frame: frame)
        self.initialise()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialise()
    }

    
    func initialise() {
    

        
        
        for i in 0...numberOfCols - 1 {
            
            var arrayOfViewsInRow:Array<LetterSquareView> = []
            
            
            for j in 0...numberOfRows - 1 {
                
                let x = firstLetterDistanceFromSide + CGFloat(i) * letterSquareViewWidth
                let y = firstLetterDistanceFromTop + CGFloat(j) * letterSquareViewHeight
                
                let letter = "\(i)\(j)"
                arrayOfViewsInRow.append(LetterSquareView(frame: CGRect(x: x, y: y, width: letterSquareViewWidth, height: letterSquareViewHeight), letter: letter))
                self.addSubview(arrayOfViewsInRow[j])
                
            }
            arrayOfRows.append(arrayOfViewsInRow)

        }
//
//
//        
//        
////        //keep this
        
//          for i in 0...numberOfRows - 1 {
////            for j in 0...numberOfCols - 1 {
////                arrayOfRows[i][j] = 0
////            }
////        }
////        let totalLetters = numberOfCols * numberOfRows
////        print(totalLetters)
////        for k in 0...totalLetters - 1 {
////            let position = route[k]
////
////            let i:Int = position.0
////            let j:Int = position.1
////
////            let x = firstLetterDistanceFromSide + CGFloat(i) * letterSquareViewWidth
////            let y = firstLetterDistanceFromTop + CGFloat(j) * letterSquareViewHeight
////
////            let letter = "\(k)"
////        arrayOfRows[i][j] = LetterSquareView(frame: CGRect(x: x, y: y, width: letterSquareViewWidth, height: letterSquareViewHeight), letter: letter)
////            self.addSubview(arrayOfRows[i][j] as! UIView)
////            print(k)
////        }
////        
////         //wordSearchView.frame = CGRect(x: 0, y: 0, width: width, height: height)
////        
    }


    
//    //make undo button plus lines through that follow touch thing down centre (must be connected to where the touch was before it was in that position so the line can be continuis)
    
    var startPoint:CGPoint?
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        onSquaredTouched(touches)
        (superview as! UIScrollView).scrollEnabled = false
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        onSquaredTouched(touches)
        (superview as! UIScrollView).scrollEnabled = false

        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        onSquaredTouched(touches)
        wordSelectionOver()
    }
    

    func onSquaredTouched(touches:Set<UITouch>) {
        if let square = pointIsInSquare(touches) {
            if isSquareAllowed(square) {
                highlightSquare(square)
            }
        }

    }
    
    
    func highlightSquare(square:(Int,Int)) {

        arrayOfRows[square.0][square.1].letterSquareViewView.backgroundColor = color
        arrayOfRows[square.0][square.1].letterLbl.backgroundColor = color
        

        selectedPoints.append(square)
        lastSquareHighlighted = square
        squaresHighlightedInThisWord += 1
    }
    
    
    
    func pointIsInSquare(touches:Set<UITouch>) -> (Int,Int)?{
        if let touch = touches.first {
            startPoint = touch.locationInView(self)
            var m:Int = 0
            var n:Int = 0
            for i in 0...numberOfCols - 1 {
                let beforeWidth:CGFloat = (firstLetterDistanceFromSide + CGFloat(i) * letterSquareViewWidth)
                let afterWidth:CGFloat = (firstLetterDistanceFromSide + (CGFloat(i) + 1) * letterSquareViewWidth)
                if beforeWidth < startPoint!.x && startPoint!.x <= afterWidth {
                    m = i
                }
            }
            for j in 0...numberOfRows - 1 {
                let beforeHeight:CGFloat = (firstLetterDistanceFromTop + CGFloat(j) * letterSquareViewHeight)
                let afterHeight:CGFloat = (firstLetterDistanceFromTop + (CGFloat(j) + 1) * letterSquareViewHeight)
                if beforeHeight < startPoint!.y && startPoint!.y <= afterHeight {
                    n = j
                }
            }
            return (m,n)
        }
        return nil
    }
    
    func isSquareSelected(square:(Int,Int)) -> Bool {
        
        if selectedPoints.count != 0 {
            for i in 0...selectedPoints.count - 1 {
                if square == selectedPoints[i] {
                    return true
                }
            }
        }
        return false
    }
    
    func isSquareAllowed(square:(Int,Int)) -> Bool {
        
        if isSquareSelected(square) || squaresHighlightedInThisWord > maxWordLength - 1 {
            return false
        }
        
        if squaresHighlightedInThisWord != 0 {
            let newI = square.0
            let newJ = square.1
            if let oldSquare = lastSquareHighlighted {
                let oldI = oldSquare.0
                let oldJ = oldSquare.1
                
                if  newI > (oldI + 1) || newI < (oldI - 1) || newJ > (oldJ + 1) || newJ < (oldJ - 1) {
                    return false
                }
                if newI == (oldI + 1) &&  newJ == (oldJ + 1){
                    return false
                }
                if newI == (oldI + 1) && newJ == (oldJ - 1) {
                    return false
                }
                if newI == (oldI - 1) &&  newJ == (oldJ + 1) {
                    return false
                }
                if newI == (oldI - 1) && newJ == (oldJ - 1) {
                    return false
                }
               
            }
        }
        
        return true
    }
    
    func wordSelectionOver(){
        (superview as! UIScrollView).scrollEnabled = true
        currentColor += 1
        squaresHighlightedInThisWord = 0
    }
    //make undo a work
}