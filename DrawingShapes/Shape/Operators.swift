//
//  Operators.swift
//  DrawingShapes
//
//  Created by Noah Wilder on 2019-01-22.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation
import UIKit

//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Operators
public extension Shape {
    
    static func + (lhs: Shape, rhs: Shape) -> Shape {
        return lhs.appending([.break] + rhs.components)
        
    }
    
    static func += (lhs: inout Shape, rhs: Shape) {
        lhs = lhs + rhs
    }
}
