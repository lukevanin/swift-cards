//
//  ShoeTests.swift
//  BlackjackTests
//
//  Created by Luke Van In on 2021/05/27.
//

import XCTest
import Deck
@testable import Blackjack

final class ShoeTests: XCTestCase {
    
    func testEmptyShouldReturnTrueWhenShoeHasNoCards() throws {
        let shoe = Shoe<StandardDeck.Card>()
        XCTAssertTrue(shoe.empty)
    }
    
    func testEmptyShouldReturnFalseWhenShoeHasAtLeastOneCard() throws {
        let card = Card.all.randomElement()!
        let shoe = Shoe<StandardDeck.Card>(card: card)
        XCTAssertFalse(shoe.empty)
    }

    func testShoeCardCountPacks() throws {
        for i in 0 ..< 10 {
            var shoe = Shoe<StandardDeck.Card>(cards: Card.all, numberOfPacks: i)
            var count = 0
            while shoe.empty == false {
                let _ = try shoe.deal()
                count += 1
            }
            XCTAssertEqual(count, i * 52)
        }
    }
    
    func testShoeAddCardThenDeal() throws {
        let cards = Array(Card.all)
        let expectedCards = cards.reversed()
        var shoe = Shoe<StandardDeck.Card>()
        cards.forEach { shoe.add(card: $0) }
        for card in expectedCards {
            let dealtCard = try shoe.deal()
            XCTAssertEqual(card, dealtCard)
        }
    }

    func testShoeShuffle() throws {
        let cards = [
            Card(rank: .ace, suite: .spades),
            Card(rank: .eight, suite: .diamonds),
            Card(rank: .queen, suite: .hearts),
            Card(rank: .jack, suite: .clubs),
            Card(rank: .three, suite: .hearts),
        ]
        let expectedCards = [
            Card(rank: .three, suite: .hearts),
            Card(rank: .queen, suite: .hearts),
            Card(rank: .jack, suite: .clubs),
            Card(rank: .ace, suite: .spades),
            Card(rank: .eight, suite: .diamonds),
        ]
        for _ in 0 ..< 100 {
            var shoe = Shoe<StandardDeck.Card>(cards: cards, random: SeededRandomNumberGenerator())
            shoe.shuffle()
            for card in expectedCards {
                let dealtCard = try shoe.deal()
                XCTAssertEqual(card, dealtCard)
            }
        }
    }
    
    func testRandomNumberGenerator() {
        var r = SeededRandomNumberGenerator()
        for _ in 0 ..< 100 {
            print(r.next(upperBound: UInt(4)))
        }
    }
}
