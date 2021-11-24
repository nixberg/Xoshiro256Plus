import Seedable
import XCTest
import Xoshiro256Plus

final class Xoshiro256PlusTests: XCTestCase {
    func test() {
        var one = Xoshiro256Plus(seededUsing: SipRNG(hashing: 0))
        var two = Xoshiro256Plus(seededWith: 0x6111c6836b29f541)
        
        XCTAssertEqual(one.next(), 0.19111320809407928)
        XCTAssertEqual(two.next(), 0.18457594175387138)
        for _ in 0..<1024 {
            _ = one.next()
            _ = two.next()
        }
        XCTAssertEqual(one.next(), 0.84681644224350180)
        XCTAssertEqual(two.next(), 0.52176324526826280)
    }
    
    func testSIMD8() {
        var one = SIMD8Xoshiro256Plus(seededUsing: SipRNG(hashing: 0))
        var two = SIMD8Xoshiro256Plus(seededWith: 0x6111c6836b29f541)
        
        XCTAssertEqual(one.next(), 0.19111320809407928)
        XCTAssertEqual(two.next(), 0.18457594175387138)
        for _ in 0..<8199 {
            _ = one.next()
            _ = two.next()
        }
        XCTAssertEqual(one.next(), 0.84681644224350180)
        XCTAssertEqual(two.next(), 0.52176324526826280)
    }
}
