//
//  Transformations.swift
//  DrawingLines
//
//  Created by Noah Wilder on 2019-01-22.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation


//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Translation
public extension Shape {
    
    public mutating func translateBy(x: CGFloat, y: CGFloat) {
        replaceComponents(with: components.mapPoints { CGPoint(x: $0.x + x, y: $0.y + y) })
    }
    public func translatedBy(x: CGFloat, y: CGFloat) -> Shape {
        var newShape = self
        newShape.translateBy(x: x, y: y)
        return newShape
    }
}


//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Scale
public extension Shape {
    
    public mutating func scale(by factor: CGFloat) {
        replaceComponents(with: components.mapPoints { CGPoint(x: $0.x * factor, y: $0.y * factor) })
    }
    public func scaled(by factor: CGFloat) -> Shape {
        var newShape = self
        newShape.scale(by: factor)
        return newShape
    }
}


//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Rotation
public extension Shape {
    
    public mutating func rotate(by angle: CGFloat) {
        let boundingRect = bounds
        let center = CGPoint(x: boundingRect.midX, y: boundingRect.midY)
        transform { point in
            var p = CGPoint(x: point.x - center.x, y: point.y - center.y)
            guard p != CGPoint(x: 0, y: 0) else { return point }
            
            let r = CGFloat(sqrt(p.x * p.x + p.y * p.y))
            let initialAngle = (p.y < 0 ? -1 : 1) * acos(p.x/r)
            
            p.x = r * cos(angle.degreesToRadians + initialAngle) + center.x
            p.y = r * sin(angle.degreesToRadians + initialAngle) + center.y
            return p
        }
    }
    public func rotated(by angle: CGFloat) -> Shape {
        var newShape = self
        newShape.rotate(by: angle)
        return newShape
    }
}




//
//    public mutating func rotate(by angle: CGFloat) {
//
//        let rect = bounds
//        let center = CGPoint(x: rect.midX, y: rect.midY)
//        components = components.mapPoints { point in
//            let p = CGPoint(x: point.x - center.x, y: point.y - center.y)
//            var newPoint = CGPoint()
//            newPoint.x = p.x * cos(angle) - p.y * sin(angle)
//            newPoint.y = p.x * sin(angle) + p.y * cos(angle)
//
//            newPoint.x += center.x
//            newPoint.y += center.y
//            return newPoint
//
////            let r = CGFloat(sqrt(pow(Double(p.x - center.x), 2) + pow(Double(p.y - center.y), 2)))
////            let newX = center.x + (r * cos(angle))
////            let newY = center.y + (r * sin(angle))
////
////            return CGPoint(x: newX, y: newY)
//        }
//    }
//    public func rotated(by angle: CGFloat) -> Shape {
//        var newShape = self
//        newShape.rotate(by: angle)
//        return newShape
//    }
