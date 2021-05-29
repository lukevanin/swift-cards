//
//  BlackjackTests.swift
//  BlackjackTests
//
//  Created by Luke Van In on 2021/05/27.
//

import XCTest
@testable import Blackjack


//func XCTAssertActionsFail<S>(initial: S, actions: [AnyAction<S, Void>], _ filePath: String = #file, _ lineNumber: Int = #line) {
//    let state = initial
//    for action in actions {
//        XCTAssertFalse(action.canPerform(on: state))
//    }
//    XCTAssertThrowsError(try {
//        var state = initial
//        for action in actions {
//            try action.perform(on: &state)
//        }
//    }())
//}


//func XCTAssertActions<S>(initial: S, expected: S, actions: [AnyAction<S, Void>], _ filePath: String = #file, _ lineNumber: Int = #line) throws where S: Equatable {
//    var state = initial
//    for action in actions {
//        XCTAssertTrue(action.canPerform(on: state))
//        try action.perform(on: &state)
//    }
//    XCTAssertEqual(state, expected)
//}



final class BlackjackTests: XCTestCase {
    
    // MARK: Deal Card

    func testDealCardShouldFailWhenShoeIsEmpty() throws {
        var subject = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player()
        )
        XCTAssertThrowsError(try subject.dealCard())
    }
    
    func testDealCardShouldReturnACard() throws {
        let card = Card.all.randomElement()!
        var subject = Blackjack(
            shoe: Shoe(card: card),
            dealer: Dealer(),
            player: Player()
        )
        let expected = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player()
        )
        let dealtCard = try subject.dealCard()
        XCTAssertEqual(dealtCard, card)
        XCTAssertEqual(subject, expected)
    }
    
    // MARK: Give card to dealer
    
    func testGiveCardToDealerShouldAddCardToDealersHand() throws {
        let card = Card.all.randomElement()!
        let playerCard = PlayerCard(card: card, face: .up)
        var subject = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player()
        )
        let expected = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(hand: Hand(card: playerCard)),
            player: Player()
        )
        subject.giveCardToDealer(playerCard)
        XCTAssertEqual(subject, expected)
    }
    
    func testRevealDealerCardShowTurnCardFaceUp() throws {
        let card = Card.all.randomElement()!
        var subject = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(hand: Hand(card: PlayerCard(card: card, face: .down))),
            player: Player()
        )
        let expected = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(hand: Hand(card: PlayerCard(card: card, face: .up))),
            player: Player()
        )
        try subject.revealDealerCard(at: 0)
        XCTAssertEqual(subject, expected)
    }
    
    func testRevealDealerCardShouldFailWhenIndexIsOutOfRange() throws {
        let card = Card.all.randomElement()!
        var subject = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(hand: Hand(card: PlayerCard(card: card, face: .down))),
            player: Player()
        )
        XCTAssertThrowsError(try subject.revealDealerCard(at: 1))
    }
    
    // MARK: Give Card to Player
    
    func testGiveCardToPlayerShouldAddCardToPlayersHand() throws {
        let card = Card.all.randomElement()!
        let playerCard = PlayerCard(card: card, face: .up)
        var subject = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player()
        )
        let expected = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player(hands: [Hand(card: playerCard)])
        )
        try subject.giveCardToPlayer(playerCard, hand: 0)
        XCTAssertEqual(subject, expected)
    }
    
    func testGiveCardToPlayerShouldFailWhenHandIsOutOfRange() throws {
        let card = Card.all.randomElement()!
        let playerCard = PlayerCard(card: card, face: .up)
        var subject = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player()
        )
        XCTAssertThrowsError(try subject.giveCardToPlayer(playerCard, hand: 1))
    }
    
    // MARK: Denomination
    
    func testDenominations() {
        let denominations: [[Card.Rank]] = [
            [.ace],
            [.two],
            [.three],
            [.four],
            [.five],
            [.six],
            [.seven],
            [.eight],
            [.nine],
            [.ten, .jack, .queen, .king],
        ]
        for ranks in denominations {
            for i in 0 ..< ranks.count {
                for j in 0 ..< ranks.count {
                    if i != j {
                        let a = ranks[i].denomination
                        let b = ranks[j].denomination
                        XCTAssertEqual(a, b)
                    }
                }
            }
        }
    }
    
    // MARK: Split hand
    
    func testSplitPlayerHandShouldMakeNewHandWhenDenominationMatches() throws {
        let cardA = Card(rank: .jack, suite: .diamonds)
        let cardB = Card(rank: .jack, suite: .hearts)
        let playerCardA = PlayerCard(card: cardA, face: .up)
        let playerCardB = PlayerCard(card: cardB, face: .up)
        var subject = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player(
                hands: [
                    Hand(cards: [playerCardA, playerCardB]),
                ]
            )
        )
        let expected = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player(
                splitLimit: 1,
                splits: 1,
                hands: [
                    Hand(card: playerCardA),
                    Hand(card: playerCardB),
                ]
            )
        )
        try subject.splitPlayerHand(0)
        XCTAssertEqual(subject, expected)
    }

    func testSplitPlayerHandShouldFailWhenDenominationsDiffer() {
        let cardA = Card(rank: .jack, suite: .diamonds)
        let cardB = Card(rank: .eight, suite: .hearts)
        let playerCardA = PlayerCard(card: cardA, face: .up)
        let playerCardB = PlayerCard(card: cardB, face: .up)
        var subject = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player(
                hands: [
                    Hand(cards: [playerCardA, playerCardB]),
                ]
            )
        )
        XCTAssertThrowsError(try subject.splitPlayerHand(0))
    }
    
    func testSplitPlayerHandShouldFailWithInvalidHand() {
        let cardA = Card(rank: .jack, suite: .diamonds)
        let cardB = Card(rank: .jack, suite: .hearts)
        let playerCardA = PlayerCard(card: cardA, face: .up)
        let playerCardB = PlayerCard(card: cardB, face: .up)
        var subject = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player(
                hands: [
                    Hand(cards: [playerCardA, playerCardB]),
                ]
            )
        )
        XCTAssertThrowsError(try subject.splitPlayerHand(1))
    }

    func testSplitPlayerHandShouldFailWhenSplitLimitIsReached() {
        let cardA = Card(rank: .jack, suite: .diamonds)
        let cardB = Card(rank: .jack, suite: .hearts)
        let playerCardA = PlayerCard(card: cardA, face: .up)
        let playerCardB = PlayerCard(card: cardB, face: .up)
        var subject = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player(
                splitLimit: 1,
                splits: 1,
                hands: [
                    Hand(cards: [playerCardA, playerCardB])
                ]
            )
        )
        XCTAssertThrowsError(try subject.splitPlayerHand(0))
    }
    
    func testSplitPlayerHandMultipleTimes() throws {
        let cardA = Card(rank: .jack, suite: .diamonds)
        let cardB = Card(rank: .jack, suite: .hearts)
        let cardC = Card(rank: .jack, suite: .clubs)
        let playerCardA = PlayerCard(card: cardA, face: .up)
        let playerCardB = PlayerCard(card: cardB, face: .up)
        let playerCardC = PlayerCard(card: cardC, face: .up)
        var subject = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player(
                splitLimit: 2,
                splits: 0,
                hands: [
                    Hand(cards: [playerCardA, playerCardB]),
                ]
            )
        )
        let expected1 = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player(
                splitLimit: 2,
                splits: 1,
                hands: [
                    Hand(card: playerCardA),
                    Hand(card: playerCardB),
                ]
            )
        )
        let expected2 = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player(
                splitLimit: 2,
                splits: 1,
                hands: [
                    Hand(card: playerCardA),
                    Hand(cards: [playerCardB, playerCardC]),
                ]
            )
        )
        let expected3 = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player(
                splitLimit: 2,
                splits: 2,
                hands: [
                    Hand(card: playerCardA),
                    Hand(card: playerCardB),
                    Hand(card: playerCardC),
                ]
            )
        )
        try subject.splitPlayerHand(0)
        XCTAssertEqual(subject, expected1)
        try subject.giveCardToPlayer(playerCardC, hand: 1)
        XCTAssertEqual(subject, expected2)
        try subject.splitPlayerHand(1)
        XCTAssertEqual(subject, expected3)
    }
}
