//
//  Dog.swift
//  DogTennis
//
//  Created by Ken Simon on 5/23/15.
//  Copyright (c) 2015 Ken Simon. All rights reserved.
//

import Foundation
import SpriteKit

class Dog : SKSpriteNode {
    var score = 0
    init(name: String) {
        super.init(texture: SKTexture(imageNamed: name), color: NSColor(calibratedRed: 0, green: 0, blue: 0, alpha: 0), size: CGSize(width: 120, height:145))

        let pb = SKPhysicsBody(circleOfRadius: 72)
        pb.affectedByGravity = true
        pb.dynamic = true
        pb.allowsRotation = false
        pb.friction = 0.0
        pb.linearDamping = 0.0

        pb.mass = 100.0

        physicsBody = pb
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func jump() {
        let groundConnections = physicsBody!.allContactedBodies().filter({
            $0.node?.name == "ground"
        })

        if groundConnections.count > 0   {
            physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 80000.0))
        }
    }

    func walkRight() {
        if let pb = physicsBody {
            pb.velocity.dx = 400
        }
    }

    func walkLeft() {
        if let pb = physicsBody {
            pb.velocity.dx = -400
        }
    }

    func stopWalkingLeft() {
        if let pb = physicsBody {
            if pb.velocity.dx < 0 {
                pb.velocity.dx = 0
            }
        }
    }

    func stopWalkingRight() {
        if let pb = physicsBody {
            if pb.velocity.dx > 0 {
                pb.velocity.dx = 0
            }
        }
    }
}
