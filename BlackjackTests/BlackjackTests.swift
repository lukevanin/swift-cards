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
                splitLimit: 1,
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
                        splitLimit: 1,
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
        }
    }

    func testSplitPlayerHandShouldFailWhenDenominationsDiffer() {
        let cardA = Card(rank: .jack, suite: .diamonds)
        let cardB = Card(rank: .ten, suite: .hearts)
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
    
    func testSplitPlayerHandShouldFailWhenHandIsBust() {
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
}
