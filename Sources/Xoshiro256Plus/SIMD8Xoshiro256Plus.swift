import Seedable

public struct SIMD8Xoshiro256Plus: Seedable {
    public static var seedByteCount = 256
    
    var s: (SIMD8<UInt64>, SIMD8<UInt64>, SIMD8<UInt64>, SIMD8<UInt64>)
    var buffer: SIMD8<Double> = .zero
    var index = 8
    
    public init() {
        s = (.random(), .random(), .random(), .random())
        assert(s != (.zero, .zero, .zero, .zero))
    }
    
    public init<Seed>(seededWith seed: Seed) where Seed: Collection, Seed.Element == UInt8 {
        var seed = seed[...]
        
        s = (.zero, .zero, .zero, .zero)
        
        for i in s.0.indices {
            s.0[i] = UInt64(littleEndianBytes: seed.prefix(8))
            seed = seed.dropFirst(8)
            s.1[i] = UInt64(littleEndianBytes: seed.prefix(8))
            seed = seed.dropFirst(8)
            s.2[i] = UInt64(littleEndianBytes: seed.prefix(8))
            seed = seed.dropFirst(8)
            s.3[i] = UInt64(littleEndianBytes: seed.prefix(8))
            seed = seed.dropFirst(8)
        }
        
        precondition(seed.isEmpty)
        
        precondition(s != (.zero, .zero, .zero, .zero))
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
