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
    let maxWordLength = 10

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let height = firstLetterDistanceFromTop * 2 + letterSquareViewHeight * CGFloat(numberOfRows)
        let width = firstLetterDistanceFromSide * 2 + letterSquareViewWidth * CGFloat(numberOfColumns)
        
        scrollView.addSubview(CharacterGridView(frame: CGRect(x: 0, y: 0, width: width, height: height), numberOfCols:numberOfColumns, numberOfRows:numberOfRows, maxWordLength: maxWordLength))
        
        scrollView.contentSize = CGSize(width: width, height: height)

        

    }
}




