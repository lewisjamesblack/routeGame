//
//  ViewController.swift
//  routeGame
//
//  Created by Lewis Black on 27/07/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import UIKit



class GameViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var wordSearchViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var wordSearchViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var wordSearchViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var wordSearchViewTrailingConstraint: NSLayoutConstraint!
   
    let numberOfColumns = 13 //letterGrid.count
    let numberOfRows = 13 //letterGrid[0].count
    let route = firstRoute
    let minimumWordLength = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let height = firstLetterDistanceFromTop * 2 + letterSquareViewHeight * CGFloat(numberOfRows)
        let width = firstLetterDistanceFromSide * 2 + letterSquareViewWidth * CGFloat(numberOfColumns)
        let answersArray = makeArrayOfAnswers(firstData)
        
        func maxWordLengthFunc() -> Int {
            var maxWordSoFar = 0
            for i in 0...answersArray.count - 1 {
                if answersArray[i].characters.count > maxWordSoFar {
                    maxWordSoFar = answersArray[i].characters.count
                }
            }
            return maxWordSoFar
        }
        
        let maxWordLength = maxWordLengthFunc()
        
        
        
        scrollView.addSubview(CharacterGridView(frame: CGRect(x: 0, y: 0, width: width, height: height), numberOfCols:numberOfColumns, numberOfRows: numberOfRows, maxWordLength: maxWordLength, route:routeArrayOfRows(route, numberOfRows: numberOfRows, numberOfCols: numberOfColumns), answersArray: answersArray, minimumWordLength: minimumWordLength))
        scrollView.contentSize = CGSize(width: width, height: height)


        
        

    }
    
    func routeArrayOfRows(array: Array<(Int,Int)>, numberOfRows: Int , numberOfCols: Int) -> Array<Array<Int>> {
        
        var arrayOfRows = [[Int]](count: numberOfRows, repeatedValue: [Int](count: numberOfCols, repeatedValue: 0))
        
        for m in 0...array.count-1 {
            let i = array[m].0
            let j = array[m].1
            
            arrayOfRows[i][j] = m
            
        }
        return arrayOfRows
    }
    
    
    
    func makeArrayOfAnswers(string:String) -> Array<String> {
        
        let stringWithOutSpaces = string.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        let array = stringWithOutSpaces.componentsSeparatedByString(",")
        print(array)

        return array
        
    }


}


let firstData = "Rome, Stockholm, Vienna, Minsk, Brussels, Sarajevo, Bern, Zagreb,  Prague, Copenhagen, Tallinn, Helsinki, Paris, Madrid, Berlin, Athens, Monaco, Reykjavik, Amsterdam, Oslo, Warsaw, Lisbon, Bucharest, Bratislava, Moscow"



