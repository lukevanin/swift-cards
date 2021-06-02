//
//  BlackjackStateTests.swift
//  BlackjackTests
//
//  Created by Luke Van In on 2021/06/01.
//

import XCTest
@testable import Blackjack

final class GameTests: XCTestCase {

    
    // MARK: Bet
    
    func testPlaceBet_Fails_WhenInsufficentFunds() {
        let game = Blackjack(
            shoe: Shoe(
                cards: [
                    Card(rank: .ace, suite: .spades),
                    Card(rank: .ace, suite: .hearts),
                    Card(rank: .ace, suite: .clubs),
                    Card(rank: .ace, suite: .diamonds),
                ]
            ),
            dealer: Dealer(
                bank: Bank(balance: 420),
                hand: Hand()
            ),
            player: Player(
                bank: Bank(balance: 90)
            )
        )
        let subject = BetState(game: game)
        XCTAssertThrowsError(try subject.placeBet(amount: 91))
    }

    func testPlaceBet_Fails_WhenNotEnoughCards() {
        let game = Blackjack(
            shoe: Shoe(
                cards: [
                    Card(rank: .ace, suite: .spades),
                    Card(rank: .ace, suite: .hearts),
                    Card(rank: .ace, suite: .clubs),
                ]
            ),
            dealer: Dealer(
                bank: Bank(balance: 420),
                hand: Hand()
            ),
            player: Player(
                bank: Bank(balance: 360)
            )
        )
        let subject = BetState(
            game: game
        )
        XCTAssertThrowsError(try subject.placeBet(amount: 360))
    }
    
    func testPlaceBet_Fails_WhenHandAlreadyExists() {
        let game = Blackjack(
            shoe: Shoe(
                cards: [
                    Card(rank: .ace, suite: .spades),
                    Card(rank: .ace, suite: .hearts),
                    Card(rank: .ace, suite: .clubs),
                    Card(rank: .ace, suite: .diamonds),
                ]
            ),
            dealer: Dealer(
                bank: Bank(balance: 420),
                hand: Hand()
            ),
            player: Player(
                bank: Bank(balance: 360),
                hand: Hand(bet: 0)
            )
        )
        let subject = BetState(game: game)
        XCTAssertThrowsError(try subject.placeBet(amount: 90))
    }
    
    func testPlaceBet_AllowsPlay_WhenNooneHasBlackjack() throws {
        let cards = [
            Card(rank: .two, suite: .spades),
            Card(rank: .seven, suite: .hearts),
            Card(rank: .two, suite: .clubs),
            Card(rank: .five, suite: .diamonds),
        ]
        let subject = BetState(
            game: Blackjack(
                shoe: Shoe(cards: cards),
                dealer: Dealer(
                    bank: Bank(balance: 420)
                ),
                player: Player(
                    bank: Bank(balance: 360)
                )
            )
        )
        let expected = PlayerState(
            hand: 0,
            game: Blackjack(
                shoe: Shoe(),
                dealer: Dealer(
                    bank: Bank(balance: 420),
                    hand: Hand(
                        cards: [
                            PlayerCard(card: cards[2], face: .up), // two
                            PlayerCard(card: cards[0], face: .down), // two
                        ]
                    )
                ),
                player: Player(
                    bank: Bank(balance: 270),
                    hand: Hand(
                        bet: 90,
                        cards: [
                            PlayerCard(card: cards[3], face: .up), // five
                            PlayerCard(card: cards[1], face: .up), // seven
                        ]
                    )
                )
            )
        )
        let result = try subject.placeBet(amount: 90)
        XCTAssertEqual(result, .player(expected))
    }
    
    func testPlaceBet_OffersInsurance_WhenDealerHasAceOrTen() throws {
        let ranks: [Card.Rank] = [.ace, .ten, .jack, .queen, .king]
        let cards = [
            Card.all.randomElement()!,
            Card(rank: .two, suite: .spades),
            Card(rank: ranks.randomElement()!, suite: .diamonds),
            Card(rank: .five, suite: .clubs),
        ]
        let subject = BetState(
            game: Blackjack(
                shoe: Shoe(cards: cards),
                dealer: Dealer(
                    bank: Bank(balance: 420)
                ),
                player: Player(
                    bank: Bank(balance: 360)
                )
            )
        )
        let expected = InsuranceState(
            game: Blackjack(
                shoe: Shoe(),
                dealer: Dealer(
                    bank: Bank(balance: 420),
                    hand: Hand(
                        cards: [
                            PlayerCard(card: cards[2], face: .up), // ace
                            PlayerCard(card: cards[0], face: .down), // king
                        ]
                    )
                ),
                player: Player(
                    bank: Bank(balance: 360 - 80),
                    hand: Hand(
                        bet: 80,
                        cards: [
                            PlayerCard(card: cards[3], face: .up), // five
                            PlayerCard(card: cards[1], face: .up), // two
                        ]
                    )
                )
            )
        )
        let result = try subject.placeBet(amount: 80)
        XCTAssertEqual(result, .insurance(expected))
    }
    
    func testPlaceBet_Push_WhenDealerAndPlayerHaveBlackjack() throws {
        let cards = [
            Card(rank: .king, suite: .hearts), // 0
            Card(rank: .ten, suite: .hearts), // 1
            Card(rank: .ace, suite: .hearts), // 2
            Card(rank: .ace, suite: .hearts), // 3
        ]
        let subject = BetState(
            game: Blackjack(
                shoe: Shoe(cards: cards),
                dealer: Dealer(
                    bank: Bank(balance: 420)
                ),
                player: Player(
                    bank: Bank(balance: 360)
                )
            )
        )
        let expected = EndState(
            outcome: .push,
            game: Blackjack(
                shoe: Shoe(),
                dealer: Dealer(
                    bank: Bank(balance: 420),
                    hand: Hand(
                        cards: [
                            PlayerCard(card: cards[2], face: .up), // ace
                            PlayerCard(card: cards[0], face: .up), // king
                        ]
                    )
                ),
                player: Player(
                    bank: Bank(balance: 270),
                    hand: Hand(
                        bet: 90,
                        cards: [
                            PlayerCard(card: cards[3], face: .up), // ace
                            PlayerCard(card: cards[1], face: .up), // ten
                        ]
                    )
                )
            )
        )
        let result = try subject.placeBet(amount: 90)
        XCTAssertEqual(result, .end(expected))
    }
    
    func testPlaceBet_PlayerWins_WhenOnlyPlayerHasBlackjack() throws {
        let cards = [
            Card(rank: .eight, suite: .spades),
            Card(rank: .ten, suite: .hearts),
            Card(rank: .eight, suite: .clubs),
            Card(rank: .ace, suite: .diamonds),
        ]
        let subject = BetState(
            game: Blackjack(
                shoe: Shoe(cards: cards),
                dealer: Dealer(
                    bank: Bank(balance: 100)
                ),
                player: Player(
                    bank: Bank(balance: 100)
                )
            )
        )
        let expected = EndState(
            outcome: .win,
            game: Blackjack(
                shoe: Shoe(),
                dealer: Dealer(
                    bank: Bank(balance: 100 - 30),
                    hand: Hand(
                        cards: [
                            PlayerCard(card: cards[2], face: .up), // eight
                            PlayerCard(card: cards[0], face: .down), // eight
                        ]
                    )
                ),
                player: Player(
                    bank: Bank(balance: 100 - 20 + 30), // 360 - 90 + ((80 / 2) * 3)
                    hand: Hand(
                        bet: 20,
                        cards: [
                            PlayerCard(card: cards[3], face: .up), // ace
                            PlayerCard(card: cards[1], face: .up), // ten
                        ]
                    )
                )
            )
        )
        let result = try subject.placeBet(amount: 20)
        XCTAssertEqual(result, .end(expected))
    }


}
