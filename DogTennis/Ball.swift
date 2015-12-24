//
//  Ball.swift
//  DogTennis
//
//  Created by Ken Simon on 5/23/15.
//  Copyright (c) 2015 Ken Simon. All rights reserved.
//

import Foundation
import SpriteKit

class Ball : SKSpriteNode {
    init() {
        super.init(texture: SKTexture(imageNamed: "Ball"), color: NSColor(calibratedRed: 0, green: 0, blue: 0, alpha: 0), size: CGSize(width: 50, height:50))
        let shape = SKShapeNode(circleOfRadius: 25)
        shape.fillColor = NSColor.redColor()
        addChild(shape)

        let pb = SKPhysicsBody(circleOfRadius: 25)
        pb.affectedByGravity = true
        pb.dynamic = true
        pb.allowsRotation = false
        pb.mass = 1.0
        pb.restitution = 0.5
        
        physicsBody = pb
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}