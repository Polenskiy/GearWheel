//
//  GearView.swift
//  GearWheel
//
//  Created by Daniil Polenskii on 20.09.2024.
//
import UIKit
import CoreGraphics

enum GeometryError {
    case height(from: Int, to: Int)
    case radius(less: Int)
    case radiusZero(enter: Int)
    case count(less: Int)
}

protocol GearViewDelegate: AnyObject {
    func handle(error: GeometryError)
}

final class GearView: UIView {
    
    weak var delegate: GearViewDelegate?

    var toothCount: Int = 0
    var toothHeight: CGFloat = 0
    var toothRadius: CGFloat = 0
    
    func configure(toothCount: Int, height: Int, radius: Int) {
        self.toothCount = toothCount
        self.toothHeight = CGFloat(height)
        self.toothRadius = CGFloat(radius)
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let center = CGPoint(x: rect.width / 2 , y: rect.height / 2)
        let outerRadius = min(rect.width, rect.height) / 2
        let angleStep = CGFloat.pi * 2 / CGFloat(toothCount)
        let minRadius = outerRadius * cos(angleStep / 2.0)
        let innerRadius = outerRadius - toothHeight
        
        guard toothRadius >= 0 else {
            delegate?.handle(error: .radiusZero(enter: Int(toothRadius)))
            return
        }
        
        guard toothCount > 2, toothCount < 100 else {
            delegate?.handle(error: .count(less: Int(toothCount)))
            return
        }

        guard toothHeight > outerRadius - minRadius, toothHeight < outerRadius  else {
            delegate?.handle(error: .height(from: Int(outerRadius - minRadius), to: Int(outerRadius)))
            return
        }

        context.beginPath()
        context.setStrokeColor(UIColor.white.cgColor)
        var lastTangentPoint: CGPoint?
        var lastOuterPoint: CGPoint?
        var lastInnerPoint: CGPoint?
        var shouldSaveOnce = true
        for toothIndex in 0..<toothCount {
            
            let startAngle = CGFloat(toothIndex) * angleStep
            let middleAngle = startAngle + angleStep / 2
            let endAngle = startAngle + angleStep

            let outerPoint = pointOnCircle(center: center, radius: outerRadius, angle: startAngle)
            let innerPoint = pointOnCircle(center: center, radius: innerRadius, angle: middleAngle)

            if shouldSaveOnce {
                lastOuterPoint = outerPoint
                lastInnerPoint = innerPoint
                shouldSaveOnce = false
            }
            
            let endPoint = pointOnCircle(center: center, radius: outerRadius, angle: endAngle)
        
            let innerRadiusSquared = pow(innerRadius, 2)
            let outerRadiusSquared = pow(outerRadius, 2)
            
            let line = sqrt(innerRadiusSquared + outerRadiusSquared - 2 * innerRadius * outerRadius * cos(angleStep / 2))

            let numerator = innerRadiusSquared + pow(line, 2) - outerRadiusSquared
            let denominator = 2 * innerRadius * line

            let alfaAngle = acos(numerator / denominator)
            
            let queAngle = CGFloat.pi - alfaAngle
            let tettaAngle = CGFloat.pi * 2 - ((CGFloat.pi / 2) + queAngle)
            
            let innerCatet = toothRadius * tan(tettaAngle)
            
            let bettaAngle = CGFloat.pi * 2 - ((angleStep / 2) + (alfaAngle))
            let outerHypotenuse = abs(toothRadius / sin(bettaAngle))

            guard (innerCatet + outerHypotenuse) < line else {
                delegate?.handle(error: .radius(less: Int(toothRadius)))
                return
            }
            
            if let lastTangentPoint {
                context.addArc(tangent1End: lastTangentPoint, tangent2End: outerPoint, radius: toothRadius)
            } else {
                context.move(to: outerPoint)
            }

            let tangentPoint4 = pointOnLine(from: endPoint, towards: innerPoint, distance: outerHypotenuse)

            context.addArc(tangent1End: outerPoint, tangent2End: innerPoint, radius: toothRadius)
            context.addArc(tangent1End: innerPoint, tangent2End: endPoint, radius: toothRadius)
            context.addLine(to: tangentPoint4)
            lastTangentPoint = context.currentPointOfPath
        }

        if let lastInnerPoint, let lastOuterPoint, let lastTangentPoint {
            context.addArc(tangent1End: lastTangentPoint, tangent2End: lastOuterPoint, radius: toothRadius)
            context.addArc(tangent1End: lastOuterPoint, tangent2End: lastInnerPoint, radius: toothRadius)
        }
        context.closePath()
        context.strokePath()
    }

    private func pointOnCircle(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
    }

    private func distanceBetweenPoints(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return sqrt(dx * dx + dy * dy)
    }

    func pointOnLine(from pointA: CGPoint, towards pointC: CGPoint, distance d: CGFloat) -> CGPoint {
        let totalDistance = distanceBetweenPoints(pointA, pointC)
        if totalDistance == 0 { return pointA }
        let dx = (pointC.x - pointA.x) / totalDistance
        let dy = (pointC.y - pointA.y) / totalDistance
        return CGPoint(x: pointA.x + d * dx, y: pointA.y + d * dy)
    }
}

