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

    override func draw(_ rect: CGRect) {
        //if let card = self.card{

        for r in rectsToDraw(give: number!) {
            let path = ovalPath(rect: r)
            let stroke = chooseStroke(for: self.color!)
            stroke.setStroke()
            stroke.setFill()
            path.stroke()
            path.fill()
            //UIColor.yellow.setFill()
            //UIRectFill(r)
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
