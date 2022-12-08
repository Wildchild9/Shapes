//
//  Degrees+Radians+Conversions.swift
//  DrawingShapes
//
//  Created by Noah Wilder on 2019-01-21.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation
import UIKit

public extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

public extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}





