//
//  BreakoutBehavior.swift
//  Breakout
//
//  Created by Jack Truskowski on 4/9/16.
//  Copyright © 2016 Jack Truskowski. All rights reserved.
//

import UIKit

class BreakoutBehavior : UIDynamicBehavior {
    
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
        return lazyBallBehavior
    }()
    
    
    
    override init() {
        super.init()
        addChildBehavior(ballBehavior)
        addChildBehavior(collider)
    }
    
    func addBall(ball: UIView){
        
        dynamicAnimator?.referenceView?.addSubview(ball)
        collider.addItem(ball)
        ballBehavior.addItem(ball)
    }
    
    func addBrick(brick: UIView){
        dynamicAnimator?.referenceView?.addSubview(brick)
    }
    
    func removeBrick(brick: UIView){
        brick.removeFromSuperview()
    }
    
}
