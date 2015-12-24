//: Playground - noun: a place where people can play

import UIKit

protocol Tickable {
    func tick()
}

let gravity = 0.1

class Dog : Tickable {
    var xpos: Double
    var ypos: Double = 0.0

    var xdelta: Double = 0.0
    var ydelta: Double = 0.0

    init(xpos: Double) {
        self.xpos = xpos
    }

    func moveLeft() {
        xdelta = 1.0
    }

    func moveRight() {
        xdelta = -1.0
    }

    func stopMoving() {
        xdelta = 0.0
    }

    func jump() {
        if ypos == 0.0 {
            ydelta = 1.0
        }
    }

    func tick() {
        xpos += xdelta
        ypos = max(0, ypos + ydelta)
        if ypos > gravity {
            ydelta -= gravity
        }
    }
}

var d1 = Dog(xpos: -5.0)
var d2 = Dog(xpos: 5.0)

d1.jump()

d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
d1.tick()
d1.ydelta
d1.ypos
