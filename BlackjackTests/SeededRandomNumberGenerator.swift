//
//  TestRandomNumberGenerator.swift
//  BlackjackTests
//
//  Created by Luke Van In on 2021/05/28.
//

import Foundation


///
/// Pseudo-random number generator. Provides a repeatable sequence of seemingly random numbers given
/// a random seed
///
struct SeededRandomNumberGenerator: RandomNumberGenerator {
    
    var seed: UInt64
    
//    private let generator: GKMersenneTwisterRandomSource
    
    init() {
        self.init(seed: 1)
    }
    
    init(seed: UInt64) {
        self.seed = seed
//        generator = GKMersenneTwisterRandomSource(seed: seed)
    }

    mutating func next() -> UInt64 {
        var x = seed
        x = x &+ (x << 10)
        x = x ^ (x >>  6)
        x = x &+ (x <<  3)
        x = x ^ (x >> 11)
        x = x &+ (x << 15)
        seed = x
        return x
    }
}
