//
//  Drawable.swift
//  DrawingShapes
//
//  Created by Noah Wilder on 2019-01-20.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation
import UIKit

public protocol Drawable: CustomPlaygroundDisplayConvertible {

    func draw() -> UIView
    
}

public extension Drawable {
    var playgroundDescription: Any {
        return draw()
    }
}

