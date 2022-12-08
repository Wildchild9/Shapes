//
//  Generating+Shapes.swift
//  DrawingShapes
//
//  Created by Noah Wilder on 2019-05-01.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation
import UIKit


//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Regular Polygons
public extension Shape {
    static func regularPolygon(n: Int, sideLength: CGFloat) -> Shape {
        let r = sideLength / (2 * sin((360 / CGFloat(n) / 2).degreesToRadians))
        return regularPolygon(n: n, enclosingCirleRadius: r)
    }
    
    static func regularPolygon(n: Int, enclosingCirleRadius r: CGFloat = 50) -> Shape {
        guard n >= 1 else { return Shape() }
        guard n > 1 else { return Shape.to(0, 0) }
        guard n > 2 else { return Shape.to(0, -r).to(0, r) }
        
        var points = [Coordinate]()
        points.reserveCapacity(n)
        
        /// Side length
        let s = 2 * r * sin((360.0 / CGFloat(n) / 2).degreesToRadians)
        
        /// Internal angle
        let internalAngle = 180.0 - (360.0 / CGFloat(n))
        
        /// Current point coordinates
        var p = (x: -s / 2.0, y: s * tan((internalAngle / 2.0).degreesToRadians) / 2.0)
        
        points.append(p)
        
        /// Angle of rotation
        let θ = 360.0 / CGFloat(n)
        
        for _ in 1..<n {
            
            // Calculate x and y values for next point
            let x = p.x * cos(θ.degreesToRadians) - p.y * sin(θ.degreesToRadians)
            let y = p.x * sin(θ.degreesToRadians) + p.y * cos(θ.degreesToRadians)
            
            // Set current point to next point
            p = (x, y)
            
            // Add the point to the shape
            points.append(p)
        }
        
        var polygon = Shape()
        points.forEach { polygon.add(.point($0.x, $0.y)) }
        polygon.close()
        
        return polygon
    }
}


//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Stars
public extension Shape {
    static func star(numberOfPoints n: Int, radiusPercent: CGFloat = 0.4, enclosingCicleRadius outerRadius: CGFloat = 100) -> Shape {
        guard n >= 3 else { return Shape() }
        
        let outerShape = Shape.regularPolygon(n: n, enclosingCirleRadius: outerRadius)
        let outerPoints = outerShape.points
        
        var shape = Shape()
        
        
        
        let innerPoints = outerShape.rotated(by: 360 / CGFloat(n) / 2).scaled(by: radiusPercent).points
        
        for (p1, p2) in zip(outerPoints, innerPoints) {
            shape.append(.point(p1.x, p1.y), .point(p2.x, p2.y))
        }
        
        shape.close()
        
        if n.isMultiple(of: 2) {
            shape.rotate(by: 360 / CGFloat(n) / 2)
        }
        
        return shape
    }
    
    static func star(numberOfPoints n: Int, radiusPercent: CGFloat = 0.4, distanceBetweenPoints sideLength: CGFloat) -> Shape {
        let r = sideLength / (2 * sin((360 / CGFloat(n) / 2).degreesToRadians))
        return star(numberOfPoints: n, radiusPercent: radiusPercent, enclosingCicleRadius: r)
    }
    
    static func crossStar(numberOfPoints n: Int, enclosingCicleRadius r: CGFloat = 100) -> Shape {
        guard n >= 3 else { return Shape() }
        
        let polygon = regularPolygon(n: n, enclosingCirleRadius: r)
        let points = polygon.points
        
        guard !n.isMultiple(of: 2) && n >= 5 else {
            return star(numberOfPoints: n, enclosingCicleRadius: r)
        }
        
        var star = Shape().to(points.first!).applyingOption(.fill(.random))
        var idx = 0
        
        for _ in points.indices {
            let nextIndex = (idx + Int(floor(Double(points.count - 1) / 2))) % points.count
            let currentPoint = points[nextIndex]
            
            star.add(.point(currentPoint.x, currentPoint.y))
            
            idx = nextIndex
        }
        return star
    }
    
    
    static func crossStar(numberOfPoints n: Int, distanceBetweenPoints sideLength: CGFloat) -> Shape {
        let r = sideLength / (2 * sin((360 / CGFloat(n) / 2).degreesToRadians))
        return crossStar(numberOfPoints: n, enclosingCicleRadius: r)
    }
    
    
}

