//
//  Line.swift
//  DrawingLines
//
//  Created by Noah Wilder on 2019-01-20.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation

public enum Line {
    case moveTo(_ x: CGFloat, _ y: CGFloat)
    case p(CGFloat, CGFloat)
    
    var point: CGPoint {
        switch self {
        case let .moveTo(x, y):
            return CGPoint(x: x, y: y)
        case let .p(x, y):
            return CGPoint(x: x, y: y)
        }
    }
}
