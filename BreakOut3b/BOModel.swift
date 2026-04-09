import Foundation
import UIKit

let BLOCK_HEIGHT: CGFloat = 20
let BLOCK_WIDTH: CGFloat = 53.3
let THICKNESS: CGFloat = 2
let PADDEL_EDGE: CGFloat = 0.333
let ACCEL: CGFloat = 0.2
let MIN_CHANGE: CGFloat = 15
let VIEW_WIDTH: CGFloat = 320
let VIEW_HEIGHT: CGFloat = 436
let MARGIN: CGFloat = 0.05
let SHRINK_FACTOR: CGFloat = 0.9
let TOP_OFFSET: CGFloat = 20
let EASY = 1
let MODERATE = 2
let HARD = 3

@objc(BOModel)
final class BOModel: NSObject {
    @objc private(set) var blocks: NSMutableArray
    @objc var paddelRect: CGRect
    @objc private(set) var moSquare: CGRect
    @objc var score: Int = 0
    @objc var netScore: Int = 0
    @objc var playerScore: Int = 0
    @objc var playerDiff: Int = 0
    @objc var timeElapsed: CGFloat = 0
    @objc var level: Int = 0
    @objc var viewColor: Int = 0

    private var blocksToRemoveFromView: NSMutableArray
    private var moVelocity: CGPoint = .zero
    private var timeOld: CGFloat = 0
    private var timeDiff: CGFloat = 0
    private var timeStart: CGFloat = 0

    @objc(initWithLevel:)
    init(level aLevel: Int) {
        self.blocks = NSMutableArray(capacity: 50)
        self.blocksToRemoveFromView = NSMutableArray(capacity: 50)
        self.paddelRect = .zero
        self.moSquare = .zero
        super.init()

        let defaults = UserDefaults.standard
        let currentPlayer = defaults.integer(forKey: "currentPlayer")
        let currentDiffs = defaults.array(forKey: "diffs") as? [NSNumber] ?? []
        let currentScores = defaults.array(forKey: "scores") as? [NSNumber] ?? []

        if currentPlayer >= 0, currentPlayer < currentDiffs.count {
            playerDiff = currentDiffs[currentPlayer].intValue
        }
        if currentPlayer >= 0, currentPlayer < currentScores.count {
            playerScore = currentScores[currentPlayer].intValue
        }

        let maxRows = (aLevel == 0) ? 3 : 6
        for row in 0 ..< maxRows {
            for col in 0 ..< 6 {
                let block = BOBlockView(
                    frame: CGRect(
                        x: MARGIN * BLOCK_WIDTH + CGFloat(col) * BLOCK_WIDTH,
                        y: TOP_OFFSET + MARGIN * BLOCK_HEIGHT + CGFloat(row) * BLOCK_HEIGHT,
                        width: SHRINK_FACTOR * BLOCK_WIDTH,
                        height: SHRINK_FACTOR * BLOCK_HEIGHT
                    ),
                    color: row
                )
                blocks.add(block)
            }
        }

        let paddelSize = UIImage(named: "paddel.png")?.size ?? CGSize(width: 80, height: 20)
        paddelRect = CGRect(x: 0, y: VIEW_HEIGHT - 60, width: paddelSize.width, height: paddelSize.height)

        let movingObject = BOMovingObject(position: CGPoint(x: MO_POS_X, y: MO_POS_Y))
        switch playerDiff {
        case MODERATE:
            moVelocity = CGPoint(x: movingObject.velocity.x * 1.5, y: movingObject.velocity.y * 1.5)
        case HARD:
            moVelocity = CGPoint(x: movingObject.velocity.x * 2.0, y: movingObject.velocity.y * 2.0)
        default:
            moVelocity = movingObject.velocity
        }

        let moSize = UIImage(named: "mo.png")?.size ?? CGSize(width: MO_SIZE, height: MO_SIZE)
        moSquare = CGRect(x: movingObject.position.x, y: movingObject.position.y, width: moSize.width, height: moSize.height)
    }

    @objc(updateModelWithTime:)
    func updateModel(withTime timeNew: CFTimeInterval) {
        let currentTime = CGFloat(timeNew)
        if timeOld == 0 {
            timeOld = currentTime
            timeStart = currentTime
            return
        }

        timeDiff = currentTime - timeOld
        timeOld = currentTime
        timeElapsed = currentTime - timeStart
        if timeElapsed > 0 {
            netScore = Int(0.5 + CGFloat(score) / timeElapsed)
        }

        moSquare.origin.x += moVelocity.x * timeDiff
        moSquare.origin.y += moVelocity.y * timeDiff

        while changeDirectionForBounds() {
            moSquare.origin.x += moVelocity.x * timeDiff
            moSquare.origin.y += moVelocity.y * timeDiff
        }

        checkCollisionWithBlocks()
        checkCollisionWithPaddel()
    }

    private func changeDirectionForBounds() -> Bool {
        var hitBounds = false

        if hitLeft() {
            moVelocity.x = abs(moVelocity.x)
            hitBounds = true
        }
        if hitRight() {
            moVelocity.x = -abs(moVelocity.x)
            hitBounds = true
        }
        if hitTop() {
            moVelocity.y = abs(moVelocity.y)
            hitBounds = true
        }
        if hitBottom() {
            moVelocity.y = -abs(moVelocity.y)
            hitBounds = true
        }

        return hitBounds
    }

    private func hitLeft() -> Bool { moSquare.origin.x <= 0 }
    private func hitRight() -> Bool { moSquare.origin.x >= VIEW_WIDTH - MO_SIZE }
    private func hitTop() -> Bool { moSquare.origin.y <= 0 }
    private func hitBottom() -> Bool { moSquare.origin.y >= VIEW_HEIGHT - MO_SIZE }

    @objc func checkCollisionWithBlocks() {
        for case let block as BOBlockView in blocks {
            if moSquare.intersects(block.frame) {
                if flipY(block.frame) {
                    moVelocity.y = -moVelocity.y
                } else {
                    moVelocity.y = -moVelocity.x
                }

                CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
                block.blockLayer.backgroundColor = UIColor(white: 1.0, alpha: 1.0).cgColor

                score += 1000 * (block.color + 1)
                blocks.remove(block)
                blocksToRemoveFromView.add(block)

                if blocksToRemoveFromView.count > 5, let oldest = blocksToRemoveFromView.firstObject as? UIView {
                    oldest.removeFromSuperview()
                    blocksToRemoveFromView.removeObject(at: 0)
                }
                break
            }
        }
    }

    @objc func checkCollisionWithPaddel() {
        if moSquare.intersects(paddelRect) {
            if flipY(paddelRect) {
                moVelocity.y = -moVelocity.y
                if moVelocity.y < 0 {
                    moSquare.origin.y = paddelRect.minY - moSquare.height
                } else {
                    moSquare.origin.y = paddelRect.maxY
                }
                changeDirection(paddelRect)
            } else {
                moVelocity.x = -moVelocity.x
                if moVelocity.x > 0 {
                    moSquare.origin.x = paddelRect.maxX
                } else {
                    moSquare.origin.x = paddelRect.minX - moSquare.width
                }
            }
        }
    }

    private func flipY(_ obstruction: CGRect) -> Bool {
        let upper = CGRect(x: obstruction.origin.x, y: obstruction.origin.y, width: obstruction.width, height: THICKNESS)
        let lower = CGRect(x: obstruction.origin.x, y: obstruction.origin.y + obstruction.height - THICKNESS, width: obstruction.width, height: THICKNESS)
        return moSquare.intersects(upper) || moSquare.intersects(lower)
    }

    private func changeDirection(_ rectangle: CGRect) {
        let left = CGRect(x: rectangle.origin.x, y: rectangle.origin.y, width: PADDEL_EDGE * rectangle.width, height: THICKNESS)
        let center = CGRect(x: rectangle.origin.x + PADDEL_EDGE * rectangle.width, y: rectangle.origin.y, width: (1 - 2 * PADDEL_EDGE) * rectangle.width, height: THICKNESS)
        let right = CGRect(x: rectangle.origin.x + (1 - PADDEL_EDGE) * rectangle.width, y: rectangle.origin.y, width: PADDEL_EDGE * rectangle.width, height: THICKNESS)

        if moSquare.intersects(left) {
            moVelocity.x = moVelocity.x - ACCEL * abs(moVelocity.x) - MIN_CHANGE
        }
        if moSquare.intersects(center) {
            moVelocity.y = moVelocity.y - (ACCEL / 2.0) * abs(moVelocity.x) + MIN_CHANGE
        }
        if moSquare.intersects(right) {
            moVelocity.x = moVelocity.x + ACCEL * abs(moVelocity.x) + MIN_CHANGE
        }
    }

    @objc func clearScreen() {
        for case let block as BOBlockView in blocksToRemoveFromView {
            block.removeFromSuperview()
        }
    }

    @objc(resetModel:color:)
    func resetModel(_ lvl: Int, color col: Int) {
        let defaults = UserDefaults.standard
        let currentPlayer = defaults.integer(forKey: "currentPlayer")
        let currentScores = defaults.array(forKey: "scores") as? [NSNumber] ?? []
        var tempScores = currentScores

        if currentPlayer >= 0, currentPlayer < currentScores.count {
            playerScore = currentScores[currentPlayer].intValue
        }

        if netScore > playerScore, currentPlayer >= 0, currentPlayer < tempScores.count {
            tempScores[currentPlayer] = NSNumber(value: netScore)
            defaults.set(tempScores, forKey: "scores")
            defaults.synchronize()
        }

        blocks = NSMutableArray()
        blocksToRemoveFromView = NSMutableArray()
        paddelRect = .zero
        moSquare = .zero
        level = lvl
        viewColor = col
    }
}
