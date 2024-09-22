//
//  GearView.swift
//  GearWheel
//
//  Created by Daniil Polenskii on 20.09.2024.
//
import UIKit
import CoreGraphics

final class GearView: UIView {
    
    var toothCount: Int = 0
    var toothHeight: CGFloat = 0
    var toothRadius: CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        
        guard toothCount > 2, toothHeight > 0, toothRadius >= 0 else { return }

        let path = UIBezierPath()
        let center = CGPoint(x: rect.width / 2 , y: rect.height / 2)
        
        if toothCount == 3 {
            let radius = min(rect.width, rect.height) / 2 - toothHeight
            
            for i in 0..<toothCount {
                let angle = CGFloat(i) * (2 * .pi / CGFloat(toothCount))
                let point = CGPoint(
                    x: center.x + radius * cos(angle),
                    y: center.y + radius * sin(angle)
                )
                if i == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }
            
            path.close()
            UIColor.white.setStroke()
            path.stroke()
            return
        }
    
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius - toothHeight
        
        guard innerRadius > 0 else {
            return
        }

        let angleStep = CGFloat.pi * 2 / CGFloat(toothCount)
        var angle: CGFloat = 0

        for i in 0..<toothCount {

            let outerPoint = CGPoint(
                x: center.x + cos(angle) * outerRadius,
                y: center.y + sin(angle) * outerRadius
            )
            
            let innerPoint = CGPoint(
                x: center.x + cos(angle + angleStep / 2) * innerRadius,
                y: center.y + sin(angle + angleStep / 2) * innerRadius
            )
            
            if i == 0 {
                path.move(to: outerPoint)
            } else {
                path.addLine(to: outerPoint)
            }
            
            path.addLine(to: innerPoint)
            angle += angleStep
        }
    
        path.close()
        UIColor.white.setStroke()
        path.stroke()
    }
}
