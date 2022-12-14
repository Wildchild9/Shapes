//
//  Array<Component>+Extensions.swift
//  DrawingShapes
//
//  Created by Noah Wilder on 2019-01-22.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation
import UIKit


public extension Array where Element == Shape.Component {
    func to(_ x: CGFloat, _ y: CGFloat) -> [Shape.Component] {
        return self + [.point(x, y)]
    }
    
    func joinedAt(x: CGFloat, y: CGFloat) -> [Shape.Component] {
        var arr = self + [.break]
        for case let .point(px, py) in self {
            arr.append(.point(px, py))
            arr.append(.point(x, y))
            arr.append(.break)
        }
        return arr
    }
    func joinedAt(points: (x: CGFloat, y: CGFloat)...) -> [Shape.Component] {
        var arr = self + [.break]
        for case let .point(px, py) in self {
            for (x, y) in points {
                arr.append(.point(px, py))
                arr.append(.point(x, y))
                arr.append(.break)
            }
        }
        return arr
    }
    func joinedAt(points: [CGPoint]) -> [Shape.Component] {
        var arr = self + [.break]
        for case let .point(px, py) in self {
            for point in points {
                arr.append(.point(px, py))
                arr.append(.point(point.x, point.y))
                arr.append(.break)
            }
        }
        return arr
    }
    func joinedAt(points: [Shape.Component]) -> [Shape.Component] {
        var arr = self + [.break]
        for case let .point(px, py) in self {
            for case let .point(x, y) in points {
                arr.append(.point(px, py))
                arr.append(.point(x, y))
                arr.append(.break)
            }
        }
        return arr
    }
    
    func mapPoints(_ transform: (CGPoint) throws -> CGPoint) rethrows -> [Element] {
        
        var result = ContiguousArray<Element>()
        result.reserveCapacity(underestimatedCount)
        
        for component in self {
            if case let .point(px, py) = component {
                let point = try transform(CGPoint(x: px, y: py))
                result.append(.point(point.x, point.y))
            } else {
                result.append(component)
            }
        }
        
        return Array(result)
        
    }
    
    func distinctPoints() -> [CGPoint] {
        var arr = [CGPoint]()
        for case let .point(x, y) in self {
            let p = CGPoint(x: x, y: y)
            if !arr.contains(p) {
                arr.append(p)
            }
        }
        return arr
    }
    
    func `break`() -> [Element] {
        var arr = self
        arr.append(.break)
        return arr
    }
    
    func close() -> [Element] {
        var arr = self
        arr.append(.close)
        return arr
    }
}
