//
//  PlayerCardTests.swift
//  BlackjackTests
//
//  Created by Luke Van In on 2021/05/30.
//

import XCTest
@testable import Blackjack

final class PlayerCardTests: XCTestCase {

    func testRevealShouldTurnCardFaceUp() throws {
        let card = Card.all.randomElement()!
        var subject = PlayerCard(card: card, face: .down)
        let expected = PlayerCard(card: card, face: .up)
        try subject.reveal()
        XCTAssertEqual(subject, expected)
    }

    func testRevealShouldFailCardIsAlreadyFaceUp() throws {
        let card = Card.all.randomElement()!
        var subject = PlayerCard(card: card, face: .up)
        XCTAssertThrowsError(try subject.reveal())
    }
}
