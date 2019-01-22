//
//  Shape+Conformances.swift
//  DrawingLines
//
//  Created by Noah Wilder on 2019-01-22.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation


//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Equatable Conformance
extension Shape.Component: Equatable {
    
    public static func == (lhs: Shape.Component, rhs: Shape.Component) -> Bool {
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


//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Drawable Comformance
extension Shape: Drawable {
    
    public func draw() -> UIView {
        
        // Constant declarations
        let view = UIView()
        let path = UIBezierPath()
        let padding: CGFloat = 7.5
        let shapeBounds = bounds
        let adjX = padding - shapeBounds.minX
        let adjY = padding - shapeBounds.minY
        
        // Create path
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
                
            case _ where lastWasBroken: // Can skip the next two cases
                continue
                
            case .break:
                lastWasBroken = true
                
            case .close:
                if !lastWasBroken {
                    path.close()
                    lastWasBroken = true
                }
            }
        }
        
        // Add padding to view
        let shapeLayer = CAShapeLayer()
        view.frame.size.width = shapeBounds.size.width + padding * 2
        view.frame.size.height = shapeBounds.size.height + padding * 2
        view.frame.origin = .zero
        
        // Set path and line properties
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = options.lineWidth
        shapeLayer.lineCap = options.lineCap
        shapeLayer.lineJoin = options.lineJoin
        
        // Fill in shape 
        if options.fillInShape {
            shapeLayer.strokeColor = UIColor.clear.cgColor
            shapeLayer.fillColor = fill.uiColor(forFrame: view.frame).cgColor
        } else  {
            shapeLayer.strokeColor = fill.uiColor(forFrame: view.frame).cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
        }
        
        // Add shadow to shape
        shapeLayer.shadowColor = options.shadowColor
        shapeLayer.shadowOpacity = options.shadowOpacity
        shapeLayer.shadowRadius = options.shadowRadius
        shapeLayer.shadowOffset = options.shadowOffset
        
        // Add shape to view
        view.layer.addSublayer(shapeLayer)
        
        return view
    }
}



//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Component CustomStringConvertible Conformance
extension Shape.Component: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .point(x, y): return ".point(\(x), \(y))"
        case .break: return ".break"
        case .close: return ".close"
        }
    }
}
