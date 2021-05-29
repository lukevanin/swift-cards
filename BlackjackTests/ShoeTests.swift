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
    
    ///
    /// A shoe is empty when there are no more cards in it.
    ///
    func testEmptyShouldReturnTrueWhenShoeHasNoCards() throws {
        let shoe = Shoe<StandardDeck.Card>()
        XCTAssertTrue(shoe.empty)
    }
    
    ///
    /// A shoe is not empty as long as there is at least one card in it.
    ///
    func testEmptyShouldReturnFalseWhenShoeHasAtLeastOneCard() throws {
        let card = Card.all.randomElement()!
        let shoe = Shoe<StandardDeck.Card>(card: card)
        XCTAssertFalse(shoe.empty)
    }
    
    ///
    /// Cards should be dealt in their order in the shoe The first card added to the shoe is dealt last.
    ///
    func testDealShouldReturnCardInOrder() throws {
        let cards = Array(Card.all)
        let expectedCards = cards.reversed()
        var shoe = Shoe(cards: cards)
        for expectedCard in expectedCards {
            let dealtCard = try shoe.deal()
            XCTAssertEqual(dealtCard, expectedCard)
        }
    }

    ///
    /// Creating a shoe with a number of packs should replicate the cards.
    ///
    /// This is useful if we want to create a shoe using multiple packs of cards. Many games use multiple
    /// packs of cards to increase the time between shuffles and increase the difficulty of card counting.
    ///
    func testShoeWithMultiplePacks() throws {
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
    
    ///
    /// Adding a card should place it at the end of the shoe and make it the next card dealt.
    ///
    func testAddShouldPlaceCardAtEndOfShoe() throws {
        let cards = Array(Card.all)
        let expectedCards = cards.reversed()
        var shoe = Shoe<StandardDeck.Card>()
        cards.forEach { shoe.add(card: $0) }
        for card in expectedCards {
            let dealtCard = try shoe.deal()
            XCTAssertEqual(card, dealtCard)
        }
    }

    ///
    /// Shuffling should rearrange cards.
    ///
    /// The purpose of the test is not to test randomness, but to test that shuffling does change the order of
    /// the cards.
    ///
    func testShuffleShouldRearrangeCards() throws {
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
        var randomNumberGenerator = SeededRandomNumberGenerator()
        // Run the test a few times to check that the results are consistent.
        for _ in 0 ..< 100 {
            // Use a seeded random number generator so that we can predict the
            // outcome of the shuffle. Usually a random number generator is
            // non-deterministic by design. In this case we want to control the
            // ordering so that we can compare the outcome to an expected
            // result. We use a seemingly random but predictable sequence to
            // control the order.
            var shoe = Shoe<StandardDeck.Card>(cards: cards)
            shoe.shuffle(with: &randomNumberGenerator)
            for card in expectedCards {
                let dealtCard = try shoe.deal()
                XCTAssertEqual(card, dealtCard)
            }
        }
    }
}
