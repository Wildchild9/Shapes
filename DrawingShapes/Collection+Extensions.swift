//
//  Collection+Extensions.swift
//  DrawingShapes
//
//  Created by Noah Wilder on 2019-01-20.
//  Copyright © 2019 Noah Wilder. All rights reserved.
//

import Foundation
import UIKit

public extension Sequence where Element: Equatable {
    
    /// An array containing all distinct elements in a sequence.
    ///
    /// Keeps the first occurrences of each element in array, every additional occurrence is not added into the array.
    ///
    /// - Complexity: O(*n²*), where *n* is the length of the sequence.
    ///
    var distinctElements: [Element] {
        return reduce(into: []) { if !$0.contains($1) { $0.append($1) } }
    }
    
}

public extension Sequence {
    
    /// Returns the number of elements of the sequence that satisfy the given predicate.
    ///
    /// In this example, `count(where:)` is used to count the number of even integers.
    ///
    ///     let numbers = [1, 2, 3, 4, 5, 6, 7]
    ///     let evenNumberCount = numbers.count { $0 % 2 == 0 }
    ///     print(evenNumberCount)
    ///     // Prints "3"
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument and returns a Boolean value indicating whether the element should be counted in the returned count.
    /// - Returns: The count of the elements that satisfy `predicate`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    ///
    func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        var counter = 0
        for element in self where try predicate(element) {
            counter += 1
        }
        return counter
    }
}
