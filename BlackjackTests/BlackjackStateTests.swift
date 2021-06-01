//
//  BlackjackStateTests.swift
//  BlackjackTests
//
//  Created by Luke Van In on 2021/06/01.
//

import XCTest
@testable import Blackjack

final class BetStateTests: XCTestCase {

    // MARK: Bet state
    
    func testEnterShouldResetGame() {
        let dealerCard = Card.all.randomElement()!
        let playerCard = Card.all.randomElement()!
        let dealerBank = Bank(balance: 420)
        let playerBank = Bank(balance: 360)
        var subject = BetState(
            game: Blackjack(
                shoe: Shoe(),
                dealer: Dealer(
                    bank: dealerBank,
                    hand: Hand(card: PlayerCard(card: dealerCard, face: .up))
                ),
                player: Player(
                    bank: playerBank,
                    hands: [Hand(card: PlayerCard(card: playerCard, face: .up))]
                )
            )
        )
        let expected = BetState(
            game: Blackjack(
                shoe: Shoe(cards: [dealerCard, playerCard]),
                dealer: Dealer(
                    bank: dealerBank,
                    hand: Hand()
                ),
                player: Player(
                    bank: playerBank,
                    hands: [Hand()]
                )
            )
        )
        subject.enter()
        XCTAssertEqual(subject, expected)
    }
    
    func testPlaceBetShouldGoToDealState() throws {
        let subject = BetState(
            game: Blackjack(
                shoe: Shoe(),
                dealer: Dealer(
                    bank: Bank(balance: 420),
                    hand: Hand()
                ),
                player: Player(
                    bank: Bank(balance: 360),
                    hands: []
                )
            )
        )
        let expected = DealState(
            game: Blackjack(
                shoe: Shoe(),
                dealer: Dealer(
                    bank: Bank(balance: 420),
                    hand: Hand()
                ),
                player: Player(
                    bank: Bank(balance: 270),
                    hands: [Hand(bet: 90)]
                )
            )
        )
        let result = try subject.placeBet(amount: 90)
        XCTAssertEqual(result, .deal(expected))
    }
    
    func testPlaceBetShouldFailWhenBetAmountExceedsBankBalance() {
        let game = Blackjack(
            shoe: Shoe(),
            dealer: Dealer(
                bank: Bank(balance: 420),
                hand: Hand()
            ),
            player: Player(
                bank: Bank(balance: 360),
                hands: []
            )
        )
        let subject = BetState(
            game: game
        )
        XCTAssertThrowsError(try subject.placeBet(amount: 720))
    }

}
