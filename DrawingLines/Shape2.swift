//
//  Shape2.swift
//  DrawingLines
//
//  Created by Noah Wilder on 2019-01-21.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation


/*
 A data structure with something like nodes
 Like saying vertex.connect(to: otherVertex)
 */




public struct Shape2 {
    
    private var components = [Component]()
    public var fill: Gradient = .sunrise
    public var options = Options()
    
    public init () { }
    
    public struct Options {
        fileprivate init() { }
        var lineWidth: CGFloat = 3
        var lineCap: CAShapeLayerLineCap = .round
        var lineJoin: CAShapeLayerLineJoin = .round
        var fillInShape = false
        var shadowColor = UIColor.black.cgColor
        var shadowOpacity: Float = 0.2
        var shadowRadius: CGFloat = 2
        var shadowOffset = CGSize(width: 1, height: 1)
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
    }

}

extension Shape2.Component: Equatable {
    public static func == (lhs: Shape2.Component, rhs: Shape2.Component) -> Bool {
        switch (lhs, rhs) {
        case (.break, .break), (.close, .close):
            return true
        case let (.point(ax, ay), .point(bx, by)):
            return ax == bx && ay == by
        default:
            return false
        }
    }
}
public extension Array where Element == Shape2.Component {
    public func to(_ x: CGFloat, _ y: CGFloat) -> [Shape2.Component] {
        return self + [.point(x, y)]
    }
    
    public func joinedAt(x: CGFloat, y: CGFloat) -> [Shape2.Component] {
        var arr = self + [.break]
        for case let .point(px, py) in self {
            arr.append(.point(px, py))
            arr.append(.point(x, y))
            arr.append(.break)
        }
        return arr
    }
    
    public func cgPoints() -> [CGPoint] {
        return reduce(into: []) {
            if case let .point(px, py) = $1 {
                $0.append(CGPoint(x: px, y: py))
            }
        }
    }
    
    public func mapPoints(_ transform: (CGPoint) throws -> CGPoint) rethrows -> [Element] {
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
    
    public func distinctPoints() -> [CGPoint] {
        var arr = [CGPoint]()
        for case let .point(x, y) in self {
            let p = CGPoint(x: x, y: y)
            if !arr.contains(p) {
                arr.append(p)
            }
        }
        return arr
    }
    
    public func `break`() -> [Element] {
        var arr = self
        arr.append(.break)
        return arr
    }
    
    public func close() -> [Element] {
        var arr = self
        arr.append(.close)
        return arr
    }
}

public extension Shape2 {
    
    public mutating func add(_ component: Component) {
        switch component {
        case .point:
            components.append(component)
        case .break, .close:
            guard let last = components.last, last.isPoint else { return }
            components.append(component)
        }
    }
    public func `break`() -> Shape2 {
        guard let last = components.last, last != .break, last != .close else { return self }
        return appending(.break)
    }
    
    public func close() -> Shape2 {
        guard let last = components.last, last != .break, last != .close else { return self }
        return appending(.close)
    }
    
    public func to(_ x: CGFloat, _ y: CGFloat) -> Shape2 {
        return appending(.point(x, y))
    
    }
    
    public func joinedAt(x: CGFloat, y: CGFloat) -> Shape2 {
        var newShape = self
        newShape.components = components.joinedAt(x: x, y: y)
        return newShape
    }
    public func joinedAt(points: (x: CGFloat, y: CGFloat)...) -> Shape2 {
        guard !points.isEmpty else { return self }
        var arr = self.break()
        for case let .point(px, py) in components {
            for point in points {
                arr.append(.point(px, py))
                arr.append(.point(point.x, point.y))
                arr.append(.break)
            }
        }
        return arr
    }
}


////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
//MARK: - Initializers
public extension Shape2 {
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

/*
 
 for component in components {
 switch component {
 case let .moveTo(x, y):
 path.move(to: CGPoint(x: x, y: y))
 case let .p(x, y):
 path.addLine(to: CGPoint(x: x, y: y))
 }
 points.append(component.point)
 }
 */
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
//MARK: - Computed Properties
public extension Shape2 {
    /// The bounds of the shape.
    ///
    /// - Complexity: O(*n*) where *n* is the number of points in the shape.
    ///
    public var bounds: CGRect {
        let pointCount = components.count { $0.isPoint }
        guard pointCount > 0 else { return CGRect() }
        var rect = CGRect()
        let firstPointIdx = components.firstIndex { $0.isPoint }!
        if case let .point(x, y) = components[firstPointIdx] {
            rect.origin = CGPoint(x: x, y: y)
        }
        
        guard pointCount > 1 else { return rect }
        let secondPointIdx = components[(firstPointIdx + 1)...].firstIndex { $0.isPoint }!
        
        var maxX, maxY, minX, minY: CGFloat
        if case let .point(x, y) = components[firstPointIdx] {
            if x > rect.origin.x {
                maxX = x
                minX = rect.origin.x
            } else {
                maxX = rect.origin.x
                minX = x
            }
            if y > rect.origin.y {
                maxY = y
                minY = rect.origin.y
            } else {
                maxY = rect.origin.y
                minY = y
            }
        } else {
            fatalError()
        }
        
        guard pointCount > 2 else { return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY) }
        
        
        for case let .point(x, y) in components[(secondPointIdx + 1)...] {
            switch x {
            case let px where px < minX: minX = px
            case let px where px > maxX: maxX = px
            default: break
            }
            switch y {
            case let py where py < minY: minY = py
            case let py where py > maxY: maxY = py
            default: break
            }
        }
        
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
}
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
//MARK: - Shape2 Operations
public extension Shape2 {
    public static func + (lhs: Shape2, rhs: Shape2) -> Shape2 {
        var newShape: Shape2
        if let last = lhs.components.last, last == .break || last == .close {
            newShape = Shape2(components: lhs.components + rhs.components, fill: lhs.fill)
        } else {
            newShape = Shape2(components: lhs.components + [.break] + rhs.components, fill: lhs.fill)
        }
        newShape.options = lhs.options
        return newShape
    }
    
    public static func += (lhs: inout Shape2, rhs: Shape2) {
        lhs = lhs + rhs
    }
}


////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
//MARK: - Transformations
public extension Shape2 {
    
    public mutating func translateBy(x: CGFloat, y: CGFloat) {
        components = components.mapPoints { CGPoint(x: $0.x + x, y: $0.y + y) }
    }
    public func translatedBy(x: CGFloat, y: CGFloat) -> Shape2 {
        var newShape = self
        newShape.translateBy(x: x, y: y)
        return newShape
    }

    public mutating func scale(by factor: CGFloat) {
        components = components.mapPoints { CGPoint(x: $0.x * factor, y: $0.y * factor) }
    }
    public func scaled(by factor: CGFloat) -> Shape2 {
        var newShape = self
        newShape.scale(by: factor)
        return newShape
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
//    public func rotated(by angle: CGFloat) -> Shape2 {
//        var newShape = self
//        newShape.rotate(by: angle)
//        return newShape
//    }

    
}


////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
//MARK: - Append Sahpe
public extension Shape2 {
    public mutating func append(_ newComponents: [Component]) {
        components.append(contentsOf: newComponents)
    }
    public mutating func append(_ newComponents: Component...) {
        self.append(newComponents)
    }
    public mutating func append(_ newComponent: Component) {
        guard let last = components.last, last != newComponent else { return }
        components.append(newComponent)
    }

    
    public func appending(_ newComponents: [Component]) -> Shape2 {
        var newShape = self
        newShape.append(newComponents)
        return newShape
    }
    public func appending(_ components: Component...) -> Shape2 {
        return self.appending(components)
    }
    
    
}


////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
//MARK: - Option Functions
public extension Shape2 {
    public func withFill(_ gradient: Gradient) -> Shape2 {
        var newShape = self
        newShape.fill = gradient
        return newShape
    }
}
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
//MARK: - Shape Manipulation

public extension Shape2 {
    public func prism(offsetBy distance: CGFloat = 25) -> Shape2 {
        return prism(offsetByX: distance, y: distance)
    }
    public func prism(offsetByX x: CGFloat, y: CGFloat) -> Shape2 {
        var prism = self
        prism.append(.break)
        prism += self.translatedBy(x: x, y: -y)
        prism.append(.break)
        for p in components.distinctPoints() {
            prism.append(.point(p.x, p.y), .point(p.x + x, p.y - y), .break)
        }
        
        return prism
    }
}



////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
//MARK: - Random Shape
public extension Shape2 {
    public static func random(in range: ClosedRange<CGFloat>, numberOfPoints: Int) -> Shape2 {
        guard numberOfPoints > 0 else { return Shape2() }
        let randomPoint = CGPoint.random(in: range)
        
        var shape = Shape2(components: .point(randomPoint.x, randomPoint.y))
        guard numberOfPoints > 1 else { return shape }
        
        for _ in 2...numberOfPoints {
            let rand = CGPoint.random(in: range)
            shape.append(.point(rand.x, rand.y))
        }
        shape.add(.break)
        
        return shape
    }
}

////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
//MARK: - Drawable Conformance
extension Shape2: Drawable {
    public func draw() -> UIView {
        let view = UIView()
        
        let path = UIBezierPath()
        let padding: CGFloat = 5

        let shapeBounds = bounds
        let adjX = padding - shapeBounds.minX
        let adjY = padding - shapeBounds.minY
        
        var lastWasBroken = true
        for component in components {
            switch component {
            case let .point(x, y):
                let point = CGPoint(x: x + adjX, y: y + adjY)
                if lastWasBroken {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
                lastWasBroken = false
            
            case .break:
                lastWasBroken = true
                
            case .close:
                if !lastWasBroken {
                    path.close()
                    lastWasBroken = true
                }
            }
        }
        
        //let pathBounds = path.bounds
        let line = CAShapeLayer()
        view.frame.size.width = shapeBounds.size.width + padding * 2
        view.frame.size.height = shapeBounds.size.height + padding * 2
        view.frame.origin = .zero
        
        line.path = path.cgPath
        line.lineWidth = options.lineWidth
        line.lineCap = options.lineCap
        line.lineJoin = options.lineJoin
        
        if options.fillInShape {
            line.strokeColor = UIColor.clear.cgColor
            line.fillColor = fill.uiColor(forFrame: view.frame).cgColor
        } else  {
            line.strokeColor = fill.uiColor(forFrame: view.frame).cgColor
            line.fillColor = UIColor.clear.cgColor
        }
        
        line.shadowColor = options.shadowColor
        line.shadowOpacity = options.shadowOpacity
        line.shadowRadius = options.shadowRadius
        line.shadowOffset = options.shadowOffset
        
        view.layer.addSublayer(line)
        
        return view
    }
}



