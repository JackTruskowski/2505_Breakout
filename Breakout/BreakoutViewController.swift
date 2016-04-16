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
        
        gameView.frame = (gameView.superview?.bounds)!
        winLossMsg.hidden = true
        
        breakoutBehavior = BreakoutBehavior()
        breakoutBehavior?.breakoutVC = self
        animator.addBehavior(breakoutBehavior!)
        currentLife = numLives
        
        updateLabelText()

        resetGame()
        resetSquares()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBOutlet weak var gameView: UIView!
    
    @IBOutlet weak var livesLabel: UILabel!
    
    @IBOutlet weak var winLossMsg: UILabel!
    
    @IBAction func panGesture(sender: UIPanGestureRecognizer) {
        
        if(sender.state == .Began){
            originalPaddlePosition = (thePaddle?.center.x)!
        }
        
        let temp = sender.translationInView(self.gameView).x
        
        print(originalPaddlePosition + temp)
        
        
        if(originalPaddlePosition + temp >= 0 && originalPaddlePosition + temp <= gameView.bounds.size.width){
            movePaddleToXLoc(originalPaddlePosition+temp)
        }
        
    }
    
    @IBAction func tapGesture(sender: UITapGestureRecognizer) {
        
        let degrees = Double(arc4random_uniform(360) + 1)
        let radians = (M_PI/180)*degrees
        
        let instantaneousPush: UIPushBehavior = UIPushBehavior(items: [theBall!], mode: UIPushBehaviorMode.Instantaneous)
        instantaneousPush.setAngle( CGFloat(radians) , magnitude: 0.025);
        
        animator.addBehavior(instantaneousPush)
        
        winLossMsg.hidden = true
    }
    
    
    let labelText = "Lives: "
    var currentLife : Int?
    var theBall : UIView?
    var thePaddle : UIView?
    var originalPaddlePosition : CGFloat = 0.0
    var breakoutBehavior : BreakoutBehavior?
    
    
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
    
    
    //
    //    CONSTANTS
    //
    let numColumns = 8
    let numRows = 4
    let paddleOffset = 5
    let brickOffset : CGFloat = 2
    let numLives = 3
    //
    //
    //
    
    lazy var animator: UIDynamicAnimator = { [unowned self] in
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
    
    func updateLabelText(){
        livesLabel.text = "\(labelText) \(currentLife!)"
    }
    
    func movePaddleToXLoc(newX: CGFloat){
        
        breakoutBehavior!.removePaddle(thePaddle!)
        
        let frame = CGRect(origin: CGPoint(x: newX, y: gameView.frame.size.height/2 + gameView.frame.size.height/3 + CGFloat(paddleOffset)), size: paddleSize)
        let path = UIBezierPath(rect: frame)
        let name = "paddle"
        breakoutBehavior!.addBarrier(path, named: name)
        
        thePaddle = UIView(frame: frame)
        thePaddle!.backgroundColor = UIColor.blackColor()
        
        breakoutBehavior!.addPaddle(thePaddle!)
    }
    
    func resetGame(){
        if(thePaddle != nil) {breakoutBehavior?.removePaddle(thePaddle!)}
        if(theBall != nil) {breakoutBehavior?.removeBall(theBall!)}
        resetBallAndPaddle()
    }
    
    func resetBricks(){
        breakoutBehavior?.removeAllBricks()
        resetSquares()
    }
    
    
    //puts the ball above the paddle
    func resetBallAndPaddle() {
        let frame = CGRect(origin: CGPoint(x: gameView.frame.size.width/2 - ballSize.width/2, y: gameView.frame.size.height/2 + gameView.frame.size.height/3), size: ballSize)
        
        var paddleFrame = frame
        paddleFrame.size = paddleSize
        paddleFrame.origin.x -= CGFloat(paddleSize.width/2 - ballSize.width/2)
        paddleFrame.origin.y += CGFloat(paddleOffset)
        
        let path = UIBezierPath(rect: paddleFrame)
        let name = "paddle"
        breakoutBehavior!.addBarrier(path, named: name)
        
        theBall = UIView(frame: frame)
        theBall!.backgroundColor = UIColor.blueColor()
        
        thePaddle = UIView(frame: paddleFrame)
        thePaddle!.backgroundColor = UIColor.blackColor()
        
        breakoutBehavior!.addBall(theBall!)
        breakoutBehavior!.addPaddle(thePaddle!)
    }
    
    
    func updateAndShowWinLossLabel(won: Bool){
        if(won){
            winLossMsg.text = "You Won!"
        }else{
            winLossMsg.text = "You Lost!"
        }
        winLossMsg.hidden = false
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


