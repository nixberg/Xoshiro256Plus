import Seedable

public struct Xoshiro256Plus: Seedable {
    var s: (UInt64, UInt64, UInt64, UInt64)
    
    public init() {
        var rng = SystemRandomNumberGenerator()
        s = (rng.next(), rng.next(), rng.next(), rng.next())
    }
    
    public init<S>(seededWith seed: S) where S: Seed {
        var rng = SipRNG(seededWith: seed)
        s = (rng.next(), rng.next(), rng.next(), rng.next())
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
