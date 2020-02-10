import XCTest
import Xoshiro256Plus

final class Xoshiro256PlusTests: XCTestCase {
    func test() {
        var one = Xoshiro256Plus(seed: 0)
        var two = Xoshiro256Plus(seed: 0x6111c6836b29f541)
        
        XCTAssertEqual(one.next(), 0.85419278636747109)
        XCTAssertEqual(two.next(), 0.19237575934256057)
        for _ in (0..<1024) {
            _ = one.next()
            _ = two.next()
        }
        XCTAssertEqual(one.next(), 0.38616476068080718)
        XCTAssertEqual(two.next(), 0.17164116097323845)
    }
}
