import XCTest

import Xoshiro256PlusTests

var tests = [XCTestCaseEntry]()
tests += Xoshiro256PlusTests.allTests()
XCTMain(tests)