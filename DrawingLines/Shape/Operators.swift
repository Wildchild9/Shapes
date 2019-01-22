//
//  Operators.swift
//  DrawingLines
//
//  Created by Noah Wilder on 2019-01-22.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation

//┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//┃ MARK: - Operators
public extension Shape {
    
    public static func + (lhs: Shape, rhs: Shape) -> Shape {
        return lhs.appending([.break] + rhs.components)
        
    }
    
    public static func += (lhs: inout Shape, rhs: Shape) {
        lhs = lhs + rhs
    }
}
