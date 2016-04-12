//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by Jack Truskowski on 4/9/16.
//  Copyright © 2016 Jack Truskowski. All rights reserved.
//

import UIKit

class BreakoutBehavior : UIDynamicBehavior, UICollisionBehaviorDelegate {
    
    
    var breakoutVC : BreakoutViewController?
    
    lazy var collider: UICollisionBehavior = {
        let lazyCollider = UICollisionBehavior()
        lazyCollider.translatesReferenceBoundsIntoBoundary = true
        return lazyCollider
    }()
    
    lazy var ballBehavior: UIDynamicItemBehavior = {
        let lazyBallBehavior = UIDynamicItemBehavior()
        lazyBallBehavior.elasticity = 1.0
        lazyBallBehavior.friction = 0.0
        lazyBallBehavior.resistance = 0.0
        lazyBallBehavior.allowsRotation = false
        return lazyBallBehavior
    }()
    
    
    struct brickStruct{
        var identity : String
        var brick : UIView
    }
    
    var structArray = [brickStruct]()
    
    
    override init() {
        super.init()
        addChildBehavior(ballBehavior)
        addChildBehavior(collider)
        collider.collisionDelegate = self
    }
    
    
    //handles collisions between ball and brick
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        
        if let id = identifier as? String {
            
            if let namedFoo = structArray.filter({$0.identity == id}).first {
                removeBrick(namedFoo.brick)
                removeBarrier(namedFoo.identity)
                
                for var i = 0; i < structArray.count; ++i {
                    if(structArray[i].identity == namedFoo.identity){
                        structArray.removeAtIndex(i)
                        break
                    }
                }
                
                if structArray.count == 0 {
                    breakoutVC?.resetGame()
                }
                
            }
        }else{
            
            //wall boundary, check if the collision was with the bottom wall
            if breakoutVC?.theBall?.center.y > breakoutVC?.thePaddle?.center.y {
                //game over
                breakoutVC?.resetGame()
            }
            
            
        }
    }
    
    func addBarrier(path: UIBezierPath, named name:String){
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    func removeBarrier(name:String){
        collider.removeBoundaryWithIdentifier(name)
    }
    
    func addBall(ball: UIView){
        dynamicAnimator?.referenceView?.addSubview(ball)
        collider.addItem(ball)
        ballBehavior.addItem(ball)
    }
    
    func removeBall(ball: UIView){
        collider.removeItem(ball)
        ballBehavior.removeItem(ball)
        ball.removeFromSuperview()
    }
    
    func addPaddle(paddle: UIView){
        dynamicAnimator?.referenceView?.addSubview(paddle)
    }
    
    func removePaddle(paddle: UIView){
        paddle.removeFromSuperview()
    }
    
    func addBrick(brick: UIView, name:String){
        
        let newBrick = brickStruct(identity: name, brick: brick)
        structArray.append(newBrick)
        
        dynamicAnimator?.referenceView?.addSubview(brick)
    }
    
    func removeAllBricks(){
        
        for var i = 0; i < structArray.count; ++i {
            structArray[i].brick.removeFromSuperview()
        }
        
        structArray.removeAll()
        
    }
    
    func removeBrick(brick: UIView){
        brick.removeFromSuperview()
    }
    
}
