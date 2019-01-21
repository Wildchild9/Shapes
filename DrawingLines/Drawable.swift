//
//  Drawable.swift
//  DrawingLines
//
//  Created by Noah Wilder on 2019-01-20.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation

public protocol Drawable: CustomPlaygroundDisplayConvertible {

    func draw() -> UIView
    
}

public extension Drawable {
    public var playgroundDescription: Any {
        return draw()
    }
}

