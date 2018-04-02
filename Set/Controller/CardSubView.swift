//
//  CardSubView.swift
//  Set
//
//  Created by Toan Nguyen on 26.03.18.
//  Copyright © 2018 Toan Nguyen. All rights reserved.
//

import UIKit

class CardSubView: UIView {
    
    var color: UIColor? { didSet {setNeedsDisplay(); setNeedsLayout()} }
    var number: Int? { didSet {setNeedsDisplay(); setNeedsLayout()} }
    var symbol: String? { didSet {setNeedsDisplay(); setNeedsLayout()} }
    var shade: String? { didSet {setNeedsDisplay(); setNeedsLayout()} }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 8)
        UIColor.white.setFill()
        roundedRect.fill()
        drawSubviews()
    }
    
    private func drawSubviews() {
        let xPosition: CGFloat = bounds.minX + (SizeRatio.dxInsetRatio * bounds.width)
        let yPosition: CGFloat = bounds.midY - (SizeRatio.dyInsetRatio * bounds.height)
        let rectWidth: CGFloat = bounds.width * SizeRatio.widthRatio
        let rectHeight: CGFloat = bounds.height * SizeRatio.heightRatio
        let dyInset: CGFloat = bounds.height * SizeRatio.dyInsetRatioBetweenRects
        var drawRects = [CGRect]()
        
        if number == 1 {
            let symbolRect = CGRect(x: xPosition, y: yPosition, width: rectWidth, height: rectHeight)
            let symbolView = UIView(frame: symbolRect)
            drawRects = [symbolRect]
            addSubview(symbolView)
        } else if number == 2 {
            let symbolRectOne = CGRect(x: xPosition, y: yPosition - (rectHeight / 2) - (dyInset / 2), width: rectWidth, height: rectHeight)
            let symbolViewOne = UIView(frame: symbolRectOne)
            addSubview(symbolViewOne)
            let symbolRectTwo = CGRect(x: xPosition, y: bounds.midY + (dyInset / 2), width: rectWidth, height: rectHeight)
            let symbolViewTwo = UIView(frame: symbolRectTwo)
            addSubview(symbolViewTwo)
            drawRects = [symbolRectOne, symbolRectTwo]
        } else if number == 3 {
            let symbolRectOne = CGRect(x: xPosition, y: yPosition - rectHeight - dyInset, width: rectWidth, height: rectHeight)
            let symbolViewOne = UIView(frame: symbolRectOne)
            addSubview(symbolViewOne)
            let symbolRectTwo = CGRect(x: xPosition, y: yPosition, width: rectWidth, height: rectHeight)
            let symbolViewTwo = UIView(frame: symbolRectTwo)
            addSubview(symbolViewTwo)
            let symbolRectThree = CGRect(x: xPosition, y: yPosition + rectHeight + dyInset, width: rectWidth, height: rectHeight)
            let symbolViewThree = UIView(frame: symbolRectThree)
            addSubview(symbolViewThree)
            drawRects = [symbolRectOne, symbolRectTwo, symbolRectThree]
        }
//        print(subviews.count)
//        for subview in subviews {
//            subview.backgroundColor = UIColor.green
//            print("subview.backgroundcolor is set to green")
//        }
        for drawRect in drawRects {
            drawSymbol(rect: drawRect)
        }
    }
    
    private func drawSymbol(rect: CGRect) {
        if symbol == "circle" {
            print("Drawing circles")
            drawOval(rect: rect)
        } else if symbol == "diamond" {
            print("Drawing diamonds")
            drawDiamond(rect: rect)
        } else if symbol == "squiggle" {
            print("Drawing squiggles")
            drawSquiggle(rect: rect)
        }
    }
    
    private func drawOval(rect: CGRect) {
        let ovalPath = UIBezierPath()
        let radius = SizeRatio.radiusRatio * rect.width
        ovalPath.addArc(withCenter: CGPoint(x: rect.minX + radius, y: rect.midY), radius: radius, startAngle: (0.5 * CGFloat.pi), endAngle: (1.5 * CGFloat.pi), clockwise: true)
        ovalPath.addArc(withCenter: CGPoint(x: rect.maxX - radius, y: rect.midY), radius: radius, startAngle: (1.5 * CGFloat.pi), endAngle: 2.5 * CGFloat.pi, clockwise: true)
        ovalPath.close()
        ovalPath.lineWidth = 2
        ovalPath.stroke()
    }
    
    private func drawDiamond(rect: CGRect) {
        let diamondPath = UIBezierPath()
        diamondPath.move(to: CGPoint(x: rect.minX, y: rect.midY))
        diamondPath.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        diamondPath.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        diamondPath.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        diamondPath.close()
        diamondPath.lineWidth = 2
        diamondPath.stroke()
    }
    
    private func drawSquiggle(rect: CGRect) {
        let squigglePath = UIBezierPath()
        let dxInset = SizeRatio.dxInsetRatio * rect.width
        let dyInset = SizeRatio.dyInsetRatio * rect.height
        squigglePath.move(to: CGPoint(x: rect.minX + (dxInset * 1.5), y: rect.maxY - (dyInset / 2.75)))
        squigglePath.addCurve(to: CGPoint(x: rect.minX + (dxInset * 2), y: rect.minY + (dyInset*1.3)), controlPoint1: CGPoint(x: rect.minX + dxInset, y: rect.maxY), controlPoint2: CGPoint(x: rect.minX, y: rect.midY))
        squigglePath.addCurve(to: CGPoint(x: rect.maxX - (dxInset*1.5), y: rect.minY + dyInset), controlPoint1: CGPoint(x: rect.midX + (dxInset / 2), y: rect.minY), controlPoint2: CGPoint(x: rect.midX + (dxInset/2), y: rect.midY))
        squigglePath.addCurve(to: CGPoint(x: rect.maxX - (dxInset * 2), y: rect.maxY - (dyInset / 2)), controlPoint1: CGPoint(x: rect.maxX, y: rect.minY), controlPoint2: CGPoint(x: rect.maxX, y: rect.maxY - dyInset))
        squigglePath.addCurve(to: CGPoint(x: rect.minX + (dxInset * 2.4), y: rect.maxY - (dyInset / 1.5)), controlPoint1: CGPoint(x: rect.midX, y: rect.maxY), controlPoint2: CGPoint(x: rect.midX, y: rect.midY + (dyInset/1.5)))
        squigglePath.addQuadCurve(to: CGPoint(x: rect.minX + (dxInset * 1.5), y: rect.maxY - (dyInset / 2.75)), controlPoint: CGPoint(x: rect.minX + (dxInset * 1.6), y: rect.maxY))
        squigglePath.lineWidth = 2
        squigglePath.stroke()
    }
}

extension CardSubView {
    private struct SizeRatio {
        static let dxInsetRatio: CGFloat = (1/8)
        static let dyInsetRatio: CGFloat = (1/7)
        static let radiusRatio: CGFloat = (1/5)
        static let widthRatio: CGFloat = (1 - (2 * SizeRatio.dxInsetRatio))
        static let heightRatio: CGFloat = (2 * SizeRatio.dyInsetRatio)
        static let dyInsetRatioBetweenRects: CGFloat = (1/40)
    }
    
}
