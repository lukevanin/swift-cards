//
//  BlackjackTests.swift
//  BlackjackTests
//
//  Created by Luke Van In on 2021/05/27.
//

import XCTest
@testable import Blackjack

class BlackjackTests: XCTestCase {
    
    // MARK: Deal to player

    func testDealToPlayerShouldDealOneCardToPlayerFaceUp() throws {
        let game = BlackjackGame(
            rules: BlackjackGame.Rules(
                numberOfCardPacks: 1,
                maximumSplits: 3
            )
        )
        let action = DealCardToPlayerAction()
        XCTAssertTrue(game.canPerform(action: action))
        try game.perform(action: action)
        XCTAssertEqual(game.playerHands[0].cards.count, 1)
        XCTAssertEqual(game.playerHands[0].cards[0].face, .up)
    }
    
    // MARK: Deal to dealer

    func testDealToDealerShouldDealOneCardToDealerFaceDown() throws {
        let game = BlackjackGame(
            rules: BlackjackGame.Rules(
                numberOfCardPacks: 1,
                maximumSplits: 3
            )
        )
        let action = DealCardToDealerAction()
        XCTAssertTrue(game.canPerform(action: action))
        try game.perform(action: action)
        XCTAssertEqual(game.dealerHand.cards.count, 1)
        XCTAssertEqual(game.dealerHand.cards[0].face, .down)
    }

    func testRevealDealerCard() throws {
        let game = BlackjackGame(
            rules: BlackjackGame.Rules(
                numberOfCardPacks: 1,
                maximumSplits: 3
            )
        )
        let dealAction = DealCardToDealerAction()
        let revealAction = RevealDealerCardAction()
        XCTAssertFalse(game.canPerform(action: revealAction))
        XCTAssertTrue(game.canPerform(action: dealAction))
        try game.perform(action: dealAction)
        XCTAssertEqual(game.dealerHand.cards.count, 1)
        XCTAssertEqual(game.dealerHand.cards[0].face, .down)
        XCTAssertTrue(game.canPerform(action: revealAction))
        try game.perform(action: revealAction)
        XCTAssertEqual(game.dealerHand.cards[0].face, .up)
    }

}
