//
//  CGPoint+Extensions.swift
//  DrawingShapes
//
//  Created by Noah Wilder on 2019-01-20.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation
import UIKit

public extension CGPoint {
    static func random(in range: ClosedRange<CGFloat>) -> CGPoint {
        return CGPoint(x: CGFloat.random(in: range), y: CGFloat.random(in: range))
    }
}
