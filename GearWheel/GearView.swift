//
//  GearView.swift
//  GearWheel
//
//  Created by Daniil Polenskii on 20.09.2024.
//
import UIKit

final class GearView: UIView {
    
    var toothCount: Int = 0
    var toothHeight: CGFloat = 0
    var toothRadius: CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        
        guard toothCount > 2, toothRadius >= 0 else { return }

        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let center = CGPoint(x: rect.width / 2 , y: rect.height / 2)
        let outerRadius = min(rect.width, rect.height) / 2
        let angleStep = CGFloat.pi * 2 / CGFloat(toothCount)
        let innerRadius = outerRadius * cos(angleStep / 2.0)

        guard toothHeight > outerRadius - innerRadius, toothHeight < outerRadius  else {
            print("Высота должна быть больше: \(outerRadius - innerRadius) и меньше: \(outerRadius)" )
            return
        }

        context.beginPath()
        context.setStrokeColor(UIColor.white.cgColor)
        for toothIndex in 0..<toothCount {
            
            let startAngle = CGFloat(toothIndex) * angleStep
            let middleAngle = startAngle + angleStep / 2
            let endAngle = startAngle + angleStep

            let outerPoint = pointOnCircle(center: center, radius: outerRadius, angle: startAngle)
            let innerPoint = pointOnCircle(center: center, radius: outerRadius - toothHeight, angle: middleAngle)
            let endPoint = pointOnCircle(center: center, radius: outerRadius, angle: endAngle)

            let line = distanceBetweenPoints(outerPoint, innerPoint)

            // отрезок между outerPoint и innerPoint
            let outerHypotenuse = hypotenuseFromOpposite(opposite: toothRadius, angleRadians: angleStep / 2)
            guard outerHypotenuse <= line / 2 else {
                print("Сделай поменьше") // Тут выведи значени для пользователя. Нужно считать
                return
            }

            let tangentPoint1 = pointOnLine(from: outerPoint, towards: innerPoint, distance: outerHypotenuse)
//            context.move(to: outerPoint)
            context.addRect(CGRect(origin: tangentPoint1, size: CGSize(width: 5, height: 5)))

            // отрезок между innerPoint и outerPoint
            let innerHypotenuse = hypotenuseFromOpposite(opposite: toothRadius, angleRadians: CGFloat.pi * 2 - angleStep)
            let tangentPoint2 = pointOnLine(from: innerPoint, towards: outerPoint, distance: -innerHypotenuse)
//            context.addLine(to: tangentPoint2)
            context.addRect(CGRect(origin: tangentPoint2, size: CGSize(width: 5, height: 5)))

            // отрезок между innerPoint и endPoint
            let tangentPoint3 = pointOnLine(from: innerPoint, towards: endPoint, distance: -innerHypotenuse)
//            context.addArc(tangent1End: tangentPoint2, tangent2End: tangentPoint3, radius: toothRadius)
            context.addRect(CGRect(origin: tangentPoint3, size: CGSize(width: 5, height: 5)))
            // отрезок между innerPoint и endPoint
            let tangentPoint4 = pointOnLine(from: endPoint, towards: innerPoint, distance: outerHypotenuse)
//            context.addLine(to: endPoint)
            context.addRect(CGRect(origin: tangentPoint4, size: CGSize(width: 5, height: 5)))

            context.move(to: outerPoint)
            context.addLine(to: innerPoint)
            context.addLine(to: endPoint)
        }
        context.strokePath()
    }

//    context.beginPath()
//    context.move(to: outerPoint)
//    context.addLine(to: innerPoint)
//    context.addLine(to: endPoint)
//    context.strokePath()

    private func pointOnCircle(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
    }

    private func distanceBetweenPoints(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        return sqrt(dx * dx + dy * dy)
    }

    // Функция для нахождения гипотенузы, если известен противолежащий катет
    func hypotenuseFromOpposite(opposite: Double, angleRadians: Double) -> Double {
        opposite / sin(angleRadians)
    }

    func angleFrom(center: CGPoint, point: CGPoint) -> CGFloat {
        let deltaX = point.x - center.x
        let deltaY = point.y - center.y
        let radians = atan2(deltaY, deltaX)
        let degrees = radians * 180 / CGFloat.pi  // Преобразование радиан в градусы
        return degrees
    }

    func pointOnLine(from pointA: CGPoint, towards pointC: CGPoint, distance d: CGFloat) -> CGPoint {
        let totalDistance = distanceBetweenPoints(pointA, pointC)
        if totalDistance == 0 { return pointA }  // Исключаем деление на ноль
        let dx = (pointC.x - pointA.x) / totalDistance
        let dy = (pointC.y - pointA.y) / totalDistance
        return CGPoint(x: pointA.x + d * dx, y: pointA.y + d * dy)
    }
}
