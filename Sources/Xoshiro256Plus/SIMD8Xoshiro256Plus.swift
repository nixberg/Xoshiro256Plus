import Seedable

public struct SIMD8Xoshiro256Plus: Seedable {
    var s: (SIMD8<UInt64>, SIMD8<UInt64>, SIMD8<UInt64>, SIMD8<UInt64>)
    var buffer: SIMD8<Double> = .zero
    var index = 8
    
    public init() {
        s = (.random(), .random(), .random(), .random())
    }
    
    public init<S>(seededWith seed: S) where S: Seed {
        var rng = SipRNG(seededWith: seed)
        s = (.zero, .zero, .zero, .zero)
        for i in s.0.indices {
            s.0[i] = rng.next()
            s.1[i] = rng.next()
            s.2[i] = rng.next()
            s.3[i] = rng.next()
        }
    }
    
    public mutating func next() -> Double {
        assert((0...8).contains(index))
        
        if index == 8 {
            let resultPlus = s.0 &+ s.3
            
            let t = s.1 &<< 17
            
            s.2 ^= s.0
            s.3 ^= s.1
            s.1 ^= s.2
            s.0 ^= s.3
            
            s.2 ^= t
            
            s.3 = (s.3 &<< 45) | (s.3 &>> 19)
            
            buffer = .init(resultPlus &>> 11) * 0x1p-53
            index = 0
        }
        
        defer { index += 1 }
        return buffer[index]
    }
}

fileprivate extension SIMD where Scalar == UInt64 {
    static func random() -> Self {
        var rng = SystemRandomNumberGenerator()
        var result: Self = .zero
        for i in result.indices {
            result[i] = rng.next()
        }
        return result
    }
}

fileprivate extension SIMD where Scalar: FloatingPoint {
    init<T>(_ values: T) where T: SIMD, T.Scalar: BinaryInteger {
        precondition(Self.scalarCount == T.scalarCount)
        self = .zero
        for (i, j) in zip(indices, values.indices) {
            self[i] = Scalar(values[j])
        }
    }
}
