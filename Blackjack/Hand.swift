//
//  Hand.swift
//  Blackjack
//
//  Created by Luke Van In on 2021/05/30.
//

import Foundation


enum HandError: Error {
    case invalidCardIndex
}


#warning("TODO: Remove score and split logic specific to Blackjack")
struct Hand: Equatable {
    
    private(set) var cards: [PlayerCard] = []
    
    init() {
    }
    
    init(card: PlayerCard) {
        self.cards = [card]
    }
    
    init(cards: [PlayerCard]) {
        self.cards = cards
    }
    
    mutating func addCard(_ card: PlayerCard) {
        cards.append(card)
    }
    
    mutating func revealCard(at index: Int) throws {
        guard index >= 0 && index < cards.count else {
            throw HandError.invalidCardIndex
        }
        try cards[index].reveal()
    }
}

extension Hand: CustomStringConvertible {
    var description: String {
        "<HAND: [\(cards.map { String(describing: $0) }.joined(separator: ", "))]>"
    }
}
