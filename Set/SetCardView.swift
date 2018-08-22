//
//  SetCardView.swift
//  Set
//
//  Created by Dbrain on 19/08/2018.
//  Copyright © 2018 Nikita. All rights reserved.
//

import UIKit

@IBDesignable
class SetCardView: UIView {

    // Set of shapes that can be drawn by this view
    enum Shape: String {
        case oval, diamond, squiggle
    }

    // Number of shapes can be drawn by this view
    enum Number: Int {
        case one, two, three
    }

    enum Color: String {
        case blue, red, green
    }

    @IBInspectable
    private var selected = false { didSet { setNeedsDisplay() } }
    private var number: Number? { didSet { setNeedsDisplay() } }
    private var shape: Shape? { didSet { setNeedsDisplay() } }
    private var color: Color? { didSet { setNeedsDisplay() } }


    // IB: use the adapter
    @IBInspectable private var numberAdapter: Int {
        get {
            return self.number!.rawValue
        }
        set(number) {
            self.number = Number(rawValue: number - 1) ?? .one
        }
    }

    // IB: use the adapter
    @IBInspectable private var shapeAdapter: String {
        get {
            return self.shape!.rawValue
        }
        set(shape) {
            self.shape = Shape(rawValue: shape) ?? .oval
        }
    }

    // IB: use the adapter
    @IBInspectable private var colorAdapter: String {
        get {
            return self.color!.rawValue
        }
        set(color) {
            self.color = Color(rawValue: color) ?? .blue
        }
    }

    private let shapeMargin: CGFloat = 0.15

    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    convenience init(frame: CGRect, shape: Shape, color: Color) {
        self.init(frame: .zero)
        self.shape = shape
        self.color = color
    }

    // Give num of rectangles to draw shapes on
    private func rectsToDraw(give num: Number) -> [CGRect] {
        var rects = [CGRect]()

        // Calculate the size for each rect
        let maxOfWidthAndHeight = max(bounds.size.width, bounds.size.height)
        let sizeOfEachRect = CGSize(width: maxOfWidthAndHeight / 3, height: maxOfWidthAndHeight / 3)

        let x = bounds.midX - sizeOfEachRect.width / 2
        let y = bounds.midY - sizeOfEachRect.height / 2
        let rect = CGRect(origin: CGPoint(x: x, y: y), size: sizeOfEachRect)

        switch num {
        case .one:
            rects.append(rect)
        case .two:
            rects.append(rect.offsetBy(dx: 0, dy: -rect.width / 2))
            rects.append(rect.offsetBy(dx: 0, dy: rect.width / 2))
        case .three:
            rects.append(rect)
            rects.append(rect.offsetBy(dx: 0, dy: -rect.width))
            rects.append(rect.offsetBy(dx: 0, dy: rect.width))
        }

        return rects
    }

    private func strikeDiamond(in rect: CGRect) -> UIBezierPath {
        let margin = min(rect.size.width, rect.size.height) * shapeMargin

        let rectWithMargin = CGRect(x: rect.origin.x - (margin * 2),
            y: rect.origin.y + margin,
            width: rect.size.width + (margin * 4),
            height: rect.size.height - (margin * 2))
        
        //let rectWithMargin = rect
        let path = UIBezierPath()
       // UIRectFill(rectWithMargin)
        path.addClip()
        path.move(to: CGPoint(x: rectWithMargin.midX, y: rectWithMargin.origin.y))
        path.addLine(to: CGPoint(x: rectWithMargin.maxX, y: rectWithMargin.midY))
        path.addLine(to: CGPoint(x: rectWithMargin.midX, y: rectWithMargin.maxY))
        path.addLine(to: CGPoint(x: rectWithMargin.origin.x, y: rectWithMargin.midY))
        path.close()
        return path
    }


    private func ovalPath(rect: CGRect) -> UIBezierPath {
        // To add a little margin/padding
        let margin = min(rect.size.width, rect.size.height) * shapeMargin

        // Oval needs to fit inside this space
        let rectWithMargin = CGRect(x: rect.origin.x + margin,
            y: rect.origin.y + 4 * margin,
            width: rect.size.width - (margin * 2),
            height: rect.size.height - (margin * 8))

        return UIBezierPath(ovalIn: rectWithMargin)
    }

    private func chooseStroke(for color: Color) -> UIColor {
        switch color {
        case .blue:
            return UIColor.blue
        case .green:
            return UIColor.green
        case .red:
            return UIColor.red
        }
    }


    private func strikePath(for shape: Shape, in rect: CGRect) -> UIBezierPath {
        switch shape {
        case .oval:
            return ovalPath(rect: rect)
        case .diamond:
            return strikeDiamond(in: rect)
        default:
            return UIBezierPath()
        }
    }

    override func draw(_ rect: CGRect) {
        //if let card = self.card{

        for r in rectsToDraw(give: number!) {
            let path = strikePath(for: shape!, in: r)
            let stroke = chooseStroke(for: self.color!)
            //UIColor.yellow.setFill()
            //UIRectFill(r)
            stroke.setStroke()
            stroke.setFill()
            path.stroke()
            //path.fill()

        }

    }

}

extension SetCardView.Number {
    var num: Int {
        get {
            return self.rawValue
        }
    }
}
