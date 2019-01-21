//
//  Collection+Extensions.swift
//  DrawingLines
//
//  Created by Noah Wilder on 2019-01-20.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation

public extension Sequence where Element: Equatable {
    
    /// An array containing all distinct elements in a sequence.
    ///
    /// Keeps the first occurrences of each element in array, every additional occurrence is not added into the array.
    ///
    /// - Complexity: O(*n²*), where *n* is the length of the sequence.
    ///
    public var distinctElements: [Element] {
        return reduce(into: []) { if !$0.contains($1) { $0.append($1) } }
    }
    
}
