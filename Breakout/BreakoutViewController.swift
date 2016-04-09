//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by Jack Truskowski on 4/9/16.
//  Copyright © 2016 Jack Truskowski. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, UIDynamicAnimatorDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameView.frame = (gameView.superview?.bounds)!;
        // Do any additional setup after loading the view, typically from a nib.
        animator.addBehavior(breakoutBehavior)
        resetSquares()
    }
    
    @IBOutlet weak var gameView: UIView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var brickSize : CGSize {
        let size = (gameView.frame.size.width / CGFloat(numColumns))
        return CGSize(width: size, height: size/2)
    }
    
    let breakoutBehavior = BreakoutBehavior()
    let numColumns = 8
    let numRows = 4
    
    lazy var animator: UIDynamicAnimator = {
        let lazyAnimator = UIDynamicAnimator(referenceView: self.gameView)
        lazyAnimator.delegate = self
        return lazyAnimator
    }()
    
    //sets up the initial row of squares
    func resetSquares() {
        
        for var j=0; j<numRows; j++ {
            for var i=0; i<numColumns; i++ {
                let frame = CGRect(origin: CGPoint(x: CGFloat(i)*(brickSize.width), y:CGFloat(j)*brickSize.height), size: brickSize)
                
                let brickView = UIView(frame: frame)
                brickView.backgroundColor = getColorForRow(j)
                
                breakoutBehavior.addBrick(brickView)
            }
        }
        
    }
    
    func getColorForRow(row: Int)-> UIColor {
        switch row{
        case 0: return UIColor.blackColor()
        case 1: return UIColor.darkGrayColor()
        case 2: return UIColor.grayColor()
        case 3: return UIColor.lightGrayColor()
        default: return UIColor.redColor()
        }
    }
    
}


