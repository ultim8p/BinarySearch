import XCTest
@testable import BinarySearch

final class BinarySearchTests: XCTestCase {
    let testDict: [[String : Any]] = [["id": 1], ["id": 2], ["id": 3], ["id": 3], ["id": 3], ["id": 4], ["id": 4], ["id": 6], ["id": 8], ["id": 8]]
    let missingValuesdict: [[String : Any]] = [["id": 0], ["id": 0], ["id": 1], ["id": 1], ["id": 6], ["id": 9], ["id": 9], ["id": 10], ["id": 10], ["id": 10], ["id": 12]]
    let twoValuesDict: [[String : Any]] = [["id": -10], ["id": -10], ["id": -10], ["id": -10], ["id": 50], ["id": 50], ["id": 50], ["id": 50]]

    
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

    static var allTests = [
        ("testSearchExistingValue", testSearchExistingValue),
    ]
}
