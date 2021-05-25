//
//  StandardDeckTests.swift
//  DeckTests
//
//  Created by Luke Van In on 2021/05/25.
//

import XCTest
@testable import Deck

class StandardDeckTests: XCTestCase {
    
    // MARK: - Suites
    
    func testHeartsShouldBeRed() {
        XCTAssertEqual(StandardDeck.Suite.hearts.color, StandardDeck.Suite.Color.red)
    }
    
    func testDiamondsShouldBeRed() {
        XCTAssertEqual(StandardDeck.Suite.diamonds.color, StandardDeck.Suite.Color.red)
    }
    
    func testClubsShouldBeBlack() {
        XCTAssertEqual(StandardDeck.Suite.clubs.color, StandardDeck.Suite.Color.black)
    }
    
    func testSpadesShouldBeBlack() {
        XCTAssertEqual(StandardDeck.Suite.spades.color, StandardDeck.Suite.Color.black)
    }
    
    func testDeckShouldHaveFourSuites() {
        let suites = Set<StandardDeck.Suite>([
            .clubs,
            .spades,
            .diamonds,
            .hearts,
        ])
        XCTAssertEqual(StandardDeck.Suite.all.count, 4)
        XCTAssertEqual(StandardDeck.Suite.all, suites)
    }
    
    // MARK: - Ranks
    
    func testDeckShouldHaveThirteenRanks() {
        let ranks = Set<StandardDeck.Rank>([
            .ace,
            .two,
            .three,
            .four,
            .five,
            .six,
            .seven,
            .eight,
            .nine,
            .ten,
            .jack,
            .queen,
            .king,
        ])
        XCTAssertEqual(StandardDeck.Rank.all.count, 13)
        XCTAssertEqual(StandardDeck.Rank.all, ranks)
    }

    // MARK: - Cards
    
    func testDeckShouldHaveFiftyTwoCards() {
        let cards = StandardDeck.Card.all
        XCTAssertEqual(cards.count, 52)
        for suite in StandardDeck.Suite.all {
            for rank in StandardDeck.Rank.all {
                let card = StandardDeck.Card(rank: rank, suite: suite)
                XCTAssert(cards.contains(card))
            }
        }
    }
    
}
