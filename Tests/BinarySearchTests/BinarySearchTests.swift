import XCTest
@testable import BinarySearch

final class BinarySearchTests: XCTestCase {
     let testDict: [[String : Any]] = [["id": 1], ["id": 2], ["id": 3], ["id": 3], ["id": 3], ["id": 4], ["id": 4], ["id": 6], ["id": 8], ["id": 8]]
    
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
    
    func testFindFirstOccurrence(){
        let searchResult = testDict.binarySearch(withBound: .lower, key: "id", value: 3)
        XCTAssertEqual(searchResult.currentIndex, 2)
    }
    
    func testFindLastOccurrence(){
        let searchResult = testDict.binarySearch(withBound: .upper, key: "id", value: 3)
        XCTAssertEqual(searchResult.currentIndex, 4)
    }

    static var allTests = [
        ("testSearchExistingValue", testSearchExistingValue),
    ]
}
