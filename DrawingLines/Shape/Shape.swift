//
//  Shape.swift
//  DrawingLines
//
//  Created by Noah Wilder on 2019-01-21.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation



/*
 A data structure with something like nodes
 Like saying vertex.connect(to: otherVertex)
 
 - cloneScale
 - cloneTranslate
 - cloneRotate
 - random point
 - add `indirect case segment([Component])` to Component enum (need to also add resursive flatten (maybe extension on array of components))
 - simplification to components array
 - lastPoint (problems with close, should return start of the segment)
 */


//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Shape Declaration
public struct Shape {
    
    public private(set) var components = [Component]()
    public var fill: Gradient = .sunrise
    public var options = Options()
    
    public init () { }
    
    public struct Options {
        fileprivate init() { }
        public var lineWidth: CGFloat = 3
        public var lineCap: CAShapeLayerLineCap = .round
        public var lineJoin: CAShapeLayerLineJoin = .round
        public var fillInShape = false
        public var shadowColor = UIColor.black.cgColor
        public var shadowOpacity: Float = 0.2
        public var shadowRadius: CGFloat = 2
        public var shadowOffset = CGSize(width: 1, height: 1)
    }
    
    public enum Component {
        case point(CGFloat, CGFloat)
        case close
        case `break`
        
        
        public func to(_ x: CGFloat, _ y: CGFloat) -> [Component] {
            return [self, .point(x, y)]
        }
        
        public var isPoint: Bool {
            if case .point = self {
                return true
            }
            return false
        }
        public func isSame(as component: Component) -> Bool {
            switch self {
            case .break  where !component.isPoint, .close where !component.isPoint:
                return true
            case let .point(x1, y1):
                if case let .point(x2, y2) = component {
                    return x1 == x2 && y1 == y2
                }
            default: break
            }
            return false
        }
    }
    
    public mutating func append(_ component: Component) {
        
        guard !(components.isEmpty && component.isPoint) else {
            components.append(component)
            return
        }
        
        guard let last = components.last else { return } // Will not add component if is empty and is not a point
        
        switch component {
        case .point:
            guard last != component else { return } // Will not add point if previous point is the same
        case .break, .close:
            guard last.isPoint else { return } // Will not add component if last is breaking
        }
        
        components.append(component)
    }
    
    public func appending(_ component: Component) -> Shape {
        var newShape = self
        newShape.append(component)
        return newShape
    }
    
    public mutating func replaceComponents(with components: [Component]) {
        self.components = components
    }
    
    /// Transforms all of the points that make up a shape with a given `transformation`.
    public mutating func transform(_ transformation: (CGPoint) -> CGPoint) {
        var pointCount = 0
        for case let (i, .point(x, y)) in components.enumerated() {
            let transformedPoint = transformation(CGPoint(x: x, y: y))
            components[i] = .point(transformedPoint.x, transformedPoint.y)
            pointCount += 1
        }
        guard pointCount > 1 else { return }

        for (i, component) in components.enumerated().reversed() where i >= 1 && component == components[i - 1] {
            components.remove(at: i)
        }

    }
    /// Returns a shape that has had a given `transformation` applied to each point in a shape.
    public func transformed(_ transformation: (CGPoint) -> CGPoint) -> Shape {
        var newShape = self
        newShape.transform(transformation)
        return newShape
    }
}




//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Initializers
public extension Shape {
    public init (components: [Component]) {
        self.components = components
    }
    
    public init (components: Component...) {
        self.init(components: components)
    }
    
    public init (components: [Component], fill: Gradient) {
        self.init(components: components)
        self.fill = fill
    }
    
    public init (components: Component..., fill: Gradient) {
        self.init(components: components, fill : fill)
    }
}


//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Static Shape Initialization
public extension Shape {
    public static func random(in range: ClosedRange<CGFloat>, numberOfPoints: Int) -> Shape {
        guard numberOfPoints > 0 else { return Shape() }
        
        var shape = Shape(components: .point(CGFloat.random(in: range), CGFloat.random(in: range)))
        guard numberOfPoints > 1 else { return shape }
        
        for _ in 2...numberOfPoints {
            shape.append(.point(CGFloat.random(in: range), CGFloat.random(in: range)))
        }
        shape.add(.break)
        
        return shape
    }
}

//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Computed Properties
public extension Shape {
    /// The bounds of the shape.
    ///
    /// - Complexity: O(*n*) where *n* is the number of points in the shape.
    ///
    public var bounds: CGRect {
        var pointArr = points
        
        guard !pointArr.isEmpty, let firstPoint = pointArr.first else { return CGRect() }
        guard pointArr.count > 1 else { return CGRect(origin: firstPoint, size: .zero) }
        
        
        var (maxX, minX) = (firstPoint.x, firstPoint.x)
        var (minY, maxY) = (firstPoint.y, firstPoint.y)
        
        for point in pointArr[1...] {
            switch point.x {
            case let px where px < minX: minX = px
            case let px where px > maxX: maxX = px
            default: break
            }
            switch point.y {
            case let py where py < minY: minY = py
            case let py where py > maxY: maxY = py
            default: break
            }
        }
        
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
    
    /// The points that make up the shape.
    ///
    /// - Complexity: O(*n*) where *n* is the number of points in the shape.
    ///
    public var points: [CGPoint] {
        return components.reduce(into: []) { pointArray, component in
            if case let .point(x, y) = component {
                let point = CGPoint(x: x, y: y)
                if !pointArray.contains(point) {
                    pointArray.append(point)
                }
            }
        }
    }
}


//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Appending Shape
public extension Shape {
    
    public mutating func append(_ components: [Component]) {
        for component in components {
            append(component)
        }
    }
    public mutating func append(_ components: Component...) {
        append(components)
    }
    
    public mutating func append(_ newComponents: [[Component]]) {
        for componentArr in components {
            append(componentArr)
        }
    }
    public mutating func append(_ components: [Component]...) {
        append(components)
    }
    
    public func appending(_ components: [Component]) -> Shape {
        var newShape = self
        newShape.append(components)
        return newShape
    }
    public func appending(_ components: Component...) -> Shape {
        return appending(components)
    }
    
}






//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Applying Options
public extension Shape {
    public func withFill(_ gradient: Gradient, angle: CGFloat = 0.0) -> Shape {
        var newShape = self
        newShape.fill = gradient.withAngle(of: angle)
        return newShape
    }
}


