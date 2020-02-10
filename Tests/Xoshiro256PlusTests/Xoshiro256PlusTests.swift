import XCTest
@testable import Xoshiro256Plus

final class Xoshiro256PlusTests: XCTestCase {
    func testXoshiro256Plus() {
        var rng = Xoshiro256Plus()
        for _ in 0..<10 {
            print(rng.next())
        }
        
        rng = Xoshiro256Plus(seed: 0)
        for _ in 0..<10 {
            print(rng.next())
        }
    }
}
