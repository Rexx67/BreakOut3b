import CoreGraphics
import Foundation

let MO_SIZE: CGFloat = 10
let MO_SPEED: CGFloat = 400
let MO_POS_X: CGFloat = 180
let MO_POS_Y: CGFloat = 220
let MO_DIR_X: CGFloat = 1
let MO_DIR_Y: CGFloat = -1

@objc(BOMovingObject)
final class BOMovingObject: NSObject {
    @objc var direction: CGPoint
    @objc var position: CGPoint
    @objc var velocity: CGPoint

    private let speed: CGFloat

    @objc(initAtPosition:)
    init(position: CGPoint) {
        self.position = position
        self.speed = MO_SPEED
        self.direction = CGPoint(x: MO_DIR_X, y: MO_DIR_Y)
        self.velocity = CGPoint(x: speed * direction.x, y: speed * direction.y)
        super.init()
    }
}
