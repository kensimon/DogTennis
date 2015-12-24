//
//  GameScene.swift
//  DogTennis
//
//  Created by Ken Simon on 5/13/15.
//  Copyright (c) 2015 Ken Simon. All rights reserved.
//

import SpriteKit
import Carbon

class GameScene: SKScene, SKPhysicsContactDelegate {
    let leftDog = Dog(name: "BearPhoto")
    let rightDog = Dog(name: "JunoPhoto")
    let leftLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
    let rightLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")


    var ball = Ball()
    var width: CGFloat?


    static let CBM_PLAYERWALLS: UInt32 = 1 << 0
    static let CBM_BALLWALLS:   UInt32 = 1 << 1
    static let CBM_FLOOR:       UInt32 = 1 << 2
    static let CBM_BARRIER:     UInt32 = 1 << 3

    override func didMoveToView(view: SKView) {
        let bgImage = SKSpriteNode(imageNamed: "Background")
        bgImage.position = CGPointMake(self.size.width / 2, self.size.height / 2)
        bgImage.zPosition = -1
        addChild(bgImage)

        width = view.bounds.width

        let ballWalls = SKNode()
        ballWalls.name = "ballwalls"
        ballWalls.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0, y: -1000, width: view.bounds.width, height: view.bounds.height + 1000))
        ballWalls.physicsBody!.restitution = 0.5
        ballWalls.physicsBody!.categoryBitMask = GameScene.CBM_BALLWALLS
        addChild(ballWalls)

        let playerWalls = SKNode()
        playerWalls.name = "playerwalls"
        playerWalls.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0, y: -1000, width: view.bounds.width, height: view.bounds.height + 1000))
        playerWalls.physicsBody!.restitution = 0.0
        playerWalls.physicsBody!.categoryBitMask = GameScene.CBM_PLAYERWALLS
        addChild(playerWalls)

        let ground = SKNode()
        ground.physicsBody = SKPhysicsBody(edgeFromPoint: CGPoint(x: view.bounds.minX, y: 0), toPoint: CGPoint(x: view.bounds.maxX, y: 0))
        ground.name = "ground"
        ground.physicsBody!.categoryBitMask = GameScene.CBM_FLOOR
        ground.physicsBody!.restitution = 0.0
        ground.physicsBody!.dynamic = true
        addChild(ground)

        let net = SKShapeNode(rectOfSize: CGSize(width: 20, height: 100))
        net.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 20, height: 100))
        net.physicsBody!.dynamic = false
        net.position = CGPoint(x: view.bounds.maxX / 2, y: 50)
        net.fillColor = NSColor.blackColor()
        net.name = "net"
        addChild(net)

        let barrier = SKNode()
        barrier.physicsBody = SKPhysicsBody(edgeFromPoint: CGPoint(x: view.bounds.width / 2, y: 0), toPoint: CGPoint(x: view.bounds.width / 2, y: view.bounds.height))
        barrier.physicsBody!.categoryBitMask = GameScene.CBM_BARRIER
        barrier.physicsBody!.restitution = 0.0
        addChild(barrier)

        leftDog.position = CGPoint(x: 200, y: 300)
        leftDog.physicsBody!.collisionBitMask &= ~GameScene.CBM_BALLWALLS
        leftDog.physicsBody!.contactTestBitMask = GameScene.CBM_FLOOR | GameScene.CBM_PLAYERWALLS
        leftDog.name = "leftDog"
        addChild(leftDog)

        rightDog.position = CGPoint(x: 800, y: 300)
        rightDog.physicsBody!.collisionBitMask &= ~GameScene.CBM_BALLWALLS
        rightDog.physicsBody!.contactTestBitMask = GameScene.CBM_FLOOR | GameScene.CBM_PLAYERWALLS
        rightDog.name = "rightDog"
        addChild(rightDog)

        scaleMode = SKSceneScaleMode.ResizeFill

        ball.name = "ball"
        ball.physicsBody!.collisionBitMask &= ~(GameScene.CBM_PLAYERWALLS | GameScene.CBM_BARRIER)
        ball.physicsBody!.contactTestBitMask = GameScene.CBM_FLOOR
        throwBall()

        leftLabel.position = CGPointMake(100, 10)
        rightLabel.position = CGPointMake(self.width! - 100, 10)
        updateScore()

        addChild(leftLabel)
        addChild(rightLabel)

        physicsWorld.contactDelegate = self
    }

    func throwBall() {
        if let w = width {
            let throwit = SKAction.runBlock({ () -> Void in
                self.addChild(self.ball)
                self.ball.runAction(SKAction.moveTo(CGPoint(x: w / 2, y: 300), duration: NSTimeInterval.abs(0)))
                self.ball.physicsBody!.velocity.dx = 0.0
                self.ball.physicsBody!.velocity.dy = 0.0
                self.ball.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: 400.0))
            })

            self.runAction(SKAction.sequence([
                SKAction.waitForDuration(1.0),
                throwit,
                ]))
        }
    }

    override func keyUp(theEvent: NSEvent) {
        switch theEvent.keyCode {
        case UInt16(kVK_ANSI_A):
            self.leftDog.stopWalkingLeft()
        case UInt16(kVK_ANSI_D):
            self.leftDog.stopWalkingRight()
        case UInt16(kVK_LeftArrow):
            self.rightDog.stopWalkingLeft()
        case UInt16(kVK_RightArrow):
            self.rightDog.stopWalkingRight()
        default:
            return
        }
    }

    override func keyDown(theEvent: NSEvent) {
        switch theEvent.keyCode {
        case UInt16(kVK_ANSI_W):
            self.leftDog.jump()
        case UInt16(kVK_ANSI_A):
            self.leftDog.walkLeft()
        case UInt16(kVK_ANSI_D):
            self.leftDog.walkRight()
        case UInt16(kVK_UpArrow):
            self.rightDog.jump()
        case UInt16(kVK_LeftArrow):
            self.rightDog.walkLeft()
        case UInt16(kVK_RightArrow):
            self.rightDog.walkRight()
        default:
            return
        }
    }

    func didBeginContact(contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "ground") {
            groundContact(contact.bodyB.node!)
        } else if (contact.bodyB.node?.name == "ground") {
            groundContact(contact.bodyA.node!)
        } else if (contact.bodyB.node?.name == "playerwalls") {
            wallContact(contact.bodyA.node!)
        } else if (contact.bodyA.node?.name == "playerwalls") {
            wallContact(contact.bodyB.node!)
        }
    }

    func groundContact(obj: SKNode) {
        if obj is Ball {
            // Someone scored
            if let w = width {
                if ball.position.x < w / 2 {
                    rightDog.score++
                } else {
                    leftDog.score++
                }

                updateScore()
                ball.removeFromParent()
                throwBall()
            }
        } else if obj is Dog {
            // Ensure Dogs don't bounce.
            obj.physicsBody!.velocity.dy = 0
            //obj.physicsBody!.velocity.dx = 0
            obj.runAction(SKAction.moveToY(0, duration: 0))
        }
    }

    func wallContact(obj: SKNode) { 
        if obj is Dog {
            obj.physicsBody!.velocity.dx = 0
            if obj.position.x < width! / 2 {
                obj.runAction(SKAction.moveToX(0.0, duration: 0))
            } else {
                obj.runAction(SKAction.moveToX(width! - 50.0, duration: 0))
            }
        }
    }

    func updateScore() {
        leftLabel.text = String(leftDog.score)
        rightLabel.text = String(rightDog.score)
    }

    func didEndContact(contact: SKPhysicsContact) {
    }
}
