//
//  Shape+Creation.swift
//  DrawingLines
//
//  Created by Noah Wilder on 2019-01-22.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation


//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Basic Shape Creation
public extension Shape {
    
    
    //┌─────────────────────────────────────────────
    //│ MARK: Mutating Component Addition
    
    // Mutating add component
    public mutating func add(_ component: Component) {
        self.append(component)
    }
    
    
    //┌─────────────────────────────────────────────
    //│ MARK:  Non-mutating Component Addition
    
    /// A shape with a break added.
    public func `break`() -> Shape {
        guard let last = components.last, last != .break, last != .close else { return self }
        return appending(.break)
    }
    
    /// A close shape to its components.
    public func close() -> Shape {
        guard let last = components.last, last != .break, last != .close else { return self }
        return appending(.close)
    }
    
    /// A shape with a point added to its components.
    public func to(_ x: CGFloat, _ y: CGFloat) -> Shape {
        return appending(.point(x, y))
    }
    
    /// A shape with a point added to its components.
    public func to(_ point: CGPoint) -> Shape {
        return appending(.point(point.x, point.y))
    }
    
    /// A shape with a point added to its components.
    public func to(_ coordinate: Coordinate) -> Shape {
        return appending(.point(coordinate.x, coordinate.y))
    }
}
