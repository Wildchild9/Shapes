//
//  Shape+Creation.swift
//  DrawingShapes
//
//  Created by Noah Wilder on 2019-01-22.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation
import UIKit


//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Basic Shape Creation
public extension Shape {
    
    
    //┌─────────────────────────────────────────────
    //│ MARK: Mutating Component Addition
    
    /// Mutating add component to shape.
    mutating func add(_ component: Component) {
        self.append(component)
    }
    
    /// Adds a break to the shape.
    mutating func `break`() {
        guard let last = components.last, last != .break, last != .close else { return }
        append(.break)
    }
    
    /// Closes the shapes.
    mutating func close() {
        guard let last = components.last, last != .break, last != .close else { return }
        append(.close)
    }
    
    
    //┌─────────────────────────────────────────────
    //│ MARK:  Non-mutating Component Addition
    
    /// A shape with a break added.
    func `breaking`() -> Shape {
        guard let last = components.last, last != .break, last != .close else { return self }
        return appending(.break)
    }
    
    /// A shape with a close added.
    func closed() -> Shape {
        guard let last = components.last, last != .break, last != .close else { return self }
        return appending(.close)
    }
    
    /// A shape with a point added to its components.
    func to(_ x: CGFloat, _ y: CGFloat) -> Shape {
        return appending(.point(x, y))
    }
    
    /// A shape with a point added to its components.
    func to(_ point: CGPoint) -> Shape {
        return appending(.point(point.x, point.y))
    }
    
    /// A shape with a point added to its components.
    func to(_ coordinate: Coordinate) -> Shape {
        return appending(.point(coordinate.x, coordinate.y))
    }
}

public extension Shape {
    /// A shape with a point added to its components.
    static func to(_ x: CGFloat, _ y: CGFloat) -> Shape {
        return Shape().appending(.point(x, y))
    }
    
    /// A shape with a point added to its components.
    static func to(_ point: CGPoint) -> Shape {
        return Shape().appending(.point(point.x, point.y))
    }
    
    /// A shape with a point added to its components.
    static func to(_ coordinate: Coordinate) -> Shape {
        return Shape().appending(.point(coordinate.x, coordinate.y))
    }
}
