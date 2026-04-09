import QuartzCore
import UIKit

let BLUE_COLOR = 0
let GREEN_COLOR = 1
let RED_COLOR = 2
let YELLOW_COLOR = 3
let CYAN_COLOR = 4
let MAGENTA_COLOR = 5

@objc(BOBlockView)
final class BOBlockView: UIView {
    @objc var color: Int
    @objc var blockLayer: CALayer

    @objc(initWithFrame:color:)
    init(frame: CGRect, color inputColor: Int) {
        self.color = inputColor
        self.blockLayer = CALayer()
        super.init(frame: frame)

        blockLayer.bounds = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        blockLayer.position = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
        blockLayer.backgroundColor = UIColor.clear.cgColor
        layer.addSublayer(blockLayer)
        backgroundColor = .clear
        isOpaque = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        let path = UIBezierPath(rect: bounds)
        path.lineWidth = 2.0

        let components: [CGFloat]
        switch color {
        case RED_COLOR:
            components = [1, 0, 0, 1, 1, 0, 0, 1]
        case GREEN_COLOR:
            components = [0, 1, 0, 1, 0, 1, 0, 1]
        case BLUE_COLOR:
            components = [0, 0, 1, 1, 0, 0, 1, 1]
        case YELLOW_COLOR:
            components = [1, 1, 0, 1, 1, 1, 0, 1]
        case CYAN_COLOR:
            components = [0, 1, 1, 1, 0, 1, 1, 1]
        case MAGENTA_COLOR:
            components = [1, 0, 1, 1, 1, 0, 1, 1]
        default:
            components = [0, 0, 0, 1, 0, 0, 0, 1]
        }

        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
              let gradient = CGGradient(colorSpace: colorSpace, colorComponents: components, locations: [0, 1], count: 2) else {
            path.stroke()
            return
        }

        context.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: bounds.width, y: 0), options: [])
        path.stroke()
    }
}
