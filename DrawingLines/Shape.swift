//
//  Shape
//  DrawingLines
//
//  Created by Noah Wilder on 2019-01-20.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation


public struct Shape {
    
    private var points = [CGPoint]()
    private var path: UIBezierPath
    public var fill: Fill = .gradient(.sunrise)
    public var options = Options()
    
    public init () {
        path = UIBezierPath()
    }
    
    public enum Fill {
        case gradient(Gradient)
        case color(UIColor)
        
        public var angle: CGFloat {
            get {
                switch self {
                case let .gradient(c): return c.angle
                default: return 0.0
                }
            }
            set {
                if case let .gradient(c) = self {
                    var g = c
                    g.angle = newValue
                    self = .gradient(g)
                }
            }
        }

        func uiColor(forFrame frame: CGRect) -> UIColor {
            switch self {
            case let .color(c):
                return c
            case let .gradient(c):
                return c.uiColor(forFrame: frame)
            }
        }
    }
    
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
        
        // padding
        
    }
    
}


////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
//MARK: - Initializers
public extension Shape {
    public init (components: Line..., fill: Fill? = nil) {
        self.init()
        if let fill = fill {
            self.fill = fill
        }
        for component in components {
            switch component {
            case let .moveTo(x, y):
                path.move(to: CGPoint(x: x, y: y))
            case let .p(x, y):
                path.addLine(to: CGPoint(x: x, y: y))
            }
            points.append(component.point)
        }
    }
}


////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
//MARK: - Computed Properties
public extension Shape {
    public var bounds: CGRect {
        return path.bounds
    }
}

////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
//MARK: - Shape Operations
public extension Shape {
    public static func + (lhs: Shape, rhs: Shape) -> Shape {
        var shape = Shape()
        shape.points.append(contentsOf: lhs.points + rhs.points)
        shape.path.append(lhs.path.duplicate())
        shape.path.append(rhs.path.duplicate())
        shape.options = lhs.options
        shape.fill = lhs.fill
        return shape
        /*
        var shape = lhs
        let rhs = rhs.copy()
        shape.path.append(rhs.path)
        shape.points.append(contentsOf: rhs.points)
        return shape*/
    }
    
    public static func += (lhs: inout Shape, rhs: Shape) {
        lhs = lhs + rhs.copy()
    }
}


////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
//MARK: - Transformations
public extension Shape {
    public mutating func translateBy(x: CGFloat, y: CGFloat) {
        let transformation = CGAffineTransform(translationX: x, y: y)
        points = points.map { CGPoint(x: $0.x + x, y: $0.y + y) }
        path.apply(transformation)
    }
    
    public func translatedBy(x: CGFloat, y: CGFloat) -> Shape {
        var shape = self
        shape.translateBy(x: x, y: y)
        return shape
    }
    
    public mutating func scale(by factor: CGFloat) {
        let transformation = CGAffineTransform(scaleX: factor, y: factor)
        path.apply(transformation)
        points = points.map { CGPoint(x: $0.x * factor, y: $0.y * factor) }
    }
    public func scaled(by factor: CGFloat) -> Shape {
        var shape = self
        shape.scale(by: factor)
        return shape
    }
    
    public mutating func rotate(by angle: CGFloat) {
        
        let transformation = CGAffineTransform(rotationAngle: -angle.degreesToRadians)
        path.apply(transformation)
        let center = CGPoint(x: path.bounds.midX, y: path.bounds.midY)

        points = points.map { p in
            let r = CGFloat(sqrt(pow(Double(p.x - center.x), 2) + pow(Double(p.y - center.y), 2)))
            let newX = center.x + (r * cos(angle))
            let newY = center.y + (r * sin(angle))

            return CGPoint(x: newX, y: newY)
        }
    }
    public func rotated(by angle: CGFloat) -> Shape {
        var shape = self
        shape.rotate(by: angle)
        return shape
    }
    
    public enum Flip {
        case horizontally, vertically
    }
    public mutating func flip(_ direction: Flip) {
        #warning("Flip shape incomplete")
    }

}


////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
//MARK: - Append Sahpe
public extension Shape {
    public mutating func append(_ components: [Line]) {
        for component in components {
            switch component {
            case let .moveTo(x, y):
                path.move(to: CGPoint(x: x, y: y))
            case let .p(x, y):
                path.addLine(to: CGPoint(x: x, y: y))
            }
            points.append(component.point)
        }
    }
    public mutating func append(_ components: Line...) {
        self.append(components)
    }
    
    public func appending(_ components: [Line]) -> Shape {
        var newShape = self
        for component in components {
            switch component {
            case let .moveTo(x, y):
                newShape.path.move(to: CGPoint(x: x, y: y))
            case let .p(x, y):
                newShape.path.addLine(to: CGPoint(x: x, y: y))
            }
            newShape.points.append(component.point)
        }
        return newShape
    }
    public func appending(_ components: Line...) -> Shape {
        return self.appending(components)
    }
    
    public func copy() -> Shape {
        var shape = Shape()
        shape.options = options
        shape.fill = fill
        shape.points = points
        shape.path = path.duplicate()
        return shape
    }
    
}


////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
//MARK: - Shape Manipulation

public extension Shape {
    public func prism(offsetBy distance: CGFloat = 25) -> Shape {
        return prism(offsetByX: distance, y: distance)
    }
    public func prism(offsetByX x: CGFloat, y: CGFloat) -> Shape {
        var shape = self
        let secondShape = copy()
        shape += secondShape.translatedBy(x: x, y: -y)
        
        for p in points.distinctElements {
            shape.append(.moveTo(p.x, p.y), .p(p.x + x, p.y - y))
        }
        
        return shape
    }
}


////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
//MARK: - Random Shape
public extension Shape {
    public static func random(in range: ClosedRange<CGFloat>, numberOfPoints: Int) -> Shape {
        guard numberOfPoints > 0 else { return Shape() }
        let randomPoint = CGPoint.random(in: range)
        var shape = Shape(components: .moveTo(randomPoint.x, randomPoint.y))
        guard numberOfPoints > 1 else { return shape }
        for _ in 2...numberOfPoints {
            let rand = CGPoint.random(in: range)
            shape.append(.p(rand.x, rand.y))
        }
        return shape
    }
}

////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
//MARK: - Drawable Conformance
extension Shape: Drawable {
    public func draw() -> UIView {
        let view = UIView()
        let pathBounds = path.bounds
        let padding: CGFloat = 5
        let line = CAShapeLayer()
        view.frame.size.width = pathBounds.size.width + padding * 2
        view.frame.size.height = pathBounds.size.height + padding * 2
        view.frame.origin = .zero
        
        let pathCopy = path.duplicate()
        let transformation = CGAffineTransform(translationX: padding - pathBounds.minX,
                                               y: padding - pathBounds.minY)
        pathCopy.apply(transformation)
        
        line.path = pathCopy.cgPath
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



public extension BinaryInteger {
    public var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

public extension FloatingPoint {
    public var degreesToRadians: Self { return self * .pi / 180 }
    public var radiansToDegrees: Self { return self * 180 / .pi }
}

















/* With [Line]
 
 public struct Shape {
 
 private var lineComponents: [Line]
 public var fill: Fill = .gradient(.sunrise)
 public var options = Options()
 
 public init () {
 lineComponents = [Line]()
 }
 
 public enum Fill {
 case gradient(Gradient)
 case color(UIColor)
 }
 
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
 
 // padding
 
 }
 
 
 
 }
 
 
 ////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
 ////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
 //MARK: - Initializers
 public extension Shape {
 
 public init (components: Line..., fill: Fill? = nil) {
 self.init()
 if let fill = fill {
 self.fill = fill
 }
 lineComponents.append(contentsOf: components)
 }
 }
 //public init (components: Line..., fill: Fill? = nil) {
 //    self.init()
 //    if let fill = fill {
 //        self.fill = fill
 //    }
 //    for component in components {
 //        switch component {
 //        case let .moveTo(x, y):
 //            path.move(to: CGPoint(x: x, y: y))
 //        case let .p(x, y):
 //            path.addLine(to: CGPoint(x: x, y: y))
 //        }
 //    }
 //}
 
 ////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
 ////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
 //MARK: - Computed Properties
 public extension Shape {
 /// The bounds of the shape.
 ///
 /// - Complexity: O(*n*) where *n* is the number of points in the shape.
 ///
 public var bounds: CGRect {
 var minX, minY, maxX, maxY: CGFloat
 
 for component in lineComponents {
 let point = component.point
 if point.x < minX {
 minX = point.x
 } else if point.x > maxX {
 maxX = point.x
 }
 if point.y < minY {
 minY = point.y
 } else if point.y > maxY {
 maxY = point.y
 }
 }
 
 return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
 }
 
 /// The points that make up the shape,
 ///
 /// - Complexity: O(*n*) where *n* is the number of points in the shape.
 ///
 public var points: [CGPoint] {
 return lineComponents.map { $0.point }
 }
 
 
 }
 
 ////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
 ////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
 //MARK: - Shape Operationss
 public extension Shape {
 public static func + (lhs: Shape, rhs: Shape) -> Shape {
 var newShape = lhs
 newShape.lineComponents.append(contentsOf: rhs.lineComponents)
 return newShape
 }
 
 public mutating func translateBy(x: CGFloat, y: CGFloat) {
 lineComponents = lineComponents.map { component in
 switch component {
 case let .moveTo(a, b):
 return .moveTo(a + x, b + y)
 case let .p(a, b):
 return .p(a + x, b + y)
 }
 }
 //        let transformation = CGAffineTransform(translationX: x, y: y)
 //        path.apply(transformation)
 }
 
 public func translatedBy(x: CGFloat, y: CGFloat) -> Shape {
 var shape = self
 shape.translateBy(x: x, y: y)
 return shape
 }
 
 public mutating func scale(by factor: CGFloat, anchor: Anchor = .center) {
 let transformation = CGAffineTransform(scaleX: factor, y: factor)
 let bounds = path.bounds
 path.apply(transformation)
 
 switch anchor {
 case .center:
 let adjX = bounds.midX - path.bounds.midX
 let adjY = bounds.midY - path.bounds.midY
 translateBy(x: adjX, y: adjY)
 
 case .topLeft:
 let adjX = bounds.minX - path.bounds.minX
 let adjY = bounds.minY - path.bounds.minY
 translateBy(x: adjX, y: adjY)
 
 case .topRight:
 let adjX = bounds.maxX - path.bounds.maxX
 let adjY = bounds.minY - path.bounds.minY
 translateBy(x: adjX, y: adjY)
 
 case .bottomLeft:
 let adjX = bounds.minX - path.bounds.minX
 let adjY = bounds.maxY - path.bounds.maxY
 translateBy(x: adjX, y: adjY)
 
 case .bottomRight:
 let adjX = bounds.maxX - path.bounds.maxX
 let adjY = bounds.maxY - path.bounds.maxY
 translateBy(x: adjX, y: adjY)
 // case let .custom(x, y):
 
 
 }
 
 }
 
 public enum Anchor {
 case center, topLeft, topRight, bottomLeft, bottomRight
 // case custom(x: CGFloat, y: CGFloat)
 }
 
 public mutating func append(_ components: Line...) {
 for component in components {
 switch component {
 case let .moveTo(x, y):
 path.move(to: CGPoint(x: x, y: y))
 case let .p(x, y):
 path.addLine(to: CGPoint(x: x, y: y))
 }
 }
 }
 
 public func appending(_ components: Line...) -> Shape {
 let newShape = self
 for component in components {
 switch component {
 case let .moveTo(x, y):
 newShape.path.move(to: CGPoint(x: x, y: y))
 case let .p(x, y):
 newShape.path.addLine(to: CGPoint(x: x, y: y))
 }
 }
 return newShape
 }
 
 }
 
 
 ////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
 ////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
 //MARK: - Shape Manipulation
 
 public extension Shape {
 func prism() -> Shape {
 path.
 }
 }
 
 ////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
 ////￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭￭\\\\\
 //MARK: - Drawable Conformance
 extension Shape: Drawable {
 public func draw() -> UIView {
 let view = UIView()
 let pathBounds = path.bounds
 let padding: CGFloat = 5
 let line = CAShapeLayer()
 
 view.frame.size.width = pathBounds.size.width + padding * 2
 view.frame.size.height = pathBounds.size.height + padding * 2
 view.frame.origin = .zero
 
 let pathCopy = path.copy() as! UIBezierPath
 let transformation = CGAffineTransform(translationX: padding - pathBounds.minX,
 y: padding - pathBounds.minY)
 pathCopy.apply(transformation)
 
 line.path = pathCopy.cgPath
 line.lineWidth = options.lineWidth
 line.lineCap = options.lineCap
 line.lineJoin = options.lineJoin
 
 switch (options.fillInShape, fill) {
 case let (false, .color(c)):
 line.strokeColor = c.cgColor
 line.fillColor = UIColor.clear.cgColor
 case let (true, .color(c)):
 line.strokeColor = UIColor.clear.cgColor
 line.fillColor = c.cgColor
 case let (false, .gradient(c)):
 line.strokeColor = c.uiColor(forFrame: view.frame).cgColor
 line.fillColor = UIColor.clear.cgColor
 case let (true, .gradient(c)):
 line.strokeColor = UIColor.clear.cgColor
 line.fillColor = c.uiColor(forFrame: view.frame).cgColor
 }
 
 line.shadowColor = options.shadowColor
 line.shadowOpacity = options.shadowOpacity
 line.shadowRadius = options.shadowRadius
 line.shadowOffset = options.shadowOffset
 
 
 
 view.layer.addSublayer(line)
 
 return view
 }
 }
 
 
 
 
 
 */
