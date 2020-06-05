//
//  RangeReplaceableCollection+extension.swift
//  EComApp
//
//  Created by Raj Kadam on 05/06/20.
//  Copyright © 2020 Raj Kadam. All rights reserved.
//

import Foundation

extension RangeReplaceableCollection where Element: Equatable {
    @discardableResult
    mutating func appendIfNotContains(_ element: Element) -> (appended: Bool, memberAfterAppend: Element) {
        if let index = firstIndex(of: element) {
            return (false, self[index])
        } else {
            append(element)
            return (true, element)
        }
    }
}
