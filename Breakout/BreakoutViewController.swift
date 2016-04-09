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
        resetBall()
    }
    
    @IBOutlet weak var gameView: UIView!
    
    @IBAction func tapGesture(sender: UITapGestureRecognizer) {
        
        let degrees = Double(arc4random_uniform(360) + 1)
        let radians = (M_PI/180)*degrees
        
        let instantaneousPush: UIPushBehavior = UIPushBehavior(items: [theBall!], mode: UIPushBehaviorMode.Instantaneous)
        instantaneousPush.setAngle( CGFloat(radians) , magnitude: 0.025);
        
        animator.addBehavior(instantaneousPush)
    }
    
    var theBall : UIView?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var brickSize : CGSize {
        let size = (gameView.frame.size.width / CGFloat(numColumns))
        return CGSize(width: size, height: size/2)
    }
    
    var ballSize: CGSize {
        let size = CGFloat(7)
        return CGSize(width: size, height: size)
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
    
    //puts the ball above the paddle
    func resetBall() {
        let frame = CGRect(origin: CGPoint(x: gameView.frame.size.width/2, y: gameView.frame.size.height/2), size: ballSize)
        
        let ballView = UIView(frame: frame)
        ballView.backgroundColor = UIColor.blueColor()
        
        breakoutBehavior.addBall(ballView)
        
        theBall = ballView
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


