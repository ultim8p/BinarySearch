import XCTest
@testable import BinarySearch

final class BinarySearchTests: XCTestCase {
    let testDict: [[String : Any]] = [["id": 1], ["id": 2], ["id": 3], ["id": 3], ["id": 3], ["id": 4], ["id": 4], ["id": 6], ["id": 8], ["id": 8]]
    let missingValuesdict: [[String : Any]] = [["id": 0], ["id": 0], ["id": 1], ["id": 1], ["id": 6], ["id": 9], ["id": 9], ["id": 10], ["id": 10], ["id": 10], ["id": 12]]
    let twoValuesDict: [[String : Any]] = [["id": -10], ["id": -10], ["id": -10], ["id": -10], ["id": 50], ["id": 50], ["id": 50], ["id": 50]]
    let boolDict: [[String: Any]] = [["value": false], ["value": false], ["value": false], ["value": false], ["value": true], ["value": true], ["value": true]]
    
    func testSearchExistingValue(){
        XCTAssertEqual(testDict.binarySearch(key: "id", value: 2).currentIndex, 1)
    }
    
    func testSearchNonExistingValue(){
        let searchResult = testDict.binarySearch(key: "id", value: 5)
        XCTAssertEqual(searchResult.insertInIndex, 7)
        XCTAssertEqual(searchResult.currentIndex, nil)
    }
    
    func testSearchRangeExclusive(){
        let searchResult = testDict.searchRange(with: "id", value: 5, withOp: .greater, limit: 2)
        for (index, result) in (searchResult ?? []).enumerated() {
            if index == 0 {
                XCTAssertEqual(result.compare(to: 6, key: "id"), Operator.equal )
            } else {
                XCTAssertEqual(result.compare(to: 8, key: "id"), Operator.equal )
            }
        }
    }
    
    func testSearchRange(){
        let searchResult = testDict.searchRange(with: "id", lowerValue: 3, lowerOpt: .greater, upperValue: 6, upperOpt: .lowerOrequal, limit: nil, bound: .lower)
        XCTAssertEqual(searchResult?.count, 3)
        
        XCTAssertEqual(searchResult![0].compare(to: 4, key: "id"), Operator.equal)
        XCTAssertEqual(searchResult![1].compare(to: 4, key: "id"), Operator.equal)
        XCTAssertEqual(searchResult![2].compare(to: 6, key: "id"), Operator.equal)

    }
    
    func testBoundariesSearchRange() {
        let searchResult = missingValuesdict.searchRange(with: "id", lowerValue: 12, lowerOpt: .greater, upperValue: 12, upperOpt: .lower, limit: nil, bound: .lower)
        XCTAssertNil(searchResult)
    }
    
    func testBoundariesSearchRangeWithLimit() {
        let searchResult = missingValuesdict.searchRange(with: "id", lowerValue: -20, lowerOpt: .greater, upperValue: 50, upperOpt: .lower, limit: 5, bound: .lower)
        XCTAssertEqual(searchResult?.count, 5)
    }
    
    func testSearchRangeWithInvalidLimit(){
        let seaarchResult = twoValuesDict.searchRange(with: "id", value: 5, withOp: .greater, limit: nil, skip: 3)
        let searchResultNilExpected = twoValuesDict.searchRange(with: "id", value: 5, withOp: .greater, limit: nil, skip: 4)

        XCTAssertEqual(seaarchResult?.count, 1)
        XCTAssertNil(searchResultNilExpected)
    }
    
    func testSearchRangeWithLimitAndSkip() {
        let searchResult = missingValuesdict.searchRange(with: "id", value: 3, withOp: .greater, limit: 2, skip: 4)
        XCTAssertEqual(searchResult?.count, 2)
        XCTAssertEqual(searchResult?[0]["id"] as? Int, 10)
        XCTAssertEqual(searchResult?[1]["id"] as? Int, 10)
    }
    
    func testSearchRangeWithSkipAndIncompleteLimit() {
        let searchResult = missingValuesdict.searchRange(with: "id", value: 9, withOp: .lower, limit: 20, skip: 3)
        XCTAssertEqual(searchResult?.count, 2)
        XCTAssertEqual(searchResult?[0]["id"] as? Int, 0)
        XCTAssertEqual(searchResult?[1]["id"] as? Int, 0)
    }
    
    func testFindFirstOccurrence(){
        let searchResult = testDict.binarySearch(withBound: .lower, key: "id", value: 3)
        XCTAssertEqual(searchResult.currentIndex, 2)
    }
    
    func testFindLastOccurrence(){
        let searchResult = testDict.binarySearch(withBound: .upper, key: "id", value: 3)
        XCTAssertEqual(searchResult.currentIndex, 4)
    }
    
    func testFindGreaterThan(){
        var searchResult = testDict.searchRange(with: "id", value: -10, withOp: .lowerOrequal)
        XCTAssertNil(searchResult)
        searchResult = testDict.searchRange(with: "id", value: 50, withOp: .greaterOrequal)
        XCTAssertNil(searchResult)
        searchResult = missingValuesdict.searchRange(with: "id", value: 10, withOp: .lowerOrequal)
        XCTAssertEqual(searchResult?.count, 10)
        searchResult = missingValuesdict.searchRange(with: "id", value: 3, withOp: .greaterOrequal)
        XCTAssertEqual(searchResult?.count, 7)
    }
    
    func testWithEmptyArray() {
        let emptyDict: [[String : Any]] = []
        var searchResult = emptyDict.searchRange(with: "id", value: 4, withOp: .greater)
        XCTAssertNil(searchResult)
        searchResult = emptyDict.searchRange(with: "id", value: 4, withOp: .lower)
        XCTAssertNil(searchResult)
        searchResult = emptyDict.searchRange(with: "id", value: 4, withOp: .greater, limit: 20)
        XCTAssertNil(searchResult)
        searchResult = emptyDict.searchRange(with: "id", value: 4, withOp: .greater, limit: nil)
        XCTAssertNil(searchResult)
        searchResult = emptyDict.searchRange(with: "id", value: 4, withOp: .greater, limit: 1, skip: 1)
        XCTAssertNil(searchResult)
        searchResult = emptyDict.searchRange(with: "id", value: 4, withOp: .greater, limit: nil, skip: 1)
        XCTAssertNil(searchResult)
        searchResult = emptyDict.searchRange(with: "id", value: 4, withOp: .greater, limit: 1, skip: nil)
        XCTAssertNil(searchResult)
        searchResult = emptyDict.searchRange(with: "id", value: 4, withOp: .greater, limit: nil, skip: nil)
        XCTAssertNil(searchResult)
        let searchAllResult = emptyDict.binarySearchAll(key: "id", value: 3)
        XCTAssertNil(searchAllResult)
        let binarySearchResult = emptyDict.binarySearch(key: "id", value: 4)
        XCTAssertNil(binarySearchResult.currentIndex)
        XCTAssertEqual(binarySearchResult.insertInIndex, 0)
        let binarySearchWithBound = emptyDict.binarySearch(withBound: .lower, key: "id", value: -4)
        XCTAssertNil(binarySearchWithBound.currentIndex)
        XCTAssertEqual(binarySearchWithBound.insertInIndex, 0)
        let binarySearchWithOBound = emptyDict.binarySearch(withBound: .upper, key: "id", value: -4)
        XCTAssertNil(binarySearchWithOBound.currentIndex)
        XCTAssertEqual(binarySearchWithOBound.insertInIndex, 0)
    }
    
    func testBoolSearch(){
        var searchResult = boolDict.searchRange(with: "value", value: true, withOp: .lower)
        XCTAssertEqual(searchResult?.count, 4)
        searchResult = boolDict.searchRange(with: "value", value: false, withOp: .lower)
        XCTAssertNil(searchResult)
        searchResult = boolDict.searchRange(with: "value", value: false, withOp: .greater)
        XCTAssertEqual(searchResult?.count, 3)
        searchResult = boolDict.searchRange(with: "value", value: false, withOp: .greaterOrequal)
        XCTAssertEqual(searchResult?.count, boolDict.count)
        searchResult = boolDict.searchRange(with: "value", value: true, withOp: .lowerOrequal)
        XCTAssertEqual(searchResult?.count, boolDict.count)
        searchResult = boolDict.searchRange(with: "value", value: true, withOp: .greaterOrequal)
        XCTAssertEqual(searchResult?.count, 3)
        searchResult = boolDict.searchRange(with: "value", value: false, withOp: .lowerOrequal)
        XCTAssertEqual(searchResult?.count, 4)
        var binarySearchResult = boolDict.binarySearch(key: "value", value: false)
        XCTAssertNotNil(binarySearchResult.currentIndex)
        let binarySearchAllResult = boolDict.binarySearchAll(key: "value", value: false)
        XCTAssertNotNil(binarySearchAllResult)
        XCTAssertEqual(binarySearchAllResult?.results?.count, 4)
        binarySearchResult = boolDict.binarySearch(withBound: .upper, key: "value", value: false)
        XCTAssertEqual(binarySearchResult.currentIndex, 3)
        binarySearchResult = boolDict.binarySearch(withBound: .lower, key: "value", value: true)
        XCTAssertEqual(binarySearchResult.currentIndex, 4)
        binarySearchResult = boolDict.binarySearch(withBound: .lower, key: "value", value: false)
        XCTAssertEqual(binarySearchResult.currentIndex, 0)
        binarySearchResult = boolDict.binarySearch(withBound: .upper, key: "value", value: true)
        XCTAssertEqual(binarySearchResult.currentIndex, 6)
        let otherValueSearch = boolDict.binarySearch(key: "value", value: 7)
        XCTAssertNil(otherValueSearch.currentIndex)
        XCTAssertNil(otherValueSearch.insertInIndex)
        let otherKeySearch = boolDict.binarySearch(key: "otherValue", value: 7)
        XCTAssertNil(otherKeySearch.currentIndex)
        XCTAssertNil(otherKeySearch.insertInIndex)
    }

    static var allTests = [
        ("testSearchExistingValue", testSearchExistingValue),
    ]
}
