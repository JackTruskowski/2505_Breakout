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
        lazyBallBehavior.elasticity = 0.75
        return lazyBallBehavior
    }()
    
    override init() {
        super.init()
        addChildBehavior(ballBehavior)
        addChildBehavior(collider)
    }
    
    func addBrick(brick: UIView){
        print("ADDING THE SUBVIEW")
        dynamicAnimator?.referenceView?.addSubview(brick)
        //collider.addItem(brick)
    }
    
    func removeBrick(brick: UIView){
        //collider.removeItem(brick)
        brick.removeFromSuperview()
    }
    
}
