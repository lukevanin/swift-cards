//
//  Pack.swift
//  Deck
//
//  Created by Luke Van In on 2021/05/25.
//

import Foundation


///
/// A pack is an ordered collection of cards. Cards are often (but not always) defined by a deck. Packs provide
/// a convenient means to transfer and manipulate groups of cards, such as a hand or manifestation of a
/// deck.
///
/// The following operations can be performed on a pack:
/// - Insert a card onto the top or bottom of the pack.
/// - Remove the top-most card from the pack.
/// - Shuffle the cards into random order
///
public struct Pack<Card>: Hashable where Card: AbstractCard {
    
    ///
    /// Returns the topmost card on the pack if the pack is not empty. Otherwise returns nil.
    ///
    var first: Card? {
        cards.first
    }
    
    private var cards: [Card]
    
    ///
    /// Initializes an empty pack of cards.
    ///
    public init() {
        self.init(cards: [])
    }

    ///
    /// Initializes a pack with an unordered collection of cards. The order in which
    ///
    public init(cards: Set<Card>) {
        self.init(cards: Array(cards))
    }

    ///
    /// Initializes a pack with a ordered collection of cards
    ///
    public init(cards: [Card]) {
        self.cards = cards
    }

    ///
    /// Removes the topmost card from the pack and returns it. Returns nil if the pack is empty.
    ///
    public mutating func removeFirst() -> Card? {
        cards.count > 0 ? cards.removeFirst() : nil
    }
    
    ///
    /// Adds the given card onto the top of the pack.
    ///
    public mutating func insertFirst(_ card: Card) {
        cards.insert(card, at: 0)
    }
    
    ///
    /// Adds the given card onto the end of the pack.
    ///
    public mutating func insertLast(_ card: Card) {
        cards.append(card)
    }
    
    ///
    /// Returns a copy of the pack with the cards in random order.
    ///
    public func shuffled() -> Self {
        Pack(cards: cards.shuffled())
    }
}

extension Pack: Collection {
    
    public var startIndex: Int {
        0
    }
    
    public var endIndex: Int {
        cards.count
    }

    public func index(after i: Int) -> Int {
        i + 1
    }

    public subscript(index: Int) -> Card {
        cards[index]
    }
}
