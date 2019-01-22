//
//  Degrees+Radians+Conversions.swift
//  DrawingLines
//
//  Created by Noah Wilder on 2019-01-21.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation

public extension BinaryInteger {
    public var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

public extension FloatingPoint {
    public var degreesToRadians: Self { return self * .pi / 180 }
    public var radiansToDegrees: Self { return self * 180 / .pi }
}





