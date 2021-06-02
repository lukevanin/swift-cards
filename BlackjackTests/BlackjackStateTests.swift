//
//  BlackjackStateTests.swift
//  BlackjackTests
//
//  Created by Luke Van In on 2021/06/01.
//

import XCTest
@testable import Blackjack

final class GameTests: XCTestCase {


    // MARK: - Betting

    
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
            Card.all.randomElement()!,
            Card(rank: .seven, suite: .hearts),
            Card(rank: .king, suite: .clubs),
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
                            PlayerCard(card: cards[2], face: .up), // king
                            PlayerCard(card: cards[0], face: .down), // wild
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
    
    func testPlaceBet_OffersInsurance_WhenDealerHasAce() throws {
        let cards = [
            Card.all.randomElement()!,
            Card(rank: .two, suite: .spades),
            Card(rank: .ace, suite: .diamonds),
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
                            PlayerCard(card: cards[0], face: .down), // wild
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


    // MARK: - Insurance
    
    
    ///
    /// Player loses if they did not buy insurance and the dealer has blackjack.
    ///
    func testPassInsurance_Lose_WhenDealerHasBlackjack() throws {
        let cards = [
            Card(rank: .eight, suite: .spades),
            Card(rank: .ten, suite: .hearts),
            Card(rank: .eight, suite: .clubs),
            Card(rank: .ace, suite: .diamonds),
        ]
        let subject = InsuranceState(
            game: Blackjack(
                shoe: Shoe(cards: cards),
                dealer: Dealer(
                    bank: Bank(balance: 100),
                    hand: Hand(
                        cards: [
                            PlayerCard(card: Card(rank: .ace, suite: .diamonds), face: .up),
                            PlayerCard(card: Card(rank: .king, suite: .diamonds), face: .down),
                        ]
                    )
                ),
                player: Player(
                    bank: Bank(balance: 100),
                    hand: Hand(
                        bet: 50,
                        cards: [
                            PlayerCard(card: Card(rank: .eight, suite: .diamonds), face: .up),
                            PlayerCard(card: Card(rank: .ten, suite: .diamonds), face: .up),
                        ]
                    )
                )
            )
        )
        let expected = EndState(
            outcome: .lose,
            game: Blackjack(
                shoe: Shoe(cards: cards),
                dealer: Dealer(
                    bank: Bank(balance: 150),
                    hand: Hand(
                        cards: [
                            PlayerCard(card: Card(rank: .ace, suite: .diamonds), face: .up),
                            PlayerCard(card: Card(rank: .king, suite: .diamonds), face: .up),
                        ]
                    )
                ),
                player: Player(
                    bank: Bank(balance: 100),
                    hand: Hand(
                        bet: 0,
                        cards: [
                            PlayerCard(card: Card(rank: .eight, suite: .diamonds), face: .up),
                            PlayerCard(card: Card(rank: .ten, suite: .diamonds), face: .up),
                        ]
                    )
                )
            )
        )
        let result = try subject.passInsurance()
        XCTAssertEqual(result, .end(expected))
    }
    
    ///
    /// Play continues if player did not buy insurance and the dealer does not have blackjack.
    ///
    func testPassInsurance_AllowsPlay_WhenDealerHasNoBlackjack() throws {
        let subject = InsuranceState(
            game: Blackjack(
                shoe: Shoe(),
                dealer: Dealer(
                    bank: Bank(balance: 100),
                    hand: Hand(
                        cards: [
                            PlayerCard(card: Card(rank: .ace, suite: .diamonds), face: .up),
                            PlayerCard(card: Card(rank: .eight, suite: .diamonds), face: .down),
                        ]
                    )
                ),
                player: Player(
                    bank: Bank(balance: 100),
                    hand: Hand(
                        bet: 50,
                        cards: [
                            PlayerCard(card: Card(rank: .eight, suite: .diamonds), face: .up),
                            PlayerCard(card: Card(rank: .ten, suite: .diamonds), face: .up),
                        ]
                    )
                )
            )
        )
        let expected = PlayerState(
            hand: 0,
            game: Blackjack(
                shoe: Shoe(),
                dealer: Dealer(
                    bank: Bank(balance: 100),
                    hand: Hand(
                        cards: [
                            PlayerCard(card: Card(rank: .ace, suite: .diamonds), face: .up),
                            PlayerCard(card: Card(rank: .eight, suite: .diamonds), face: .up),
                        ]
                    )
                ),
                player: Player(
                    bank: Bank(balance: 100),
                    hand: Hand(
                        bet: 50,
                        cards: [
                            PlayerCard(card: Card(rank: .eight, suite: .diamonds), face: .up),
                            PlayerCard(card: Card(rank: .ten, suite: .diamonds), face: .up),
                        ]
                    )
                )
            )
        )
        let result = try subject.passInsurance()
        XCTAssertEqual(result, .player(expected))
    }
    
    ///
    /// Player can only insure up to half the bet amount,
    ///
    func testBuyInsurance_Fails_WhenInsuranceExceedsHalfOfBet() {
        let cards = [
            Card(rank: .eight, suite: .spades),
            Card(rank: .ten, suite: .hearts),
            Card(rank: .eight, suite: .clubs),
            Card(rank: .ace, suite: .diamonds),
        ]
        let subject = InsuranceState(
            game: Blackjack(
                shoe: Shoe(cards: cards),
                dealer: Dealer(
                    bank: Bank(balance: 100),
                    hand: Hand(
                        cards: [
                            PlayerCard(card: Card(rank: .ace, suite: .diamonds), face: .up),
                            PlayerCard(card: Card(rank: .king, suite: .diamonds), face: .down),
                        ]
                    )
                ),
                player: Player(
                    bank: Bank(balance: 100),
                    hand: Hand(
                        bet: 50,
                        cards: [
                            PlayerCard(card: Card(rank: .eight, suite: .diamonds), face: .up),
                            PlayerCard(card: Card(rank: .ten, suite: .diamonds), face: .up),
                        ]
                    )
                )
            )
        )
        XCTAssertThrowsError(try subject.buyInsurance(amount: 26))
    }

    ///
    /// Player loses the hand but gets their bet paid back if they bought insurance and the dealer has
    /// blackjack.
    ///
    func testBuyInsurance_PaysOutInsurance_WhenDealerHasBlackjack() throws {
        let cards = [
            Card(rank: .eight, suite: .spades),
            Card(rank: .ten, suite: .hearts),
            Card(rank: .eight, suite: .clubs),
            Card(rank: .ace, suite: .diamonds),
        ]
        let subject = InsuranceState(
            game: Blackjack(
                shoe: Shoe(cards: cards),
                dealer: Dealer(
                    bank: Bank(balance: 100),
                    hand: Hand(
                        cards: [
                            PlayerCard(card: Card(rank: .ace, suite: .diamonds), face: .up),
                            PlayerCard(card: Card(rank: .king, suite: .diamonds), face: .down),
                        ]
                    )
                ),
                player: Player(
                    bank: Bank(balance: 100),
                    hand: Hand(
                        bet: 50,
                        cards: [
                            PlayerCard(card: Card(rank: .eight, suite: .diamonds), face: .up),
                            PlayerCard(card: Card(rank: .ten, suite: .diamonds), face: .up),
                        ]
                    )
                )
            )
        )
        let expected = EndState(
            outcome: .lose,
            game: Blackjack(
                shoe: Shoe(cards: cards),
                dealer: Dealer(
                    bank: Bank(balance: 100 + 50 - 20),
                    hand: Hand(
                        cards: [
                            PlayerCard(card: Card(rank: .ace, suite: .diamonds), face: .up),
                            PlayerCard(card: Card(rank: .king, suite: .diamonds), face: .up),
                        ]
                    )
                ),
                player: Player(
                    bank: Bank(balance: 120),
                    hand: Hand(
                        bet: 0,
                        cards: [
                            PlayerCard(card: Card(rank: .eight, suite: .diamonds), face: .up),
                            PlayerCard(card: Card(rank: .ten, suite: .diamonds), face: .up),
                        ]
                    )
                )
            )
        )
        let result = try subject.buyInsurance(amount: 10)
        XCTAssertEqual(result, .end(expected))
    }

    ///
    /// Player loses their insurance but continues playing if they bought insurance and the dealer does not
    /// have blackjack.
    ///
    func testBuyInsurance_AllowsPlay_WhenDealerHasNoBlackjack() throws {
        let cards = [
            Card(rank: .eight, suite: .spades),
            Card(rank: .eight, suite: .hearts),
            Card(rank: .ace, suite: .clubs),
            Card(rank: .eight, suite: .diamonds),
        ]
        let subject = InsuranceState(
            game: Blackjack(
                shoe: Shoe(cards: cards),
                dealer: Dealer(
                    bank: Bank(balance: 100),
                    hand: Hand(
                        cards: [
                            PlayerCard(card: Card(rank: .ace, suite: .spades), face: .up), // ace
                            PlayerCard(card: Card(rank: .eight, suite: .hearts), face: .down), // eight
                        ]
                    )
                ),
                player: Player(
                    bank: Bank(balance: 100),
                    hand: Hand(
                        bet: 50,
                        cards: [
                            PlayerCard(card: Card(rank: .eight, suite: .clubs), face: .up), // eight
                            PlayerCard(card: Card(rank: .eight, suite: .diamonds), face: .up), // eight
                        ]
                    )
                )
            )
        )
        let expected = PlayerState(
            hand: 0,
            game: Blackjack(
                shoe: Shoe(cards: cards),
                dealer: Dealer(
                    bank: Bank(balance: 110),
                    hand: Hand(
                        cards: [
                            PlayerCard(card: Card(rank: .ace, suite: .spades), face: .up), // ace
                            PlayerCard(card: Card(rank: .eight, suite: .hearts), face: .up), // eight
                        ]
                    )
                ),
                player: Player(
                    bank: Bank(balance: 90),
                    hand: Hand(
                        bet: 50,
                        cards: [
                            PlayerCard(card: Card(rank: .eight, suite: .clubs), face: .up), // eight
                            PlayerCard(card: Card(rank: .eight, suite: .diamonds), face: .up), // eight
                        ]
                    )
                )
            )
        )
        let result = try subject.buyInsurance(amount: 10)
        XCTAssertEqual(result, .player(expected))
    }
}
