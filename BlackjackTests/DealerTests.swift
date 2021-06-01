//
//  DealerTests.swift
//  BlackjackTests
//
//  Created by Luke Van In on 2021/05/31.
//

import XCTest
@testable import Blackjack


final class DealerTests: XCTestCase {

    func testGiveCardToDealerShouldAddCardToDealersHand() throws {
        let card = Card.all.randomElement()!
        let playerCard = PlayerCard(card: card, face: .up)
        var subject = Dealer()
        let expected = Dealer(hand: Hand(card: playerCard))
        subject.addCard(playerCard)
        XCTAssertEqual(subject, expected)
    }
    
    func testRevealDealerCardShouldTurnCardFaceUp() throws {
        let card = Card.all.randomElement()!
        var subject = Dealer(hand: Hand(card: PlayerCard(card: card, face: .down)))
        let expected = Dealer(hand: Hand(card: PlayerCard(card: card, face: .up)))
        try subject.revealCard(at: 0)
        XCTAssertEqual(subject, expected)
    }
    
    func testRevealDealerCardShouldFailWhenIndexIsOutOfRange() throws {
        let card = Card.all.randomElement()!
        var subject = Dealer(hand: Hand(card: PlayerCard(card: card, face: .down)))
        XCTAssertThrowsError(try subject.revealCard(at: 1))
    }
}
