import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Xoshiro256PlusTests.allTests),
    ]
}
#endif