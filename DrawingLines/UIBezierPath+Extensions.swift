//
//  UIBezierPath+Extensions.swift
//  DrawingLines
//
//  Created by Noah Wilder on 2019-01-20.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation

public extension UIBezierPath {
    public convenience init (components: Line...) {
        self.init()
        for component in components {
            switch component {
            case let .moveTo(x, y):
                move(to: CGPoint(x: x, y: y))
            case let .p(x, y):
                addLine(to: CGPoint(x: x, y: y))
            }
        }
    }
    
    public func duplicate() -> UIBezierPath {
        return copy() as! UIBezierPath
    }
}
