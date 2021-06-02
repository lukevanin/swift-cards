//
//  PlayerTests.swift
//  BlackjackTests
//
//  Created by Luke Van In on 2021/05/31.
//

import XCTest
@testable import Blackjack

final class PlayerTests: XCTestCase {
    
    // MARK: Give Card to Player
    
    func testDealCardToPlayer_AddsCardToPlayersHand() throws {
        let card = Card.all.randomElement()!
        var subject = Blackjack(
            shoe: Shoe(card: card),
            dealer: Dealer(),
            player: Player(bank: Bank(), hand: Hand())
        )
        let expected = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player(hand: Hand(card: PlayerCard(card: card, face: .up)))
        )
        try subject.dealCardToPlayer(hand: 0, face: .up)
        XCTAssertEqual(subject, expected)
    }
    
    func testDealCardToPlayer_Fails_WhenHandIndexIsInvalid() throws {
        let card = Card.all.randomElement()!
        var subject = Blackjack(
            shoe: Shoe(card: card),
            dealer: Dealer(),
            player: Player()
        )
        XCTAssertThrowsError(try subject.dealCardToPlayer(hand: 1, face: .up))
    }
    
    // MARK: Split hand
    
    func testSplitPlayerHandShouldMakeNewHandWhenRankMatches() throws {
        let cardA = Card(rank: .seven, suite: .diamonds)
        let cardB = Card(rank: .seven, suite: .hearts)
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
                hands: [
                    Hand(card: playerCardA),
                    Hand(card: playerCardB),
                ]
            )
        )
        try subject.splitPlayerHand(0)
        XCTAssertEqual(subject, expected)
    }
    
    func testSplitPlayerHandShouldMakeNewHandWhenDenominationMatches() throws {
        let ranks: [Card.Rank] = [.ten, .jack, .queen, .king]
        for i in 0 ..< ranks.count {
            for j in 0 ..< ranks.count {
                guard i != j else {
                    continue
                }
                let cardA = Card(rank: ranks[i], suite: .diamonds)
                let cardB = Card(rank: ranks[j], suite: .diamonds)
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
                        hands: [
                            Hand(card: playerCardA),
                            Hand(card: playerCardB),
                        ]
                    )
                )
                try subject.splitPlayerHand(0)
                XCTAssertEqual(subject, expected)
            }
        }
    }

    func testSplitPlayerHandShouldFailWhenDenominationsDiffer() {
        let cardA = Card(rank: .jack, suite: .diamonds)
        let cardB = Card(rank: .nine, suite: .hearts)
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
    
    func testSplitPlayerHandShouldFailWhenHandIsNotAPair() {
        var subject = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player(
                hands: [
                    Hand(
                        cards: [
                            PlayerCard(card: Card(rank: .ten, suite: .diamonds), face: .up),
                            PlayerCard(card: Card(rank: .ten, suite: .diamonds), face: .up),
                            PlayerCard(card: Card(rank: .two, suite: .diamonds), face: .up),
                        ]
                    ),
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
    
    func testSplitPlayerHandMultipleTimes() throws {
        let cardA = Card(rank: .jack, suite: .diamonds)
        let cardB = Card(rank: .jack, suite: .hearts)
        let cardC = Card(rank: .jack, suite: .clubs)
        let playerCardA = PlayerCard(card: cardA, face: .up)
        let playerCardB = PlayerCard(card: cardB, face: .up)
        let playerCardC = PlayerCard(card: cardC, face: .up)
        var subject = Blackjack(
            shoe: Shoe(card: cardC),
            dealer: Dealer(),
            player: Player(
                hands: [
                    Hand(cards: [playerCardA, playerCardB]),
                ]
            )
        )
        let expected1 = Blackjack(
            shoe: Shoe(card: cardC),
            dealer: Dealer(),
            player: Player(
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
                hands: [
                    Hand(card: playerCardA),
                    Hand(card: playerCardB),
                    Hand(card: playerCardC),
                ]
            )
        )
        try subject.splitPlayerHand(0)
        XCTAssertEqual(subject, expected1)
        try subject.dealCardToPlayer(hand: 1, face: .up)
        XCTAssertEqual(subject, expected2)
        try subject.splitPlayerHand(1)
        XCTAssertEqual(subject, expected3)
    }
    
    // MARK: Double Down
    
    func testDoubleDown_ShouldAddAmountToBetAndDecreaseBank() throws {
        var subject = Player(
            bank: Bank(balance: 5),
            hands: [Hand(bet: 5)]
        )
        let expected = Player(
            bank: Bank(balance: 0),
            hands: [Hand(bet: 10)]
        )
        try subject.doubleDown(hand: 0)
        XCTAssertEqual(subject, expected)
    }
    
    func testDoubleDownShouldFailWhenHandIsInvalid() {
        var subject = Player(
            bank: Bank(balance: 5),
            hands: [Hand(bet: 5)]
        )
        XCTAssertThrowsError(try subject.doubleDown(hand: 1))
    }
    
    func testDoubleDownShouldFailWhenBankIsInsufficient() {
        var subject = Player(
            bank: Bank(balance: 4),
            hands: [Hand(bet: 5)]
        )
        XCTAssertThrowsError(try subject.doubleDown(hand: 0))
    }
}
