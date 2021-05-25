//
//  PackTests.swift
//  DeckTests
//
//  Created by Luke Van In on 2021/05/25.
//

import XCTest
@testable import Deck

class PackTests: XCTestCase {
    
    typealias Card = StandardDeck.Card
    
    func testDecksWithSameCardsShouldBeEqual() {
        let cardA = Card(rank: .ace, suite: .spades)
        let cardB = Card(rank: .queen, suite: .hearts)
        let deckA = Pack(cards: [cardA, cardB])
        let deckB = Pack(cards: [cardA, cardB])
        XCTAssertEqual(deckA, deckB)
    }
    
    func testDecksWithDifferentCardsShouldNotBeEqual() {
        let cardA = Card(rank: .ace, suite: .spades)
        let cardB = Card(rank: .queen, suite: .hearts)
        let cardC = Card(rank: .eight, suite: .diamonds)
        let cardD = Card(rank: .ten, suite: .clubs)
        let deckA = Pack(cards: [cardA, cardB])
        let deckB = Pack(cards: [cardC, cardD])
        XCTAssertNotEqual(deckA, deckB)
    }
    
    func testDecksWithSameCardsInDifferentOrderShouldNotBeEqual() {
        let cardA = Card(rank: .ace, suite: .spades)
        let cardB = Card(rank: .queen, suite: .hearts)
        let deckA = Pack(cards: [cardA, cardB])
        let deckB = Pack(cards: [cardB, cardA])
        XCTAssertNotEqual(deckA, deckB)
    }

    func testCountShouldEqualNumberOfCards() {
        let pack = Pack(
            cards: [
                Card(rank: .ace, suite: .spades),
                Card(rank: .queen, suite: .hearts),
                Card(rank: .eight, suite: .diamonds),
                Card(rank: .ten, suite: .clubs),
            ]
        )
        XCTAssertEqual(pack.count, 4)
    }

    func testSubscriptShouldReturnCardAtIndex() {
        let cards = [
            Card(rank: .ace, suite: .spades),
            Card(rank: .queen, suite: .hearts),
            Card(rank: .eight, suite: .diamonds),
            Card(rank: .ten, suite: .clubs),
        ]
        let pack = Pack(cards: cards)
        for i in 0 ..< 4 {
            XCTAssertEqual(pack[i], cards[i])
        }
    }
    
    func testFirstShouldReturnFirstCard() {
        let cardA = Card(rank: .ace, suite: .spades)
        let cardB = Card(rank: .queen, suite: .hearts)
        let pack = Pack(cards: [cardA, cardB])
        XCTAssertEqual(pack.first, cardA)
        XCTAssertNotEqual(pack.first, cardB)
    }

    func testRemoveFirstFromEmptyPackShouldReturnNothing() {
        var pack = Pack<Card>()
        XCTAssertNil(pack.removeFirst())
    }

    func testRemoveFirstShouldRemoveAndReturnFirstCard() {
        let cards = [
            Card(rank: .ace, suite: .spades),
            Card(rank: .queen, suite: .hearts),
            Card(rank: .eight, suite: .diamonds),
            Card(rank: .ten, suite: .clubs),
        ]
        var pack = Pack(cards: cards)
        for i in 0 ..< 4 {
            let card = pack.removeFirst()
            XCTAssertEqual(card, cards[i])
            XCTAssertEqual(pack.count, 4 - i - 1)
        }
    }

    func testInsertFirstShouldAddCardToTopOfPack() {
        let cards = [
            Card(rank: .ace, suite: .spades),
            Card(rank: .queen, suite: .hearts),
            Card(rank: .eight, suite: .diamonds),
            Card(rank: .ten, suite: .clubs),
        ]
        var pack = Pack<Card>()
        for i in 0 ..< 4 {
            let card = cards[i]
            pack.insertFirst(card)
            XCTAssertEqual(pack.count, i + 1)
            XCTAssertEqual(pack.first, card)
        }
    }

    func testInsertLastShouldAddCardToEndOfPack() {
        let cards = [
            Card(rank: .ace, suite: .spades),
            Card(rank: .queen, suite: .hearts),
            Card(rank: .eight, suite: .diamonds),
            Card(rank: .ten, suite: .clubs),
        ]
        var pack = Pack(cards: cards)
        for _ in 0 ..< 4 {
            let card = pack.removeFirst()!
            XCTAssertNotNil(card)
            pack.insertLast(card)
        }
        XCTAssertEqual(pack, Pack(cards: cards))
    }

    func testShuffleShouldReorderCards() {
        let cards = [
            StandardDeck.Card(rank: .ace, suite: .spades),
            StandardDeck.Card(rank: .queen, suite: .hearts),
            StandardDeck.Card(rank: .eight, suite: .diamonds),
            StandardDeck.Card(rank: .ten, suite: .clubs),
        ]
        let original = Pack(cards: cards)
        let shuffled = original.shuffled()
        XCTAssertEqual(original.count, original.count)
        XCTAssertNotEqual(original, shuffled)
    }
}
