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
        
        breakoutBehavior = BreakoutBehavior()
        breakoutBehavior?.breakoutVC = self
        animator.addBehavior(breakoutBehavior!)

        resetGame()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBOutlet weak var gameView: UIView!
    
    
    @IBAction func panGesture(sender: UIPanGestureRecognizer) {
        
        let temp = sender.translationInView(self.gameView)
        
        var newDir = temp.x - prevPan
        
        
        if(currentPaddleXPosition + newDir < 0 || currentPaddleXPosition + paddleSize.width + newDir > gameView.bounds.size.width){
            newDir = 0
            prevPan = 0
        }
        
        movePaddleToXLoc(newDir)
        
        switch sender.state{
        case .Ended:
            prevPan = 0.0
        default:
            prevPan = temp.x
        }
        
    }
    
    @IBAction func tapGesture(sender: UITapGestureRecognizer) {
        
        let degrees = Double(arc4random_uniform(360) + 1)
        let radians = (M_PI/180)*degrees
        
        let instantaneousPush: UIPushBehavior = UIPushBehavior(items: [theBall!], mode: UIPushBehaviorMode.Instantaneous)
        instantaneousPush.setAngle( CGFloat(radians) , magnitude: 0.025);
        
        animator.addBehavior(instantaneousPush)
    }
    
    var theBall : UIView?
    var thePaddle : UIView?
    var currentPaddleXPosition : CGFloat = 0.0
    var prevPan : CGFloat = 0.0
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var brickSize : CGSize {
        let size = (gameView.frame.size.width / CGFloat(numColumns))
        return CGSize(width: size-brickOffset, height: gameView.bounds.height/20-brickOffset)
    }
    
    var ballSize: CGSize {
        let size = CGFloat(7)
        return CGSize(width: size, height: size)
    }
    
    var paddleSize: CGSize {
        return CGSize(width: gameView.bounds.width/7, height: 8.0)
    }
    
    var breakoutBehavior : BreakoutBehavior?
    let numColumns = 8
    let numRows = 4
    let paddleOffset = 5
    let brickOffset : CGFloat = 2
    
    
    lazy var animator: UIDynamicAnimator = {
        let lazyAnimator = UIDynamicAnimator(referenceView: self.gameView)
        lazyAnimator.delegate = self
        return lazyAnimator
    }()
    
    //sets up the initial row of squares
    func resetSquares() {
        
        for var j=0; j<numRows; j++ {
            for var i=0; i<numColumns; i++ {
                let frame = CGRect(origin: CGPoint(x: CGFloat(i)*(brickSize.width)+(brickOffset*CGFloat(i)), y:CGFloat(j)*brickSize.height+(brickOffset*CGFloat(j))), size: brickSize)
                
                let path = UIBezierPath(rect: frame)
                let name = String(j) + String(i)
                breakoutBehavior!.addBarrier(path, named: name)
                
                let brickView = UIView(frame: frame)
                brickView.backgroundColor = getColorForRow(j)
                
                breakoutBehavior!.addBrick(brickView, name: name)
            }
        }
        
    }
    
    func movePaddleToXLoc(newX: CGFloat){
        
        breakoutBehavior!.removePaddle(thePaddle!)
        
        let frame = CGRect(origin: CGPoint(x: currentPaddleXPosition + newX, y: gameView.frame.size.height/2 + gameView.frame.size.height/3 + CGFloat(paddleOffset)), size: paddleSize)
        let path = UIBezierPath(rect: frame)
        let name = "paddle"
        breakoutBehavior!.addBarrier(path, named: name)
        
        thePaddle = UIView(frame: frame)
        thePaddle!.backgroundColor = UIColor.blackColor()
        
        breakoutBehavior!.addPaddle(thePaddle!)
        
        currentPaddleXPosition += newX
    }
    
    func resetGame(){
        if(thePaddle != nil) {breakoutBehavior?.removePaddle(thePaddle!)}
        if(theBall != nil) {breakoutBehavior?.removeBall(theBall!)}
        breakoutBehavior?.removeAllBricks()
        resetSquares()
        resetBallAndPaddle()
    }
    
    
    //puts the ball above the paddle
    func resetBallAndPaddle() {
        let frame = CGRect(origin: CGPoint(x: gameView.frame.size.width/2 - ballSize.width/2, y: gameView.frame.size.height/2 + gameView.frame.size.height/3), size: ballSize)
        
        var paddleFrame = frame
        paddleFrame.size = paddleSize
        paddleFrame.origin.x -= CGFloat(paddleSize.width/2 - ballSize.width/2)
        paddleFrame.origin.y += CGFloat(paddleOffset)
        currentPaddleXPosition = paddleFrame.origin.x
        
        let path = UIBezierPath(rect: paddleFrame)
        let name = "paddle"
        breakoutBehavior!.addBarrier(path, named: name)
        currentPaddleXPosition = paddleFrame.origin.x
        
        theBall = UIView(frame: frame)
        theBall!.backgroundColor = UIColor.blueColor()
        
        thePaddle = UIView(frame: paddleFrame)
        thePaddle!.backgroundColor = UIColor.blackColor()
        
        breakoutBehavior!.addBall(theBall!)
        breakoutBehavior!.addPaddle(thePaddle!)
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


