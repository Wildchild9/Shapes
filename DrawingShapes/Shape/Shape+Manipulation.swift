//
//  Shape+Manipulation.swift
//  DrawingShapes
//
//  Created by Noah Wilder on 2019-01-22.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation
import UIKit


public extension Shape {
    func prism(offsetBy distance: CGFloat = 25) -> Shape {
        return prism(offsetByX: distance, y: distance)
    }
    func prism(offsetByX x: CGFloat, y: CGFloat) -> Shape {
        var prism = self
        prism.append(.break)
        prism += self.translatedBy(x: x, y: -y)
        prism.append(.break)
        for p in components.distinctPoints() {
            prism.append(.point(p.x, p.y), .point(p.x + x, p.y - y), .break)
        }
        
        return prism
    }
    
    func joinedAt(x: CGFloat, y: CGFloat) -> Shape {
        var newShape = self
        newShape.add(.break)
        for case let .point(px, py) in components {
            newShape.append(.point(px, py), .point(x, y), .break)

        }
        return newShape
    }
    func joinedAt(points: (x: CGFloat, y: CGFloat)...) -> Shape {
        guard !points.isEmpty else { return self }
        var arr = self.breaking()
        for case let .point(px, py) in components {
            for point in points {
                arr.append(.point(px, py))
                arr.append(.point(point.x, point.y))
                arr.append(.break)
            }
        }
        return arr
    }
    func joinedAt(points: [CGPoint]) -> Shape {
        guard !points.isEmpty else { return self }
        var arr = self.breaking()
        for case let .point(px, py) in components {
            for point in points {
                arr.append(.point(px, py))
                arr.append(.point(point.x, point.y))
                arr.append(.break)
            }
        }
        return arr
    }
    func joinedAt(points: [Component]) -> Shape {
        guard !points.isEmpty else { return self }
        var arr = self.breaking()
        for case let .point(px, py) in components {
            for case let .point(x, y) in points {
                arr.append(.point(px, py))
                arr.append(.point(x, y))
                arr.append(.break)
            }
        }
        return arr
    }

    
    func mapPoints(_ transform: (CGPoint) throws -> CGPoint) rethrows -> [Component] {
        
        var result = ContiguousArray<Component>()
        result.reserveCapacity(components.underestimatedCount)
        
        for component in components {
            if case let .point(px, py) = component {
                let point = try transform(CGPoint(x: px, y: py))
                result.append(.point(point.x, point.y))
            } else {
                result.append(component)
            }
        }
        
        return Array(result)
    }

}
