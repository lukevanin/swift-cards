//
//  Shoe.swift
//  Blackjack
//
//  Created by Luke Van In on 2021/05/27.
//

import Foundation


public enum ShoeError: Error {
    case empty
}


///
/// The shoe contains one or more packs of cards that are used to play the game. Cards are dealt one at a
/// time until the shoe is empty. A placeholder card is inserted into the shoe. When the placeholder is dealt
/// the shoe is reshuffled.
///
public struct Shoe<Card> where Card: Hashable {
    
    public var empty: Bool {
        cards.count == 0
    }
    
    private var cards: [Card] = []
    private var random: RandomNumberGenerator
    
    init(random: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.random = random
    }

    init<S>(cards: S, numberOfPacks: Int, random: RandomNumberGenerator = SystemRandomNumberGenerator()) where S: Sequence, S.Element == Card {
        self.random = random
        for _ in 0 ..< numberOfPacks {
            self.cards.append(contentsOf: cards)
        }
    }
    
    init<S>(cards: S, random: RandomNumberGenerator = SystemRandomNumberGenerator()) where S: Sequence, S.Element == Card {
        self.random = random
        self.cards.append(contentsOf: cards)
    }
    
    init(card: Card, random: RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.random = random
        self.cards.append(card)
    }

    mutating func add(card: Card) {
        cards.append(card)
    }
    
    mutating func shuffle() {
        // We use our own shuffle implementation instead of the one provided by
        // Swift:
        // - The implementation is subject to change, which makes it impossible
        // to write a reliable unit test.
        // - The `Collection.shuffle(using:)` requires a mutable inpout
        // reference, which means we cannot pass in a reference to just any
        // RandomNumberGenerator.
        let count = cards.count
        for i in 0 ..< count {
            let j = Int(random.next(upperBound: UInt(count)))
            cards.swapAt(i, j)
        }
    }
    
    mutating func deal() throws -> Card {
        guard cards.count > 0 else {
            throw ShoeError.empty
        }
        return cards.removeLast()
    }
}
