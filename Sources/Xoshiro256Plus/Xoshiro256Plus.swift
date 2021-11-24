import Seedable

public struct Xoshiro256Plus: Seedable {
    public static var seedByteCount = 32
    
    var s: (UInt64, UInt64, UInt64, UInt64)
    
    public init() {
        var rng = SystemRandomNumberGenerator()
        s = (rng.next(), rng.next(), rng.next(), rng.next())
        assert(s != (.zero, .zero, .zero, .zero))
    }
    
    public init<Seed>(seededWith seed: Seed) where Seed : Collection, Seed.Element == UInt8 {
        var seed = seed[...]
        
        s.0 = UInt64(littleEndianBytes: seed.prefix(8))
        seed = seed.dropFirst(8)
        s.1 = UInt64(littleEndianBytes: seed.prefix(8))
        seed = seed.dropFirst(8)
        s.2 = UInt64(littleEndianBytes: seed.prefix(8))
        seed = seed.dropFirst(8)
        s.3 = UInt64(littleEndianBytes: seed.prefix(8))
        seed = seed.dropFirst(8)
        
        precondition(seed.isEmpty)
        
        precondition(s != (.zero, .zero, .zero, .zero))
    }
    
    public mutating func next() -> Double {
        let resultPlus = s.0 &+ s.3
        
        let t = s.1 << 17
        
        s.2 ^= s.0
        s.3 ^= s.1
        s.1 ^= s.2
        s.0 ^= s.3
        
        s.2 ^= t
        
        s.3 = (s.3 << 45) | (s.3 >> 19)
        
        return .init(resultPlus >> 11) * 0x1p-53
    }
}

extension UInt64 {
    init<Bytes>(littleEndianBytes bytes: Bytes) where Bytes: Collection, Bytes.Element == UInt8 {
        precondition(bytes.count == 8)
        self = bytes.enumerated().reduce(0) {
            $0 | (Self($1.element) &<< ($1.offset &* 8))
        }
    }
}
