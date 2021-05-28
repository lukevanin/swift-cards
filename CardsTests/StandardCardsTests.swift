//
//  StandardCardsTests.swift
//  CardsTests
//
//  Created by Luke Van In on 2021/05/26.
//

import XCTest
import Deck
@testable import Cards

class StandardCardsTests: XCTestCase {

    private var factory: FiftyTwoCardFrenchSuiteCardImageFactory!

    override func setUp() {
        factory = FiftyTwoCardFrenchSuiteCardImageFactory.standard
    }
    
    func testFactoryShouldReturnImageForCard() throws {
        let card = StandardDeck.Card(rank: .ace, suite: .spades)
        let _ = try factory.image(for: card, size: .zero)
    }
}
