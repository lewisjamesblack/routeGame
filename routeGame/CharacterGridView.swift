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
    var minimumWordLength:Int!
    
    var height:CGFloat!
    var width:CGFloat!

    var currentColor:Int = 0
    var color:UIColor{
        
            return colours[abs(currentColor % (colours.count - 1))]
    }
    var route:Array<Array<Int>>!
    var answersArray: Array<String>!
    var answersOneString:String!
    var arrayOfRows:Array<Array<LetterSquareView>> = []
    
    var currentSquare:(Int,Int)?
    var currentWord:Int?
    
    var selectedWords:Array<Array<(Int,Int)>> = []
    
    var selectedPoints: Array<(Int,Int)> {
        var selectedPoints:Array<(Int,Int)> = []
        if selectedWords.count != 0 {
            for i in 0...selectedWords.count - 1 {
                for x in 0...selectedWords[i].count - 1 {
                    selectedPoints.append(selectedWords[i][x])
                }
            }
        }
        return selectedPoints
    }

    enum BorderType {
        case endTop
        case endLeft
        case endRight
        case endBottom
        
        case tubeVertical
        case tubeHorizontal
        
        case cornerTopLeft
        case cornerTopRight
        case cornerBottomLeft
        case cornerBottomRight
        
        case none
    }
    
    
    
    //Make Grid
    
    init(frame: CGRect, numberOfCols:Int, numberOfRows:Int, maxWordLength: Int, route:Array<Array<Int>>, answersArray:Array<String>, minimumWordLength: Int) {
        self.maxWordLength = maxWordLength
        self.numberOfCols = numberOfCols
        self.numberOfRows = numberOfRows
        self.route = route
        self.answersArray = answersArray
        self.minimumWordLength = minimumWordLength
        
        self.height = firstLetterDistanceFromTop * 2 + letterSquareViewHeight * CGFloat(self.numberOfRows)
        self.width = firstLetterDistanceFromSide * 2 + letterSquareViewWidth * CGFloat(self.numberOfCols)
        
        super.init(frame: frame)
        self.answersOneString = oneString(answersArray)

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
                let index = answersOneString.startIndex.advancedBy(route[i][j])
                let placeInRoute = answersOneString[index]
                
                let letter = "\(placeInRoute)"
                arrayOfViewsInRow.append(LetterSquareView(frame: CGRect(x: x, y: y, width: letterSquareViewWidth, height: letterSquareViewHeight), letter: letter))
                self.addSubview(arrayOfViewsInRow[j])
            }
            arrayOfRows.append(arrayOfViewsInRow)
        }
    }
    
    
    
    
    
    //Touches
    
    var startPoint:CGPoint?
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        onSquaredTouched(touches, startOfTouch:true, endOfTouch: false)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        onSquaredTouched(touches, startOfTouch:false, endOfTouch: false)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        onSquaredTouched(touches, startOfTouch:false, endOfTouch: true)
        wordSelectionOver()
    }
    
    func wordSelectionOver(){
        
        if currentWord != nil {
            if selectedWords[currentWord!].count < minimumWordLength {
                deSelectWord(currentWord!)
            }
        }
        
        currentSquare = nil
        currentWord = nil
        
        //get rid of minimum words
        
    }
    
    func onSquaredTouched(touches:Set<UITouch>, startOfTouch:Bool, endOfTouch: Bool) {
        (superview as! UIScrollView).scrollEnabled = endOfTouch
        if let square = pointIsInSquare(touches) {
            if isTouchNewSquare(touches, square: square) {
                if whatIsSquare(square, startOfTouch: startOfTouch) == Square.selectedInPreviousWord {
                    print("selectedInPrevious")

                    if startOfTouch {
                        undoWordQuestion(square)
                        print("delete word question")
                    }
                } else if whatIsSquare(square, startOfTouch: startOfTouch) == Square.selectedInCurrentWord {
                    print("selectedInCurrent")

                    unselectUpToSquare(square)
                } else if whatIsSquare(square, startOfTouch: startOfTouch) == Square.unSelectedAllowed {
                    
                    selectSquare(square, startOfTouch:startOfTouch)
                  //  print("unselectedAllowed")

                } else if whatIsSquare(square, startOfTouch: startOfTouch) == Square.unSelectedNotAllowed {
                    print("unselected not allowed")
                }
                
                print(selectedWords)
            }
        }
    }
    
    //Establish where touch is
    
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
    
    func isTouchNewSquare(touches:Set<UITouch>, square:(Int,Int)) -> Bool {
        if currentSquare != nil {
            if square == currentSquare! {
                return false
            }
            currentSquare = square

            return true
        }
        print("current square nil")

        currentSquare = square
        return true
    }
    
    
    
    
    
    //Establish what square is
    
    enum Square {
        case selectedInPreviousWord
        case selectedInCurrentWord
        case unSelectedAllowed
        case unSelectedNotAllowed
    }
    
    
    func whatIsSquare(square:(Int,Int), startOfTouch: Bool) -> Square {
        
        if isSquareSelected(square) {
            if isSelectedSquareInCurrentWord(square, startOfTouch: startOfTouch) {
                
                return Square.selectedInCurrentWord
            }
            return Square.selectedInPreviousWord
        } else {
            if isUnSelectedSquareAllowed(square, startOfTouch: startOfTouch) {
                return Square.unSelectedAllowed
            }
            return Square.unSelectedNotAllowed
        }
    }
   
    func isSquareSelected(square:(Int,Int)) -> Bool {
        if selectedWords.count != 0 {
            for i in 0...selectedPoints.count - 1 {
                if square == selectedPoints[i] {
                    return true
                }
            }
        }
        return false
    }
    
    
    func isSelectedSquareInCurrentWord(square:(Int,Int), startOfTouch: Bool) -> Bool {
    
        if let m = whatWordIsSquareIn(square) {
            let word = m.0
            if word == currentWord {
                return true
            }
            return false
        }
        return false
    }
    
    func whatWordIsSquareIn(square:(Int,Int)) -> (Int,Int)? {
        for i in 0...selectedWords.count - 1 {
            for j in 0...selectedWords[i].count - 1 {
                if square == selectedWords[i][j]{
                    return (i,j)
                }
            }
        }
        return nil
    }
    
    func isUnSelectedSquareAllowed(square:(Int,Int), startOfTouch: Bool) -> Bool {
        if startOfTouch != true {
            if selectedWords.count != 0 {
                let highLightedWord = selectedWords[selectedWords.count - 1]
                if highLightedWord.count > maxWordLength - 1 {
                    return false
                }
            
                let newI = square.0
                let newJ = square.1
                let lastSquareHighlighted = highLightedWord[highLightedWord.count - 1]
                let oldI = lastSquareHighlighted.0
                let oldJ = lastSquareHighlighted.1
                
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
    
    
    
    
    //Do stuff with square
    //Select
    func selectSquare(square:(Int,Int), startOfTouch: Bool){
        if startOfTouch {

            if selectedWords.count == 0 {
                print("first word")
                selectedWords = [[square]]
            } else  {
                print("new word")
                selectedWords.append([square])
                currentColor += 1
            }
            currentWord = selectedWords.count - 1

        } else {
            print("new letter")
            selectedWords[selectedWords.count - 1].append(square)
        }
        highlightSquare(square)
    }
    
    func highlightSquare(square:(Int,Int)) {
        arrayOfRows[square.0][square.1].letterSquareViewView.backgroundColor = color
        arrayOfRows[square.0][square.1].letterLbl.backgroundColor = color
    }
    
    
    
    //Delete
    
    func undoWordQuestion(square:(Int,Int)) {
        if let j = whatWordIsSquareIn(square) {
            let m = j.0
            deleteWordAlert("Do you want to delete this word?", msg: "Press Ok to delete", word: m)
            
        }
    }
   
    func deleteWordAlert(title: String, msg: String, word:Int) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: {(alert: UIAlertAction!) in
            self.deSelectWord(word)
        })
        alert.addAction(action)
        let rootViewController: UIViewController = UIApplication.sharedApplication().windows[0].rootViewController!
        colourChangeBeforeDeletion(word)

        rootViewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    func deSelectWord(word:Int){
    
        currentColor -= 1 //the problem here is i delete words allot even when they don't get new colours so you can get quite negative, or mihgt not be that but there does seem to be a problem with the colours, try printing them to see when you've got time
        
        for i in 0...selectedWords[word].count - 1 {
            unHighlightSquare(selectedWords[word][i])
        }
        selectedWords.removeAtIndex(word)
    }
    
    func unHighlightSquare(square:(Int,Int)) {
        arrayOfRows[square.0][square.1].letterSquareViewView.backgroundColor = nonHighlightedLetterViewColor
        arrayOfRows[square.0][square.1].letterLbl.backgroundColor = nonHighlightedLetterLabelColor
    }

    func colourChangeBeforeDeletion(word:Int){
        for i in 0...selectedWords[word].count - 1 {
            let square = selectedWords[word][i]
            arrayOfRows[square.0][square.1].letterLbl.backgroundColor = deleteColourChangeLetterLabelColor
        }
    
    }
    
    //Deselect

    
    func unselectUpToSquare(square:(Int,Int)){
        
        let word = whatWordIsSquareIn(square)!.0
        let letter = whatWordIsSquareIn(square)!.1
        let mostRecentWord = selectedWords.count - 1
        let mostRecentLetter = selectedWords[mostRecentWord].count - 1
        
        if selectedWords[word].count != 1 {
            if word == mostRecentWord && letter != mostRecentLetter {
                let letterBeingUnSelected = letter + 1
            
                let squaresBeingDeleted = selectedWords[word][letterBeingUnSelected...mostRecentLetter]
            
                if squaresBeingDeleted.count == 1 {
                    unHighlightSquare(selectedWords[word][letterBeingUnSelected])
                    selectedWords[word].removeLast()
                } else {
                    for i in 0...selectedWords[word].count - 1 {
                        for j in letterBeingUnSelected...letterBeingUnSelected + squaresBeingDeleted.count - 1 {
                            if selectedWords[word][i] == squaresBeingDeleted[j] {
                                unHighlightSquare(selectedWords[word][i])
                            }
                        }
                    }
                    for _ in 0...squaresBeingDeleted.count - 1 {
                        selectedWords[word].removeLast()//rewrite this
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    // check if Words correct
    
//    func isWordCorrect(wordIndex:Int) -> Bool {
//        for i in 0...answersArray.count - 1 {
//            
//            if answersArray[i].characters.count == selectedWords[wordIndex].count {
//                for j in 0...answersArray[i].characters.count - 1 {
//                    if answersArray[i][j] == word
//                }
//            }
//        }
//        return false
//    }
    
    
    
    
    
    
    
    
    // Make big sting one string
    
    func oneString(answersArray: Array<String>) -> String{
        let answersArrayCount = answersArray.count
        var str = ""
        
        for i in 0...answersArrayCount - 1 {
            str = "\(str)\(answersArray[i])"
        }
        
        return str
    }
    
}










