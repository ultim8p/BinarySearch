//
//  File.swift
//  
//
//  Created by Ita on 7/2/20.
//

import Foundation

public extension Array where Element == [String: Any] {
    
    func searchRange(with key: String, lowerValue: Any, lowerOpt: LowerOperator, upperValue: Any, upperOpt: UpperOperator, limit: Int?, bound: Bound) -> [Element]? {
        let valuesComparison = ["value": lowerValue].compare(to: upperValue, key: "value")
        guard valuesComparison == .equal || valuesComparison == .lower else { return nil }
        let lowerBound: BinarySearchBound = lowerOpt == .greaterOrequal ? .lower : .upper
        let upperBound: BinarySearchBound = upperOpt == .lowerOrequal ? .upper : .lower
        let lowerSearchResult = binarySearch(withBound: lowerBound, key: key, value: lowerValue)
        let upperSearchResult = binarySearch(withBound: upperBound, key: key, value: upperValue)
        var lowerIndexR: Int?
        var upperIndexR: Int?

        if let current = lowerSearchResult.currentIndex {
            lowerIndexR = lowerOpt == .greaterOrequal ? current : (Swift.min(current + 1,self.count))
        } else if let insertInIndex = lowerSearchResult.insertInIndex {
            lowerIndexR = insertInIndex
        }

        if let current = upperSearchResult.currentIndex {
            upperIndexR = upperOpt == .lowerOrequal ? current : Swift.max(current - 1, 0)
        } else if let insertInIndex = upperSearchResult.insertInIndex {
            upperIndexR = Swift.max(insertInIndex - 1, 0)
        }
        guard var lowerIndex = lowerIndexR, var upperIndex = upperIndexR, lowerIndex <= upperIndex else { return nil }
        guard var limit = limit else { return Array(self[lowerIndex...upperIndex]) }
        limit = limit - 1
        upperIndex = bound == .lower ? Swift.min((lowerIndex + limit), upperIndex) : upperIndex
        lowerIndex = bound == .upper ? Swift.max(upperIndex - limit, lowerIndex) : lowerIndex
        return Array(self[lowerIndex...upperIndex])
    }
    
    func searchRange(with key: String, value: Any, withOp operatr: LowerOperator) -> [Element]? {
        switch operatr {
        case .greater:
            return self.searchRange(with: key, value: value, withOp: .greater, limit: nil, skip: nil)
        case .greaterOrequal:
            let searchResults = binarySearch(withBound: .lower, key: key, value: value)
            let endIndex = self.count - 1
            guard let startIndex = searchResults.currentIndex ?? searchResults.insertInIndex, startIndex >= 0, startIndex <= endIndex else { return nil }
            return Array(self[startIndex...endIndex])
        }
    }
    
    func searchRange(with key: String, value: Any, withOp operatr: UpperOperator) -> [Element]? {
        switch operatr {
        case .lower:
            return self.searchRange(with: key, value: value, withOp: .lower, limit: nil, skip: nil)
        case .lowerOrequal:
            let searchResults = binarySearch(withBound: .upper, key: key, value: value)
            let endIndex = searchResults.currentIndex ?? ((searchResults.insertInIndex ?? 0) - 1)
            guard endIndex >= 0, endIndex < self.count else { return nil }
            return Array(self[0...endIndex])
        }
    }
    
    func searchRange(with key: String, value: Any, withOp operatr: ExclusiveOperator, limit: Int?, skip: Int? = nil) -> [Element]? {
        if (skip != nil && (skip ?? 1) < 0) || (limit != nil && (limit ?? 1) < 1) {
            return nil
        }
        let lastIndex = self.count - 1
        if operatr == .greater {
            let searchResult = binarySearch(withBound: .upper, key: key, value: value)
            guard var startIndex = searchResult.currentIndex != nil ? (searchResult.currentIndex! + 1) : searchResult.insertInIndex, startIndex < self.count else { return nil }
            startIndex = startIndex + (skip ?? 0)
            guard let limit = limit else {
                guard startIndex <= lastIndex else { return nil }
                return Array(self[startIndex...lastIndex])
            }
            let endIndex = Swift.min((startIndex + limit - 1), lastIndex)
            guard startIndex <= endIndex else { return nil }
            return Array(self[startIndex...endIndex])
        } else {
            let searchResult = binarySearch(withBound: .lower, key: key, value: value)
            guard var endIndex = (searchResult.currentIndex ?? searchResult.insertInIndex), endIndex - 1 - (skip ?? 0) >= 0 else { return nil }
            endIndex = (endIndex - 1) - (skip ?? 0)
            guard let limit = limit else {
                return Array(self[0...endIndex])
            }
            let startIndex = Swift.max((endIndex - (limit - 1)), 0)
            return Array(self[startIndex...endIndex])
        }
    }
    
    /// Searches all elemets that have a specific key value pair.
    /// - Parameters:
    ///     - key: Key name of parameter.
    ///     - value: Value of key.
    /// - Returns: results: List of objects with the key value pair.
    /// - Returns: lowerIndex: First index of results inside the array.
    /// - Returns: upperIndex: Last index of results inside the array.
    func binarySearchAll(key: String, value: Any) -> BinarySearchResult? {
        let lowerIndexTuple = binarySearch(withBound: .lower, key: key, value: value)
        let upperIndexTuple = binarySearch(withBound: .upper, key: key, value: value)
        if let lowerBound = lowerIndexTuple.currentIndex, let upperBound = upperIndexTuple.currentIndex, lowerBound <= upperBound {
            let results: [Element] = Array(self[lowerBound...upperBound])
            return BinarySearchResult(results: results, lowerIndex: lowerBound, upperIndex: upperBound)
        }
        return nil
    }

    func binarySearch(withBound bound: BinarySearchBound = .any, key: String, value: Any) -> (currentIndex: Int?, insertInIndex: Int?) {
        if self.count == 0 {
            return (nil, 0)
        }
        var lowerIndex = 0
        var upperIndex = self.count - 1
        var currentIndex = 0
        var indexResult = -1
        while (lowerIndex <= upperIndex) {
            currentIndex = (lowerIndex + upperIndex) / 2
            let currentDict = self[currentIndex]
            guard let comparisonResult = currentDict.compare(to: value, key: key) else { return (nil, nil)}
                switch bound {
                case .any:
                    if comparisonResult == .equal {
                        return (currentIndex, nil)
                    }
                    upperIndex = comparisonResult == .greater ? currentIndex - 1 : upperIndex
                    lowerIndex = comparisonResult == .lower ? currentIndex + 1 : lowerIndex
                case .lower:
                    upperIndex = (comparisonResult == .equal || comparisonResult == .greater) ? currentIndex - 1 : upperIndex
                    lowerIndex = comparisonResult == .lower ? currentIndex + 1 : lowerIndex
                    indexResult = comparisonResult == .equal ? currentIndex : indexResult
                case .upper:
                    lowerIndex = (comparisonResult == .lower || comparisonResult == .equal) ? currentIndex + 1 : lowerIndex
                    upperIndex = comparisonResult == .greater ? currentIndex - 1 : upperIndex
                    indexResult = comparisonResult == .equal ? currentIndex : indexResult
                }
        }
        var index = (bound == .any) ? currentIndex : (indexResult != -1 ? indexResult : currentIndex)
        let valueFound = self[index]
        let comparisonResult = valueFound.compare(to: value, key: key)
        if comparisonResult == .equal {
            return (index, nil)
        }
        index =  comparisonResult == .greater ? index : index + 1
        return (nil, index)
    }
    
}
