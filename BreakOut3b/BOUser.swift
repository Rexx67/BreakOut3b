import Foundation

@objc(BOUser)
final class BOUser: NSObject {
    @objc var userId: String
    @objc var difficulty: NSNumber
    @objc var score: NSNumber
    @objc var backgroundColor: NSNumber

    @objc(initWithId:difficulty:score:andBackground:)
    init(id: String, difficulty: NSNumber, score: NSNumber, backgroundColor: NSNumber) {
        self.userId = id
        self.difficulty = difficulty
        self.score = score
        self.backgroundColor = backgroundColor
        super.init()
    }
}
