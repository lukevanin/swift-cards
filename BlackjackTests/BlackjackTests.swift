//
//  BlackjackTests.swift
//  BlackjackTests
//
//  Created by Luke Van In on 2021/05/27.
//

import XCTest
@testable import Blackjack


final class BlackjackTests: XCTestCase {
    
    // MARK: Shoe
    
    func testDealCardShouldFailWhenShoeIsEmpty() throws {
        var subject = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player()
        )
        XCTAssertThrowsError(try subject.dealCardToDealer(face: .up))
    }
    
    func testDealCardToDealer_ShouldAddCardToDealersHand() throws {
        let card = Card.all.randomElement()!
        var subject = Blackjack(
            shoe: Shoe(card: card),
            dealer: Dealer(),
            player: Player()
        )
        let expected = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(hand: Hand(card: PlayerCard(card: card, face: .up))),
            player: Player()
        )
        try subject.dealCardToDealer(face: .up)
        XCTAssertEqual(subject, expected)
    }
    
    // MARK: Give card to dealer
    
    func testDealCardToDealerShouldAddCardToDealersHand() throws {
        let card = Card.all.randomElement()!
        var subject = Blackjack(
            shoe: Shoe(card: card),
            dealer: Dealer(),
            player: Player()
        )
        let expected = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(hand: Hand(card: PlayerCard(card: card, face: .up))),
            player: Player()
        )
        try subject.dealCardToDealer(face: .up)
        XCTAssertEqual(subject, expected)
    }
    
    func testRevealDealerCardShouldTurnCardFaceUp() throws {
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
            shoe: Shoe(card: card),
            dealer: Dealer(),
            player: Player(hand: Hand())
        )
        let expected = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player(hands: [Hand(card: playerCard)])
        )
        try subject.dealCardToPlayer(hand: 0, face: .up)
        XCTAssertEqual(subject, expected)
    }
    
    func testGiveCardToPlayerShouldFailWhenHandIsOutOfRange() throws {
        let card = Card.all.randomElement()!
        var subject = Blackjack(
            shoe: Shoe(card: card),
            dealer: Dealer(),
            player: Player()
        )
        XCTAssertThrowsError(try subject.dealCardToPlayer(hand: 1, face: .up))
    }
    
    // MARK: Place Bet
    
//    func testPlaceBetShouldCreateHandWithTwoCardsFaceUp() throws {
//        let cardA = Card(rank: .eight, suite: .spades)
//        let cardB = Card(rank: .queen, suite: .hearts)
//        let playerCardA = PlayerCard(card: cardA, face: .up)
//        let playerCardB = PlayerCard(card: cardB, face: .up)
//        var subject = Blackjack(
//            shoe: Shoe(
//                cards: [cardA, cardB]
//            ),
//            dealer: Dealer(),
//            player: Player(
//                bank: Bank(balance: 1),
//                hands: []
//            )
//        )
//        let expected = Blackjack(
//            shoe: Shoe(),
//            dealer: Dealer(),
//            player: Player(
//                bank: Bank(balance: 0),
//                hands: [
//                    Hand(bet: 1, cards: [playerCardA, playerCardB]),
//                ]
//            )
//        )
//        try subject.placeBet(1)
//        XCTAssertEqual(subject, expected)
//    }
    
//    func testPlaceBetShouldFailDuringPlayerRound() throws {
//        let cardA = Card(rank: .eight, suite: .spades)
//        let cardB = Card(rank: .queen, suite: .hearts)
//        let playerCardA = PlayerCard(card: cardA, face: .up)
//        let playerCardB = PlayerCard(card: cardB, face: .up)
//        var subject = Blackjack(
//            shoe: Shoe(
//                cards: []
//            ),
//            dealer: Dealer(),
//            player: Player(
//                bank: Bank(balance: 1),
//                hands: [
//                    Hand(
//                        bet: 1,
//                        cards: [
//                            playerCardA,
//                            playerCardB,
//                        ]
//                    )
//                ]
//            )
//        )
//        XCTAssertThrowsError(try subject.placeBet(1))
//    }
//
//    func testPlaceBetShouldFailWhenItIsTheDealersTurn() throws {
//        var subject = Blackjack(
//            shoe: Shoe(
//                cards: [
//                    Card.all.randomElement()!,
//                    Card.all.randomElement()!
//                ]
//            ),
//            dealer: Dealer(),
//            player: Player(
//                bank: Bank(balance: 1),
//                hands: []
//            )
//        )
//    }
    
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
                bank: Bank(balance: 1),
                hands: [
                    Hand(bet: 1, cards: [playerCardA, playerCardB]),
                ]
            )
        )
        let expected = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player(
                bank: Bank(balance: 0),
                hands: [
                    Hand(bet: 1, card: playerCardA),
                    Hand(bet: 1, card: playerCardB),
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
                        bank: Bank(balance: 1),
                        hands: [
                            Hand(bet: 1, cards: [playerCardA, playerCardB]),
                        ]
                    )
                )
                let expected = Blackjack(
                    shoe: Shoe(),
                    dealer: Dealer(),
                    player: Player(
                        bank: Bank(balance: 0),
                        hands: [
                            Hand(bet: 1, card: playerCardA),
                            Hand(bet: 1, card: playerCardB),
                        ]
                    )
                )
                try subject.splitPlayerHand(0)
                XCTAssertEqual(subject, expected)
            }
        }
    }

    func testSplitPlayerHandShouldFailWhenInsufficentFunds() {
        let cardA = Card(rank: .jack, suite: .diamonds)
        let cardB = Card(rank: .jack, suite: .hearts)
        let playerCardA = PlayerCard(card: cardA, face: .up)
        let playerCardB = PlayerCard(card: cardB, face: .up)
        var subject = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player(
                bank: Bank(balance: 1),
                hands: [
                    Hand(bet: 2, cards: [playerCardA, playerCardB]),
                ]
            )
        )
        XCTAssertThrowsError(try subject.splitPlayerHand(0))
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
                bank: Bank(balance: 1),
                hands: [
                    Hand(bet: 1, cards: [playerCardA, playerCardB]),
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
                bank: Bank(balance: 1),
                hands: [
                    Hand(
                        bet: 1,
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
                bank: Bank(balance: 1),
                hands: [
                    Hand(bet: 1, cards: [playerCardA, playerCardB]),
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
                bank: Bank(balance: 2),
                hands: [
                    Hand(bet: 1, cards: [playerCardA, playerCardB]),
                ]
            )
        )
        let expected1 = Blackjack(
            shoe: Shoe(card: cardC),
            dealer: Dealer(),
            player: Player(
                bank: Bank(balance: 1),
                hands: [
                    Hand(bet: 1, card: playerCardA),
                    Hand(bet: 1, card: playerCardB),
                ]
            )
        )
        let expected2 = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player(
                bank: Bank(balance: 1),
                hands: [
                    Hand(bet: 1, card: playerCardA),
                    Hand(bet: 1, cards: [playerCardB, playerCardC]),
                ]
            )
        )
        let expected3 = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player(
                bank: Bank(balance: 0),
                hands: [
                    Hand(bet: 1, card: playerCardA),
                    Hand(bet: 1, card: playerCardB),
                    Hand(bet: 1, card: playerCardC),
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
    
    func testDoubleDownShouldAddAmountToBetAndDecreaseBank() throws {
        var subject = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player(
                bank: Bank(balance: 5),
                hands: [Hand(bet: 5)]
            )
        )
        let expected = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player(
                bank: Bank(balance: 0),
                hands: [Hand(bet: 10)]
            )
        )
        try subject.doubleDown(hand: 0)
        XCTAssertEqual(subject, expected)
    }
    
    func testDoubleDownShouldFailWhenHandIsInvalid() {
        var subject = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player(
                bank: Bank(balance: 5),
                hands: [Hand(bet: 5)]
            )
        )
        XCTAssertThrowsError(try subject.doubleDown(hand: 1))
    }
    
    func testDoubleDownShouldFailWhenBankIsInsufficient() {
        var subject = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(),
            player: Player(
                bank: Bank(balance: 4),
                hands: [Hand(bet: 5)]
            )
        )
        XCTAssertThrowsError(try subject.doubleDown(hand: 0))
    }

    // MARK: 
}
