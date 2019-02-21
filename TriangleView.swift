//
//  TestView.swift
//  TestBezierPath
//
//  Created by Vladimir Andrienko on 20.02.2019.
//  Copyright © 2019 VAndrJ. All rights reserved.
//

import UIKit

@IBDesignable
class TriangleView: UIView {

    @IBInspectable
    var heightPercent: CGFloat = 80 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var fillColor: UIColor = UIColor.gray {
        didSet {
            setNeedsDisplay()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        fillColor.setFill()
        let topPoints = getTriangleTopPoints(for: rect, newHeightPercent: heightPercent)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: topPoints.left)
        path.addQuadCurve(to: topPoints.right, controlPoint: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.close()
        path.fill()
    }

    // MARK: - Calculate top points using right triangle rules
    private func getTriangleTopPoints(for rect: CGRect, newHeightPercent: CGFloat) -> (left: CGPoint, right: CGPoint) {
        assert((0...100) ~= newHeightPercent, "Come on. And how should it look like?")
        let newHeightMultiplier = newHeightPercent / 100
        let с = sqrt(pow((rect.width / 2), 2) + pow(rect.height, 2))
        let sina = rect.height / с
        let sinb = rect.width / (2 * с)
        let newHeight = rect.height * newHeightMultiplier
        let Δc = rect.height * newHeightMultiplier / sina
        let Δb = Δc * sinb
        let pointsY = rect.height - newHeight
        return (CGPoint(x: Δb, y: pointsY), CGPoint(x: rect.width - Δb, y: pointsY))
    }
}
