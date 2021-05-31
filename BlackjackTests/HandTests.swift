//
//  HandTests.swift
//  BlackjackTests
//
//  Created by Luke Van In on 2021/05/30.
//

import XCTest
@testable import Blackjack

final class HandTests: XCTestCase {
    
    // MARK: Add Card

    func testAddCardIntoEmptyHandShouldInsertCardIntoHand() throws {
        let card = Card.all.randomElement()!
        let playerCard = PlayerCard(card: card, face: .up)
        var subject = Hand()
        let expected = Hand(card: playerCard)
        subject.addCard(playerCard)
        XCTAssertEqual(subject, expected)
    }

    func testAddCardIntoNonEmptyHandShouldInsertCardIntoHand() throws {
        let cardA = PlayerCard(card: Card.all.randomElement()!, face: .up)
        let cardB = PlayerCard(card: Card.all.randomElement()!, face: .up)
        var subject = Hand(card: cardA)
        let expected = Hand(cards: [cardA, cardB])
        subject.addCard(cardB)
        XCTAssertEqual(subject, expected)
    }
    
    // MARK: Reveal Card

    func testRevealCardShouldFailWhenIndexIsOutOfRange() {
        let card = Card.all.randomElement()!
        let playerCard = PlayerCard(card: card, face: .down)
        var subject = Hand(card: playerCard)
        XCTAssertThrowsError(try subject.revealCard(at: 1))
    }

    func testRevealCardShouldFailWhenCardIsAlreadyFaceUp() throws {
        let card = Card.all.randomElement()!
        let playerCard = PlayerCard(card: card, face: .up)
        var subject = Hand()
        let expected = Hand(card: playerCard)
        subject.addCard(playerCard)
        XCTAssertThrowsError(try subject.revealCard(at: 1))
    }

    func testRevealCardShouldTurnCardFaceUp() throws {
        let card = Card.all.randomElement()!
        let playerCard = PlayerCard(card: card, face: .down)
        var subject = Hand()
        let expected = Hand(card: playerCard)
        subject.addCard(playerCard)
        XCTAssertEqual(subject, expected)
    }
}
