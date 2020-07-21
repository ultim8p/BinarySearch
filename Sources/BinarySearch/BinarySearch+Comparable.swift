//
//  File.swift
//  
//
//  Created by Ita on 7/2/20.
//

import Foundation

public extension Array where Element: Comparable {
    /// Returns the index of an object in an array, if the item is not found we return the index where it should be inserted.
    func binarySearch(withBound bound: BinarySearchBound = .any, _ obj: Element) -> (currentIndex: Int?, insertInIndex: Int?) {
        if self.count == 0 {
            return (nil, 0)
        }
        var lowerIndex = 0
        var upperIndex = self.count - 1
        var currentIndex = 0
        var indexResult = -1
        while (lowerIndex <= upperIndex) {
            currentIndex = (lowerIndex + upperIndex) / 2
            let currentValue = self[currentIndex]
            switch bound {
            case .any:
                if currentValue == obj {
                    return (currentIndex, nil)
                }
                upperIndex = currentValue >= obj ? currentIndex - 1 : upperIndex
                lowerIndex = currentValue < obj ? currentIndex + 1 : lowerIndex
            case .lower:
                upperIndex = currentValue >= obj ? currentIndex - 1 : upperIndex
                lowerIndex = currentValue < obj ? currentIndex + 1 : lowerIndex
                indexResult = currentValue == obj ? currentIndex : indexResult
            case .upper:
                lowerIndex = currentValue <= obj ? currentIndex + 1 : lowerIndex
                upperIndex = currentValue > obj ? currentIndex - 1 : upperIndex
                indexResult = currentValue == obj ? currentIndex : indexResult
            }
        }
        var index = (bound == .any) ? currentIndex : (indexResult != -1 ? indexResult : currentIndex)
        let valueFound = self[index]
        if valueFound == obj {
            return (index, nil)
        }
        index = valueFound > obj ? index : index + 1
        return (nil, index)
    }
}
