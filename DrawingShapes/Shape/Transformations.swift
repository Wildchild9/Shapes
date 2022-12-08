//
//  Transformations.swift
//  DrawingShapes
//
//  Created by Noah Wilder on 2019-01-22.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation
import UIKit


//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Translation
public extension Shape {
    
    mutating func translateBy(x: CGFloat, y: CGFloat) {
        replaceComponents(with: components.mapPoints { CGPoint(x: $0.x + x, y: $0.y + y) })
    }
    func translatedBy(x: CGFloat, y: CGFloat) -> Shape {
        var newShape = self
        newShape.translateBy(x: x, y: y)
        return newShape
    }
}


//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Scale
public extension Shape {
    
    mutating func scale(by factor: CGFloat) {
        replaceComponents(with: components.mapPoints { CGPoint(x: $0.x * factor, y: $0.y * factor) })
    }
    mutating func scale(byX x: CGFloat, y: CGFloat) {
        replaceComponents(with: components.mapPoints { CGPoint(x: $0.x * x, y: $0.y * y) })
    }
    func scaled(by factor: CGFloat) -> Shape {
        var newShape = self
        newShape.scale(by: factor)
        return newShape
    }
    func scaled(byX x: CGFloat, y: CGFloat) -> Shape {
        var newShape = self
        newShape.scale(byX: x, y: y)
        return newShape
    }
}


//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Rotation
public extension Shape {
    
    mutating func rotate(by angle: CGFloat, pivot: Pivot = .center) {
        let boundsRect = bounds

        let pivotPoint: CGPoint
        
        switch pivot {
        case .topLeft:
            pivotPoint = CGPoint(x: boundsRect.minX, y: boundsRect.minY)

        case .topMiddle:
            pivotPoint = CGPoint(x: boundsRect.midX, y: boundsRect.minY)

        case .topRight:
            pivotPoint = CGPoint(x: boundsRect.maxX, y: boundsRect.minY)

        case .rightMiddle:
            pivotPoint = CGPoint(x: boundsRect.maxX, y: boundsRect.midY)

        case .bottomRight:
            pivotPoint = CGPoint(x: boundsRect.maxX, y: boundsRect.maxY)

        case .bottomMiddle:
            pivotPoint = CGPoint(x: boundsRect.midX, y: boundsRect.maxY)

        case .bottomLeft:
            pivotPoint = CGPoint(x: boundsRect.minX, y: boundsRect.maxY)

        case .leftMiddle:
            pivotPoint = CGPoint(x: boundsRect.minX, y: boundsRect.midY)

        case .center:
            pivotPoint = CGPoint(x: boundsRect.midX, y: boundsRect.midY)

        case let .point(x, y):
            pivotPoint = CGPoint(x: x, y: y)
            
        }

        transform { point in
            
            var p = CGPoint(x: point.x - pivotPoint.x, y: point.y - pivotPoint.y)
            guard p != CGPoint(x: 0, y: 0) else { return point }
            
            let r = CGFloat(sqrt(p.x * p.x + p.y * p.y))
            let initialAngle = (p.y < 0 ? -1 : 1) * acos(p.x / r)
            
            p.x = r * cos(angle.degreesToRadians + initialAngle) + pivotPoint.x
            p.y = r * sin(angle.degreesToRadians + initialAngle) + pivotPoint.y
            return p
        }
    }
    func rotated(by angle: CGFloat, pivot: Pivot = .center) -> Shape {
        var newShape = self
        newShape.rotate(by: angle, pivot: pivot)
        return newShape
    }
    
    enum Pivot {
        case topLeft, topMiddle, topRight, rightMiddle, bottomRight, bottomMiddle, bottomLeft, leftMiddle, center
        case point(x: CGFloat, y: CGFloat)
    }
}

//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Reflection & Flip
public extension Shape {
    
    enum ReflectionAxis {
        case bottom, top, left, right
        case topLeftToBottomRight
        case topRightToBottomLeft
        case centerX, centerY
        case x(CGFloat), y(CGFloat)
        case line(CGPoint, CGPoint)
        // anchor point + angle for diagonal
    }
    
    mutating func reflect(over axis: ReflectionAxis) {
        let bounds = self.bounds
        switch axis {
        case let .line(p1, p2):
            _reflectOverLine(p1, p2)
            return
        case .topLeftToBottomRight:
            _reflectOverLine(CGPoint(x: bounds.minX, y: bounds.minY), CGPoint(x: bounds.maxX, y: bounds.maxX))
            return
        case .topRightToBottomLeft:
            _reflectOverLine(CGPoint(x: bounds.maxX, y: bounds.minY), CGPoint(x: bounds.minX, y: bounds.maxX))
        default: break
        }
        
        transform { p in
            switch axis {
            case .top:
                return CGPoint(x: p.x, y: -p.y + 2 * bounds.maxY)

            case .bottom:
                return CGPoint(x: p.x, y: -p.y + 2 * bounds.maxY)
                
            case .left:
                return CGPoint(x: -p.x + 2 * bounds.maxX, y: p.y)

            case .right:
                return CGPoint(x: -p.x + 2 * bounds.minX, y: p.y)
                
            case .centerX:
                return CGPoint(x: p.x, y: -p.y + 2 * bounds.midY)
                
            case .centerY:
                return CGPoint(x: -p.x + 2 * bounds.midX, y: p.y)

            case let .x(axisX):
                return CGPoint(x: p.x, y: -p.y + 2 * axisX)

            case let .y(axisY):
                return CGPoint(x: -p.x + 2 * axisY, y: p.y)
                
            default: fatalError() //Needed because of .line axis
            }
            
        }
    }
    
    func reflected(over axis: ReflectionAxis) -> Shape {
        var newShape = self
        newShape.reflect(over: axis)
        return newShape
    }
    
    private mutating func _reflectOverLine(_ p1: CGPoint, _ p2: CGPoint) {
        let m1 = (p2.y - p1.y) / (p2.x - p1.x)
        
        let b1 = p1.y - m1 * p1.x
       
        let m2 = -1 / m1
        
        transform { p3 in
            let b2 = p3.y - m2 * p3.x
            
            var intersection = CGPoint()
            intersection.x = (b1 - b2) / (m2 - m1)
            intersection.y = m1 * intersection.x + b1
            
            let reflectedPoint = CGPoint(x: p3.x + 2 * (intersection.x - p3.x),
                                         y: p3.y + 2 * (intersection.y - p3.y))
            
            return reflectedPoint
        }
    }
    enum Flip {
        case horizontally, vertically
    }
    
    mutating func flip(_ orientation: Flip) {
        switch orientation {
        case .horizontally: reflect(over: .centerX)
        case .vertically: reflect(over: .centerY)
        }
    }
    
    func flipped(_ orientation: Flip) -> Shape {
        switch orientation {
            case .horizontally: return reflected(over: .centerX)
            case .vertically: return reflected(over: .centerY)
        }
    }
}




