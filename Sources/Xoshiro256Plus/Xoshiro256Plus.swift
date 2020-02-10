public struct Xoshiro256Plus {
    var s: (UInt64, UInt64, UInt64, UInt64)
    
    public init() {
        var rng = SystemRandomNumberGenerator()
        s = (rng.next(), rng.next(), rng.next(), rng.next())
    }
    
    public init(seed: UInt64) {
        var rng = SplitMix64(x: seed)
        s = (rng.next(), rng.next(), rng.next(), rng.next())
    }
    
    public mutating func next() -> Double {
        let resultPlus = s.0 &+ s.3
        
        let t = s.1 &<< 17
        
        s.2 ^= s.0
        s.3 ^= s.1
        s.1 ^= s.2
        s.0 ^= s.3
        
        s.2 ^= t
        
        s.3 = (s.3 &<< 45) | (s.3 &>> 19)
        
        return Double(resultPlus &>> 11) * 0x1p-53
    }
}

fileprivate struct SplitMix64 {
    var x: UInt64
    
    mutating func next() -> UInt64 {
        x = x &+ 0x9e3779b97f4a7c15
        var z = x
        z = (z ^ (z &>> 30)) &* 0xbf58476d1ce4e5b9
        z = (z ^ (z &>> 27)) &* 0x94d049bb133111eb
        return z ^ (z &>> 31)
    }
}
