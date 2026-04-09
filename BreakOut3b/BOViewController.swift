import QuartzCore
import UIKit

let WHITE_BKGCOLOR = 1
let LIGHTGRAY_BKGCOLOR = 2
let GRAY_BKGCOLOR = 3
let YELLOW_BKGCOLOR = 4

@objc protocol BOViewControllerDelegate: AnyObject {
    func newScore(_ sender: BOViewController, withScore myScore: Int32)
}

@objc(BOViewController)
final class BOViewController: UIViewController {
    // 2026-04-09:
    // The original 2012 controller assumed a full-screen 320x436 playfield and
    // relied on raw touch handling plus image-based paddle rendering. During the
    // UIScene migration and modern iOS cleanup, the game view was updated to:
    // 1. Render the legacy playfield inside a centered fixed-size board view.
    // 2. Use a visible UIView-based paddle instead of the old image asset.
    // 3. Move the paddle with a pan gesture recognizer instead of touchesMoved:.
    // 4. Disable the navigation controller's edge-swipe gesture while playing.
    // These changes preserve the original gameplay geometry while restoring stable
    // paddle rendering and interaction on current iOS versions.
    private var gameModel: BOModel?
    private var gameTimer: CADisplayLink?
    private var mo: UIImageView?
    private var paddel: UIView?
    private var maxScore = 0
    private var color = 0
    private var realColor = UIColor.white
    private var gameLevel = 0

    private var gameBoardView: UIView?
    private var paddlePanGesture: UIPanGestureRecognizer?

    @objc var users: NSMutableArray = []
    @objc weak var delegate: BOViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        rebuildBoardViewIfNeeded()
        initLevel(0)
    }

    private func initLevel(_ level: Int) {
        rebuildBoardViewIfNeeded()
        gameLevel = level

        let defaults = UserDefaults.standard
        let currentPlayer = defaults.integer(forKey: "currentPlayer")
        let currentScores = defaults.array(forKey: "scores") as? [NSNumber] ?? []
        let currentColors = defaults.array(forKey: "colors") as? [NSNumber] ?? []

        if currentPlayer >= 0, currentPlayer < currentColors.count {
            color = currentColors[currentPlayer].intValue
        }
        if currentPlayer >= 0, currentPlayer < currentScores.count {
            maxScore = currentScores[currentPlayer].intValue
        }

        gameModel = BOModel(level: level)

        let movingObjectView = UIImageView(image: UIImage(named: "mo.png"))
        movingObjectView.frame = gameModel?.moSquare ?? .zero
        mo = movingObjectView
        gameBoardView?.addSubview(movingObjectView)

        let paddleView = UIView(frame: .zero)
        paddleView.backgroundColor = .black
        paddleView.layer.cornerRadius = 4.0

        if var paddleRect = gameModel?.paddelRect {
            paddleRect.origin.x = floor((VIEW_WIDTH - paddleRect.width) / 2.0)
            gameModel?.paddelRect = paddleRect
            paddleView.frame = paddleRect
        }

        paddel = paddleView
        gameBoardView?.addSubview(paddleView)

        for case let block as BOBlockView in gameModel?.blocks ?? [] {
            gameBoardView?.addSubview(block)
        }

        gameBoardView?.bringSubviewToFront(paddleView)
        gameBoardView?.bringSubviewToFront(movingObjectView)

        switch color {
        case WHITE_BKGCOLOR:
            realColor = .white
        case LIGHTGRAY_BKGCOLOR:
            realColor = .lightGray
        case GRAY_BKGCOLOR:
            realColor = .gray
        case YELLOW_BKGCOLOR:
            realColor = .yellow
        default:
            realColor = .white
        }

        gameBoardView?.backgroundColor = realColor

        let displayLink = CADisplayLink(target: self, selector: #selector(gameLoop(_:)))
        displayLink.add(to: .current, forMode: .common)
        gameTimer = displayLink
    }

    @objc func gameLoop(_ sender: CADisplayLink) {
        guard let gameModel else { return }
        gameModel.updateModel(withTime: sender.timestamp)
        mo?.frame = gameModel.moSquare
        paddel?.frame = gameModel.paddelRect

        if gameModel.blocks.count == 0 {
            gameModel.clearScreen()
            let scoreString = "Score = \(gameModel.netScore)"
            if gameLevel < 1 {
                levelOver(scoreString)
            } else {
                gameOver(scoreString)
            }
        }
    }

    private func levelOver(_ message: String) {
        gameTimer?.invalidate()
        presentResultAlert(title: "Level Over", message: message) { [weak self] in
            guard let self else { return }
            self.clearBoardSubviews()
            self.gameModel?.resetModel(0, color: 1)
            self.initLevel(1)
        }
    }

    @objc func gameOver(_ message: String) {
        gameTimer?.invalidate()
        presentResultAlert(title: "Game Over", message: message) { [weak self] in
            guard let self else { return }
            self.clearBoardSubviews()
            self.gameModel?.resetModel(0, color: 1)
        }
    }

    private func presentResultAlert(title: String, message: String, completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in completion() })
        present(alertController, animated: true)
    }

    private func cleanupGameState() {
        gameTimer?.invalidate()
        gameModel?.resetModel(0, color: 1)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rebuildBoardViewIfNeeded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        cleanupGameState()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rebuildBoardViewIfNeeded()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .allButUpsideDown
    }

    private func rebuildBoardViewIfNeeded() {
        var availableBounds = view.bounds
        if #available(iOS 11.0, *) {
            availableBounds = view.bounds.inset(by: view.safeAreaInsets)
        }

        let boardX = availableBounds.minX + floor((availableBounds.width - VIEW_WIDTH) / 2.0)
        let boardY = availableBounds.minY + floor((availableBounds.height - VIEW_HEIGHT) / 2.0)
        let boardFrame = CGRect(x: boardX, y: boardY, width: VIEW_WIDTH, height: VIEW_HEIGHT)

        if gameBoardView == nil {
            let boardView = UIView(frame: boardFrame)
            boardView.clipsToBounds = true
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePaddlePan(_:)))
            boardView.addGestureRecognizer(gesture)
            gameBoardView = boardView
            paddlePanGesture = gesture
            view.addSubview(boardView)
        } else {
            gameBoardView?.frame = boardFrame
        }
    }

    private func clearBoardSubviews() {
        gameBoardView?.subviews.forEach { $0.removeFromSuperview() }
    }

    @objc private func handlePaddlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let gameModel, let paddel, let boardView = gameBoardView else { return }
        let translation = gestureRecognizer.translation(in: boardView)
        if translation.x == 0 { return }

        var newPaddelRect = gameModel.paddelRect
        newPaddelRect.origin.x += translation.x
        let maxX = VIEW_WIDTH - newPaddelRect.width
        newPaddelRect.origin.x = min(max(newPaddelRect.origin.x, 0), maxX)
        gameModel.paddelRect = newPaddelRect
        paddel.frame = newPaddelRect
        gestureRecognizer.setTranslation(.zero, in: boardView)
    }
}
