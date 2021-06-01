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
    
    // MARK: Increase Bet
    
    func testIncreaseBetShouldAddAmountToBet() {
        var subject = Hand(bet: 1)
        let expected = Hand(bet: 12)
        subject.increaseBet(11)
        XCTAssertEqual(subject, expected)
    }
    
    // MARK: Score

    func testScoreOneAceShouldEqualEleven() throws {
        let hand = Hand(
            cards: [
                PlayerCard(card: Card(rank: .ace, suite: .diamonds), face: .up),
            ]
        )
        XCTAssertEqual(try hand.score(), 11)
    }

    func testScoreShouldFailWhenCardIsFaceDown() {
        let hand = Hand(
            cards: [
                PlayerCard(card: Card(rank: .ace, suite: .diamonds), face: .down),
            ]
        )
        XCTAssertThrowsError(try hand.score())
    }

    func testScoreAceAndTenShouldEqualTwentyOne() throws {
        let hand = Hand(
            cards: [
                PlayerCard(card: Card(rank: .ace, suite: .diamonds), face: .up),
                PlayerCard(card: Card(rank: .ten, suite: .diamonds), face: .up),
            ]
        )
        XCTAssertEqual(try hand.score(), 21)
    }
    
    func testScoreTwoAcesShouldEqualTwelve() throws {
        let hand = Hand(
            cards: [
                PlayerCard(card: Card(rank: .ace, suite: .diamonds), face: .up),
                PlayerCard(card: Card(rank: .ace, suite: .spades), face: .up),
            ]
        )
        XCTAssertEqual(try hand.score(), 12)
    }
    
    func testScoreThreeAcesShouldEqualThirteen() throws {
        let hand = Hand(
            cards: [
                PlayerCard(card: Card(rank: .ace, suite: .diamonds), face: .up),
                PlayerCard(card: Card(rank: .ace, suite: .spades), face: .up),
                PlayerCard(card: Card(rank: .ace, suite: .hearts), face: .up),
            ]
        )
        XCTAssertEqual(try hand.score(), 13)
    }
    
    func testScoreFourAcesShouldEqualFourteen() throws {
        let hand = Hand(
            cards: [
                PlayerCard(card: Card(rank: .ace, suite: .diamonds), face: .up),
                PlayerCard(card: Card(rank: .ace, suite: .spades), face: .up),
                PlayerCard(card: Card(rank: .ace, suite: .hearts), face: .up),
                PlayerCard(card: Card(rank: .ace, suite: .clubs), face: .up),
            ]
        )
        XCTAssertEqual(try hand.score(), 14)
    }
    
    func testScoreTenAndFourAcesShouldEqualFourteen() throws {
        let hand = Hand(
            cards: [
                PlayerCard(card: Card(rank: .ten, suite: .hearts), face: .up),
                PlayerCard(card: Card(rank: .ace, suite: .diamonds), face: .up),
                PlayerCard(card: Card(rank: .ace, suite: .spades), face: .up),
                PlayerCard(card: Card(rank: .ace, suite: .hearts), face: .up),
                PlayerCard(card: Card(rank: .ace, suite: .clubs), face: .up),
            ]
        )
        XCTAssertEqual(try hand.score(), 14)
    }
    
    func testTwoTwosShouldEqualFour() {
        let hand = Hand(
            cards: [
                PlayerCard(card: Card(rank: .two, suite: .hearts), face: .up),
                PlayerCard(card: Card(rank: .two, suite: .spades), face: .up),
            ]
        )
        XCTAssertEqual(try hand.score(), 4)
    }
    
    func testTwoFivesShouldEqualTen() {
        let hand = Hand(
            cards: [
                PlayerCard(card: Card(rank: .five, suite: .diamonds), face: .up),
                PlayerCard(card: Card(rank: .five, suite: .hearts), face: .up),
            ]
        )
        XCTAssertEqual(try hand.score(), 10)
    }
    
    func testTwoTensShouldEqualTwenty() throws {
        let hand = Hand(
            cards: [
                PlayerCard(card: Card(rank: .ten, suite: .diamonds), face: .up),
                PlayerCard(card: Card(rank: .ten, suite: .spades), face: .up),
            ]
        )
        XCTAssertEqual(try hand.score(), 20)

    }

    func testScoreTwoTensAndOneAceShouldEqualTwentyOne() {
        let hand = Hand(
            cards: [
                PlayerCard(card: Card(rank: .ten, suite: .diamonds), face: .up),
                PlayerCard(card: Card(rank: .ten, suite: .spades), face: .up),
                PlayerCard(card: Card(rank: .ace, suite: .spades), face: .up),
            ]
        )
        XCTAssertEqual(try hand.score(), 21)
    }
}
